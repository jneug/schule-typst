#let erd_stroke = 1.2pt + black
#let erd_inset = 2mm
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
#let entity( x, y, id, content ) = {
  (
    type:"entity",
    x:x, y:y, id:id,
	content:content,
	shape:rect[#content]
  )
}
#let attribute(x, y, id, content) = {
  (
    type:"attribute",
    x:x, y:y, id:id,
	content:content,
	shape:ellipse[#content]
  )
}
#let relation(x, y, id, content) = {
  (
    type:"relation",
    x:x, y:y, id:id,
	content:content,
	shape: rotate(45deg, origin: center+horizon,
		square[#move(dy:50% - .5em,
			rotate(-45deg, content)
			)
		]
	)
  )
}
#let connect(from, to, c1:none, c2:none) = {(
	type:"connection",
	from:from, to:to,
	c1:c1, c2:c2

)}
#let erd(
	width: auto, //100%,
	height:auto,
	padding:5pt,
	..elements
) = {
  locate(loc => {
    set rect(stroke: erd_stroke, fill: white, inset: erd_inset)
    set square(stroke: erd_stroke, fill: white, inset: erd_inset)
    set ellipse(stroke: erd_stroke, fill: white, inset: erd_inset)

	let b = bounds(elements.pos())
	let nodes = state("@erd-nodes", (:))

	for elem in elements.pos() {
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
									from.x + 0.5*from.width,
									from.y + 0.5*from.height
								),
								end: (
									to.x + 0.5*to.width,
									to.y + 0.5*to.height
								)
							)
						)
					}
				}
			}
			#for _elem in _nodes.pairs() {
				let id = _elem.at(0)
				let elem = _elem.at(1)

				if elem.type != "connection" {
					place(
						top + left,
						dx:elem.x, dy:elem.y,
						elem.shape
					)
				}
			}
		]
	})
  })
}
