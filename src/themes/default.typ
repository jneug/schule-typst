// TODO: Improve theme support
// TODO: Add more theme style keys

#let typst-text = text

// General colors
#let primary = rgb(40, 70, 167)
#let secondary = rgb(204, 74, 71)
#let muted = luma(174)

// General backgrounds
#let bg = (
  primary: primary.lighten(90%),
  secondary: secondary.lighten(90%),
  muted: muted.lighten(90%),
  code: muted.lighten(90%),
  solution: muted.lighten(85%),
)

// Text colors
#let text = (
	default:   black,
	header:    luma(20%), // primary
	footer:    luma(70%),
	title:     primary,
	subject:   luma(33%)
)

// Font settings
#let fonts = (
  default: (
    "Fira Sans",
    "Liberation Sans",
    "Avenir Next",
    "Avenir",
    "Helvetica Neue",
    "Helvetica",
    "Apple Color Emoji",
  ),
  headings: ("Charter", "Georgia", "Apple Color Emoji"),
  code: ("Fira Code", "Liberation Mono", "Courier New"),
  serif: (/*"EB Garamond 12",*/ "Garamond", "Charter", "Georgia"),
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
  type1: rgb("#36c737"),
  type2: rgb("#ffcc02"),
  type3: rgb("#cd362c"),
  help: rgb("#b955b6"),
  back: rgb("#ffffb2"),
)

#let init(body) = {
  body
}
