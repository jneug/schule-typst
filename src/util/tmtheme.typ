#import "../_deps.typ": plist

#let extract-colors(tmtheme) = {
  if type(tmtheme) == str {
    tmtheme = bytes(tmtheme)
  }
  let tmtheme = plist(tmtheme)

  let settings = tmtheme.at("settings", default: (:)).at(0, default: (:)).at("settings", default: (:))

  let fg = settings.at("foreground", default: white)
  let bg = settings.at("background", default: black)

  return (
    foreground: if fg.starts-with("#") {
      rgb(fg)
    } else {
      luma(int(fg))
    },
    background: if fg.starts-with("#") {
      rgb(bg)
    } else {
      luma(int(bg))
    },
  )
}
