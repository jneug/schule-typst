/********************************\
*  Variables and some functions *
*   for setting a common theme  *
\********************************/

// General colors
#let primary   = rgb(56, 86, 153)  // rgb(40, 70, 167)
#let secondary = rgb(114, 5, 23)   // rgb(204, 74, 71)
#let muted     = luma(174)

// General backgrounds
#let bg = (
	primary:    primary.lighten(90%),
	secondary:  secondary.lighten(90%),
	muted:      muted.lighten(90%),
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
	default:   ("Fira Sans", "Liberation Sans", "Avenir Next", "Avenir", "Helvetica Neue", "Helvetica"),
	headings:  ("Charter", "Georgia"),
	code:      ("Fira Code", "Liberation Mono", "Courier New"),
)

// Table colors and styles
#let table = (
	header:   bg.primary,
	even:     bg.muted,
	odd:      white,
)

// Code settings
#let code = (
	bg:      bg.muted,
)
