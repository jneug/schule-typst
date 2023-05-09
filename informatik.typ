#import "./typo.typ": rahmen

#import "./if/docs.typ"


// ================================
// =       Dokumentationen        =
// ================================
#let _ab_highlight_doku = false

#let mdoku( signature, body ) = {
	if signature.func() == raw {
		signature = signature.text
	}

	block(
		width:100%,
		fill:luma(85%),
		breakable:false,
		inset:4pt,
		below: 4pt
	)[
		#set text(size:0.85em)
		#if not _ab_highlight_doku [*#signature*]
		else [#raw(signature, block:false, lang:"java")]
	]
	body
}


// ================================
// =         Datenbanken          =
// ================================
#import "./if/erd.typ": *

#let dbs( body ) = rahmen[
	#set align(left)
	#body
]

#let pkey( name ) = underline(stroke:1.1pt,offset:0.25em)[#name]
#let fkey( name ) = [#sym.arrow.t.filled#name]
#let fpkey( name ) = pkey(fkey(name))
