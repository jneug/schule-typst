/********************************\
*  Variables and some functions *
*   for setting a common theme  *
\********************************/

#let typst-text = text

// General colors
#let primary = rgb("#3b6dda")
#let secondary = rgb("#e7d216")
#let muted = luma(174)

// General backgrounds
#let bg = (
  primary: primary.lighten(80%),
  secondary: secondary.lighten(90%),
  muted: muted.lighten(90%),
  code: muted.lighten(90%),
  solution: muted.lighten(85%),
)

// Text colors
#let text = (
	default:   luma(20%),
	light:     white,
	header:    luma(50%), // primary
	footer:    luma(75%),
	title:     primary,
	subject:   luma(33%),
  primary:   white,
  secondary:  white
)

// Font settings
#let fonts = (
  default: ("Source Sans Pro", "Roboto", "Avenir Next", "Avenir", "Helvetica"),
  headings: ("Helvetica Neue", "Avenir Next", "Avenir", "Helvetica"),
  code: ("Fira Code", "Liberation Mono", "Courier New"),
  serif: (/*"EB Garamond 12",*/ "Garamond", "Charter", "Georgia"),
  sans: ("Fira Sans", "Liberation Sans", "Avenir Next", "Avenir", "Helvetica Neue", "Helvetica"),
)

// Table colors and styles
#let table = (
  header: rgb("#99b9ff"),
  even: rgb("#fcfcef"),
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
  set typst-text(font: fonts.default, weight: "medium")
  show figure.caption: it => [
    #typst-text(secondary, weight: 400, [#it.supplement #it.numbering])#h(1.28em)#emph(it.body)]
  body
}
