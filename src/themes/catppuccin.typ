// TODO: Improve theme support
// TODO: Add more theme style keys

#let typst-text = text

// General colors
#let primary = rgb("#dc8a78")
#let secondary = rgb("#04a5e5")
#let muted = rgb("#dce0e8")

// General backgrounds
#let bg = (
  primary: primary.lighten(90%),
  secondary: secondary.lighten(90%),
  muted: rgb("#eff1f5"),
  code: rgb("#e6e9ef"),
  solution: rgb("#e6e9ef"),
)

// Text colors
#let text = (
	default:   rgb("#4c4f69"),
	header:    rgb("#5c5f77"), // primary
	footer:    rgb("#ccd0da"),
	title:     primary,
	subject:   rgb("#4c4f69"),
  primary:   white,
  secondary:  white
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
