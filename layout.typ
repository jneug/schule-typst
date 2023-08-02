#import "@local/typopts:0.0.4": options

#import "./theme.typ"
#import "./typo.typ": small, luecke

// ============================
// Body start / end markers
// ============================
#let docstart() = [#hide[] <body-start>]
#let docend()   = [#hide[] <body-end>]

// ============================
// Page numbers
// ============================
/*
 * current = aktuelle Seite
 * body = Anzahl Seiten im Textkörper
 * total = Anzahl Seiten gesamt (inkl. Lösungen etc.)
 */
#let pagenumber-format(
	current, body, total
) = {
	if current > total [
		#sym.dash
	] else if current > body {
		numbering("I", (current - body))
		if total - body > 2 [
			von #numbering("I", (total - body))
		]
	} else {
		if body > 1 [ #current ]
		if body > 2 [ von #body ]
	}
}

// Display pagenumber
#let d_pagenumber( format: pagenumber-format ) = locate(loc => {
	let bodyend = query(<body-end>, loc)
	if bodyend != () {
		bodyend = counter(page).at(
			bodyend.first().location()
		).at(0)
	} else {
		bodyend = counter(page).final(loc).at(0)
	}
	format(
		counter(page).at(loc).at(0),
		bodyend,
		counter(page).final(loc).at(0)
	)
})
#let d_seitenzahl = d_pagenumber

#let kopfLinks() = [#options.display("fach", final:true) #options.display("kurs", final:true) #options.display("kuerzel", format: v=>{if v != none [(#v)]}, final:true)]
#let kopfMitte() = [Datum: #options.display("datum", format: v=>{if v != none [#v.display("[day].[month].[year]")] else [#luecke()]}, final:true)]
#let kopfRechts() = [#options.display("typ", final:true) #options.display("nummer", format: v=>{if v != none [Nr. #v]}, final:true)]
#let kopfzeile( links: kopfLinks, mitte: kopfMitte, rechts:kopfRechts ) = locate(loc => [
	#set text(fill: theme.text.header)
	#small[
		#links()
		#h(1fr)
		#mitte()
		#h(1fr)
		#rechts()
	]
	#move(dy:-.4em, line(length:100%, stroke:.5pt))
])

#let fussLinks() = [#options.display("version", format: v=>{if v != none [ver.#v]}, final:true)]
#let fussMitte() = [cc-by-sa-4]
#let fussRechts() = d_seitenzahl()
#let fusszeile( links: fussLinks, mitte: fussMitte, rechts:fussRechts ) = locate(loc => [
	#set text(fill: theme.text.footer)
	#small[
		#links()
		#h(1fr)
		#mitte()
		#h(1fr)
		#rechts()
	]
])

#let __place_wrapfig(
	align,
	width,
	gutter:0.75em,
	dx: 0pt, dy: 0pt,
	element,
	body
) = block(width:100%, {
	let insets = ()
	if align == left {
		insets = (left:width + gutter)
	} else {
		insets = (right:width + gutter)
	}
	place(align, move(dx:dx, dy:dy, block(width:width, element)))
	if align == center {
		columns(2, gutter:width + gutter, body)
	} else {
		block(width:100%, inset:insets, body)
	}
})
#let wrapfig(
	align,
	width:auto,
	gutter:0.75em,
	dx: 0pt, dy: 0pt,
	element,
	body
) = block(width:100%, {
	if width == auto {
		style(styles => {
			let w = measure(element, styles).width
			__place_wrapfig(align, w, gutter:gutter, element, body)
		})
	} else {
		__place_wrapfig(align, width, gutter:gutter, dx:dx, dy:dy, element, body)
	}
})
