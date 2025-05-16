#import "_imports.typ": *
#import "util/tmtheme.typ"

#import deps: touying, codetastic
#import touying: *
#import deps.shadowed: shadowed

#let no-headers(self, header: none, footer: none) = touying.utils.merge-dicts(
  self,
  touying.config-page(
    header: header,
    footer: footer,
  ),
)

#let slide-title(self, title, level: auto, sep: sym.dash) = {
  let level = if level == auto {
    self.slide-level
  } else {
    level
  }

  let title = title
  if title == auto {
    context {
      let current-page = here().page()
      let all-headings = query(heading.where(level: level)).filter(h => (
        h.location().page() == current-page
      ))
      let current-heading = all-headings.at(-1, default: none)

      if current-heading != none {
        [#sep #text(self.colors.secondary, current-heading.body)]
      } else {
        return []
      }
    }
  } else {
    [#sep #text(self.colors.secondary, title)]
  }
}

#let show-progress-bar(self) = {
  place(
    top,
    touying.components.progress-bar(
      height: self.store.progress-bar-height,
      self.colors.primary,
      self.colors.primary-light,
    ),
  )
}

// TODO: (jneug) refactor into an internal _slide function to be used by subslides?
#let slide(
  title: auto,
  // page layout
  fill: none,
  header: auto,
  footer: auto,
  show-progress: auto,
  show-section: auto,
  align: top + left,
  styles: (:),
  // body generator for slide-types
  body: self => [],
  // touying settings
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  //
  ..bodies,
) = touying.touying-slide-wrapper(self => {
  // Configure slide
  let page-config = (fill: fill)
  if header != auto {
    page-config.insert("header", header)
  }
  if footer != auto {
    page-config.insert("footer", footer)
  }
  let self = touying.utils.merge-dicts(
    self,
    touying.config-page(..page-config),
  )

  // Update store
  self.store.title = title

  if show-progress != auto {
    self.store.show-progress = show-progress
  }
  if show-section != auto {
    self.store.show-section = show-section
  }

  // Compose slide
  touying.touying-slide(
    self: self,
    config: config,
    repeat: repeat,
    setting: body => {
      set std.align(align)
      set std.text(..styles.at("text", default: (:)))

      setting(body)
    },
    composer: composer,
    ..if bodies.pos().len() == 0 { (body(self),) } else { bodies },
  )
})

#let empty-slide(..slide-args) = {
  let bodies = if slide-args.pos() == () {
    (hide(""),)
  } else {
    slide-args.pos()
  }

  slide(
    header: none,
    footer: none,
    ..slide-args.named(),
    ..bodies,
  )
}

#let title-slide(..args) = touying.touying-slide-wrapper(self => {
  self.store.show-progress = false

  // Compose slide
  set std.align(left + horizon)
  set std.text(1.5em)

  let self = no-headers(self)

  touying.touying-slide(
    self: self,
    ..args,
  )[
    #v(.25fr)
    #text(1.5em, self.colors.primary, weight: 500, self.info.title)
    #if self.info.subtitle != none {
      linebreak()
      self.info.subtitle
    }
    #v(.5fr)
    #if self.info.author != none {
      set text(.66em)
      v(1em)
      self
        .info
        .author
        .map(author => {
          author.name
          if author.institution != none {
            [#footnote(author.institution)]
          }
          if author.abbr != none {
            [ (#author.abbr)]
          }
          if author.email != none {
            [ <#link("mailto:" + author.email, author.email)>]
          }
        })
        .join(linebreak())
    }
    #v(.25fr)
  ]
})

#let section-slide(level: 1, ..args) = touying.touying-slide-wrapper(self => {
  self.store.show-progress = false

  // Compose slide
  set std.align(center + horizon)

  let self = no-headers(
    touying.utils.merge-dicts(
      self,
      touying.config-page(fill: if level == 2 { self.colors.secondary-light } else { self.colors.primary-light }),
    ),
  )

  touying.touying-slide(
    self: self,
    composer: (1fr,),
    ..args.named(),
    text(
      size: 2em,
      fill: if level == 2 { self.colors.secondary } else { self.colors.primary },
      weight: 500,
      touying.utils.display-current-heading(level: 1),
    ),
  )
})

#let focus-slide(title: auto, level: 1, ..args) = touying.touying-slide-wrapper(self => {
  self.store.show-progress = false

  // Compose slide
  set std.align(center + horizon)

  let self = no-headers(
    touying.utils.merge-dicts(
      self,
      touying.config-page(fill: if level == 2 { self.colors.secondary } else { self.colors.primary }),
    ),
  )

  let bodies = args.pos()
  if title == auto and bodies.len() > 0 {
    self.store.title = bodies.remove(0)
  } else {
    self.store.title = title
  }

  set std.text(fill: self.colors.neutral-light)
  touying.touying-slide(
    self: self,
    composer: (1fr,),
    ..args.named(),
    text(
      size: 2em,
      weight: 500,
      touying.utils.call-or-display(self, self.store.title),
    ),
    ..bodies,
  )
})

