# Provisional UI foundation

DEV-004a implements the confirmed dark-first direction while the finalized UX
specification is being recovered. The existing deep-purple starter seed, Material
icons, typography and counter layout remain the basis for this small foundation.

## Theme API

`AppTheme.light` and `AppTheme.dark` provide Material 3 ThemeData with semantic
seeded ColorScheme roles. `MyApp()` defaults to dark. Explicit light mode and
system brightness are available through `MyApp(themeMode: ...)` for future
composition; there is no theme-preference screen or persistence yet.

Flutter documents [theme selection](https://api.flutter.dev/flutter/material/MaterialApp/themeMode.html)
and [seeded color roles](https://api.flutter.dev/flutter/material/ColorScheme/ColorScheme.fromSeed.html).

## Validation scope

Widget coverage checks the real entry point/counter interaction, dark default,
explicit light and system changes, semantic foreground/background contrast, and
375x812 / 812x375 viewports at 2x text scale. Actual outcomes are recorded in
DEVELOPMENT-HANDOFF.md after independent execution; proposed tests are not proof
that they passed. Browser, device, visual and assistive-technology checks remain
separate gates. These checks do not establish full accessibility compliance.

The seed, typography, component styling and layout are provisional. This is a
small reusable theme foundation, not the recovered finalized design system.
There are no new product screens, mock statistics or fitness calculations.
