# Styling Conventions

## Tailwind CSS

Tailwind is the primary styling approach. Avoid `<style>` blocks except when absolutely necessary (e.g., `:global()` targeting third-party rendered HTML).

### Class Composition with `cn()`

Use `cn()` (a `clsx` + `tailwind-merge` wrapper) for conditional classes. Never use ternaries in class attributes.

```svelte
<!-- Correct: boolean && pattern -->
<div class={cn(
  "px-4 py-2 rounded-md",
  isActive && "bg-primary text-white",
  isDisabled && "opacity-50 cursor-not-allowed",
  variant === 'outline' && "border border-border"
)}>

<!-- Wrong: ternary in class -->
<div class={`px-4 py-2 ${isActive ? 'bg-primary' : 'bg-muted'}`}>
```

### Class Ordering

Follow Tailwind's recommended order:
1. Layout (display, position, overflow)
2. Sizing (width, height)
3. Spacing (margin, padding, gap)
4. Typography (font, text, leading)
5. Visual (background, border, shadow, opacity)
6. Interactive (cursor, pointer-events)
7. Transitions/animations

### Design Tokens

When a project has a design system with token-based Tailwind classes, prefer tokens over raw values:

```svelte
<!-- Prefer tokens when available -->
<p class="text-ax-body-regular text-ax-foreground">

<!-- Over raw values -->
<p class="text-sm font-normal text-gray-800">
```

### Responsive Design

Mobile-first approach using Tailwind breakpoints:

```svelte
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
```

### No Style Blocks

Do not use `<style>` blocks. The only exception is `:global()` selectors for styling third-party HTML that you don't control.

```svelte
<!-- Only acceptable use of style block -->
<style>
  :global(.third-party-widget .label) {
    font-size: 14px;
  }
</style>
```