#let image-slide(
  image,
  align: top + left,
  image-align: right + horizon,
  image-width: auto,
  gutter: 2%,
  composer: (1fr,),
  ..slide-args,
) = {
  let body = if type(composer) == function {
    composer(..slide-args.pos())
  } else {
    touying.components.side-by-side(columns: composer, ..slide-args.pos())
  }

  if image-align.x == right {
    slide(
      ..slide-args.named(),
      grid(
        columns: (1fr, auto),
        rows: 1fr,
        column-gutter: gutter,
        align: (align, image-align),
        body, image,
      ),
    )
  } else {
    slide(
      ..slide-args.named(),
      grid(
        columns: (auto, 1fr),
        rows: 1fr,
        align: (image-align, align),
        column-gutter: gutter,
        image, body,
      ),
    )
  }
}

#let full-image-slide(image, title: auto, mode: "cover", ..slide-args) = touying.touying-slide-wrapper(self => {
  assert(
    mode in ("cover", "contain", "stretch"),
    message: "mode needs to be one of cover, contain or stretch. got: " + mode,
  )

  self.store.title = title

  context {
    let _m = measure(image, width: 1000cm, height: 1000cm)
    let _margin = args.inset(self.page.margin)
    let _area = measure(
      block(width: 100%, height: 100%),
      width: page.width - _margin.left - _margin.right,
      height: page.height - _margin.top - _margin.bottom,
    )

    let x-factor = (page.width / _m.width) * 100%
    let y-factor = (page.height / _m.height) * 100%

    if mode == "cover" {
      x-factor = calc.max(x-factor, y-factor)
      y-factor = x-factor
    } else if mode == "contain" {
      y-factor = (_area.height / _m.height) * 100%

      x-factor = calc.min(x-factor, y-factor)
      y-factor = x-factor
    }

    if mode != "contain" {
      let self = no-headers(self)
    }

    touying.touying-slide(
      self: self,
      ..slide-args.named(),
      place(
        center + horizon,
        scale(image, x: x-factor, y: y-factor, origin: center + horizon),
      ),
    )
  }
})

#let quote-slide(
  attribution: none,
  ..slide-args,
) = {
  slide(
    align: center + horizon,
    setting: body => {
      quote(attribution: attribution, body)
    },
    composer: (..cont) => cont.pos().join(parbreak()),
    ..slide-args,
  )
}

#let link-slide(
  qrcode: true,
  qrcode-align: top,
  ..slide-args,
) = {
  let bodies = ()
  for target in slide-args.pos().filter(t => type(t) == str) {
    let l = (link(target, target),)
    if qrcode {
      if qrcode-align.y == bottom {
        l.push(codetastic.qrcode(target))
      } else {
        l.insert(0, codetastic.qrcode(target))
      }
    }
    bodies.push(
      grid(
        columns: 1,
        align: center,
        row-gutter: .64em,
        ..l
      ),
    )
  }

  slide(
    align: center + horizon,
    ..slide-args.named(),
    ..bodies,
  )
}

#let code-theme-colors(
  light: false,
  code-theme: auto,
) = {
  let code-theme = if code-theme == auto {
    if light {
      "assets/Eiffel.tmTheme"
    } else {
      "assets/1337.tmTheme"
    }
  } else {
    code-theme
  }
  return tmtheme.extract-colors(read(code-theme, encoding: none))
}

#let code-frame(
  code,
  light: false,
  code-theme: auto,
) = {
  let colors = code-theme-colors(light: light, code-theme: code-theme)

  shadowed(
    blur: 12pt,
    color: luma(50%).transparentize(10%),
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
        if type(code) == content and code.func() == raw {
          raw(
            lang: code.lang,
            theme: code-theme,
            code.text,
          )
        } else {
          code
        },
      )
    },
  )
}

#let code-slide(
  light: false,
  frame: true,
  theme: auto,
  align: center + horizon,
  ..slide-args,
) = {
  // let (codes, _) = util.extract-element(raw, slide-args.pos(), all: true)

  let codes = slide-args
    .pos()
    .map(body => {
      let (code, _) = util.extract-element(raw, body, all: true)
      code
    })

  let bodies = codes.map(c => if frame {
    code-frame(c, light: light, code-theme: theme)
  } else {
    c
  })

  slide(
    align: align,
    ..slide-args.named(),
    ..bodies,
  )
}


