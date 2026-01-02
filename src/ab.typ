#import "_imports.typ": *

/// Basisvorlage für ein Arbeitsblatt.
#let arbeitsblatt(
  ..args,
) = (
  body => {
    let (
      doc,
      page-init,
      tpl,
    ) = base-template(
      type: "AB",
      type-long: "Arbeitsblatt",
      _tpl: (
        options: (
          columns: t.integer(default: 1),
          line-numbers: t.either(
            t.string(),
            t.function(),
            t.boolean(),
            default: false,
            pre-transform: (_, it) => {
              if it == false {
                it = none
              }
              it
            },
          ),
        ),
        aliases: (
          spalten: "columns",
          zeilennummern: "line-numbers",
        ),
        post-pages: (
          (doc, page-init) => if doc.solutions == "page" {
            show: page-init.with(header-center: (..) => [= Lösungen])
            context ex.solutions.display-solutions-page(ex.get-exercises())
          },
        ),
      ),
      loesungen: "keine",
      ..args,
      body,
    )

    {
      show: page-init.with(columns: doc.columns)
      set par.line(
        numbering: if doc.line-numbers == true {
          n => text(.8em, theme.muted)[#n]
        } else { doc.line-numbers },
        number-clearance: .64em,
      )
      show heading: set par.line(numbering: none)
      show figure: set par.line(numbering: none)
      tpl
    }
  }
)

#let span(align: top, body) = place(align, scope: "parent", float: true, body)
