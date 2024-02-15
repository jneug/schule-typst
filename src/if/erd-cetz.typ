#import "@preview/cetz:0.2.0"
#import "@preview/fletcher:0.4.1"

#let connect(from, to, c:none) = {((
	type:"edge",
	from:from, to:to,
  id: repr(from) + "-" + repr(to),
	c:c,
  func: fletcher.edge
),)}

#let entity( pos, id, content ) = {((
  type:"entity",
  pos:pos, id:id,
	content:content,
  func: fletcher.node
),)}

#let attribute(pos, id, content, to:none) = {
  let r = ((
    type:"attribute",
    pos:pos, id:id,
    content:content,
    func: fletcher.node.with(shape:fletcher.shapes.pill)
  ),)
  if to != none {
    r.push(connect(id, to).first())
  }
  return r
}

#let relation( pos, id, e1: none, c1: none, e2: none, c2: none, content ) = {
  let r = ((
    type:"relation",
    pos:pos, id:id,
    content:content,
    from: e1, to: e1,
    c1: c1, c2: c2,
    func: fletcher.node.with(shape: fletcher.shapes.diamond)
  ),)
  if e1 != none and e2 != none {
    r.push(connect(e1, id, c:c1).first())
    r.push(connect(e2, id, c:c2).first())
  }
  return r
}

#let erd(
	width: auto, //100%,
	height: auto,
	padding: 5pt,
  inset: 6mm,
  fill: white,
  stroke: 1.2pt + black,
  unit: 1cm,
  ..fletcher-args,
	elements
) = {
  let nodes = (:)
  for elem in elements {
    nodes.insert(elem.id, elem)
  }

  let resolve( pos ) = {
    while type(pos) == str {
      pos = nodes.at(pos).pos
    }
    return pos
  }

  let f-elements = ()
  for (id, node) in nodes {
    if node.type == "edge" {
      node.from = resolve(node.from)
      node.to = resolve(node.to)

      f-elements.push((node.func)(node.from, node.to, label:node.c, label-pos: .33, label-side:left))
    } else {
      node.pos = resolve(node.pos)

      f-elements.push((node.func)(node.pos, node.content))
    }
  }

  fletcher.diagram(
    node-stroke: stroke,
    edge-stroke: stroke,
    node-inset: inset,
    spacing: (unit, unit),
    crossing-fill: none,
    ..fletcher-args.named(),
    ..f-elements
  )
}
