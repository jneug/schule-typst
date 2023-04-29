#import "./options.typ"
#import "./states.typ"
#import "./hooks.typ"

#import "./theme.typ"
#import "./layout.typ": *
#import "./typo.typ": *
#import "./figures.typ": *

#import emoji

#import "./aufgaben.typ": *


#let __getOrDefault( var, key, default ) = {
	if key in var.named() { var.named().at(key) }
	else if key in var.pos() { var.pos().at(key) }
	else { default }
}


#let arbeitsblatt(
	..args,

	_init: none,

	body
) = {
	let fontsize = __getOrDefault(args, "fontsize", 12pt)

	// set document(
	// 	title: if "titel" in args.named() {args.named().titel},
	// 	author: if "autor" in args.named() {args.named().autor}
	// )

	// Configure page
	set page(
		..options.extract(args,
			paper: "a4",
			flipped: false,
		),
		header: kopfzeile(),
		footer: fusszeile()
	)
	// Configure text
  	set par(
		..options.extract(args, prefix:"par",
			justify: true
		)
	)
	set text(
		font: theme.fonts.default,
		size: __getOrDefault(args, "fontsize", 13pt),
		..options.extract(args, prefix:"font",
			weight: 300,
			fallback: true,
			lang: "de",
			region: "DE",
			hyphenate: auto,
		)
	)
	// Configure headings
	show heading: set text(
		font: theme.fonts.headings,
		fill: theme.primary
	)
	// Lists
	set enum(
		numbering: "1)"
	)
	// Configure code blocks
	show raw: set text(
		font: theme.fonts.code,
		size: __getOrDefault(args, "fontsize", 13pt)*0.88
	)
	show raw.where(block: false): set text(
		fill: theme.primary
	)
	show raw.where(block: true): c => code(c)

	// Handle options (after setting up page with header / footer)
	for opt in (
		"autor", "kuerzel", "titel",
		"reihe", "nummer", "fach",
		"kurs", "datum", "version"
	) {
		options.addconfig(opt)
	}
	options.addconfig("typ", default:"Arbeitsblatt")
	options.addconfig("fontsize", default:13pt, type:"length")

	options.addconfig("loesungen", default:"sofort")

	options.parseconfig(..args)

	// Subtype init
	if _init != none {
		_init()
	}

	[
		<ab-start>
		#body
		#options.get("loesungen", v => {
			if v == "seite" { d_loesungen() }
		})
		<ab-end>
	]
}


#let derautor = options.display("autor")
#let daskuerzel = options.display("kuerzel")
#let dertitel = options.display("titel")
#let diereihe = options.display("reihe")
#let dienummer = options.display("nummer")
#let dasfach = options.display("fach")
#let derkurs = options.display("kurs")
#let dertyp = options.display("typ")
#let dasdatum = options.display("datum")
#let dieversion = options.display("version")


#let abtitel(
	titel: none,
	reihe: none
) = block(spacing:0pt, width:100%)[#{
	if titel == none { titel = dertitel }
	if reihe == none { reihe = diereihe }

	set align(center)
	if reihe != none [
		=== #text(fill: theme.text.subject)[#smallcaps(reihe)]
	]
	move(dy:-.4em)[
		#text(fill: theme.primary)[= #smallcaps(titel)]
		//#move(dy: -.8em, line(length: 100%))
	]
	v(-1.5em)
}]

#let anhang( body ) = page(
	header: kopfzeile(
		mitte: () => [Anhang]
	)
)[
	= Anhang <anhang>
	#body
]
