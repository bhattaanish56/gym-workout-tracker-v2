# Gym Workout Tracker V2 roadmap

Recovered from the accessible "Gym Tracker Overview" and "Supervise Project
Development" chats. This records confirmed scope rather than replacing the
unavailable full architecture and UX specifications.

## M0: project foundation

| Task | Scope | Current state |
| --- | --- | --- |
| DEV-001 | Fresh Flutter project, Android/iOS/Web scaffolding | Verified at `16d2b71` |
| DEV-002 | Feature-first layering and app composition | Foundation pilot verified at `8ab2a52`; full-spec compliance unverified |
| DEV-003a | Riverpod bootstrap and planned routing/storage dependencies | Implemented; resolver, analysis, VM widget test and Web build passed |
| DEV-003b | Remaining dependencies and platform compatibility | Firebase packages resolved; iOS project target aligned to 15; backend remains uninitialized and native validation incomplete |
| DEV-004 | Theme and UI foundation | Provisional dark-first themes verified; finalized UX specification still needed |
| DEV-005 | Navigation and app shell | Provisional five-section adaptive shell verified; final UX and authentication flow pending |
| DEV-006 | Testing and CI | 17 widget tests and 12 controller tests pass locally; manual-only workflow prepared, remote run pending |

DEV-003a and DEV-003b are small execution slices of the recovered DEV-003
milestone, not new product requirements. No full DEV-003 task specification was
present in the returned chat history.

## Planned feature boundaries

Authentication, onboarding, home, programs, sessions, exercises, progress,
nutrition, profile, and account data. AI assistant is future-only. No feature
behavior, fitness formulas, database schema, or UI layout is implied by these
module names.

## Required source recovery

- GWT-V2-ARCH-001.
- GWT-V2-DEV-001.
- Finalized UX specification.

The accessible chat response returned no attachments containing these documents.
They were not present in this repository or the previously selected project
Documents folder. Their contents must be recovered before claiming compliance
or inventing product behavior.

## Execution policy

The supervisor assigns one bounded task to Claude CLI through the user's
configured 9router provider, reviews its actual output, independently validates
changes, and saves a local checkpoint. Failed outputs do not establish success.
Source changes, dependencies, repository setup, commits and pushes are authorized.
Preserve unrelated work and never force-push or discard changes without a
specific need and authorization.

Destructive operations, credentials/account changes, new paid services, public
releases, deployments and production Firebase changes remain approval gates.
No recurring dispatcher is enabled. Active-session waiting for temporary rate
limits does not establish self-restart after Codex stops or the host sleeps.

See DEVELOPMENT-HANDOFF.md for observed results and remaining limitations.

Android SDK components are now installed; build validation remains limited by
disk headroom and an active free-space reserve. Chrome-platform widget validation has timed out; a successful
Web build is not evidence of browser-runtime success. These do not block saving
the independently verified dependency/bootstrap source checkpoint.
