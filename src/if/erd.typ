#let erd_stroke = 1.2pt + black
#let erd_inset = 3mm
#let erd_unit = 1cm

#let bounds( elements ) = {
	let b = (
		width:0,
		height:0,
		x:0,
		y:0,
	)
	for elem in elements {
		if elem.type != "connection" {
			if elem.x < b.x { b.x = elem.x }
			if elem.y < b.y { b.y = elem.y }
		}
	}
	b
}

#let rombus( content ) = rotate(45deg, origin: center+horizon,
  square[#move(dy:50% - .5em,
      rotate(-45deg, content)
  )]
)


#let connect(from, to, c1:none, c2:none) = {((
	type:"connection",
	from:from, to:to,
	c1:c1, c2:c2
),)}

#let entity( x, y, id, content ) = {((
  type:"entity",
  x:x, y:y, id:id,
	content:content,
	shape:rect[#content]
),)}

#let attribute(x, y, id, content, to: none) = {
  let r = ((
    type:"attribute",
    x:x, y:y, id:id,
    content:content,
    shape: ellipse[#content]
  ),)
  if to != none {
    r.push(connect(id, to).first())
  }
  return r
}

#let relation(x, y, id, content, e1:none, e2:none, c1:none, c2:none) = {
  let r = ((
    type:"relation",
    x:x, y:y, id:id,
    content:content,
    from: e1, to: e1,
    c1: c1, c2: c2,
    shape: rombus(content)
  ),)
  if e1 != none and e2 != none {
    r.push(connect(e1, id, c1:c1).first())
    r.push(connect(id, e2, c2:c2).first())
  }
  return r
}
#let erd(
	width: auto, //100%,
	height:auto,
	padding:5pt,
  fill: white,
  stroke: erd_stroke,
	elements
) = {
  locate(loc => {
    set rect(stroke: stroke, fill: fill, inset: erd_inset)
    set square(stroke: stroke, fill: fill, inset: erd_inset)
    set ellipse(stroke: stroke, fill: fill, inset: erd_inset)

    let b = bounds(elements)
    let nodes = state("@erd-nodes")
    nodes.update((:))

    for elem in elements {
      if elem.type != "connection" {
        style(styles => {
          let m = measure(elem.shape, styles)
          nodes.update(n => {
            n.insert(elem.id, (
              type: elem.type,
              width: m.width,
              height: m.height,
              x: (elem.x - b.x)*erd_unit,
              y: (elem.y - b.y)*erd_unit,
              shape: elem.shape
            ))
            n
          })
        })
      } else {
        nodes.update(n => {
          n.insert(elem.from + "-" + elem.to, elem)
          n
        })
      }
    }

    locate(loc => {
      let _nodes = nodes.at(loc)

      let canvas_width = width
      if width == auto {
        canvas_width = _nodes.values().fold(0pt, (w, elem) => {
          if elem.type != "connection" and elem.x + elem.width > w {
            elem.x + elem.width
          } else {
            w
          }
        })
      }
      let canvas_height = height
      if height == auto {
        canvas_height = _nodes.values().fold(0pt, (h, elem) => {
          if elem.type != "connection" and elem.y + elem.height > h {
            elem.y + elem.height
          } else {
            h
          }
        })
      }
      let min_x = calc.min(.._nodes.values().map(e => {
        if e.type != "connection" {
          e.x - e.width/2
        } else {
          canvas_width
        }
      }))
      let min_y = calc.min(.._nodes.values().map(e => {
        if e.type != "connection" {
          e.y - e.height/2
        } else {
          canvas_height
        }
      }))

      block(width:canvas_width, height:canvas_height, outset:padding)[
        <erd>
        #for _elem in _nodes.pairs() {
          let id = _elem.at(0)
          let elem = _elem.at(1)

          if elem.type == "connection" {
            if elem.from in _nodes and elem.to in _nodes {
              let from = _nodes.at(elem.from)
              let to = _nodes.at(elem.to)
              place(
                top+left,
                line(
                  start: (
                    from.x - min_x,
                    from.y - min_y
                  ),
                  end: (
                    to.x - min_x,
                    to.y - min_y
                  )
                )
              )
              if elem.c1 != none {
                place(top+left,
                  dx: from.x - min_x + from.width/2 + .5em,
                  dy: from.y - min_y - from.height/2 - .2em,
                  raw(elem.c1, block:false)
                )
              }
              if elem.c2 != none {
                place(top+left,
                  dx: to.x - min_x - to.width/2 - elem.c2.len()*1em - .25em,
                  dy: to.y - min_y - to.height/2 - .2em,
                  raw(elem.c2, block:false)
                )
              }
            }
          }
        }
        #for _elem in _nodes.pairs() {
          let id = _elem.at(0)
          let elem = _elem.at(1)

          if elem.type != "connection" {
            place(
              top + left,
              dx:elem.x - min_x - elem.width/2, dy:elem.y - min_y - elem.height/2,
              elem.shape
            )
          }
        }
      ]
    })
  })
}
