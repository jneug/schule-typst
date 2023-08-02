#import "./../canvas/canvas.typ": canvas
#import "./../canvas/draw.typ": *

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
	width:   auto, //100%,
	height:  auto,
	padding: 5pt,
	..elements
) = canvas({
	for elem in elements.pos() {
		if elem.at("type") == "entity" {
			rect((), ())
		}
	}
})
