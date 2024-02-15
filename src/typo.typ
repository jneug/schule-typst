/********************************\
*    Typographic enhancements    *
\********************************/

#import "@preview/codelst:2.0.0"
#import "@preview/showybox:2.0.1": showybox
#import "@preview/t4t:0.3.2": get
#import "@preview/unify:0.4.0"

#import "@local/typopts:0.0.4": options

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

#let highlight( body, color:yellow ) = box(fill:color, inset:(x:0.1em), outset:(y:0.1em), radius:0.1em, body)

// German number format for integers / floats
#let num( value ) = {
	get.text(value).replace(".", ",")
}

// SI units
#let si(value, unit) = [#num(value)#h(0.2em)#unit]

// Keys
#let key(label) = box(stroke:.5pt + gray, inset:(x:2pt), outset:(y:2pt), radius:2pt, fill:theme.bg.muted, text(.88em, label))

// Folders and files
#let datei(name) = [#emoji.page#raw(block:false, get.text(name))]
#let ordner(name) = [#emoji.folder#raw(block:false, get.text(name))]
#let programm(name) = text(theme.primary, weight: 400, name)


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
// #let sourcecode(numbers-style: codelst.numbers-style, ..args, body) = codelst.code-frame(codelst.sourcecode(numbers-style: numbers-style, ..args, body))
#let sourcecode = codelst.sourcecode

#let lineref = codelst.lineref.with(supplement:"Zeile")
#let lineref- = codelst.lineref.with(supplement:"")

// Code mit highlight, aber inline
#let code(body, lang: "java") = {
  raw(get.text(body), block: false, lang: lang)
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
		title-color: get.stroke-paint(stroke),
		footer-color: fill,
    body-color: fill,
		radius: radius,
		thickness: get.stroke-thickness(stroke),
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
