/********************************\
*          Page layout           *
\********************************/

#import "lib/typopts/typopts.typ": options

#import "./theme.typ"
#import "./typo.typ": small, luecke


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
		bodyend = bodyend.first().location().page()
	} else {
		bodyend = counter(page).final(loc).first()
	}
	format(
		counter(page).at(loc).first(),
		bodyend,
		counter(page).final(loc).first()
	)
})

// {API}
#let d_seitenzahl = d_pagenumber


// =================================
//  Kopf- / Fußzeile
// =================================

#let kopfLinks() = [
  #options.display("fach", final:true)
  #options.display("kurs", final:true)
  #options.display("kuerzel", format: v=>{if v != none [(#v)]}, final:true)
]

#let kopfMitte() = [
  Datum: #options.display("datum", format: v=>{if v != none [#v.display("[day].[month].[year]")] else [#luecke()]}, final:true)
]

#let kopfRechts() = [
  #options.display("typ", final:true)
  #options.display("nummer", format: v=>{if v != none [Nr. #v]}, final:true)
]

#let kopfzeile(
  links: kopfLinks,
  mitte: kopfMitte,
  rechts: kopfRechts
) = {
  set text(theme.text.header, 0.88em)
  grid(
    columns: (25%, 50%, 25%),
    links(),
    {
      set align(center)
      mitte()
    },
    {
      set align(right)
      rechts()
    }
  )
  box(line(length:100%, stroke:.5pt))
}

#let fussLinks() = [
  #options.display("version", format: v=>{if v != none [ver.#v]}, final:true)
]

#let fussMitte() = "cc-by-sa-4"

#let fussRechts() = [
  #d_seitenzahl()
]

#let fusszeile(
  links: fussLinks,
  mitte: fussMitte,
  rechts: fussRechts
) = {
  set text(theme.text.footer, 0.88em)
  grid(
    columns: (25%, 50%, 25%),
    links(),
    {
      set align(center)
      mitte()
    },
    {
      set align(right)
      rechts()
    }
  )
}


// =================================
//  Figures
// =================================

#let __place_wrapfig(
	align,
	width,
	gutter: 0.75em,
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
	width: auto,
	gutter: 0.75em,
	dx: 0pt, dy: 0pt,
	element,
	body
) = block(width:100%, {
	if width == auto {
		style(styles => {
			let w = measure(element, styles).width
			__place_wrapfig(align, w, gutter:gutter, dx:dx, dy:dy, element, body)
		})
	} else {
		__place_wrapfig(align, width, gutter:gutter, dx:dx, dy:dy, element, body)
	}
})


#let __all__ = (
  pagenumber-format,
).fold((:), (a, b) => {a.insert(repr(b), b); a})
