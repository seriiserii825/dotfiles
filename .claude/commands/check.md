Run the following checks and report results:

1. **TypeScript check:**
   - If `vue-tsc` is available or `.vue` files exist in the project — run `vue-tsc --noEmit`
   - Otherwise — run `tsc --noEmit`

2. **Lint check:**
   - If `.vue` files exist — run `eslint . --ext .ts,.tsx,.vue`
   - Otherwise — run `eslint . --ext .ts,.tsx`

If both pass — report "✅ All checks passed".
If something fails — show the exact errors and suggest fixes.
