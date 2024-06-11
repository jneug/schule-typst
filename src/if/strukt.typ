#import "@preview/cetz:0.2.2"

#let typst-measure = measure
#import cetz.util: measure, resolve-number
#import cetz.draw: *

#let STRUKT-TYPES = (
  EMPTY: 0,
  INSTRUCTION: 1,
  FORK: 2,
  LOOP: 3
)



#let leer( height: auto ) = (
  (
    type: STRUKT-TYPES.EMPTY,
    text: sym.emptyset,
    height: height
  ),
)

#let anweisung( text, height: auto ) = (
  (
    type: STRUKT-TYPES.INSTRUCTION,
    text: text,
    height: height
  ),
)

#let schleife( text, elements, height: auto ) = (
  (
    type: STRUKT-TYPES.LOOP,
    text: text,
    elements: elements,
    height: height
  ),
)

#let verzweigung( text, left, right, height: auto, center:.5 ) = (
  (
    type: STRUKT-TYPES.FORK,
    text: text,
    left: left,
    right: right,
    height: height,
    center: center
  ),
)


#let draw-elements( ctx, pos, width, inset:.5em, stroke:1pt+black, elements ) = {
  let (x, y) = pos
  let inset = inset
  let inset-num = resolve-number(ctx, 2*inset)

  if elements == () or elements == none {
    elements = leer()
  }

  for element in elements {
    let height = if element.height == auto {
      measure(ctx, block(width:width * ctx.length, element.text)).at(1) + inset-num
    } else {
      element.height
    }

    if element.type == STRUKT-TYPES.EMPTY {
      content(
        (x, y),
        (x + width, y - height),
        box(
          align(center+horizon, element.text),
          fill: rgb("#fffff3"), // white,
          stroke: stroke,
          width: 100%,
          height: 100%,
          inset: inset
        )
      )
    } else if element.type == STRUKT-TYPES.INSTRUCTION {
      content(
        (x, y),
        (x + width, y - height),
        box(
          align(left+horizon, element.text),
          fill: rgb("#fceece"), // luma(95%),
          stroke: stroke,
          width: 100%,
          height: 100%,
          inset: inset
        )
      )
    } else if element.type == STRUKT-TYPES.LOOP {
      let elems = draw-elements(ctx, (x + inset-num, y - height), width - inset-num, element.elements)
      let min-y = elems.fold(
        y - height,
        (x, f) => calc.min(x, f(ctx).drawables.fold(
          x,
          (y, d) => calc.min(y, -d.pos.at(1) - d.height/2))
        )
      )
      let elems-height = (y - height) - min-y

      content(
        (x, y),
        (x + width, y - height - elems-height),
        box(
          align(left+top, element.text),
          fill: rgb("#dcefe7"), //luma(85%),
          stroke: stroke,
          width: 100%,
          height: 100%,
          inset: inset
        )
      )
      elems

      y -= elems-height
    } else if element.type == STRUKT-TYPES.FORK {
      if element.height == auto {
        height *= 2
      }

      let elems-left = draw-elements(ctx, (x, y - height), width*element.center, element.left)
      let elems-right = draw-elements(ctx, (x + width*element.center, y - height), width*(1 - element.center), element.right)

      let min-y-left = elems-left.fold(
        y - height,
        (x, f) => calc.min(x, f(ctx).drawables.fold(
          x,
          (y, d) => calc.min(y, -d.pos.at(1) - d.height/2))
        )
      )
      let min-y-right = elems-right.fold(
        y - height,
        (x, f) => calc.min(x, f(ctx).drawables.fold(
          x,
          (y, d) => calc.min(y, -d.pos.at(1) - d.height/2))
        )
      )
      let elems-height = (y - height) - calc.min(min-y-left, min-y-right)

      content(
        (x, y),
        (x + width, y - height - elems-height),
        box(
          align(center+top, element.text),
          fill: rgb("#fadad0"), //luma(85%),
          stroke: stroke,
          width: 100%,
          height: 100%,
          inset: inset
        )
      )
      line((x, y), (x + width*element.center, y - height), (x + width, y), stroke:stroke)
      content(
        (x + inset-num*.5, y - height + inset-num*.5),
        text(.66em, "Wahr"),
        anchor: "south-west"
      )
      content(
        (x + width - inset-num*.5, y - height + inset-num*.5),
        text(.66em, "Falsch"),
        anchor: "south-east"
      )

      elems-left
      elems-right

      y -= elems-height
    }

    y -= height
  }
}

#let parse-strukt( content ) = {
  if content == none {
    return ()
  }

  let code = content.split("\n")

  let elements = ()

  let i = 0
  while i < code.len() {
    let line = code.at(i).trim()

    if line.starts-with("if ") {
      let (left, right) = ((),())
      let left-branch = true

      i += 1
      while code.at(i).trim() != "endif" {
        if code.at(i).trim() == "else" {
          left-branch = false
        } else if left-branch {
          left += (code.at(i),)
        } else {
          right += (code.at(i),)
        }

        i += 1
      }

      elements += verzweigung(
        line.slice(3),
        parse-strukt(left.join("\n")),
        parse-strukt(right.join("\n")),
        center: if left == () { .25 } else if right == () { .75 } else { .5 }
      )
    } else if line.starts-with("while ") {
      let elems = ()

      i += 1
      while code.at(i).trim() != "endwhile" {
        elems += (code.at(i),)
        i += 1
      }

      elements += schleife(
        line.slice(6),
        parse-strukt(elems.join("\n"))
      )
    } else {
      elements += anweisung(line)
    }

    i += 1
  }

  return elements
}

#let ogramm( elements, width: 12, ..args ) = {
  if type(elements) != array {
    elements = parse-strukt(elements.text)
  }

  set text(font:("Verdana", "Geneva"))
  cetz.canvas(..args, {
    get-ctx(ctx => {
      draw-elements(ctx, (0,0), width, elements)
    })
  })
}
