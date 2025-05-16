
#import "../util/args.typ"
#import "../theme.typ"
#import "../_deps.typ" as deps

// Landau-Symbole

#let O(n) = $cal(O)(#n)$
#let o(n) = $cal(o)(#n)$

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
#let _nary-digits = "0123456789ABCDEF"

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

#let nary-display(num, sep: none, block-size: auto) = {
  let block-size = block-size
  if block-size == auto {
    if num.base == 10 {
      block-size = 3
    } else {
      block-size = 4
    }
  }

  let str-num = str(num.number)
  let blocks = ()
  for i in range(str-num.len(), step: block-size) {
    blocks.push(str-num.slice(i, calc.min(str-num.len(), i + block-size)))
  }
  [(#text(1.2em, raw(blocks.join(sep))))#sub[#num.base]]
}

#let nary(num, base, ..arg) = {
  if type(num) == int {
    let encode-args = args.extract-args(arg, "from", "pad")
    let arg = arg.named()
    _ = arg.remove("from", default: none)
    _ = arg.remove("pad", default: none)

    nary-display(
      nary-encode(num, base, ..encode-args),
      ..arg,
    )
  } else {
    nary-display(
      nary-decode(str(num), base),
      ..arg,
    )
  }
}

#let nary-term(num) = {
  let parts = ()
  let len = num.number.len()
  for i in range(len) {
    parts.push(num.number.at(len - 1 - i) + " dot " + str(num.base) + "^" + str(i))
  }
  return eval(parts.rev().join(" + "), mode: "math")
}

#import "cs-uml.typ" as uml
#import "cs-db.typ" as db


// =================================
//  Bäume
// =================================
#import deps: cetz

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

#let tree-edge(
  from,
  to,
  tree,
  node,
  draw-empty: false,
  draw-edge: (from, to, ..) => cetz.draw.line(from, to),
  ..args,
) = {
  if draw-empty or node.content != none {
    draw-edge(from, to, tree, node, ..args)
  }
}

#let tree(nodes, draw-node: auto, draw-empty: auto, draw-edge: auto, draw-empty-edges: false, ..args) = cetz.canvas({
  let (pos, named) = (args.pos(), args.named())

  cetz.draw.set-style(stroke: .6pt, padding: .33em)

  if "styles" in named {
    cetz.draw.set-style(..named.styles)
    let _ = named.remove("styles")
  }

  let tree-node = tree-node
  if draw-node != auto {
    tree-node = tree-node.with(draw-node: draw-node)
  }
  if draw-empty != auto {
    tree-node = tree-node.with(draw-empty: draw-empty)
  }

  cetz.tree.tree(
    nodes,
    spread: 1.6,
    grow: 1.25,
    draw-node: tree-node,
    draw-edge: if draw-edge == auto {
      tree-edge.with(draw-empty: draw-empty-edges)
    } else {
      tree-edge.with(draw-edge: draw-edge, draw-empty: draw-empty-edges)
    },
    // ..pos,
    ..named,
  )
})


// =================================
//  Automaten
// =================================
//
/// Übersetzt eine Grammatik aus der FLACI.com Syntax
/// in eine im Unterricht übliche Darstellung.
#let grammar(body) = {
  let trim(s) = s.trim()
  let math-eval(m) = if m.starts-with("$") and m.ends-with("$") {
    return eval(mode: "math", m.slice(1, -1))
  } else {
    return m
  }

  let lines = body.text.split("\n")

  grid(
    columns: 4,
    row-gutter: 1em, column-gutter: .64em,
    ..for (p, l) in lines.enumerate() {
      l = l.split("->").map(trim)
      (
        emph[p#sub([#p]):],
        text(weight: 400, l.at(0)),
        sym.arrow.r,
        l.at(1).split("|").map(trim).map(math-eval).join($#h(.2em)|#h(.2em)$),
      )
    }
  )
}
