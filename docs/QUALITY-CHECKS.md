# Quality checks

The supervisor independently runs checks after reviewing Claude's proposal.
Private stdout/stderr, exit codes, timeouts and resource stops are retained under
ignored `build/unattended-pilot/`; these logs are not published as CI artifacts.

```sh
flutter pub get --enforce-lockfile
dart format --output=none --set-exit-if-changed lib test
flutter analyze --no-pub
python -m unittest discover -s scripts -p test_claude_pilot.py -v
flutter test --no-pub
python scripts/check_browser.py
flutter build web --no-pub
```

The controller tests never call Claude or the network. Windows-only job lifecycle
coverage is skipped on Linux; Windows remains the host for that verified check.
Twenty widget tests cover bootstrap, routes, Home shortcuts, adaptive navigation,
selected-page preservation on resize, branch scroll retention, Enter activation
of a focused rail destination, themes, contrast and small/large-text viewports.
Programmatic focus in that activation test does not establish keyboard traversal.
These tests do not establish
browser rendering, device performance or complete accessibility compliance.

## Optional manual CI

`.github/workflows/manual-quality.yml` runs only through `workflow_dispatch`.
Once a repository is connected and the workflow is available on its default
branch, select **Manual quality checks → Run workflow** in GitHub Actions.
It does not run on pushes, pull requests or a schedule. No remote run has yet
been performed. It publishes a seven-day Web build artifact, not a hosted app.
The job cannot push changes, deploy, contact Claude or configure Firebase.

Flutter is pinned to 3.44.6 and third-party actions use immutable commit hashes:
[checkout v7.0.1](https://github.com/actions/checkout/releases/tag/v7.0.1),
[flutter-action v2.23.0](https://github.com/subosito/flutter-action/releases/tag/v2.23.0),
[upload-artifact v7.0.2](https://github.com/actions/upload-artifact/releases/tag/v7.0.2).
Review pins deliberately when updating; no dependency-update automation is enabled.

## Remaining platform gates

Android builds use an active 2 GB free-space reserve and a process timeout.
A debug build targeting android-arm64 completed and its APK metadata/checksum
were verified. A full multi-ABI debug build has not completed within this host's disk budget.
No Android device/emulator is connected. Native iOS builds require macOS/Xcode.
All 20 widget tests also passed in headless Chrome through `check_browser.py`.
On Windows, the installed Flutter 3.44.6 test server has the URL-path mismatch
described in [Flutter issue 192069](https://github.com/flutter/flutter/issues/192069).
The helper corrects only URL classification in a disposable tool copy under
`.dart_tool`; it does not patch the installed SDK. It logs the original handler
hash and unchanged status, stops after 180 seconds or at a 2 GB disk reserve,
and removes the copy. Other hosts use installed tooling directly. Reassess this
workaround when upgrading Flutter rather than applying a global SDK patch.
See ignored `build/unattended-pilot/browser-check.json` for actual outcomes.
Manual browser visual/accessibility and device checks remain open gates.
