#import "./ab.typ": *
#import "./figures.typ": tablefill

#let checkup(
	..args,

	body
) = {
	arbeitsblatt(
		typ: "Checkup",

		..args,

		body
	)
}

#let cutitel() = {
	[= Checkup zur #dertitel: #text(fill:theme.secondary, diereihe)]
}

#let CheckupBild = image("./assets/checkup.png", width:2cm)

#let smilies = [
	#emoji.face.beam #emoji.face.happy #emoji.face.diagonal #emoji.face.sad
]

#let join( items ) = if type(items) == "array" {
	items.map(str).join(", ", last:" und ")
} else {
	items
}

#let af(nr) = [Aufg. #join(nr)]
#let bu(seite) = [Buch S. #join(seite)]
#let buaf(seite, nr) = [#bu(seite), #af(nr)]
#let ah(seite) = [AH S. #join(seite)]
#let ahaf(seite, nr) = [#ah(seite), #af(nr)]
#let ab(titel, supl:[AB]) = [#supl "#titel"]

#let ichkann( body, aufgaben ) = (
	[#sym.dots #body], [#smilies], [#aufgaben.children.filter(c => c.func() != [ ].func()).join([\ ])]
)

#let checkuptable( ..cells ) = table(
	columns: (1fr, auto, auto),
	fill: tablefill(oddfill:white),
	align: (c,r) => (left+horizon, center+horizon, left+top).at(c),
	[*Ich kann #sym.dots*], [], [*Informationen &
Aufgaben*],
	..cells.pos().flatten()
)
