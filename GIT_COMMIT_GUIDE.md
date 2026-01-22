# Civic Resolve - Git Commit Guide

## Commit Strategy
We'll commit at strategic points to maintain clean git history. Here's the pattern:

### Phase 1: Theme & UI Foundation (✅ COMPLETED - COMMIT NOW)
**Files created:**
- `lib/theme/app_theme.dart` - Material 3 design system with light/dark themes
- `lib/providers/theme_provider.dart` - Theme state management
- `lib/widgets/app_shell.dart` - Responsive app layout shell
- `lib/widgets/common_widgets.dart` - Reusable UI components
- `lib/main.dart` - Updated with theme integration

**Commit Message:**
```
feat: implement Material 3 design system with dark/light mode

- Add professional theme configuration with custom colors
- Create responsive app shell with sidebar navigation
- Implement theme provider for dark/light mode toggle
- Add reusable UI components (buttons, loaders, empty states)
- Update main.dart to integrate theme system
```

## Upcoming Commit Points

### Phase 2: Authentication Service (Next - 5-8 commits)
- Firebase auth service with email verification
- Login screen UI
- Registration flows (Citizen, Worker, Authority)
- Email verification screen
- Password reset flow

### Phase 3: Firestore Models & Services (5-7 commits)
- User model and repository
- Issue model and repository
- Real-time data streams
- Location service integration

### Phase 4: Dashboards (8-12 commits)
- Citizen dashboard with issue reporting
- Worker dashboard with task assignment
- Authority dashboard with monitoring
- Issue detail views for each role
- Status tracking and timeline views

### Phase 5: Polish & Features (5-10 commits)
- Error handling improvements
- Loading states
- Animations and transitions
- Form validation enhancements
- Real-time notifications setup

## Quick Git Commands

### First Commit (After Phase 1):
```bash
# Navigate to project
cd c:\Users\praga\Desktop\projects\civic_resolve

# Check status
git status

# Stage all changes
git add .

# Commit with message
git commit -m "feat: implement Material 3 design system with dark/light mode

- Add professional theme configuration with custom colors
- Create responsive app shell with sidebar navigation
- Implement theme provider for dark/light mode toggle
- Add reusable UI components (buttons, loaders, empty states)
- Update main.dart to integrate theme system"

# Push to remote
git push origin main
```

### For subsequent commits:
```bash
git add .
git commit -m "feat: [feature name]"
git push origin main
```

## Commit Convention
- Use conventional commits: `feat:`, `fix:`, `refactor:`, `docs:`, etc.
- Be descriptive in the body
- Keep commits focused and atomic
- One feature per commit when possible

## When to Commit
1. ✅ After each major feature is complete and working
2. ✅ When a module is fully tested
3. ✅ After fixing significant bugs
4. ❌ Don't commit broken/incomplete code
5. ❌ Don't commit with console.log/debug prints

---

**Current Status:** Ready for first commit! 🎉
