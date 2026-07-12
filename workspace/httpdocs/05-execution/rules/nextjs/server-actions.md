# Server Actions

## What Are Server Actions

Server Actions are asynchronous functions that execute on the server. They can be called directly from forms or buttons in Client Components without creating an API route.

```tsx
'use server';

import { revalidatePath } from 'next/cache';

export async function createTodo(formData: FormData) {
  const title = formData.get('title') as string;
  
  await db.insert(todos).values({
    title,
    completed: false,
    createdAt: new Date(),
  });
  
  revalidatePath('/todos');
}
```

## Form Submission

### Traditional Form
```tsx
// app/todos/page.tsx
export default function TodosPage() {
  return (
    <form action={createTodo}>
      <input name="title" placeholder="New todo" required />
      <button type="submit">Add Todo</button>
    </form>
  );
}
```

### With useActionState (React 19)
```tsx
'use client';

import { useActionState } from 'react';

export default function TodoForm() {
  const [state, formAction, isPending] = useActionState(createTodo, {
    error: null,
    success: false,
  });
  
  return (
    <form action={formAction}>
      <input name="title" placeholder="New todo" />
      <button disabled={isPending}>
        {isPending ? 'Adding...' : 'Add Todo'}
      </button>
      {state.error && <p>{state.error}</p>}
    </form>
  );
}
```

## Error Handling

### Validation with Zod
```tsx
'use server';

import { z } from 'zod';

const schema = z.object({
  title: z.string().min(1).max(100),
  description: z.string().optional(),
});

export async function createTodo(formData: FormData) {
  const data = schema.parse({
    title: formData.get('title'),
    description: formData.get('description'),
  });
  
  // ... create todo
}
```

### try/catch with Error Boundaries
```tsx
// actions/todo.ts
'use server';

export async function toggleTodo(id: string) {
  try {
    await db.update(todos)
      .set({ completed: true })
      .where(eq(todos.id, id));
    
    revalidatePath('/todos');
    return { success: true };
  } catch (error) {
    return { error: 'Failed to update todo' };
  }
}

// Component
'use client';

export default function TodoItem({ todo }: { todo: Todo }) {
  async function handleToggle() {
    const result = await toggleTodo(todo.id);
    if (result.error) {
      toast.error(result.error);
    }
  }
  
  return <button onClick={handleToggle}>Toggle</button>;
}
```

## Progressive Enhancement

```tsx
// Works without JavaScript (form submission)
// Works with JavaScript (instant feedback)

export default function ContactForm() {
  const [optimisticState, addOptimistic] = useOptimistic(
    state,
    (state, newMessage) => [...state, newMessage]
  );
  
  async function handleSubmit(formData: FormData) {
    const message = formData.get('message') as string;
    
    // Optimistic update
    addOptimistic({ id: 'temp', message, pending: true });
    
    // Server action
    await sendMessage(formData);
  }
  
  return (
    <form action={handleSubmit}>
      {optimisticState.map((msg) => (
        <div key={msg.id} style={{ opacity: msg.pending ? 0.5 : 1 }}>
          {msg.message}
        </div>
      ))}
      <input name="message" />
      <button type="submit">Send</button>
    </form>
  );
}
```

## Revalidation

### Path Revalidation
```tsx
'use server';

import { revalidatePath } from 'next/cache';

export async function updatePost(id: string, data: FormData) {
  await db.update(posts).set(data).where(eq(posts.id, id));
  
  // Revalidate specific path
  revalidatePath(`/blog/${id}`);
  
  // Revalidate all blog posts
  revalidatePath('/blog', 'page');
}
```

### Tag-Based Revalidation
```tsx
'use server';

import { revalidateTag } from 'next/cache';

export async function createPost(data: FormData) {
  const post = await db.insert(posts).values(data).returning();
  
  // Revalidate all cache entries with this tag
  revalidateTag('posts');
  
  return post;
}

// In component: fetch with tag
const posts = await fetch('/api/posts', {
  next: { tags: ['posts'] },
});
```

## Security

### Input Validation
Always validate server-side. Never trust client input.

```tsx
'use server';

export async function deleteTodo(formData: FormData) {
  const id = formData.get('id') as string;
  
  // Validate ownership
  const todo = await db.select().from(todos).where(eq(todos.id, id)).get();
  if (!todo) throw new Error('Todo not found');
  if (todo.userId !== currentUser.id) throw new Error('Unauthorized');
  
  await db.delete(todos).where(eq(todos.id, id));
  revalidatePath('/todos');
}
```

### Rate Limiting
```tsx
'use server';

import { Ratelimit } from '@upstash/ratelimit';

const ratelimit = new Ratelimit({ redis, limiter: Ratelimit.slidingWindow(10, '1 m') });

export async function submitContactForm(formData: FormData) {
  const { success } = await ratelimit.limit('contact-form');
  if (!success) throw new Error('Rate limit exceeded');
  
  // ... process form
}
```

## Anti-Patterns

- **No validation**: Trusting client input without server-side validation
- **No error handling**: Letting exceptions bubble to user
- **Over-revalidation**: Revalidating entire app for small changes
- **Mutations in GET**: Server Actions should only be called from mutations
- **No auth checks**: Forgetting to verify user ownership/permissions


## Related
- `05-execution/rules/nextjs/architecture.md` — Next.js architecture overview
- `05-execution/rules/nextjs/patterns.md` — Common patterns
- `05-execution/checklists/code-review.md` — Code review checklist
- `07-patterns/controller/` — Controller patterns
