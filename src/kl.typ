#import "core/document.typ"
#import "core/layout.typ": base-header, header-left, header-right

#import "_imports.typ": *

#let grading-table = (
  "0": .0,
  "1": .20,
  "2": .27,
  "3": .33,
  "4": .39,
  "5": .45,
  "6": .50,
  "7": .55,
  "8": .60,
  "9": .65,
  "10": .70,
  "11": .75,
  "12": .80,
  "13": .85,
  "14": .90,
  "15": .95,
)

#let ewh(exercises) = {
  v(8mm)
  [Name: #box(stroke:(bottom:.6pt+black), width:6cm)]

  // TODO: Should the grading table be created here?
  ex.grading.display-expectations-table-expanded(exercises)

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

#let kl-title(
  doc,
) = block(
  below: 0.65em,
  width: 100%,
  rect(
    width: 100%,
    stroke: (
      right: 10pt + theme.muted,
      bottom: 10pt + theme.muted,
    ),
    inset: -2pt,
  )[
    #rect(width: 100%, stroke: 2pt + black, fill: white, inset: 0.25em)[
      #set align(center)
      #set text(fill: theme.text.title)
      #heading(
        level: 1,
        outlined: false,
        bookmarked: false,
      )[
        #smallcaps(doc.title) (#doc.duration Minuten)
      ]
      #v(-1em)
      #heading(level: 2, outlined: false, bookmarked: false)[
        #args.if-none(doc.subject, () => [])
        #args.if-none(doc.class, () => [])
        #(doc.author-abbr)()
      ]
      #v(0.25em)
    ]
  ],
)

// TODO: Rework this. Maybe add "pre-pages" and "post-pages" as conecpt in base-template / document?
#let cover-sheet(doc, message: [Klausuren und Informationen für die Aufsicht]) = [
  #v(.5fr)
  #align(center)[
    #text(4em, font: theme.fonts.sans, weight: "bold")[
      #doc.number. #doc.type-long #doc.subject
    ]

    #text(3em, font: theme.fonts.sans, weight: "bold")[
      #sym.tilde #doc.at("class") #sym.tilde
    ]

    #v(4em)

    #text(3em, font: theme.fonts.sans, weight: "bold")[
      #{
        ("Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag").at(doc.date.weekday())
      },
      #doc.date.display("[day].[month].[year]")
    ]

    #v(2em)

    #text(2em, weight: 400, message)

    #v(2em)

    #block()[
      #set text(1.2em)
      #set align(right)
      / Beginn: #luecke(width: 2cm) Uhr
      / Abgabe: #luecke(width: 2cm) Uhr
    ]
  ]

  #v(1fr)

  #grid(
    columns: (1fr, 1fr),
    gutter: 3cm,
    [*Anwesend:*], [*Abwesend:*],
    [], [],
  )

  #v(1fr)

  #pagebreak()
  #counter(page).update(4)
]

#let klausur(
  ewh: ewh,
  ..args,
) = (
  body => {
    let (doc, page-init, tpl) = base-template(
      type: "KL",
      type-long: "Klausur",
      _tpl: (
        options: (
          duration: t.integer(default: 180),
          split-expectations: t.boolean(default: false),
          cover-sheet: t.either(
            t.boolean(),
            t.string(),
            default: false,
          ),
        ),
        aliases: (
          dauer: "duration",
          erwartungen-einzeln: "split-expectations",
          deckblatt: "cover-sheet",
        ),
        pre-pages: (
          (doc, page-init) => {
            if doc.cover-sheet != false {
              show: page-init.with(header: none, footer: none)

              if type(doc.cover-sheet) == str {
                cover-sheet(doc, message: doc.cover-sheet())
              } else {
                cover-sheet(doc)
              }
            }
          }
        ),
        post-pages: (
          (doc, page-init) => if doc.solutions == "page" {
            show: page-init.with(header-center: (..) => [= Lösungen])
            context ex.solutions.display-solutions-page(ex.get-exercises())
          },
          (doc, page-init) => {
            show: page-init.with(
              header-center: (..) => [= Erwartungshorizont],
              footer: (..) => [],
            )
            context ewh(ex.get-exercises())
          },
        ),
      ),
      fontsize: 10pt,
      title-block: kl-title,
      ..args,
      body,
    )

    {
      show: page-init.with(header: base-header.with(rule: true))
      tpl
    }
  }
)

#let deckblatt = document.use(doc => cover-sheet(doc))

#let teilaufgabe = teilaufgabe.with(points-format: ex.points-format-join)
