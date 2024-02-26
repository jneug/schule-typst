
#import "./typo.typ": rahmen
#import "@preview/t4t:0.3.2": is, assert, def

#import "@preview/cetz:0.2.0"

// Array
#let arr( len, ..data ) = {
  let d = data.pos() + ([],) * calc.max(0, (len - data.pos().len()))
  table(
    columns: (auto,) + (8mm,) * len,
    fill: (c,r) => if r == 1 { theme.bg.muted },
    align: center,
    [*Inhalt*], ..d,
    [*Index*], ..range(len).map(str).map(raw)
  )
}


// =================================
//  Binärzahlen
// =================================

// Ziffern bis Hexadezimal
#let nary-digits = (
	"0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
	"A", "B", "C", "D", "E", "F"
)

// string -> int
#let parse-nary( num, base ) = {
  assert.any-type("integer", "string", "content", num)
  // unpack raw
  if is.content(num) {
    assert.that(is.raw(num))
    num = num.text
  }
  // convert to string
  let num-str = upper(str(num))
  // parse to decimal
	let result = 0
	let exp = 0
	while num-str.len() > 0 {
		let char = num-str.last()
		let fact = nary-digits.position(x => x == char)
		if fact >= base {
			return 0
		}
		num-str = num-str.slice(0, -1)
		result += fact * calc.pow(base, exp)
		exp += 1
	}
	return result
}

// int -> string
#let nary( num, base, pad: none, from: 10 ) = {
	if from != 10 {
    // convert from base to decimal
		num = parse-nary(num, from)
	} else {
    // check type
    assert.any-type("integer", num)
    assert.that(num >= 0, message:"can only convert numbers >= 0")
  }
  // convert to new base
	let result = ""
	if num == 0 {
		result = "0"
	} else {
		while num > 0 {
			let r = calc.rem(num, base)
			num = calc.floor(num / base)
			result = nary-digits.at(r) + result
		}
	}
	if pad not in (none, 0) and result.len() < pad {
		result = "0"*(pad - result.len()) + result
	}
	[(#text(1.2em, raw(result)))#sub[#base]]
}

// ================================
// =        UML Diagramme         =
// ================================
#import "if/uml.typ"

// ================================
// =       Dokumentationen        =
// ================================
#import "./if/docs.typ"


// ================================
// =         Datenbanken          =
// ================================
// #import "./if/erd.typ": *

#let dbs( body ) = rahmen[
	#set align(left)
	#body
]

#let pkey( name ) = underline(stroke:1.1pt,offset:0.25em)[#name]
#let fkey( name ) = [#sym.arrow.t.filled#name]
#let fpkey( name ) = pkey(fkey(name))

// =================================
//  Automaten
// =================================
#import "if/automaten.typ"


// =================================
//  Datenbanken
// =================================
#import "if/db.typ"


// =================================
//  Bäume
// =================================

#let tree-node(node, empty:none, size:.5, stroke:1pt+black, padding:.1,..) = {
  if node.content == empty {
    cetz.draw.content((), "")
  } else {
    cetz.draw.circle((), radius:size, stroke:stroke)
    cetz.draw.content(
      (),
      [#node.content],
      padding: padding
    )
  }
}

#let tree-edge(from, to, source, target, empty:none, size:.5, ..) = {
  if target.content == empty {
    ()
  } else {
    let (a, b) = (from + ".center", to + ".center")
    cetz.draw.line((a: a, b: b, abs: true, number: size), (a: b, b: a, abs: true, number: size))
  }
}

#let tree( ..nodes ) = cetz.canvas({
  cetz.tree.tree(
    nodes.pos(),
    spread: 2,
    grow: 1.25,
    draw-node: tree-node,
    draw-edge: tree-edge,
    ..nodes.named()
  )
})
