// HTML export smoke test: `just test-html`.
#import "/src/keyle.typ": kbd
#import "/src/keyle.typ"

// Default mode: the exact themed rendering embedded as inline SVG.
Press #kbd("Ctrl+Shift+P") to open the command palette.

// Semantic mode: plain <kbd> elements, styled by the browser / user CSS.
#let sem = keyle.config(html: "kbd")
Copy with #sem("Ctrl", "C"), paste with #sem("Ctrl", "V").

// Themed + aliases still work under HTML export.
#let mac = keyle.config(theme: "flowbite", layout: "mac", delim: none)
Quit with #mac("cmd+Q").
