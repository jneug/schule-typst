#import "./ab.typ": *
#import "theme.typ"

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

#let cutitel() = heading(level:1, outlined: false, bookmarked: false)[Checkup zur #dertitel: #text(fill:theme.secondary, diereihe)]

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

#let trenner( content ) = (
  [#content], [], []
)

#let checkuptable( ..cells ) = {
  let fills = (
    rows: (:), cols: (:)
  )
  for (i,row) in cells.pos().enumerate() {
    if row.at(1) == [] {
      fills.rows.insert(str(i+1), theme.table.header)
    }
  }
  table(
  	columns: (1fr, auto, auto),
  	fill: tablefill(
     fills: fills
    ),
  	align: (c,r) => (left+horizon, center+horizon, left+horizon).at(c),
  	[*Ich kann #sym.dots*], [], [*Informationen &
  Aufgaben*],
  	..cells.pos().flatten()
  )
}
