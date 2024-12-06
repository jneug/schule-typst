#import "@preview/polylux:0.3.1" as polylux: *
#import "@preview/codetastic:0.2.2": qrcode
#import "@preview/shadowed:0.1.2": shadowed
#import "@preview/oasis-align:0.2.0"

// #import "@preview/oasis-align:0.1.0"

#import "_imports.typ": *


#let slide(
  title: auto,
  subtitle: none,
  fill: none,
  header: auto,
  footer: auto,
  section: none,
  show-progress: auto,
  align: top + left,
  styles: (),
  body,
) = {
  let (title, rest) = (title, body)
  if title == auto {
    (title, rest) = util.extract-title(body)
  }

  if section != none {
    polylux.utils.register-section(section)
  }

  let page-args = (:)
  if fill != auto {
    page-args.insert("fill", fill)
  }
  if header != auto {
    page-args.insert("header", header)
  }
  if footer != auto {
    page-args.insert("footer", footer)
  }
  if "page" in styles {
    page-args += styles.page
  }
  let text-args = (:)
  if "text" in styles {
    text-args += styles.text
  }

  set page(..page-args)

  polylux-slide({
    set text(..text-args)
    set std.align(align)

    context document.use-value(
      "show-progress",
      show-progress-doc => if (show-progress == auto and show-progress-doc) or show-progress {
        polylux.utils.polylux-progress(ratio => {
          let bar(width, clr) = place(
            top,
            dx: -util.inset-at(left, page.margin),
            dy: -util.inset-at(top, page.margin),
            rect(
              fill: clr,
              width: (100% + util.inset-at(left, page.margin) + util.inset-at(right, page.margin)) * width,
              height: 6pt,
            ),
          )
          bar(1.0, theme.bg.primary)
          bar(ratio, theme.primary)
        })
      },
    )

    if title != none {
      heading(depth: 1, title)
    }
    if subtitle != none {
      move(dy: -.33em, text(weight: 600, subtitle))
    } else {
      v(1em)
    }

    rest
  })
}

#let empty-slide = slide.with(header: [], footer: [])

#let title-slide(title, subtitle: none) = {
  empty-slide(title: none, subtitle: none, align: left + horizon, show-progress: false)[
    #set text(1.5em)
    #heading(level: 1, outlined: false, bookmarked: false, title)

    #if subtitle != none {
      subtitle
    }

    #context document.use-value(
      "author",
      authors => {
        if authors != () {
          let author = authors.first()

          set text(.66em)
          v(1em)
          author.name
          if "email" in author {
            " " + sym.angle.l + link("mailto:" + author.email, author.email) + sym.angle.r
          }
        }
      },
    )
  ]
}

#let praesentation(
  ..args,
  body,
) = {
  let (
    doc,
    page-init,
    tpl,
  ) = base-template(
    type: "PT",
    type-long: "Präsentation",
    _tpl: (
      options: (
        show-progress: t.boolean(default: true),
        // TODO: Add polylux options and pass to init
        polylux: t.dictionary(
          (
            theme: t.string(optional: true)
          ),
          default: (:)
        )
      )
    ),
    title-block: (doc) => title-slide(doc.title, subtitle: doc.topic),

    // Some defaults for slides
    paper: "presentation-16-9",
    fontsize: 22pt,

    ..args,
    body,
  )

  {
    show: page-init.with(
      header: (doc, ..) => {
        set text(theme.muted)
        grid(
          columns: (1fr, auto),
          align: (left, right),
          polylux.utils.current-section, doc.date.display("[day].[month].[year]"),
        )
      },
      footer-right: (doc, body) => {
        context logic.logical-slide.display()
        " / "
        polylux.utils.last-slide-number
      },
    )

    // TODO: title-block slide ist noch empty ..
    // title-slide(doc.title, subtitle: doc.topic)

    show emph: it => text(theme.secondary, weight: 600, it.body)
    tpl
  }
}


#let section-slide(section-name, subtitle: none, level: 1, hidden: false, ..slide-args) = {
  // empty-slide(
  //   fill: if level == 1 {
  //     theme.bg.primary
  //   } else {
  //     theme.bg.secondary
  //   },
  //   align: center + horizon,
  //   ..slide-args,
  //   title: none,
  //   subtitle: none,
  //   section: section-name,
  //   [],
  // )
  if not hidden {
    empty-slide(
      fill: if level == 1 {
        theme.bg.primary
      } else {
        theme.bg.secondary
      },
      align: center + horizon,
      ..slide-args,
      title: none,
      subtitle: none,
      heading(
        depth: 1,
        {
          set text(
            if level == 1 {
              theme.primary
            } else {
              theme.secondary
            },
            1.5em,
          )
          section-name
        },
      ),
    )
  }
}

