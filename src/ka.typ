#import "core/layout.typ": base-header, header-left, header-right

#import "_imports.typ": *

#let grading-table = (
  /* @typststyle:off */
  "6": .0,
  "5-": .20,
  "5": .28,
  "5+": .37,
  "4-": .45,
  "4": .50,
  "4+": .55,
  "3-": .60,
  "3": .65,
  "3+": .70,
  "2-": .75,
  "2": .80,
  "2+": .85,
  "1-": .90,
  "1": .95,
  "1+": 1.00,
)

#let ewh(exercises, grading-table: grading-table) = {
  v(8mm)
  [Name: #box(stroke: (bottom: .6pt + black), width: 6cm)]

  ex.grading.display-expectations-table(exercises)

  v(4mm)
  align(right, [*Note:* #box(stroke: (bottom: .6pt + black), width: 5cm)])
  v(4mm)
  align(right, [Datum, Unterschrift: #box(stroke: (bottom: .6pt + black), width: 5cm)])
  v(4mm)
  align(right, [zur Kenntnis genommen (Eltern): #box(stroke: (bottom: .6pt + black), width: 5cm)])

  v(1fr)
  align(
    center,
    {
      ex.grading.display-competencies(exercises, header: "Du kannst ...")

      ex.grading.display-grading-table(
        exercises,
        grading-table,
      )
    },
  )
}

#let klassenarbeit(
  // ewh: ewh,
  ..args,
) = (
  body => {
    let (doc, page-init, tpl) = base-template(
      type: "KA",
      type-long: "Klassenarbeit",
      _tpl: (
        options: (
          duration: t.integer(default: 180),
          double-grading-page: t.boolean(default: false),
          grading-table: t.dictionary((:), default: grading-table),
          grading-page: t.function(default: ewh),
          variant-icons: t.dictionary(
            (:),
            default: (
              A: emoji.monkey.face,
              B: emoji.bear,
              D: emoji.cat.face,
              C: emoji.dog.face,
            ),
          ),
        ),
        aliases: (
          dauer: "duration",
          doppelter-ewh: "double-grading-page",
          bewertungstabelle: "grading-table",
          ewh: "grading-page",
        ),
      ),
      font: ("Comic Neue", "Grundschrift", "Apple Color Emoji"),
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

    context {
      let grading-page-content = (doc.grading-page)(ex.get-exercises(), grading-table: doc.grading-table)

      if grading-page-content != none and grading-page-content != [] {
        show: page-init.with(
          header-center: (..) => [== Erwartungshorizont],
          footer: (..) => [],
        )

        grading-page-content

        if doc.double-grading-page {
          pagebreak(weak: true)
          grading-page-content
        }
      }
    }
  }
)
