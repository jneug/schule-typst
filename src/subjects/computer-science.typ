
#import "../util/args.typ"
#import "../theme.typ"

/// Erstellt eine Tabelle zur Visualisierung eines Arrays mit Indizes und Inhalten.
#let arr(data, len: auto, empty: none, start: 0, cell-width: 8mm) = {
  len = args.if-auto(len, () => data.len())
  let d = data + (empty,) * calc.max(0, (len - data.len()))

  table(
    columns: (auto,) + (cell-width,) * len,
    fill: (c, r) => if c == 0 {
      theme.table.header
    } else if r == 1 {
      theme.bg.muted
    },
    align: center,
    [*Inhalt*],
    ..d.map(i => if type(i) == int {
      str(i)
    } else {
      i
    }),
    [*Index*],
    ..range(start, start + len).map(str).map(raw),
  )
}

#import "cs-docs.typ" as docs

// Ziffern bis Hexadezimal
#let _nary-digits = "01234567890ABCDEF"

// string -> int
#let nary-decode(num, base) = {
  if type(num) == int {
    num = str(num)
  } else if type(num) == content and num.func() == raw {
    num = num.text
  } else if type(num) != str {
    panic("Pass string, raw or integer as number.")
  }

  num = upper(num)

  // parse to decimal
  let result = 0
  let exp = 0
  while num.len() > 0 {
    let char = num.last()
    let fact = _nary-digits.position(char)
    if fact >= base {
      return 0
    }
    num = num.slice(0, -1)
    result += fact * calc.pow(base, exp)
    exp += 1
  }
  return (number: result, base: base, display: () => [(#text(1.2em, raw(result)))#sub[10]])
}

// int -> string
#let nary-encode(num, base, pad: none, from: 10) = {
  if from != 10 {
    // convert from base to decimal
    num = parse-nary(num, from)
  } else {
    // check type
    assert.eq(type(num), int, message: "can only convert numbers")
    assert(num >= 0, message: "can only convert numbers >= 0")
  }

  // convert to new base
  let result = ""
  if num == 0 {
    result = "0"
  } else {
    while num > 0 {
      let r = calc.rem(num, base)
      num = calc.floor(num / base)
      result = _nary-digits.at(r) + result
    }
  }
  if pad not in (none, 0) and result.len() < pad {
    result = "0" * (pad - result.len()) + result
  }
  return (number: result, base: base, display: () => [(#text(1.2em, raw(result)))#sub[#base]])
}

#let nary-display(num) = {
  [(#text(1.2em, raw(num.number)))#sub[#num.base]]
}

// #import "cs-uml.typ" as uml
#import "cs-db.typ" as db

// =================================
//  Bäume
// =================================
#import "@preview/cetz:0.2.2"

#let tree-node(
  node,
  draw-node: (node, ..args) => cetz.draw.content((), node.content, frame: "circle"),
  draw-empty: (node, ..) => cetz.draw.content((), h(1em)),
  ..args,
) = {
  if node.content != none {
    draw-node(node, ..args)
  } else {
    draw-empty(node, ..args)
  }
}

#let tree-edge(from, to, tree, node, draw-edge: (from, to, ..) => cetz.draw.line(from, to), ..args) = {
  if node.content != none {
    draw-edge(from, to, tree, node, ..args)
  }
}

#let tree(nodes, draw-node: auto, draw-edge: auto, ..args) = cetz.canvas({
  let (pos, named) = (args.pos(), args.named())

  cetz.draw.set-style(stroke: .6pt, padding: .33em)

  if "styles" in named {
    cetz.draw.set-style(..named.styles)
    let _ = named.remove("styles")
  }
  cetz.tree.tree(
    nodes,
    spread: 1.6,
    grow: 1.25,
    draw-node: if draw-node == auto {
      tree-node
    } else {
      tree-node.with(draw-node: draw-node)
    },
    draw-edge: if draw-edge == auto {
      tree-edge
    } else {
      tree-edge.with(draw-edge: draw-edge)
    },
    // ..pos,
    ..named
  )
})
