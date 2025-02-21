
#import "../util/typing.typ" as t

#let _theme-schema = t.dictionary((
  primary: t.color(),
  secondary: t.color(),
  muted: t.color(),
  //
  bg: t.dictionary((
    primary: t.color(),
    secondary: t.color(),
    muted: t.color(),
    code: t.color(optional: true),
  )),
  //
  text: t.dictionary((
    default: t.color(),
    header: t.color(),
    footer: t.color(optional: true),
    title: t.color(optional: true),
    subject: t.color(optional: true),
  )),
  //
  fonts: t.dictionary((
    default: t.array(t.string()),
    headings: t.array(t.string()),
    code: t.array(t.string()),
    serif: t.array(t.string()),
    sans: t.array(t.string()),
  )),
  //
  table: t.dictionary((
    header: t.color(optional: true),
    even: t.color(optional: true),
    odd: t.color(optional: true),
  )),
))

#let themes = (
  default: (
    // Primary and secondary colors
    primary: rgb(56, 86, 153),
    secondary: rgb(114, 5, 23),
    muted: luma(74%),
    bg: (
      primary: rgb(56, 86, 153).lighten(90%),
      secondary: rgb(114, 5, 23).lighten(90%),
      muted: luma(92%),
    ),
    text: (
      default: black,
      header: luma(20%),
      footer: luma(70%),
      title: rgb(56, 86, 153),
      subject: luma(33%),
    ),
    fonts: (
      default: (), //("Fira Sans", "Liberation Sans", "Avenir Next", "Avenir", "Helvetica Neue", "Helvetica"),
      headings: ("Charter", "Georgia"),
      code: ("Fira Code", "Liberation Mono", "Courier New"),
      serif: ("Charter", "Georgia"),
      sans: ("Fira Sans", "Liberation Sans", "Avenir Next", "Avenir", "Helvetica Neue", "Helvetica"),
    ),
    table: (
      header: rgb(56, 86, 153).lighten(90%),
      even: luma(96%),
      odd: white,
    ),
  ),
)

#let create(
  primary,
  ..colors,
) = {
  let _if-color(name, default) = colors.named().at(name, default: default)

  let theme = (
    primary: primary,
    secondary: _if-color("secondary", primary.rotate(180deg)),
    muted: _if-color("muted", luma(74%)),
    //
    bg: (
      primary: primary.lighten(90%),
      secondary: none,
      muted: none,
      code: none,
    ),
    //
    text: (
      default: _if-color("text-default", themes.default.text.default),
      header: _if-color("text-header", themes.default.text.header),
      footer: _if-color("text-footer", themes.default.text.footer),
      title: _if-color("text-title", primary),
      subject: _if-color("text-subject", themes.default.text.subject),
    ),
    //
    fonts: themes.default.fonts,
    //
    table: (
      header: _if-color("text.default", primary.lighten(90%)),
      even: none,
      odd: white,
    ),
  )
  theme.bg.secondary = theme.secondary.lighten(90%)
  theme.bg.muted = theme.muted.lighten(80%)
  theme.bg.code = theme.bg.muted
  theme.table.odd = theme.bg.muted

  return theme
}
