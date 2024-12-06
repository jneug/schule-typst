#import "@preview/cetz:0.3.1"
#import "@preview/fletcher:0.5.0"

#let klasse(pos, name, attributes, methods) = {
  (
    (
      type: "class",
      id: repr(name),
      name: name,
      pos: pos,
      attributes: attributes,
      methods: methods,
    ),
  )
}

#let klassendiagramm(
  width: auto,
  height: auto,
  padding: 5pt,
  inset: 6mm,
  fill: white,
  stroke: 1.2pt + black,
  unit: 1cm,
  ..fletcher-args,
  elements,
) = {
  let nodes = (:)
  for elem in elements {
    nodes.insert(elem.id, elem)
  }

  let resolve(pos) = {
    while type(pos) == str {
      pos = nodes.at(pos).pos
    }
    return pos
  }

  let f-elements = ()
  for (id, node) in nodes {
    if node.type == "class" {
      node.pos = resolve(node.pos)

      f-elements.push(
        fletcher.node(
          node.pos,
          inset: 0pt,
          stroke: none,
          table(
            columns: 1,
            stroke: 1pt + black,
            inset: .33em,
            align: left,
            align(center, strong(node.name)),
            node.attributes.map(raw.with(lang: "java")).join(linebreak()),
            node.methods.map(raw.with(lang: "java")).join(linebreak()),
          ),
        ),
      )
    }
  }

  fletcher.diagram(
    node-stroke: stroke,
    edge-stroke: stroke,
    node-inset: inset,
    spacing: (unit, unit),
    crossing-fill: none,
    ..fletcher-args.named(),
    ..f-elements,
  )
}
