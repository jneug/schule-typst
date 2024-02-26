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
