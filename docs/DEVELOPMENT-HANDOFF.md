# Development handoff

Updated: 2026-11-17 (Asia/Katmandu).

## Additional source recovery

Read-only filename checks found two older project proposals in Downloads:
`Gym_Workout_Tracker_Proposal.docx` and `Gym_Workout_Tracker_Proposal1.docx`.
Their extracted text describes Firebase accounts, exercise/sets/reps/notes logs,
dated history, streaks, BMI, weight charts and a WGER library. Both explicitly
exclude nutrition, which conflicts with the recovered V2 five-section plan.
They are historical context, not GWT-V2-ARCH-001, GWT-V2-DEV-001 or finalized V2
UX. No author/personal details were copied into this handoff. Related project ZIPs
contain presentation PNGs, not source code or the missing specifications. None
of these files were edited or sent to Claude/9router. Their requirements were
not silently adopted into the V2 data model or business rules.

## DEV-006b browser gate resolved with isolated tooling workaround

- Found the installed Flutter 3.44.6 test server's Windows URL/path mismatch:
  `_localCanvasKitHandler` converts `canvaskit/...` to backslashes and then checks
  a forward-slash prefix. This matches the mechanism reported in
  [Flutter issue 192069](https://github.com/flutter/flutter/issues/192069).
- In a disposable local tooling copy, changed only that URL classification to
  `request.url.path`. The isolated plain-widget Chrome probe passed, followed by
  all 20 application widget tests in headless Chrome. Evidence:
  `browser-path-diagnostic.json` and `browser-app-path-corrected.json` under
  `build/unattended-pilot/`. Early copy/path setup failures were corrected before
  either browser result was obtained; the installed SDK was never patched.
- Added `scripts/check_browser.py` to reproduce the verified check. On affected
  Windows tooling only, it copies the tool into a unique `.dart_tool` temporary
  directory, rewrites dependency locations for that copy, makes the single URL
  correction, and runs Chrome tests. Other hosts use their installed tooling.
  It preserves a 2 GB reserve, bounds execution to 180 seconds, records the
  installed handler hash/unchanged status and removes its disposable copy.
- The reusable command independently passed all 20 tests; evidence:
  `browser-check.json`. The installed handler remained byte-identical and the
  temporary directory was removed. The earlier diagnostic tooling copy was also
  removed after resolved-path/reparse checks; its JSON evidence remains.
- Added the browser gate to the manual-only quality workflow. Ubuntu 24.04's
  official runner image includes Chrome/Python; remote CI itself remains unrun.
  Headless widget coverage is now verified, while manual browser visual checks,
  Android installation/runtime, release packaging and native iOS remain pending.

## DEV-006a regression coverage and ARM64 packaging

- Navigation foundation saved as `3ad778f`. One subsequent bounded Claude
  request proposed three test additions, using the same four approved inputs;
  evidence: `20261117T010154.205610Z/` under `build/unattended-pilot/`.
- The supervisor replaced its brittle two-Tab assumption with targeted focus
  and real Enter activation, and strengthened resize assertions to check the
  actual visible page and selected destination as well as URI. All 20 widget
  tests passed. Formatting and analysis also passed after removing the two
  temporary screenshot/YAML probes; their initial lint findings were confined
  to those probes, not hidden through analyzer exclusions.
- A single `flutter build apk --debug --target-platform android-arm64 --no-pub`
  completed successfully in 51 seconds while retaining the 2 GB reserve.
  Locked dependencies were verified first with offline `--enforce-lockfile`.
  Evidence: `android-arm64-dev005/report.json`. APK:
  `build/app/outputs/flutter-apk/app-debug.apk`, 97,604,426 bytes; SHA-256
  `6dd1c6839749a115ac942b9f5e79e3d40db75966e44fb3e2ca67fb3ffa7637a9`.
- APK inspection verified `com.gymworkouttracker.v2`, version 1.0.0 (1), target
  SDK 36 and display name Gym Workout Tracker V2. The Flutter engine is ARM64;
  transitive plugins also bundle some ARMv7/x64 libraries. This is not a
  universal Flutter APK. No installation or device launch occurred.
- Phone (390x844) and desktop (1280x800) PNGs were rendered with Flutter's test
  engine, real local Roboto/Material fonts, and inspected by the supervisor.
  No clipping/overlap was observed in those two Home layouts. Files are ignored
  `preview-phone.png` / `preview-desktop.png`; these are widget renders, not
  browser/device screenshots or complete visual/accessibility verification.
- Remaining native gates: other CPU targets, release signing and device runtime;
  iOS remains unbuilt on Windows. Browser tests still require diagnosis. Actual
  tracking, persistence and Firebase remain unimplemented pending specifications.

## Current checkpoint: DEV-005a navigation and manual quality workflow

- Claude supplied the eight-file navigation proposal via the existing 9router
  connection, using only the four explicitly approved input files. Evidence:
  `20261117T000249.875380Z/` under ignored `build/unattended-pilot/`. The
  supervisor reviewed and corrected routing, page constraints, Home callbacks,
  empty-state copy and test assertions before applying the result.
- Replaced the starter counter with Home, Workouts, Exercises, Progress and
  Nutrition branches. Compact/short windows use bottom navigation; wider/taller
  windows use a rail, extended on desktop. Root redirects, unknown-route recovery
  and in-memory Home scroll retention are implemented. These are provisional
  navigation screens; there is no logging, storage or backend behavior yet.
- App, Android and web display names now agree. Web metadata uses the actual
  dark surface color and allows both orientations. Application IDs are unchanged.
- Independent formatting, analysis, 17 VM widget tests and Web build all passed.
  Evidence: `dev005a-validation/final/report.json`. Browser/device/manual visual
  checks remain unverified; serving HTTP 200 is not evidence of rendered UI.
- Controller manifests now support bounded task-specific time/budget estimates.
  Proposal parsing accepts one explicit JSON fence from the provider and rejects
  ambiguous artifacts. Path checks reject drive/alternate-stream colons on every
  host. All 12 controller tests passed after these changes.
- `.github/workflows/manual-quality.yml` is manual-only, has a 20-minute limit,
  a read-only token and immutable action pins. It resolves the lockfile, formats,
  analyzes, runs controller/widget tests and produces a Web artifact. YAML and
  trigger/permission/pin checks passed locally. No remote CI run is claimed;
  no Git remote exists and no recurring trigger or Claude job was enabled.
- A read-only localhost preview is bounded to four hours. Runtime URL and expiry
  are in ignored `local-preview.json`; it was queued for the Codex browser panel,
  but no visual rendering was confirmed. It is not a deployment or persistent
  development dispatcher.
- The previous full multi-ABI Android attempt stopped at the 2 GB disk reserve.
  Only its generated `build/app` directory was removed after path/symlink checks;
  Web output and diagnostic logs were preserved, restoring about 4.1 GB free.
  Completed SDK components remain installed. No APK success is claimed here.

Earlier sections below are historical checkpoints. Current pending work is
native/runtime validation and recovery of the full specifications before
implementing authoritative tracking rules or a data schema. Second Brain writes
remain outside the permitted roots; this repository is the verified handoff.

## DEV-004a provisional theme foundation

- Claude produced the Material 3 light/dark theme library, widget coverage and
  draft documentation. The supervisor integrated the API into MyApp, corrected
  contrast tests to compare actual foreground/background roles, and replaced
  deprecated or ineffective text-scale fixtures with asserted platform scaling.
- Default mode is dark; explicit light and system modes are injectable through
  MyApp's constructor. There is no preference UI/storage. Existing seed, icons,
  typography and counter layout/behavior remain the provisional basis.
- Formatting, analysis, all eight widget tests and the Web build passed under
  the active 2 GB disk reserve. Tests cover real bootstrap/counter interaction,
  default/explicit/system modes, semantic contrast and operable 375x812/812x375
  layouts at an asserted 2x text scale. Evidence: `dev004a-validation/report.json`
  under `build/unattended-pilot/`.
- The Flutter stack guidance from the UI/UX skill was consulted. This is an
  isolated foundation based on the confirmed dark-first direction; finalized UX,
  manual visual checks, browser runtime and device verification remain pending.
- A final incremental Android attempt may use the now-installed toolchain and
  recovered space, but must keep the active 2 GB reserve and an explicit timeout.

## Resource-guarded Android and browser investigation

- Added an optional free-space reserve to the process runner. It checks before
  launch and every 0.5 seconds while the child runs, and terminates the contained
  process tree when the reserve is reached. Eleven tests passed, including
  prevention of low-space launches and termination of a running worker.
- A guarded Android retry installed NDK 28.2.13676358, Android platforms 34/35/36,
  and CMake 3.22.1 successfully. The build then reached the 2 GB reserve and was
  stopped by the guard; no successful APK build is claimed. Completed SDK
  installations were preserved. Evidence: `android-guarded-retry/report.json`
  under `build/unattended-pilot/`.
- Applied reversible NTFS compression only to the newly installed, completed NDK
  directory. Reparse points were refused. Hashes of source.properties and clang.exe
  matched before/after. The command succeeded and recovered about 1.0 GB, raising
  observed free space from about 1.97 GB to 3.00 GB. No deletion or CompactOS
  setting was involved. Evidence: `build/unattended-pilot/ndk-compression.json`.
- Ignored Android's generated `.kotlin` build cache; no cache contents were added
  to Git. Empty allowed-output task scopes now reject proposals instead of
  inheriting a default scope.
- The supported Wasm browser test also compiled then stalled before executing
  tests. A monitored standard Flutter browser-test command, without the custom
  wrapper, stalled as well and was interrupted cleanly. The wrapper is therefore
  not the sole cause. CanvasKit assets have plausible nonzero sizes; aggregate
  available memory did not identify pressure at the inspected point.
- Claude's generic diagnostic proposal remains private and unverified. Several
  suggested flags/renderers were inapplicable; no browser downgrade, global
  security change, or speculative app rewrite was performed.

Further native retries require a fresh resource check and the same active reserve.

## DEV-003b dependency continuation

- Claude proposed firebase_core 5.2.0, firebase_auth 7.1.0 and cloud_firestore
  7.2.0 declarations. They resolved successfully with the pinned Flutter/Dart
  toolchain. The supervisor reviewed the proposal and corrected unsupported
  platform claims in its draft documentation before application.
- All three iOS project deployment settings were aligned from the generated
  13.0 default to 15.0, matching the documented Firebase minimum. Native iOS
  compilation remains unverified and requires macOS/Xcode.
- Formatting, analysis, one VM widget test and the Web build passed after the
  actual changes. Evidence: `build/unattended-pilot/dev003b-actual-validation/`.
  An earlier validation ran against unchanged DEV-003a source because a proposal
  formatting assertion stopped application; that older report is explicitly
  labeled as inapplicable to the Firebase changes.
- The parser now accepts a complete JSON code fence with no surrounding prose,
  including the already supported provider wrapper. Arbitrary prose remains
  rejected. All nine controller tests passed after this change.
- Source sharing of the new dependency document was rejected by automatic
  approval review. The safer request excluded that document and transmitted
  only explicitly approved pubspec/architecture files; documentation was
  corrected locally from the resulting proposal.
- No Firebase initialization call, project configuration, Google Services file,
  authentication flow, database operation, cloud request, deployment or production
  action was added. Dart package resolution is not native-platform validation.
- Full DEV-003 completion remains blocked on native platform validation. The
  missing architecture/UX source documents still prevent specification-driven
  screen and feature implementation. No persistent dispatcher is enabled.

## DEV-003a continuation

Implemented after the user instructed continuous development beyond DEV-002:

- Claude proposed dependency/bootstrap changes using the reviewed generic task
  manifest mode. The strict automated parser rejected surrounding prose/code
  fences; the supervisor manually inspected the response, validated its four
  output paths, and applied the reviewed JSON contents.
- Added and resolved flutter_riverpod 3.5.0, go_router 18.1.4, drift 2.35.4,
  drift_flutter 0.3.1 and path_provider 2.1.6. Lockfile records the resolved graph.
- The real entry point now installs ProviderScope. The widget test calls that
  entry point, checks the scope exists and verifies the counter interaction.
- Dependency resolution, Dart formatting, analysis, one widget test and a Web
  release build passed. Evidence: `build/unattended-pilot/dev003a-validation/`.
- Nine runner tests passed, including task-path rejection and Windows job
  cleanup when the supervisor exits. Generic task manifests have explicit
  input/output source paths; proposals still require supervisor review/application.
- Android debug build failed installing NDK 28.2.13676358 because C: ran out of
  disk space. No APK was produced. Removed only the two incomplete installer
  directories created by this attempt, after checking timestamps, contents,
  resolved SDK paths and absence of a completed NDK `source.properties` file.
  This recovered about 2.3 GB. Do not retry NDK installation with this little
  free space; provide substantially more disk headroom first.
- Flutter doctor found no Android device, reported Android license status
  unknown, and reported missing Visual Studio (Windows desktop is not a target).
- Chrome-platform widget tests timed out after 180 seconds both during the
  full-disk condition and on one retry after cleanup. Browser-runtime testing
  has not passed. A 60-second verbose diagnostic reached Chrome launch and test
  suite startup, then timed out. An isolated plain-widget probe that imports
  neither the app nor Riverpod also timed out before its test body. The probe
  was removed after checking that its contents were unchanged. This narrows the
  investigation to browser-test harness readiness; it does not establish a
  browser-runtime pass or justify speculative app changes. Evidence includes
  `chrome-diagnostic.json` and `minimal-chrome-diagnostic.json`.
- Firebase packages, backend configuration, database schema/codegen, UI theme and
  routing remain deferred. iOS currently targets 13; Firebase's documented
  minimum of 15 is a compatibility decision that has not been applied.
- Computer-use fallback for source recovery was attempted, but app approval timed
  out. No project specifications were read through native app UI and no browser
  changes were made. A request for the missing specification paths is pending.

The entire DEV-003 milestone is not complete. `docs/ROADMAP.md` records confirmed
milestones and the missing requirements without inventing product behavior.
Checkpoint branch: `codex/dev003-dependencies`. No Android retries should be made
without a fresh resource check. A direct check after the browser tests exited
showed about 8.1 GB free; earlier low-space readings overlapped active processes.

## Verified checkpoint

- Base: `16d2b71`; task branch: `codex/dev002-architecture`.
- Claude Code through the user's existing localhost 9router connection returned a
  DEV-002 implementation proposal. The first proposal failed independent review;
  one correction request produced the accepted proposal.
- The supervisor applied the reviewed changes. Claude had no tools or direct
  filesystem access during these requests.
- `lib/main.dart` now starts the app and re-exports its existing public widgets.
- `lib/app/app.dart` contains the original starter widgets. Their class bodies
  were compared with the base revision and preserved without behavioral changes.
- `docs/ARCHITECTURE.md` defines feature boundaries, layers, naming, contracts,
  testing conventions, and planned storage/platform separation.
- No dependencies, platform identifiers, navigation, theme, or Firebase setup changed.

## Validation

All commands below passed after the app changes:

- `dart format --output=none --set-exit-if-changed lib test`: no changes.
- `flutter analyze --no-pub`: no issues.
- `flutter test --no-pub`: one widget test passed.
- `flutter build web --no-pub`: Web build and Wasm dry run succeeded.
- `python -m unittest discover -s scripts -p test_claude_pilot.py -v`:
  seven controller tests passed, including process-tree termination on timeout,
  failed-command handling, response validation, path restrictions and redaction.
- `git diff --check`: passed after documentation whitespace cleanup.

No Android or iOS build, device launch, or visual responsive check was performed.
The UI remains the starter counter screen; workout functionality is not implemented.

## Pilot operation and evidence

- `scripts/claude_pilot.py --run-claude` sends one tool-free connection request.
- `scripts/claude_pilot.py --propose-dev002` sends the fixed DEV-002 context and
  saves a three-file proposal for review; it never automatically applies files.
- `scripts/claude_pilot.py --verify-flutter` independently runs analysis and tests.
- The runner uses one lock, per-command timeouts, a Windows job object for process
  cleanup, a persisted per-run report, and no automatic repair loop.
- Existing API routing values are passed only to the child environment. Settings,
  hooks, plugins, MCP tools, shell tools, and file-editing tools are disabled for
  Claude requests. No credentials are embedded in source or deliberately logged.
- CLI budget stops are estimates, not guarantees of provider billing limits.
- Private logs and proposals are under ignored `build/unattended-pilot/`.
- Accepted proposal: `20261116T181808.112879Z/proposal.json` in that directory.
- Independent Flutter evidence: `dev002-validation/report.json` in that directory.
- Initial sandbox failures are retained. Local proxy access and Flutter checks
  required approved execution outside the restricted sandbox.

## Authorization and remaining work

The user authorized project development, source transmission through their
configured 9router provider, branches, repository creation/connection, commits,
and pushes. Preserve unrelated changes and stop for destructive operations,
new paid services, credential/account changes, public releases, production
deployments, or production Firebase changes.

No Git remote is configured. No push, repository creation, deployment, production
Firebase action, recurring schedule, or persistent overnight dispatcher was run.
This checkpoint verifies a supervised implementation/review/test cycle only.

Full GWT-V2-ARCH-001, GWT-V2-DEV-001 and finalized UX documents remain unavailable.
Recover them before claiming full specification compliance or inventing feature
requirements. The next planned milestone is DEV-003: dependencies and platform
validation; its detailed task definition is still pending. Later milestones are
DEV-004 theme, DEV-005 navigation, and DEV-006 testing/CI.

A provider reset can be handled while the supervisor session remains active.
Self-restarting after Codex stops or after host sleep requires a separately
configured runner and has not been established. Second Brain was not updated:
its directory is outside the permitted write roots; this project-local file
holds the verified handoff.
