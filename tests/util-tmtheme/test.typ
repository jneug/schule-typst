#import "../../src/util/tmtheme.typ"

#{
  let parsed-theme = tmtheme.extract-colors(read("../../src/assets/Eiffel.tmTheme"))

  assert.eq(parsed-theme.foreground, rgb("#000000"))
  assert.eq(parsed-theme.background, rgb("#f4fafc"))
}
