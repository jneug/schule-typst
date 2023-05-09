#import "./typo.typ": rahmen



// ================================
// =       Dokumentationen        =
// ================================
#import "./if/docs.typ"


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
