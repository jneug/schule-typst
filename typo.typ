/********************************\
*    Typographic enhancements    *
\********************************/
// #import "@local/showybox:0.2.0": showybox
#import "@local/typopts:0.0.4": options
#import "@local/codelst:0.0.3"
#import "@local/showybox:0.2.1": showybox
#import "@local/t4t:0.1.0": get

#import "./theme.typ"

// ============================
// Text scaling
// ============================
#let scaled(content, size: 0.8) = text(size*1em, content)
#let small(content) = scaled(content, size:0.88)
#let large(content) = scaled(content, size:1.2)

// ============================
// New text decorations
// ============================
// Double underline
#let uunderline(
	stroke: auto,
	offset: auto,
	extent: 0pt,
	evade: true,
	body
) = underline(
	offset: if offset == auto { .25em } else { offset * 1.25 },
	extent: extent,
	stroke: stroke,
	evade: evade,
	underline(
		offset: offset,
		extent: extent,
		stroke: stroke,
		evade: evade,
		body
	)
)

// Squiggly / Zickzack underline
#let squiggly(
	stroke:1pt + black,
	body
) = {
	style(styles => {
		let m = measure(body, styles)
		let step = 2pt
		let i = 1

		box(width:m.width, clip:true, baseline:-1*m.height)[
			#move(
				dy:m.height + 0.25em,
				while i*step < m.width {
					place(top + left,
						line(
							stroke:stroke,

							start:((i - 1)*step, -.5*step),
							end:(i*step, .5*step)
						)
					)
					place(top + left,
							line(
								stroke:stroke,
								start:(i*step, .5*step),
								end:((i + 1)*step, -.5*step)
							)
					)
					i += 2
				}
			)
			#place(top+left, body)
		]
	})
}

// ============================
// Text highlights
// ============================

#let operator( body ) = smallcaps(body)

#let name( name, last:none ) = {
	if last == none {
		let parts = get.text(name).split()
		last = parts.pop()
		name = parts.join(" ")
	}
	[#name #smallcaps(last)]
}

// German number format for integers / floats
#let num( value ) = {
	get.text(value).replace(".", ",")
}

// SI units
#let si(value, unit) = [#num(value)#h(0.2em)#unit]

// ============================
// Misc
// ============================
// Textlücke
#let luecke(width: 4cm, stroke: 1pt + black, offset: 2pt) = {
	box(width: width, move(dy:offset, line(stroke: stroke, length: 100%)))
}

// Randnotizen
#let marginnote(position: left, gutter: .5em, offset: 0pt, body) = {
	style(styles => {
		let _m = measure(body, styles)
		if position == right {
			place(position, dx: gutter + _m.width, dy:offset, body)
		} else {
			place(position, dx: -1*gutter - _m.width, dy:offset, body)
		}
	})
}


// ============================
// Code
// ============================

// Quelltexte
#let sourcecode(numbers-style: codelst.numbers-style, ..args, body) = codelst.code-frame(codelst.sourcecode(numbers-style: numbers-style, ..args, body))

#let lineref = codelst.lineref

// Code mit highlight, aber inline
#let code(body, lang: "java") = {
	if type(body) == "content" {
		raw(body.at("text"), block: false, lang: lang)
	} else {
		raw(mty.codei(body, lang: lang))
	}
}

// ============================
// Frames and Boxes
// ============================
#let container(
	width:  100%,
	stroke: 2pt + black,
	fill:   white,
	inset:  8pt,
	shadow: 0pt,
	radius: 0pt,
	..args,
	body
) = showybox(
	frame: (
		border-color: get.stroke-paint(stroke),
		upper-color: get.stroke-paint(stroke),
		lower-color: fill,
		radius: radius,
		width: get.stroke-thickness(stroke),
	),
	shadow: (
		offset: shadow,
		color: get.stroke-paint(stroke).darken(40%)
	),
	..args,
	body
)

#let rahmen = container.with(stroke:2pt + theme.secondary)
#let kasten = container.with(fill:theme.bg.muted, stroke:2pt + theme.secondary)
#let schattenbox = container.with(shadow:3pt)
#let infobox = container.with(radius:4pt, fill:theme.bg.primary, stroke:2pt + theme.primary, shadow:3pt)
#let warnungbox = container.with(radius:4pt, fill:cmyk(0%,6%,18%,2%), stroke:2pt + cmyk(0%,30%,100%,0%), shadow:3pt)

// ============================
// Hints
// ============================
#let hinweis(typ: "Hinweis", icon: emoji.info, body) = {
	marginnote[#text(fill:theme.secondary)[#icon]]
	text(fill:theme.secondary)[*#typ:* ]
	body
}
#let info(body) = hinweis(typ:"Info", body)
#let tipp(body) = hinweis(typ:"Tipp", icon:emoji.lightbulb, body)

// ============================
// Lists and enums
// ============================
#let enuma( body ) = {
	set enum(numbering: "a)")
	body
}

#let enumn( body ) = {
	set enum(numbering: "1)", tight:false, spacing:1.5em)
	body
}
#let enumnn( body ) = {
	set enum(numbering: "(1)")
	body
}

// Vertical task lists
#let __c-task = counter("@schule-tasks")
#let tasks(
	cols: 3,
	gutter: 4%,
	numbering: "1)",
	body
) = {
	__c-task.update(0)
	grid(
		columns:(1fr,)*cols,
		gutter: gutter,
		..body.children
			.filter((c) => c.func() in (enum.item, list.item))
			.map((it) => {
				__c-task.step()
				__c-task.display(numbering)
				h(.5em)
				it.body
			}
		)
	)
}
