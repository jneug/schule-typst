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
	light:     white,
	header:    luma(20%), // primary
	footer:    luma(70%),
	title:     primary,
	subject:   luma(33%),
  primary:   white,
  secondary:  white
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

#let cards = {
  let (type1, type2, type3, help) = (
    rgb("#36c737"),
    rgb("#ffcc02"),
    rgb("#cd362c"),
    rgb("#b955b6"),
  )

  (
    type1: gradient.linear(type1.lighten(15%), type1.darken(15%), angle: 90deg),
    type2: gradient.linear(type2.lighten(15%), type2.darken(15%), angle: 90deg),
    type3: gradient.linear(type3.lighten(15%), type3.darken(15%), angle: 90deg),
    help: gradient.linear(help.lighten(15%), help.darken(15%), angle: 90deg),
    back: rgb("#ffffb2"),
  )
}

#let init(body) = {
  body
}
