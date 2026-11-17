# Provisional UI foundation

DEV-004a implements the confirmed dark-first direction while the finalized UX
specification is being recovered. The existing deep-purple starter seed, Material
icons and Material typography remain the basis for this foundation. DEV-005a
replaces the starter counter with adaptive navigation and truthful empty states;
see NAVIGATION.md for the implemented routes and boundaries.

## Theme API

`AppTheme.light` and `AppTheme.dark` provide Material 3 ThemeData with semantic
seeded ColorScheme roles. `MyApp()` defaults to dark. Explicit light mode and
system brightness are available through `MyApp(themeMode: ...)` for future
composition; there is no theme-preference screen or persistence yet.

Flutter documents [theme selection](https://api.flutter.dev/flutter/material/MaterialApp/themeMode.html)
and [seeded color roles](https://api.flutter.dev/flutter/material/ColorScheme/ColorScheme.fromSeed.html).

## Validation scope

Widget coverage checks the real entry point/navigation, dark default,
explicit light and system changes, semantic foreground/background contrast, and
375x812 / 812x375 viewports at 2x text scale. Actual outcomes are recorded in
DEVELOPMENT-HANDOFF.md after independent execution; proposed tests are not proof
that they passed. Browser, device, visual and assistive-technology checks remain
separate gates. These checks do not establish full accessibility compliance.

The seed, typography, component styling and layout are provisional. This is a
small reusable theme foundation, not the recovered finalized design system.
There are no mock statistics or fitness calculations. The section screens are
navigation scaffolding; workout logging, persistence and backend behavior remain
unimplemented.

## Current dark palette

These values were read from the actual seeded ColorScheme in a local VM probe.
Screens consume semantic roles rather than duplicating hex values.

| Role | Value |
| --- | --- |
| surface | `#151218` |
| surfaceContainerLow | `#1D1B20` |
| primary | `#D3BCFD` |
| onSurface | `#E7E0E8` |
| secondary | `#CDC2DB` |
| outline | `#948F99` |

Android and web display names use Gym Workout Tracker V2. Web launch metadata
uses the dark surface color and permits both orientations; these metadata edits
do not establish device/browser runtime verification.
