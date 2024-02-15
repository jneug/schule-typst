#import "./ab.typ": *
#import "./figures.typ": tablefill

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

#let wptitel() = {
	[= Wochenplan vom #options.get("datum", v => v.display("[day].[month].[year]")) bis #options.get("bis", v => v.display("[day].[month].[year]"))]
}

#let join( items ) = if type(items) == "array" {
	items.map(str).join(", ", last:" und ")
} else {
	items
}

#let af(nr) = [Aufg. #join(nr)]
#let bu(seite, ..aufg) = if aufg.pos().len() > 0 [
  Buch S. #join(seite), #af(aufg.pos().first())
] else [
  Buch S. #join(seite)
]
#let ah(seite, ..aufg) = if aufg.pos().len() > 0 [
  AH S. #join(seite), #af(aufg.pos().first())
] else [
  AH S. #join(seite)
]
#let ab(titel, supl:[AB]) = [#supl "#titel"]
