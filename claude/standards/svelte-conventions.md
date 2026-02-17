# Svelte 5 & SvelteKit Conventions

## Svelte 5 Runes

Use runes exclusively. Never use legacy Svelte 4 patterns.

### State

```typescript
let isOpen = $state(false);
let items = $state<Item[]>([]);
let selected = $state<string | null>(null);
```

- Use `$state` for all reactive state, never plain `let` for values that change
- Always provide type annotations for non-obvious types

### Derived Values

```typescript
const filtered = $derived(items.filter(i => i.active));
const count = $derived(filtered.length);
```

- Use `const` with `$derived`, never `let`
- Prefer `$derived` over `$derived.by` unless the computation needs multiple statements

### Effects

```typescript
$effect(() => {
  if (items.length === 0) {
    addDefaultItem();
  }
});
```

- Use `$effect` for side effects only, not for derived computations
- Keep effects minimal and focused

### Props

Destructure inline with type annotations. No separate interface declarations unless the prop type is reused elsewhere.

```typescript
let {
  title,
  items,
  onselect,
  class: className = ''
}: {
  title: string;
  items: Item[];
  onselect?: (item: Item) => void;
  class?: string;
} = $props();
```

### Snippets (not slots)

Use `{#snippet}` blocks instead of slots:

```svelte
{#snippet header()}
  <h2>Title</h2>
{/snippet}

<Panel {header}>
  <p>Content</p>
</Panel>
```

Accepting snippets as props:

```typescript
let {
  header,
  children
}: {
  header?: import('svelte').Snippet;
  children: import('svelte').Snippet;
} = $props();
```

### Event Handlers

Use lowercase attribute syntax, not `on:` directive:

```svelte
<!-- Correct -->
<button onclick={handleClick}>Click</button>
<input onchange={handleChange} />

<!-- Wrong -->
<button on:click={handleClick}>Click</button>
```

## SvelteKit Patterns

### Route Structure

```
src/routes/
  +layout.svelte          # Root layout
  +layout.server.ts       # Root data loading
  (app)/                  # Route group for authenticated pages
    dashboard/
      +page.svelte
      +page.server.ts
  api/                    # API endpoints
    resource/
      +server.ts
```

### Data Loading

```typescript
// +page.server.ts
export const load = async ({ locals, params }) => {
  // Server-side data fetching
  return { items };
};

// +page.svelte
let { data } = $props();
```

### Form Actions

Use SvelteKit form actions for mutations, not raw fetch calls from the client when possible.

## Component Organization

### Script Section Order

1. Imports
2. Props (`$props()`)
3. Constants
4. State declarations (`$state`)
5. Derived values (`$derived`)
6. Effects (`$effect`)
7. Helper functions
8. (Template follows)

### File Organization

- One component per file
- Component files use PascalCase: `FilterDropdown.svelte`
- Co-locate related components in directories when they form a logical group
- Keep components focused; extract when a component exceeds ~200 lines

## State Management

- Use `.svelte.ts` files for shared state (Svelte 5 rune-based modules)
- Avoid external state management libraries
- Prefer passing data through props and SvelteKit load functions over global state
- Use context (`setContext`/`getContext`) for dependency injection within component trees
