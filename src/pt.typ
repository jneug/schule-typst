#import "@preview/polylux:0.3.1" as polylux: *
#import "@preview/codetastic:0.2.2": qrcode

#import "_imports.typ": *
#import "util/harbinger.typ": shadow-box

#let _split-title(body) = {
  let items = if repr(body.func()) != "sequence" {
    (body,)
  } else {
    body.children
  }
  let first-heading = items.find(it => it.func() == heading and it.at("depth", default: 0) == 1)

  return (
    if first-heading != none {
      first-heading.body
    } else {
      none
    },
    items.filter(it => it != first-heading and it != [ ]).join(""),
  )
}

#let slide(
  title: auto,
  subtitle: none,
  fill: none,
  header: auto,
  footer: auto,
  section: none,
  show-progress: auto,
  align: top + left,
  body,
) = {
  let (title, rest) = (title, body)
  if title == auto {
    (title, rest) = _split-title(body)
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
  set page(..page-args)

  if section != none {
    polylux.utils.register-section(section)
  }

  set typst.align(align)

  polylux-slide({
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
    }

    rest
  })
}

#let empty-slide = slide.with(header: [], footer: [])

#let title-slide(title, subtitle: none) = {
  set text(1.5em)

  empty-slide(title: none, subtitle: none, align: left + horizon, show-progress: false)[
    #heading(level: 1, outlined: false, bookmarked: false, title)

    #if subtitle != none {
      subtitle
    }
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
      header: (doc, ..) => grid(
        columns: (1fr, auto),
        align: (left, right),
        polylux.utils.current-section, doc.date.display("[day].[month].[year]"),
      ),
      footer-right: (doc, body) => {
        logic.logical-slide.display()
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


#let section-slide(section-name, subtitle: none, level: 1, ..slide-args) = {
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
    section: section-name,
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

#let subsection-slide(body, level: 1, ..slide-args) = {
  let (title, rest) = _split-title(body)

  empty-slide(
    fill: theme.bg.muted,
    align: left + horizon,
    ..slide-args,
    {
      text(
        2.5em,
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

#let image-slide(img, align: right, ..slide-args, body) = {
  slide(
    ..slide-args,
    {
      if align == right {
        side-by-side(body, img)
      } else {
        side-by-side(img, body)
      }
    },
  )
}

#let full-image-slide(img, ..slide-args, overlay: []) = {
  set page(margin: 0pt)

  context {
    let _m = measure(img)
    let factor = if _m.width > _m.height {
      page.width / _m.width
    } else {
      page.height / _m.height
    } * 100% + 100%

    empty-slide(
      ..slide-args,
      {
        set align(center + horizon)

        scale(img, x: factor, y: factor, origin: center + horizon)
      },
    )
  }
}

#let quote-slide(attribution: none, ..slide-args, body) = {
  set text(font: theme.fonts.serif)

  slide(
    align: center + horizon,
    ..slide-args,
    {
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

#let code-frame(code, light: false) = {
  let code = code.children.find(it => it.func() == raw)

  shadow-box(
    blur: 12,
    radius: 6pt,
    dy: 8pt,
    block(
      fill: if light {
        rgb("#f4fafc")
      } else {
        rgb("#151718")
      },
      stroke: none,
      radius: .33em,
      inset: .5em,
      {
        set align(left)
        block(
          spacing: 0pt,
          below: .5em,
          {
            for clr in (red, yellow, green) {
              box(
                inset: (x: .2em),
                circle(radius: .33em, fill: clr),
              )
            }
          },
        )
        block(
          spacing: 0pt,
          inset: 4pt,
          raw(
            lang: code.lang,
            theme: if light {
              "assets/Eiffel.tmTheme"
            } else {
              "assets/Codeacademy.tmTheme"
            },
            code.text,
          ),
        )
      },
    ),
  )
}

#let code-slide(light: false, ..slide-args, body) = {
  slide(
    align: center + horizon,
    ..slide-args,
    {
      code-frame(body, light: light)
    },
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
    offset: 3pt,
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
    offset: 3pt,
    color: theme.muted.transparentize(50%),
  ),
  body-style: (
    color: theme.text.secondary,
  ),
)
