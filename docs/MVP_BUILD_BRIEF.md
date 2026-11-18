# GYM WORKOUT TRACKER V2 — MVP BUILD BRIEF

## Checkpoint
Commit: e51d38b
Branch: codex/dev005-navigation-foundation
Date: 2026-11-18

## Mission
Transform existing Flutter project into polished, functional, offline-first gym companion.

## Stack
- Flutter/Dart
- Riverpod state management
- GoRouter navigation
- Drift SQLite persistence
- SharedPreferences theme
- Offline bundled exercise library

## Global UI Design
**Default: LIGHT theme**

Light: #F7F8FA bg, #FFFFFF cards, #17191D text, #FF6B00 accent
Dark: #101114 bg, #1C1E23 surface, high-contrast text, #FF6B00 accent

Material 3, consistent spacing, 48dp touch targets, responsive 320-430px + desktop.
One bottom nav: Home, Workouts, Exercises, Progress, Nutrition.
Theme persists. No obstructing float buttons.

## Feature Requirements

### A — Home Dashboard
- Time-based greeting + user name
- Main card: Resume/Today's Plan/Rest Day/Start Freestyle
- Weekly completed workouts, streak, recent workout, latest bodyweight
- Quick links to plans/exercises/progress
- Real data only, no fake stats

### B — Workouts Hub
- Active workout/resume card
- Active plan summary with today's scheduled workout
- Start Planned Workout / Start Freestyle
- Switch Plan / Manage Plan / Deactivate Plan
- Quick nav: My Plans, Templates, History
- Recent workouts or empty state

### C — Workout Session Logger (HIGHEST PRIORITY)
- Start freestyle or scheduled workout
- ONE active workout at a time
- Exercise cards with sets, weight, reps, completed checkbox
- Add/remove/reorder exercises and sets
- Previous performance display
- Autosave without disrupting input
- Cleared values must persist cleared
- Rest timer: 60/90/120s presets, pause/resume/skip
- Finish → completion review → persist → refresh all views
- Plan edits: this workout only OR this + future sessions

### D — Plans and Templates
- Five-step builder, v6 WeekdayAssignments
- Create/edit/view/activate/switch/deactivate
- Fixed-weekly: weekday assignments (1-7)
- Flexible rotation: follow program-day order
- Templates: PPL, Upper/Lower, Full Body, Bro Split
- Using template creates editable copy

### E — Exercise Library
- Search by name, muscle-group filter, equipment filter
- Exercise detail, form instructions
- Favorite/unfavorite
- Custom exercise creation
- Consistent light/dark theme

### F — Progress
- Total workouts, workouts this week, streak
- Valid completed volume only
- Bodyweight entry/history/chart
- Height, BMI calculation
- Exercise strength progression, estimated 1RM
- Real date-based charts

### G — Nutrition MVP
- Today/date selector (local date)
- Daily calorie + P/C/F totals
- Breakfast/Lunch/Dinner/Snacks sections
- Manual food entry with serving/macros
- Edit/delete entries
- Persist locally
- No external APIs, no barcode scanning

### H — Workout History
- Completed workouts display immediately
- Exercise list, set details, volume
- Rename, delete with confirmation
- Repeat workout
- Retain historical snapshots

## Execution Milestones
M0 — Safe Git checkpoint ✓
M1 — Visual consistency, navigation, Home, Workouts Hub
M2 — Freestyle/planned workout logging
M3 — Plan creation, scheduling, templates
M4 — Exercise Library, history, Progress
M5 — Nutrition MVP
M6 — Tests, responsive UI, builds

## Verification Rules
- Test real workflows, not just compilation
- flutter analyze + focused tests during dev
- Full flutter test at integration
- flutter build web --release
- flutter build apk --debug if available
- Mark browser tests UNVERIFIED if unavailable
- Never delete existing test data to pass tests

## Completion Criteria
- Main journeys functional
- Core values persist accurately
- All five tabs accessible and themed
- Workouts/plans work
- Home shows real schedule
- Progress uses valid data
- Nutrition logs food offline
- No release-blocking exceptions
- Analysis/build checks pass
- Honest test status reporting

Output `<promise>MVP_VERIFIED</promise>` only when all criteria met.
