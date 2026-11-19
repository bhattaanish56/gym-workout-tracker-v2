GYM WORKOUT TRACKER V2 — UI MOCKUP REFERENCES

These images are design references for Claude Code, NOT app screenshots or Flutter UI assets.

Suggested project location: docs/ui-design/mockups/

LATEST DECISION FOR SET EDITOR: Refer to 08_set_editor_centered_modal_latest.png.
- Tapping the editable area of a set row opens a focused CENTERED modal over a dimmed workout screen, not a bottom sheet.
- Three vertically scrolling pickers: Type, Reps, KG.
- KG initially scrolls in increments of 1 kg. Long-press/hold on the selected weight switches to 0.5 kg increments; e.g. scroll to 55, hold, then select 55.5.
- Support direct numerical input as accessibility and precision fallback.
- Cancel discards draft changes; Save Set persists the edits.
- Completion checkbox remains independently tappable.

CTA: Start Workout has subtle breathing orange glow, with reduced-motion support.

NOTES:
- All screenshot data values are synthetic examples. Do not hardcode them.
- Generated mockup text and layouts may contain inconsistencies; app behavior and existing data models take precedence.
- Dark mode should be theme-derived; light screenshots are the visual reference.
- Design content is subject to review; do not import these images as production assets.
