
#import "../util/args.typ"
#import "../util/marks.typ"
#import "../util/util.typ"
#import "document.typ"
#import "layout.typ"

#import "../theme.typ"
#import "../_deps.typ": codly

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

  // TODO: allow users to change headers / footers?
  // TODO: Move some of page-init to theme?
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
    settings: body => {
      show: codly.codly-init
      codly.codly(
        zebra-fill: none,
        display-name: false,
        display-icon: false,
        number-format: n => text(
          size: .88em,
          fill: theme.muted,
          strong(str(n)),
        ),
        ..theme.codly,
      )
      body
    },
    // additional page args
    ..page-args,
    //
    body,
  ) = {
    set text(
      font: args.extract-args(document-args, font: theme.fonts.default).font,
      ..args.extract-args(
        document-args,
        _prefix: "font",
        size: 12pt,
        weight: 300,
        fallback: true,
        lang: "de",
        region: "DE",
        hyphenate: auto,
      ),
    )
    show heading: set text(
      font: theme.fonts.headings,
      fill: theme.primary,
    )
    show link: set text(fill: theme.secondary)

    set table(stroke: theme.table.stroke)

    if header == none {
      header = (..) => []
    }
    if footer == none {
      footer = (..) => []
    }

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
      ..page-args.named(),
      header: {
        // TODO: add conditional stepping?
        // TODO: Remove counters from doc
        // doc._counters.content-pages.step()
        header(
          doc,
          header-left(doc, layout.header-left(doc)),
          header-center(doc, layout.header-center(doc)),
          header-right(doc, layout.header-right(doc)),
        )
      },
      footer: footer(
        doc,
        footer-left(doc, layout.footer-left(doc)),
        footer-center(doc, layout.footer-center(doc)),
        footer-right(doc, layout.footer-right(doc)),
      ),
    )

    set par(
      leading: 1.2em,
      ..args.extract-args(
        document-args,
        _prefix: "par",
        justify: true,
      ),
    )
    // Lists
    set enum(numbering: "1)")
    // Configure code blocks
    // show raw: set text(font: theme.fonts.code)
    // show raw.where(block: false): set text(fill: theme.primary)
    // TODO: (jneug) add option to activate bw theme
    // set raw(theme: "../assets/BW.tmTheme")
    show figure.caption: set text(.88em)

    // TODO: (jneug) handle this in another way?
    // decimal fix for now
    show: util.decimal-fix

    // initialize theme
    show: theme.init

    // apply custom settings
    show: settings

    // Show the actual document body
    body
  }

  // Set PDF metadata
  // TODO: currently does not work?
  set std.document(
    title: "my title", // doc.title,
    author: doc.author.map(a => a.name),
    date: doc.date,
  )

  return (
    doc,
    page-init,
    {
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
