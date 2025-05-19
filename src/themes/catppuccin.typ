#import "@preview/catppuccin:1.0.0": latte

#let make-flavor(palette) = (
  palette
    .colors
    .pairs()
    .fold(
      (:),
      (dict, (name, clr)) => {
        dict.insert(name, clr.rgb)
        dict
      },
    )
)

#let flavor = make-flavor(latte)


// General colors
#let primary = flavor.maroon
#let secondary = flavor.lavender
#let muted = flavor.rosewater

// General backgrounds
#let bg = (
  primary: primary.lighten(90%),
  secondary: secondary.lighten(90%),
  muted: flavor.base,
  code: flavor.mantle,
  solution: flavor.surface0,
)

// Text colors
#let text = (
  default: flavor.text,
  light: white,
  header: flavor.text,
  footer: flavor.overlay1,
  title: primary,
  subject: flavor.subtext0,
  primary: flavor.text,
  secondary: flavor.text,
)

// Font settings
#let fonts = (
  default: ("Charter", "Georgia", "Apple Color Emoji"),
  headings: (
    "Avenir Next",
    "Avenir",
    "Helvetica Neue",
    "Helvetica",
    "Apple Color Emoji",
  ),
  code: ("Fira Code", "Liberation Mono", "Courier New"),
  serif: ("EB Garamond 12", "Garamond", "Charter", "Georgia"),
  sans: ("Fira Sans", "Liberation Sans", "Avenir Next", "Avenir", "Helvetica Neue", "Helvetica"),
)

#let raw = (
  fill: bg.code,
  stroke: 1pt + muted,
  inset: 3pt,
)

// Table colors and styles
#let table = (
  header: bg.primary,
  even: bg.muted,
  odd: white,
  stroke: .6pt + muted,
)

#let cards = (
  type1: rgb("#40a02b"),
  type2: rgb("#df8e1d"),
  type3: rgb("#d20f39"),
  help: rgb("#8839ef"),
  back: rgb("#ffffb2"),
)

#let init(body) = {
  body
}
