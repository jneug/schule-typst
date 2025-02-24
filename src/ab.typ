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
        "post-pages": (
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
      show: page-init
      tpl
    }
  }
)
