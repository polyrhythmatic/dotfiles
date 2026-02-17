# Code Review Checklist

## Correctness

- [ ] Does the code do what the PR/task description says?
- [ ] Are edge cases handled (empty arrays, null values, loading states, error states)?
- [ ] Are there race conditions in async operations?
- [ ] Is state properly cleaned up (effects, subscriptions, event listeners)?

## Svelte 5 Patterns

- [ ] Uses `$state`, `$derived`, `$effect` (no legacy reactive patterns)
- [ ] Props destructured inline with `$props()` and typed
- [ ] Event handlers use `onclick`/`onchange` (not `on:click`)
- [ ] No unnecessary `$effect` — could this be a `$derived` instead?
- [ ] Snippets used instead of slots

## Styling

- [ ] Tailwind classes only (no `<style>` blocks unless `:global()` for third-party HTML)
- [ ] `cn()` used for conditional classes with boolean `&&` (no ternaries)
- [ ] Design tokens used where available (not raw color/spacing values)
- [ ] Responsive behavior considered

## TypeScript

- [ ] No `any` types (use `unknown` or proper typing)
- [ ] Function signatures have explicit return types for exported/public APIs
- [ ] No unused imports or variables

## Architecture

- [ ] Component is focused (single responsibility)
- [ ] No prop drilling — consider context for deeply nested data
- [ ] Data loading happens in `+page.server.ts`/`+layout.server.ts` where appropriate
- [ ] Shared state uses `.svelte.ts` modules
- [ ] Component hierarchy makes sense (design-system -> shared components -> app-specific)

## Performance

- [ ] No unnecessary re-renders (effects that trigger on every state change)
- [ ] Large lists use appropriate patterns (virtualization if needed)
- [ ] Images have proper sizing/loading attributes
- [ ] No blocking operations in `$effect`

## Accessibility

- [ ] Semantic HTML elements used
- [ ] Interactive elements are keyboard accessible
- [ ] Icon-only buttons have `aria-label`
- [ ] Color is not the only indicator of state

## Security

- [ ] No secrets or API keys in client-side code
- [ ] User input is validated/sanitized
- [ ] Server-side authorization checks present for protected operations
