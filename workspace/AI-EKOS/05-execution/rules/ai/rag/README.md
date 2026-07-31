---
tags:
  - ai
  - anti-patterns
  - best-practices
  - database
  - embeddings
  - performance
  - postgres
  - rag
  - sql
summary: "RAG (Retrieval-Augmented Generation)"
read_when:
  - "Implementing ai features"
  - "Troubleshooting ai issues"
---

# RAG (Retrieval-Augmented Generation)

## What is RAG

RAG combines retrieval from a knowledge base with LLM generation. Instead of relying solely on the model's training data, RAG retrieves relevant documents and includes them in the prompt context.

```
User Query → Embedding → Vector Search → Retrieved Docs → LLM + Docs → Answer
```

## When to Use RAG

### Use RAG when:
- Knowledge changes frequently (can't retrain model)
- Need domain-specific knowledge not in training data
- Need source attribution ("where did this come from?")
- Data is proprietary or private
- Cost of fine-tuning exceeds retrieval cost

### Don't use RAG when:
- Task is simple pattern matching (use rules)
- Knowledge is static and small (prompt engineering sufficient)
- Latency requirements are strict (<500ms) and can't be met
- Data quality is poor (garbage in, garbage out)

## Architecture Components

### 1. Document Processing
```python
# Chunk documents strategically
def chunk_document(text: str, chunk_size: int = 500, overlap: int = 50):
    """Chunk with overlap to preserve context at boundaries."""
    chunks = []
    for i in range(0, len(text), chunk_size - overlap):
        chunk = text[i:i + chunk_size]
        chunks.append(chunk)
    return chunks
```

**Chunking Strategies:**
- **Fixed-size**: Simple, may break mid-sentence
- **Semantic**: Break at paragraph/sentence boundaries
- **Hierarchical**: Parent-child chunks (summary + detail)
- **Agentic**: Let LLM decide chunk boundaries

### 2. Embedding

```python
from openai import OpenAI

client = OpenAI()

def embed(text: str) -> list[float]:
    response = client.embeddings.create(
        model="text-embedding-3-large",
        input=text
    )
    return response.data[0].embedding
```

**Model Selection:**
| Model | Dimensions | Best For |
|-------|-----------|----------|
| text-embedding-3-small | 1536 | Cost-sensitive, general |
| text-embedding-3-large | 3072 | Accuracy-critical |
| multilingual-e5-large | 1024 | Multilingual |

### 3. Vector Database

**Options:**
| Solution | Hosting | Best For |
|----------|---------|----------|
| pgvector | Self-hosted | Existing PostgreSQL |
| Pinecone | Managed | Scale, managed ops |
| Weaviate | Self/Managed | Flexibility, hybrid search |
| Qdrant | Self/Managed | Performance, Rust |

**Schema (pgvector):**
```sql
CREATE TABLE chunks (
    id SERIAL PRIMARY KEY,
    document_id INTEGER REFERENCES documents(id),
    content TEXT NOT NULL,
    embedding VECTOR(3072),
    metadata JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX ON chunks USING ivfflat(embedding vector_cosine_ops)
WITH (lists = 100);
```

### 4. Retrieval

**Basic Similarity Search:**
```sql
SELECT content, metadata,
       1 - (embedding <=> query_embedding) AS similarity
FROM chunks
ORDER BY embedding <=> query_embedding
LIMIT 5;
```

**Hybrid Search (BM25 + Vector):**
```sql
-- Combine full-text and vector scores
SELECT 
    content,
    (0.7 * vector_score) + (0.3 * bm25_score) AS combined_score
FROM chunks
WHERE to_tsvector('english', content) @@ plainto_tsquery('english', $query)
ORDER BY combined_score DESC
LIMIT 5;
```

### 5. Re-ranking

```python
from cohere import Client

cohere = Client()

def rerank(query: str, documents: list[str], top_k: int = 3):
    response = cohere.rerank(
        model='rerank-english-v2.0',
        query=query,
        documents=documents,
        top_n=top_k
    )
    return [documents[r.index] for r in response.results]
```

## Advanced Patterns

### Multi-Query Retrieval
```python
# Generate multiple query variations for better coverage
queries = [
    "How do I reset my password?",
    "Password reset instructions",
    "Forgot password help"
]

# Retrieve for each, deduplicate
results = set()
for q in queries:
    results.update(retrieve(q))
```

### Self-Querying
```python
# Use LLM to extract filters from query
# "Show me sales reports from last month" → 
# filters: {type: "sales_report", date_range: "last_month"}
```

### Parent-Document Retrieval
```python
# Retrieve small chunks for accuracy
# But return full parent document for context
```

## Evaluation Framework

### Metrics
- **Hit Rate**: Is the correct doc in top-k?
- **Mean Reciprocal Rank (MRR)**: How high is the correct doc?
- **Faithfulness**: Does the answer match retrieved docs?
- **Answer Relevance**: Does the answer address the question?

### Test Dataset
```python
test_cases = [
    {
        "query": "How do I upgrade my plan?",
        "expected_chunks": ["billing-upgrade-001", "billing-upgrade-002"],
        "expected_answer_contains": ["settings", "billing"]
    }
]
```

## Anti-Patterns

- **No chunking**: Sending entire documents wastes tokens
- **No metadata filtering**: Retrieving irrelevant documents
- **No re-ranking**: Trusting raw vector similarity
- **No evaluation**: Shipping without measuring retrieval quality
- **Ignoring context window**: Retrieving more than fits in prompt
