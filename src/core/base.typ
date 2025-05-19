
#import "../util/args.typ"
#import "../util/marks.typ"
#import "../util/util.typ"
#import "document.typ"
#import "layout.typ"

#import "../theme.typ"
#import "../_deps.typ": zebraw, et

// Basisvorlage für alle Dokumentvorlagen
#let base-template(
  title-block: layout.base-title,
  //
  _tpl: (:),
  //
  ..document-args,
  //
  body,
) = {
  let doc = document.create(
    ..document-args,
    options: args.if-has(_tpl, "options", () => (:)),
    aliases: args.if-has(_tpl, "aliases", () => (:)),
  )

  let page-init(
    header: layout.base-header,
    header-left: (_, body) => body,
    header-center: (_, body) => body,
    header-right: (_, body) => body,
    footer: layout.base-footer,
    footer-left: (_, body) => body,
    footer-center: (_, body) => body,
    footer-right: (_, body) => body,
    // custom page-settings function
    settings: body => body,
    // additional page args
    ..page-args,
    //
    body,
  ) = {
    // Create empty header / footer if non provided
    if header == none {
      header = (..) => []
    }
    if footer == none {
      footer = (..) => []
    }

    // Initialize page
    set page(
      ..args.extract-args(
        document-args,
        paper: "a4",
        flipped: false,
        margin: (
          y: 2cm,
          x: 1.69cm,
          left: if document-args.named().at("binding", default: false) {
            2.41cm
          } else {
            1.69cm
          },
        ),
      ),
      // Additional page arguments for overwrites
      ..page-args.named(),
      // Header
      header: {
        header(
          doc,
          header-left(doc, layout.header-left(doc)),
          header-center(doc, layout.header-center(doc)),
          header-right(doc, layout.header-right(doc)),
        )
      },
      // Footer
      footer: footer(
        doc,
        footer-left(doc, layout.footer-left(doc)),
        footer-center(doc, layout.footer-center(doc)),
        footer-right(doc, layout.footer-right(doc)),
      ),
    )

    // Paragraphs
    let line-spacing = document-args.named().at("line-spacing", default: 150%)
    let paragraph-spacing = document-args.named().at("paragraph-spacing", default: line-spacing * line-spacing)
    set par(
      ..args.extract-args(
        document-args,
        _prefix: "par",
        leading: line-spacing * 0.5em,
        spacing: paragraph-spacing * 0.5em,
        justify: true,
      ),
      linebreaks: "optimized",
    )

    // Basic body text properties
    set text(
      ..args.extract-args(
        document-args,
        _prefix: "font",
        size: 12pt,
        weight: "light",
        lang: "de",
        region: "DE",
        hyphenate: auto,
        style: "normal",
        number-width: "proportional",
      ),
    )

    // Configure headings
    show heading: it => {
      block(
        breakable: false,
        sticky: true,
        above: layout.heading-size(1.25em, 0.8em, it.level),
        below: layout.heading-size(0.64em, 0.55em, it.level),
        text(
          font: theme.fonts.headings,
          fill: theme.primary,
          size: layout.heading-size(1.1em, 1.0em, it.level),
          weight: layout.heading-weight(it.level),
          it,
        ),
      )
    }
    // Link color
    show link: set text(fill: theme.secondary)
    // Table defaults
    show table: it => {
      set table(stroke: theme.table.stroke)
      set text(number-width: "tabular")
    }
    // Lists defaults
    set enum(numbering: "1)")
    // Figures
    show figure.caption: set text(.88em)

    // Raw code blocks
    show raw: set text(font: theme.fonts.code)
    // show raw.where(block: false): set text(fill: theme.primary)
    set raw(
      theme: if not doc.colors { "../assets/BW.tmTheme" } else {
        page-args.named().at("code-theme", default: "../assets/Eiffel.tmTheme")
      },
    )
    show: zebraw.zebraw.with(
      lang: false,
      numbering-separator: true,
      hanging-indent: true,
    )

    // decimal fix for now
    show: util.decimal-fix

    // initialize theme
    show: theme.init

    // Show the actual document body
    // with custom settings applied
    settings(body)
  }

  return (
    doc,
    page-init,
    {
      // Set PDF metadata
      set std.document(
        title: util.get-text(doc.title),
        author: doc.author.map(a => a.name),
        date: doc.date,
      )

      if doc._debug {
        page(paper: "a3", flipped: true, columns: 3)[
          == Document
          #doc

          == Exercises
          #import "../exercise/exercise.typ" as ex
          #context ex.get-exercises(final: true)
        ]
      }

      document.save(doc)
      document.save-meta(doc)

      marks.place-meta(<pre-pages-start>)
      if "pre-pages" in _tpl {
        marks.env-open("pre-pages")
        for p in args.as-arr(_tpl.pre-pages) {
          if type(p) == function {
            p(doc, page-init)
          } else {
            p
          }
        }
        marks.env-close("pre-pages")
      }
      marks.place-meta(<pre-pages-end>)

      marks.place-meta(<content-start>)
      marks.env-open("content")
      if title-block != none {
        title-block(doc)
      }
      body
      marks.env-close("content")
      marks.place-meta(<content-end>)

      marks.place-meta(<post-pages-start>)
      if "post-pages" in _tpl {
        marks.env-open("post-pages")
        for p in args.as-arr(_tpl.post-pages) {
          if type(p) == function {
            p(doc, page-init)
          } else {
            p
          }
        }
        marks.env-close("post-pages")
      }
      marks.place-meta(<post-pages-end>)
    },
  )
}

#let appendix(body, title: [Anhang], ..page-args) = {
  set page(..page-args.named())
  pagebreak(weak: true)

  marks.env-open("appendix")
  // state("schule.appendix").update(true)
  set heading(
    numbering: (..n) => {
      let n = n.pos()
      let _ = n.remove(0)
      if n.len() > 0 {
        numbering("A.1", ..n)
      }
    },
  )
  heading(level: 1, title)
  body
  marks.env-close("appendix")
}
