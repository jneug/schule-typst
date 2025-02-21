#import "core/layout.typ": base-header, header-left, header-right

#import "_imports.typ": *

#let lernzielkontrolle(
  ..args,
) = (
  body => {
    let (doc, page-init, tpl) = base-template(
      type: "LZK",
      type-long: "Lernzielkontrolle",
      _tpl: (
        options: (
          duration: t.integer(default: 180),
        ),
        aliases: (
          dauer: "duration",
        ),
      ),
      ..args,
      body,
    )

    {
      show: page-init
      tpl
    }

    if doc.solutions == "page" {
      show: page-init.with(header-center: (..) => [== Lösungen])
      context ex.solutions.display-solutions-page(ex.get-exercises())
    }
  }
)
