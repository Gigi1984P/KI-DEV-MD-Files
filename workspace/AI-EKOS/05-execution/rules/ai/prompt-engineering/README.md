# Prompt Engineering

## Principles

### 1. Be Specific and Clear
```
❌ "Write a function"
✅ "Write a TypeScript function that takes a User object and returns a formatted display name string, handling null/undefined fields"
```

### 2. Provide Context
```
"You are a senior React developer. We use Next.js App Router with Server Components.
Write a component that fetches user data and displays it in a card layout.
The component should handle loading and error states."
```

### 3. Use Examples (Few-Shot)
```
"Format these dates consistently:

Input: 2024-01-15
Output: January 15, 2024

Input: 2024-06-20
Output: June 20, 2024

Now format: 2024-12-25"
```

### 4. Specify Output Format
```
"Respond with ONLY a JSON object containing:
- summary: string (max 100 chars)
- tags: string[] (max 3)
- confidence: number (0-1)

No other text."
```

## Chain of Thought

For complex reasoning tasks:
```
"Think through this step by step:
1. Identify the key variables
2. Apply the formula
3. Check edge cases
4. Provide the final answer

Problem: [your problem here]"
```

## Prompt Templates

### Code Generation
```
"Write a {language} function that {description}.

Requirements:
- {requirement 1}
- {requirement 2}

Constraints:
- {constraint 1}

Include error handling and type safety."
```

### Code Review
```
"Review this code for:
1. Security vulnerabilities
2. Performance issues
3. Type safety
4. Best practices

```code
[code here]
```

Provide specific suggestions with line references."
```

## Anti-Patterns

- **Ambiguity**: "Make it better" — what does "better" mean?
- **Overloading**: Asking 5 questions in one prompt
- **No constraints**: "Write anything" — leads to irrelevant output
- **Ignoring context**: Not providing framework/language context
- **Assuming knowledge**: Not specifying assumptions
