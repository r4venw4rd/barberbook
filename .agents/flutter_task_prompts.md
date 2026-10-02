# ⚡ Flutter Agent — Task Prompt
# rules.md must be open in project context. Use this file at the start of every new task.

## 📋 Task
<!-- DEFINE TASK HERE -->
[Feature]: 
[Layer]: domain / service / dto / repository / notifier / page / component
[File(s)]: 

---

## ✅ Pre-Flight Checklist (Complete Before Writing Any Code)

- [ ] Which layer am I writing for? Am I violating that layer's dependency rules?
- [ ] Does this use `StatefulWidget` or `setState`? → **FORBIDDEN**. Use `HookConsumerWidget` + `flutter_hooks`.
- [ ] Am I using a `_buildXxx()` method for a non-trivial UI block? → Extract as a standalone widget class. Use a method only for trivially small blocks (1–3 widgets, no state, no params).
- [ ] Is threshold/error detection logic here? → **ONLY allowed in `repository/`**.
- [ ] Am I catching exceptions in a Service? → **FORBIDDEN**. Services only fetch — let exceptions propagate to Repository.
- [ ] Will this file exceed 100 lines? → **FORBIDDEN**. Extract into `components/` now.
- [ ] Any magic string routing or raw asset path? → **FORBIDDEN**. Use type-safe generated alternatives.
- [ ] Any hardcoded color (`Colors.x`, `Color(0x...)`)? → **FORBIDDEN**. Use `colorScheme` or design token.
- [ ] Any hardcoded UI string (`Text('...')`)? → **FORBIDDEN**. Use `context.l10n.*`.
- [ ] Using `ref.watch(provider)` for a single field? → **FORBIDDEN**. Use `.select()`.
- [ ] Using `BuildContext` after `await`? → Add `if (!context.mounted) return`.
- [ ] Any hardcoded pixel breakpoint (`width > 800`)? → **FORBIDDEN**. Use `Breakpoints.*`.
- [ ] Navigation widget (BottomNav, Rail, Drawer) directly in a Page? → **FORBIDDEN**. Belongs in `AppShell`.
- [ ] Is the web page wrapped in `ContentConstraint`? → If not, add it.
- [ ] Two different layouts inside one widget with `if (isMobile)`? → Extract separate `MobileLayout` / `DesktopLayout` components.
- [ ] Any hardcoded `TextStyle(fontSize: x)`? → **FORBIDDEN**. Use `textTheme.*`.

---

## 🚫 Forbidden Keywords (Stop and rewrite if any of these appear)
`setState` · `StatefulWidget` · `context.push('/')` · `Image.asset('` · `Colors.red` · `Color(0x` · `Text('` · `dynamic` · `fontSize:` · `MediaQuery.of(context).size.width >` · `Platform.isIOS` · `Platform.isAndroid`
