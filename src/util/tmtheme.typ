// Helpers to parse tmTheme files
#let find-tag(root, tag) = {
  if not (type(root) == array or "children" in root) {
    panic("xml error: root element has no children")
  }
  if not type(root) == array {
    root = root.children
  }
  return root.find(e => (type(e) == dictionary and "tag" in e and e.tag == tag))
}

#let find-dict-key(root, key) = {
  if not "children" in root {
    panic("xml error: root element has no children")
  }
  let i = root.children.position(e => (
    type(e) == dictionary and "tag" in e and e.tag == "key" and e.children.first() == key
  ))
  return root.children.slice(i + 2).find(e => type(e) == dictionary and "tag" in e and e.tag != "key")
}

#let extract-colors(xml-theme) = {
  let data = find-tag(xml-theme, "plist")
  let main-dict = find-tag(data, "dict")
  let settings = find-dict-key(main-dict, "settings")
  settings = find-tag(settings, "dict")
  settings = find-dict-key(settings, "settings")
  let fg = find-dict-key(settings, "foreground").children.first()
  let bg = find-dict-key(settings, "background").children.first()

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
