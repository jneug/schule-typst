// TODO: i18n verbessern

#import "../util/args.typ"
#import "../util/typst.typ"
#import "../util/marks.typ"
#import "../util/util.typ"
#import "document.typ"
#import "layout.typ"

#import "../theme.typ"

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
    show raw: set text(font: theme.fonts.code)
    show raw.where(block: false): set text(fill: theme.primary)
    // set raw(theme: "./BW.tmTheme")
    show figure.caption: set text(.88em)

    show: util.decimal-fix

    show: theme.init

    body
  }

  // Set PDF metadata
  // TODO: currently does not work?
  set typst.document(
    title: "my title",// doc.title,
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

      // TODO: remove _metadata key?
      // for key in doc._metadata {
      //   [#metadata(doc.at(key))#label("schule-" + key)]
      // }

      marks.place-meta(<content-start>)
      marks.env-open("content")
      if title-block != none {
        title-block(doc)
      }
      body
      marks.env-close("content")
      marks.place-meta(<content-end>)
    },
  )
}

#let appendix(body, title: [Anhang], ..page-args) = {
  set page(..page-args.named())
  pagebreak(weak: true)

  marks.env-open("appendix")
  // state("schule.appendix").update(true)
  set heading(numbering: (..n) => {
    let n = n.pos()
    let _ = n.remove(0)
    if n.len() > 0 {
      numbering("A.1", ..n)
    }
  })
  heading(level: 1, title)
  body
  marks.env-close("appendix")
}
