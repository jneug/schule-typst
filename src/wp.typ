#import "./ab.typ": *

#let wplan(
	..args,

	body
) = {
	arbeitsblatt(
		typ: "Wochenplan",

		..args,

    module-init: () => {
      options.add-argument(
				"bis",
				default: none,
				type: ("string", "datetime"),
				code: v => {
					if type(v) == "string" {
            let d = v.split(".")
            datetime(
              day:int(d.at(0)),
              month:int(d.at(1)),
              year:int(d.at(2))
            )
          } else {
            v
          }
				}
			)
    },

		body
	)
}

#let d_date(d) = if type(d) == datetime {
  d.display("[day].[month].[year]")
} else {
  d
}

#let zeitraum(von:auto, bis:auto) = container(radius: 4pt, fill: theme.muted, stroke: 0pt)[
  #set align(center)
  #set text(white)
  #emoji.calendar *#if is.a(von) { options.get("datum", d_date) } else { d_date(von) } bis #if is.a(bis) { options.get("bis", d_date) } else { d_date(bis) }*
]

#let wptitel() = [
  = #dertitel: #diereihe
  #zeitraum()
]

#let gruppe(titel, beschreibung, body) = container(
  radius: 6pt,
  fill: theme.bg.muted,
  stroke: 1.5pt + luma(120),
  title-style: (boxed-style: (:)),
  title: text(weight: "bold", hyphenate: false, size: .88em, titel),
)[#small(beschreibung)#container(fill: white, radius: 3pt, stroke: 1pt + luma(120), body)]

#let aufg-join( items ) = if type(items) == "array" {
	items.map(str).join(", ", last:" und ")
} else {
	items
}

#let aufg(nr) = [Aufg. #aufg-join(nr)]
#let af = aufgabe

#let neue-quelle(name) = (seite, ..aufgaben) => if aufgaben.pos().len() > 0 [
  #name S. #aufg-join(seite), #aufg(aufgaben.pos().first())
] else [
  #name S. #aufg-join(seite)
]

// #let bu(seite, ..aufg) = if aufg.pos().len() > 0 [
//   Buch S. #aufg-join(seite), #af(aufg.pos().first())
// ] else [
//   Buch S. #aufg-join(seite)
// ]
// #let ah(seite, ..aufg) = if aufg.pos().len() > 0 [
//   AH S. #aufg-join(seite), #af(aufg.pos().first())
// ] else [
//   AH S. #aufg-join(seite)
// ]

#let bu = neue-quelle("Buch")
#let ah = neue-quelle("AH")

#let ab(titel, supl:[AB]) = [#supl "#titel"]