#let subsection-slide(body, level: 1, ..slide-args) = {
  let (title, rest) = util.extract-title(body)

  empty-slide(
    fill: theme.bg.muted,
    align: left + horizon,
    ..slide-args,
    {
      text(
        2em,
        if level == 1 {
          theme.primary
        } else {
          theme.secondary
        },
        title,
      )
      linebreak()
      rest
    },
  )
}

#let image-slide(img, image-align: right + horizon, align: left + top, image-width: auto, ..slide-args, body) = {
  let (title, rest) = util.extract-title(body)

  // Use oasis-align
  slide(
    title: title,
    ..slide-args,
    align: top + left,
    if image-align.x == right {
      grid(
        columns: (1fr, image-width),
        align: (align, image-align),
        gutter: 1em,
        rest, img,
      )
    } else {
      grid(
        columns: (image-width, 1fr),
        align: (image-align, align),
        gutter: 1em,
        img, rest,
      )
    },
  )
}

// TODO: Fix
#let full-image-slide(img, mode: "stretch", ..slide-args, overlay: []) = {
  set page(margin: 0pt)

  assert(mode in ("stretch", "fit", "fill"), message: "mode needs to be one of stretch or fit, got: " + mode)

  context {
    let _m = measure(img, width: 1000cm, height: 1000cm)

    let x-factor = (page.width / _m.width) * 100%
    let y-factor = (page.height / _m.height) * 100%

    if mode == "fill" {
      x-factor = calc.max(x-factor, y-factor)
      y-factor = x-factor
    } else if mode == "fit" {
      x-factor = calc.min(x-factor, y-factor) * .9
      y-factor = x-factor
    }

    empty-slide(
      ..slide-args,
      place(
        center + horizon,
        scale(img, x: x-factor, y: y-factor, origin: center + horizon),
      ),
    )
  }
}

#let quote-slide(attribution: none, ..slide-args, body) = {
  slide(
    align: center + horizon,
    ..slide-args,
    {
      set text(font: theme.fonts.serif)
      quote(attribution: attribution, body)
    },
  )
}

#let link-slide(target, ..slide-args) = {
  slide(
    align: center + horizon,
    ..slide-args,
    {
      set text(2.5em)
      link(target, target)
      linebreak()
      qrcode(target, colors: (white, theme.text.default))
    },
  )
}



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

#let extract-colors(theme) = {
  let data = find-tag(xml(theme), "plist")
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

#let code-frame(code, light: false, code-theme: auto) = {
  // let code = code.children.find(it => it.func() == raw)

  let code-theme = if code-theme == auto {
    if light {
      "assets/Eiffel.tmTheme"
    } else {
      "assets/1337.tmTheme"
    }
  } else {
    code-theme
  }
  let colors = extract-colors(code-theme)

  shadowed(
    blur: 12pt,
    color: theme.muted.transparentize(10%),
    radius: 6pt,
    inset: 6pt,
    fill: colors.background,
    {
      set align(left)
      block(
        spacing: 0pt,
        below: 6pt,
        {
          for clr in (red, yellow, green) {
            box(
              inset: (right: 4pt),
              circle(radius: 5pt, fill: clr),
            )
          }
        },
      )
      set text(colors.foreground)
      block(
        spacing: 0pt,
        inset: 4pt,
        raw(
          lang: code.lang,
          theme: code-theme,
          code.text,
        ),
      )
    },
  )
}

#let code-slide(light: false, frame: true, theme: auto, ..slide-args, body) = {
  let (code, rest) = util.extract-element(raw, body)

  slide(
    align: center + horizon,
    ..slide-args,
    place(
      center + horizon,
      {
        if frame {
          code-frame(code, code-theme: theme, light: light)
        } else {
          code
        }
        rest
      },
    ),
  )
}


#let note = showybox.with(
  frame: (
    body-color: theme.primary,
    radius: 4pt,
    inset: .66em,
    border-color: theme.primary.darken(50%),
    thickness: .6pt,
  ),
  shadow: (
    offset: 2pt,
    color: theme.muted.transparentize(50%),
  ),
  body-style: (
    color: theme.text.primary,
  ),
)


#let note-secondary = showybox.with(
  frame: (
    body-color: theme.secondary,
    radius: 4pt,
    inset: .66em,
    border-color: theme.secondary.darken(50%),
    thickness: .6pt,
  ),
  shadow: (
    offset: 2pt,
    color: theme.muted.transparentize(50%),
  ),
  body-style: (
    color: theme.text.secondary,
  ),
)


#let position(pos, body) = place(
  top + left,
  dx: pos.first(),
  dy: pos.last(),
  body,
)

#let draft-grid(unit: 1cm, color: silver) = {
  let pat = pattern(
    size: (unit, unit),
    {
      // place(line(start: (0%, 0%), end: (100%, 100%)))
      // place(line(start: (0%, 100%), end: (100%, 0%)))
      rect(width: 100%, height: 100%, stroke: .5mm + color)
    },
  )

  place(
    top + left,
    rect(
      fill: pat,
      width: 100%,
      height: 100%,
    ),
  )
}
