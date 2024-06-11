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
  serif:     ("Charter", "Georgia"),
  sans:      ("Fira Sans", "Liberation Sans", "Avenir Next", "Avenir", "Helvetica Neue", "Helvetica")
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

// Read custom theme file
#let theme-file = sys.inputs.at("theme", default:none)

#if theme-file != none {
  let theme = toml(theme-file)

  if "primary" in theme {
    primary = rgb(theme.primary)
  }
  if "secondary" in theme {
    secondary = rgb(theme.secondary)
  }
  if "muted" in theme {
    muted = rgb(theme.muted)
  }

  let parse-colors(origin, new) = {
    for k in origin.keys() {
      if k in new {
        origin.insert(k, rgb(new.at(k)))
      }
    }
    return origin
  }

  if "bg" in theme {
    bg = parse-colors(bg, theme.bg)
  }
  if "table" in theme {
    table = parse-colors(table, theme.table)
  }
  if "code" in theme {
    code = parse-colors(code, theme.code)
  }
}
