#import "core/layout.typ": base-header, header-left, header-right

#import "_imports.typ": *

#let grading-table = (
  /* @typststyle:off */
  "6": .0,
  "5-": .20, "5": .27, "5+": .33,
  "4-": .40, "4": .45, "4+": .50,
  "3-": .55, "3": .60, "3+": .65,
  "2-": .70, "2": .75, "2+": .80,
  "1-": .85, "1": .90, "1+": .95
)

#let ewh(exercises) = {
  v(8mm)
  [Name: #box(stroke:(bottom:.6pt+black), width:6cm)]

  ex.grading.display-expectations-table(exercises)

  v(4mm)
  align(right, [*Note:* #box(stroke:(bottom:.6pt+black), width:4cm)])
  align(right, [Datum, Unterschrift: #box(stroke:(bottom:.6pt+black), width:4cm)])

  v(1fr)
  align(
    center,
    ex.grading.display-grading-table(
      exercises,
      grading-table,
    ),
  )
}

#let klassenarbeit(
  ewh: ewh,
  ..args,
  body,
) = {
  let (doc, page-init, tpl) = base-template(
    type: "KA",
    type-long: "Klassenarbeit",
    _tpl: (
      options: (
        duration: t.integer(default: 180),
        double-grading-page: t.boolean(default: false),
      ),
      aliases: (
        dauer: "duration",
        doppelter-ewh: "double-grading-page",
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

  show: page-init.with(
    header-center: (..) => [== Erwartungshorizont],
    footer: (..) => [],
  )
  context ewh(ex.get-exercises())
}
}