#let praesentation(
  ..args,
) = (
  body => {
    let fontsize = args.named().at("fontsize", default: 20pt)

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
          progress-bar-height: t.length(default: 6pt),
          show-section: t.boolean(default: false),
          // Touying specific configuration
          touying: t.array(default: ()),
        ),
      ),
      title-block: doc => title-slide(),

      // Some defaults for slides
      paper: "presentation-16-9",
      fontsize: fontsize,

      ..args,
      body,
    )

    {
      show: touying.touying-slides.with(
        touying.config-info(
          title: doc.title,
          subtitle: doc.topic,
          // TODO: (ngb) pass author array to theme
          // author: (doc.author-formatted)(),
          author: doc.author,
          date: doc.date,
          // institution: doc.author.first().institute,
        ),
        touying.config-page(
          header: self => {
            set text(size: fontsize, fill: self.colors.neutral)
            if self.store.show-progress {
              show-progress-bar(self)
            }
            touying.components.cell(
              inset: (x: 2%),
              {
                set align(horizon)
                touying.components.left-and-right[
                  #set text(weight: 500)
                  #if self.store.show-section {
                    text(fill: self.colors.primary, touying.utils.display-current-heading(level: 1))
                  }
                  #slide-title(self, self.store.title, sep: if self.store.show-section { sym.dash } else { "" })
                ][
                  #touying.utils.display-info-date(self)
                ]
              },
            )
          },
          footer: self => {
            set text(size: fontsize * .8, fill: self.colors.neutral)
            set align(bottom)
            touying.components.cell(
              inset: 1%,
              layout.base-footer(
                doc,
                layout.footer-left(doc),
                layout.footer-center(doc),
                context {
                  layout.format-pagenumber(
                    touying.utils.slide-counter.get().first(),
                    1,
                    touying.utils.last-slide-counter.final().first(),
                    touying.utils.last-slide-counter.final().first(),
                  )
                },
              ),
            )
          },
        ),
        touying.config-common(
          slide-fn: slide,
          new-section-slide-fn: section-slide,
          datetime-format: "[day].[month].[year]",
        ),
        touying.config-colors(
          primary: theme.primary,
          primary-light: theme.bg.primary,
          secondary: theme.secondary,
          secondary-light: theme.bg.secondary,
          neutral: theme.muted,
          neutral-light: theme.bg.muted,
          neutral-dark: theme.text,
          neutral-darkest: rgb("#23373b"),
        ),
        touying.config-store(
          title: none,
          subtitle: none,
          align: top + left,
          show-progress: doc.show-progress,
          show-section: doc.show-section,
          progress-bar-height: doc.progress-bar-height,
        ),
        touying.config-methods(
          alert: touying.utils.alert-with-primary-color,
          init: (self: none, body) => {
            show: page-init.with(
              header: none,
              footer: none,
            )
            set footnote.entry(separator: [])
            show footnote.entry: set text(.5em)
            show heading: it => {
              if it.level >= 3 {
                set text(1.25em)
                it
              } else {
                it
              }
            }
            show emph: set std.text(self.colors.secondary)
            set std.align(self.store.align)

            // if self.store.title != none {
            //   text(self.colors.primary, self.store.title)
            // }
            body
          },
        ),
        ..doc.touying,
      )

      tpl
    }
  }
)

// #let debug-slide(..keys, list-keys: false) = touying.touying-slide-wrapper(self => {
//   let body = none
//   if list-keys {
//     body = self.keys().map(raw.with(block: false)).join(", ")
//   } else {
//     let keys = if keys.pos() == () {
//       self.keys()
//     } else {
//       keys.pos()
//     }
//     let trimmed = (:)
//     for key in keys {
//       if key in self {
//         trimmed.insert(key, self.at(key, default: none))
//       }
//     }
//     body = [#trimmed]
//   }
//   touying.touying-slide(self: self, body)
// })


#let note(level: 1, ..args) = showybox(
  frame: (
    body-color: if level == 2 { theme.secondary } else { theme.primary },
    radius: 4pt,
    inset: .66em,
    border-color: if level == 2 { theme.secondary } else { theme.primary }.darken(50%),
    thickness: .6pt,
  ),
  shadow: (
    offset: 2pt,
    color: theme.muted.transparentize(50%),
  ),
  body-style: (
    color: if level == 2 { theme.text.secondary } else { theme.text.primary },
  ),
  ..args,
)

// TODO: (ngb) maybe replace with pinit package?
#let position(pos, body, angle: 0deg) = place(
  top + left,
  dx: pos.first(),
  dy: pos.last(),
  rotate(angle, body),
)

#let draft-grid(major: 1cm, minor: 2mm, color: silver) = {
  let major-pattern = pattern(
    size: (major, major),
    rect(width: 100%, height: 100%, stroke: .5mm + color),
  )
  let minor-pattern = pattern(
    size: (minor, minor),
    rect(width: 100%, height: 100%, stroke: .25mm + color.lighten(50%)),
  )

  place(
    top + left,
    rect(
      fill: minor-pattern,
      width: 100%,
      height: 100%,
    ),
  )
  place(
    top + left,
    rect(
      fill: major-pattern,
      width: 100%,
      height: 100%,
    ),
  )
}
