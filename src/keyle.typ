#import "sym.typ": mac-key, biolinum-key

#let shadow-times = 6

/// Generate examples for the given keyboard rendering function.
/// -> content
#let gen-examples(
  /// The keyboard rendering function.
  /// -> function
  kbd,
) = [
  #kbd("Ctrl", "A") #h(1em) #kbd("Alt", "P", compact: true)

  #kbd("Home") #kbd("End") #kbd("Ins") #kbd("Del")
]

/// Join rendered keys with a delimiter between them.
#let join-keys(keys, theme, delim) = {
  let items = keys.map(k => [#theme(k)])
  if delim == biolinum-key.delim_plus or delim == biolinum-key.delim_minus {
    items.join(theme(delim))
  } else {
    context {
      let sep = box(
        height: measure(theme("A")).height,
        inset: 2pt,
        align(horizon, delim),
      )
      items.join(sep)
    }
  }
}

/// Theme function to render keys in a standard style.
///
/// #example(```typst
/// #let kbd = keyle.config(theme: keyle.themes.standard)
/// #keyle.gen-examples(kbd)
/// ```)
/// -> content
#let theme-func-standard(
  /// The key symbol to render.
  /// -> str
  sym,
) = box({
  let bg-color = rgb("#eee")
  let stroke-color = rgb("#555")

  let cust-rect = rect.with(
    inset: (x: 3pt),
    stroke: stroke-color + 0.6pt,
    radius: 2pt,
    fill: bg-color,
  )
  let button = cust-rect(
    text(fill: black, sym),
  )
  let shadow = cust-rect(
    fill: stroke-color,
    text(fill: bg-color, sym),
  )
  for n in range(shadow-times) {
    place(dx: 0.2pt * n, dy: 0.2pt * n, shadow)
  }
  button
})

// Backward-compatible alias for the old misspelled name.
#let theme-func-stardard = theme-func-standard

/// Theme function to render keys in a deep blue style.
///
/// #example(```typst
/// #let kbd = keyle.config(theme: keyle.themes.deep-blue)
/// #keyle.gen-examples(kbd)
/// ```)
/// -> content
#let theme-func-deep-blue(
  /// The key symbol to render.
  /// -> str
  sym,
) = box({
  let bg-color = rgb("#16456b")
  let stroke-color = rgb("#4682b4")

  let cust-rect = rect.with(
    inset: (x: 3pt),
    stroke: bg-color + 0.6pt,
    radius: 2pt,
    fill: stroke-color,
  )
  let button = cust-rect(
    smallcaps(text(fill: white, sym)),
  )
  let shadow = cust-rect(fill: bg-color, smallcaps(text(fill: bg-color, sym)))
  for n in range(shadow-times) {
    place(dx: 0.2pt * n, dy: 0.2pt * n, shadow)
  }
  button
})

/// Theme function to render keys in a type writer style.
///
/// #example(```typst
/// #let kbd = keyle.config(theme: keyle.themes.type-writer)
/// #keyle.gen-examples(kbd)
/// ```)
/// -> content
#let theme-func-type-writer(
  /// The key symbol to render.
  /// -> str
  sym,
) = box({
  let bg-color = rgb("#333")
  let stroke-color = rgb("#2b2b2b")

  let cust-rect = rect.with(
    inset: (x: 2pt),
    stroke: bg-color,
    fill: stroke-color,
    radius: 50%,
  )

  let button = cust-rect(
    smallcaps(text(fill: white, sym)),
  )
  let shadow = cust-rect(
    outset: 2.2pt,
    fill: white,
    stroke: stroke-color + 1.2pt,
    smallcaps(text(fill: bg-color, sym)),
  )
  box(
    inset: 2pt,
    {
      place(shadow)
      button
    },
  )
})

/// Theme function to render keys in a Linux Biolinum Keyboard style.
///
/// You need to have the font installed on your system.
///
/// #example(```typst
/// #let kbd = keyle.config(theme: keyle.themes.biolinum, delim: keyle.biolinum-key.delim_plus)
/// #keyle.gen-examples(kbd)
/// ```)
/// -> content
#let theme-func-biolinum(
  /// The key symbol to render.
  /// -> str
  sym,
) = text(
  fill: black,
  font: ("Linux Biolinum Keyboard"),
  size: 1.4em,
  sym,
)

#let themes = (
  standard: theme-func-standard,
  deep-blue: theme-func-deep-blue,
  type-writer: theme-func-type-writer,
  biolinum: theme-func-biolinum,
)

/// Config function to generate keyboard rendering helper function.
/// -> function
#let config(
  /// The theme function to use.
  /// -> function
  theme: themes.standard,
  /// Whether to render keys in a compact format.
  /// -> bool
  compact: false,
  /// The delimiter to use between keys.
  /// -> str
  delim: "+",
) = (
  (..keys, compact: compact, delim: delim) => {
    let key-list = keys.pos()
    if compact {
      theme(key-list.join(delim))
    } else {
      join-keys(key-list, theme, delim)
    }
  }
)
