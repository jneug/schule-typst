/********************************\
*  Variables and some functions *
*   for setting a common theme  *
\********************************/

#let typst-text = text

// General colors
#let primary = luma(20%)
#let secondary = luma(50%)
#let muted = luma(88%)

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
  default: ("Liberation Serif",),
  headings: ("Liberation Sans",),
  code: (),
  serif: "Liberation Sans",
  sans: ("Liberation Sans",),
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
