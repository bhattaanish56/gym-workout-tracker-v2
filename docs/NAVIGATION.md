# Navigation Implementation

## Overview

DEV-005a implements a provisional five-section app shell using GoRouter 18.1.4 with StatefulShellRoute.indexedStack. This is an app structure foundation, not final UX or functional tracking.

## Routes

| Path | Branch | Content | Status |
|------|--------|---------|--------|
| `/` | - | Redirects to `/home` | Implemented |
| `/home` | 0 | HomeScreen with quick actions | Implemented |
| `/workouts` | 1 | Empty state for programs/sessions | Provisional |
| `/exercises` | 2 | Empty state for exercise catalog | Provisional |
| `/progress` | 3 | Empty state for progress tracking | Provisional |
| `/nutrition` | 4 | Empty state for nutrition logging | Provisional |
| Unknown | - | Page not found with Home recovery | Implemented |

## Navigation Shell

### Adaptive Layout Breakpoints

| Condition | Navigation | Extended |
|-----------|------------|----------|
| width < 720 OR height < 480 | NavigationBar (bottom) | - |
| width ≥ 720 AND height ≥ 480 | NavigationRail (left) | No |
| width ≥ 1200 AND height ≥ 480 | NavigationRail (left) | Yes |

Extended rail:
- Shows labels inline with icons
- Sets labelType to NavigationRailLabelType.none (Material3 pattern)

Compact rail:
- Shows labels below icons
- Uses NavigationRailLabelType.all

### Navigation Icons

| Section | Outlined Icon | Filled Icon |
|---------|---------------|-------------|
| Home | home_outlined | home |
| Workouts | fitness_center_outlined | fitness_center |
| Exercises | list_outlined | list |
| Progress | trending_up_outlined | trending_up |
| Nutrition | restaurant_outlined | restaurant |

## Branch Preservation

StatefulShellRoute.indexedStack preserves scroll position and UI state when switching branches. Navigation calls `navigationShell.goBranch(index, initialLocation: false)` to maintain state.

## Test Keys

Public keys for test assertions:
- `nav-bar`: Bottom NavigationBar
- `nav-rail`: Left NavigationRail
- `nav-home`, `nav-workouts`, `nav-exercises`, `nav-progress`, `nav-nutrition`: Bottom bar destinations
- `page-home`, `page-workouts`, `page-exercises`, `page-progress`, `page-nutrition`: Content pages

## Module Boundaries

**Implemented:**
- `/home` → HomeScreen in `lib/features/home/presentation/screens/`
- Shared PageFrame and SectionPage in `lib/shared/widgets/section_page.dart`
- AppShell in `lib/app/app_shell.dart`
- Router configuration in `lib/app/router.dart`

**Future (not implemented):**
- Workouts is UI umbrella for separate programs/ and sessions/ modules
- Each section will move to feature-specific presentation when logic is assigned
- Auth flows, Firebase initialization, CRUD operations, schema definitions
- Settings persistence, theme/locale pickers
- Actual workout tracking, exercise definitions, progress charts, nutrition calculations

## Assumptions

1. Deep linking and web URL handling use default GoRouter behavior
2. No custom page transitions (NoTransitionPage for instant switches)
3. No authentication guard on routes yet
4. Home scroll retention is covered by a widget test; actual results are recorded after supervisor validation
5. Router is disposed when provider scope is disposed
6. Test routers are created and disposed explicitly in test scope

## Design Constraints

- Max content width: 960px
- Adaptive horizontal gutters: 24px (< 600px width), 40px (≥ 600px)
- Vertical padding: 24px
- All content wrapped in SafeArea
- All scrollable content uses SingleChildScrollView
- Semantic heading hierarchy preserved
- No hardcoded color values in screens
- Theme from `lib/app/theme.dart` with deepPurple (#673AB7) seed

## Known Limitations

1. Empty states are truthful placeholders, not final copy
2. Branch state is in-memory only; restart restoration is not implemented
3. No animation between branch switches (intentional for simplicity)
4. No error boundary for child route failures
5. HomeScreen receives navigation callbacks from app-level routing

## References

- [StatefulShellRoute documentation](https://pub.dev/documentation/go_router/latest/go_router/StatefulShellRoute-class.html)
- [StatefulNavigationShell.goBranch](https://pub.dev/documentation/go_router/latest/go_router/StatefulNavigationShell/goBranch.html)

---

**Last Updated:** 2026-11-17
**Implementation:** DEV-005a

Validation outcomes are recorded in DEVELOPMENT-HANDOFF.md. Twenty tests pass on VM and headless Chrome through the documented local tooling workaround. Device and manual browser visual verification remain pending.
