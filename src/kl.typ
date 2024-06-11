#import "./ab.typ": *
#import  "./bewertung.typ": *
// #import "./layout.typ": kopfzeile


#let _teilaufgabe = teilaufgabe
#let teilaufgabe( ..args ) = {
	_teilaufgabe(..args.pos(), ..args.named())
	d_erwpunkte()
}


#let klausur(
	..args,

	fontsize: 11pt,

  deckblatt: true,

	body
) = {
	show <ab-end>: body => {
		d_ew_oberstufe()
		body
	}

	arbeitsblatt(
		typ: "Klausur",

		..args,

		fontsize: fontsize,

		module-init: () => {
			options.add-argument("dauer", default:180, type:"integer")
			options.add-argument("punkte-pro-erwartung", default:false, type:"boolean")
		},
    body
	)
}


#let diedauer = options.display("dauer")


#let kltitel(
	titel: none,
	reihe: none
) = {
	if titel == none { titel = dertitel }
	rect(width:100%, stroke: (
		right: 10pt + gray,
		bottom: 10pt + gray
	), inset: -2pt)[
		#rect(width:100%, stroke:2pt + black, fill:white, inset:0.25em)[
			#set align(center)
			#set text(fill:theme.text.title)
			#heading(level:1, outlined: false, bookmarked: false)[#smallcaps(titel) (#diedauer Minuten)]
			#v(-1em)
			#heading(level:2, outlined: false, bookmarked: false)[#dasfach #derkurs (#daskuerzel)]
			#v(0.25em)
		]
	]
}

#let deckblatt( message: [Klausuren und Informationen für die Aufsicht] ) = [
  #v(.5fr)
  #align(center)[
    #text(4em, font:theme.fonts.sans, weight:"bold")[
      #dienummer. #dertyp #dasfach
    ]

    #text(3em, font:theme.fonts.sans, weight:"bold")[
      #sym.tilde #derkurs #sym.tilde
    ]

    #v(4em)

    #text(3em, font:theme.fonts.sans, weight:"bold")[
      #options.display("datum", format: (dt)=> if dt != none {
        ("Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag").at(dt.weekday())

        dt.display(", [day].[month].[year]")
      })
    ]

    #v(2em)

    #text(2em, weight:400, message)

    #v(2em)

    #block()[
      #set text(1.2em)
      #set align(right)
      / Beginn: #luecke(width: 2cm) Uhr
      / Abgabe: #luecke(width: 2cm) Uhr
    ]
  ]

  #v(1fr)

  #grid(columns:(1fr,1fr), gutter:3cm,
    [*Anwesend:*],
    [*Abwesend:*]
  )

  #v(1fr)

  #pagebreak()
]
