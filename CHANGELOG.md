## 0.4.0

### Feat

- target Typst 0.15 (`compiler = "0.15.0"`)
- export a ready-to-use `kbd` renderer: `#import "@preview/keyle:0.4.0": kbd` works without `config()`
- parse shortcut strings: `kbd("Ctrl+Shift+P")` splits on `+` (lone `+` stays literal; opt out with `parse: false`)
- normalize key aliases case-insensitively: `cmd` -> ⌘, `opt` -> ⌥, `up`/`down`/`left`/`right` -> arrows (opt out with `normalize: false`)
- add `layout: "mac"` mapping all common key names to Apple glyphs (`ctrl` -> ⌃, `shift` -> ⇧, `enter` -> ↩, ...)
- accept theme names in `config`: `keyle.config(theme: "flowbite")`
- support HTML export: keys embed as inline SVG (`html: "frame"`, default), as semantic `<kbd>` elements (`html: "kbd"`), or pass through (`html: none`); added `just test-html` smoke test
- expose `resolve-theme`, `expand-shortcuts`, `normalize-key`, `key-aliases`, `mac-aliases`

### Refactor

- migrate the manual from mantys (broken on Typst 0.15, no fixed release yet) to tidy 0.4.3 + codelst
- tests/example/doc import `src/` directly; no local package tree or `.packages/` checkout needed to build
- simplify the justfile to everyday recipes (`test`/`test-html`/`example`/`doc`/`all`/`bump`); releasing to typst/packages now runs in GitHub Actions (`.github/workflows/release.yml`, triggered by pushing a version tag)

- build alias tables from `(glyph, (..names))` groups via `array.to-dict` instead of hand-written repeated-value dict literals

### Fix

- stabilize delimiter vertical alignment across themes: the delimiter is rendered through the theme itself -- `keycap`/`svg-keycap`/`type-writer` draw it as if it were a key (same box, baseline and centering) with an invisible shell, so it aligns with the keys by construction; custom theme functions fall back to measuring the cap's descent with a zero-width probe plus an optical correction
- fix justfile parsing broken by the unindented release PR-body heredoc

## 0.3.0

### Feat

- redesign themes as `keycap`/`svg-keycap` factories; customize any preset via native `.with(...)`
- separate the text layer (`text-args`, `wrap`) from the cap layer (geometry/colors)
- add SVG backend and SVG-based themes: `flowbite`, `flowbite-dark`, `daisy`
- add rect themes `minimal` and `radix`
- add `svg-key` inline SVG glyphs (arrows, enter, backspace, tab, win) usable as any `sym`
- support a per-glyph viewBox for `svg-icon` so glyphs from different icon sets render correctly
- migrate doc comments to tidy 0.4 syntax
- upgrade manual build to mantys 1.0.2 for Typst 0.13+

### Refactor

- split `keyle.typ` into `cap.typ` (factories) + `themes.typ` (presets); `keyle.typ` is now a thin facade
- optimize `standard`/`deep-blue` shadows from a 6-layer place loop to a single raised lip
- keep `theme-func-*` names as backward-compatible aliases

### Fix

- redraw the `win` glyph as a clean 4-pane Windows logo (was a distorted slanted shape)
- fix `svg-icon` baseline and size so glyphs align with text and adjacent keycaps
- fix `theme-func-stardard` typo (kept as backward-compatible alias)
- fix doc build on Typst 0.14 (`std.link` show rule, `mantys()` API, mantys 1.0.2)
- bump test dependencies (codelst 2.0.2, showybox 2.0.4)

## 0.2.0 (2024-08-19)

### Fix

- theme type-writer overlaps; add test cases

## 0.1.2 (2024-08-13)

### Feat

- support shadow for themes and modify example

## 0.1.1 (2024-08-09)

### Feat

- format keyle.typ and bump to 0.1.1
- add example for theme
- add `config` factory method pattern
- add Biolinum Keyboard style

## 0.1.0 (2024-07-24)

### Feat

- enhance doc and bump to 0.1.0
- add type-writer style
- support deep-blue style and bump to 0.0.2
- init keyle lib for typst

### Refactor

- add repository
