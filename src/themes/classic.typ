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
	header:    luma(20%), // primary
	footer:    luma(70%),
	title:     primary,
	subject:   luma(33%)
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
)

#let init(body) = {
  body
}
