# Code Quality Standards

## TypeScript

- Strict mode always enabled
- Prefer explicit types for function signatures and exported APIs
- Use type inference for local variables when the type is obvious
- Prefer `interface` for object shapes, `type` for unions/intersections/mapped types
- Avoid `any`; use `unknown` when the type is genuinely not known
- Underscore-prefix unused variables/params: `_unused`

## Formatting

- Tabs for indentation (not spaces)
- Single quotes
- No trailing commas
- 100 character line width
- Prettier handles formatting; don't fight it

## Linting Rules

- No `console.log` in client code (use proper logging or remove before commit)
- `console.warn`/`console.error` acceptable in server-side code
- No ternaries in class attributes (use `cn()` with boolean `&&`)
- Prefer `const` over `let` when the binding isn't reassigned

## Component Design

### Props API

- Keep prop interfaces minimal; don't expose implementation details
- Use sensible defaults to reduce required props
- Accept a `class` prop (aliased from `className`) for style customization
- Callback props use `on` prefix: `onselect`, `onchange`, `ondismiss`

### Composition Over Configuration

- Prefer composable components with snippets/children over mega-components with dozens of props
- Use the "compound component" pattern for complex UI (e.g., `Table`, `TableHeader`, `TableRow`, `TableCell`)

### Accessibility

- Use semantic HTML elements (`button`, `nav`, `main`, `section`)
- Include `aria-label` on icon-only buttons
- Ensure keyboard navigation works for interactive elements
- Use proper heading hierarchy

## Error Handling

- Never silently swallow errors
- Use SvelteKit's error handling (`error()`, `+error.svelte`) for route-level errors
- Show user-facing error messages for failed operations
- Log errors with context on the server side

## File & Directory Naming

- Components: `PascalCase.svelte`
- TypeScript modules: `camelCase.ts` or `kebab-case.ts` (match project convention)
- Route directories: `kebab-case`
- Type files: one file per domain, named after the domain (`filters.ts`, `compounds.ts`)
- State modules: `name.svelte.ts` (for Svelte 5 rune-based state)

## Imports

- Group imports: external packages first, then internal modules, then relative imports
- Use package aliases (`$lib/`, `design-system`, `components`) over deep relative paths
- Barrel exports (`index.ts`) for public package APIs; avoid for internal modules
