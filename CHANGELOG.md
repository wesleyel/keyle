## Unreleased

### Feat

- redesign themes as `keycap`/`svg-keycap` factories; customize any preset via native `.with(...)`
- separate the text layer (`text-args`, `wrap`) from the cap layer (geometry/colors)
- add SVG backend and SVG-based themes: `flowbite`, `flowbite-dark`, `daisy`
- add rect themes `minimal` and `radix`
- add `svg-key` inline SVG glyphs (arrows, enter, backspace, tab) usable as any `sym`
- migrate doc comments to tidy 0.4 syntax
- upgrade manual build to mantys 1.0.2 for Typst 0.13+

### Refactor

- split `keyle.typ` into `cap.typ` (factories) + `themes.typ` (presets); `keyle.typ` is now a thin facade
- optimize `standard`/`deep-blue` shadows from a 6-layer place loop to a single raised lip
- keep `theme-func-*` names as backward-compatible aliases

### Fix

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
