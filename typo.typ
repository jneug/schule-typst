/********************************\
*    Typographic enhancements    *
\********************************/

#import "./options.typ"
#import "./theme.typ"

// Text sizes
#let scaled(content, size: 0.8) = {
	text(size:size*1em)[#content]
}
#let small(content) = scaled(content, size:0.88)
#let large(content) = scaled(content, size:1.2)

// New text decorations
#let uunderline( body ) = underline(offset: 0.25em)[#underline[#body]]

#let squiggly( body, stroke:1pt + black ) = {
	style(styles => {
		let m = measure(body, styles)
		let step = 2pt
		let i = 1

		box(width:m.width, baseline:-1*m.height)[
			#move(
				dy:m.height + 2pt,
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

// Textlücke
#let luecke(width: 4cm, symbol: none, dy: 2pt) = {
	if symbol != none {
		box(width: width, move(dy:dy, repeat[#symbol]))
	} else {
		box(width: width, move(dy:dy, line(length:width)))
	}
}

// Randnotizen
#let marginnote(pos: left, margin: .5em, dy: 0pt, body) = {
	style(styles => {
		let _m = measure(body, styles)
		if pos == left {
			place(pos, dx: -1*margin - _m.width, dy:dy, body)
		} else {
			place(pos, dx: margin + _m.width, dy:dy, body)
		}
	})
}

// Quellcode
#let __tabs(line, spaces:4, gobble:0) = {
	if gobble in (none, false) { gobble = 0 }

	if spaces != none and spaces > 0 {
		let m = line.match(regex("^\t+"))
		if m != none {
			line = line.replace(regex("^\t+"), " " * (m.end - gobble) * spaces)
		}
	}
	return line
}

#let __count_tabs(line, default:0) = {
	if line.len() == 0 {
		return default
	}

	let m = line.match(regex("^\t+"))
	if m != none {
		return m.end
	} else {
		return 0
	}
}

#let code(
	fill: theme.code.bg,
	border: none,

	tab-indent: 4,
	gobble: auto,

	linenos: true,
	gutter: 10pt,

	body
) = {
	let lines = 0
	let lang = none
	let code_lines = ()

	for item in body.children {
		if item.func() == raw {
			code_lines = item.text.split("\n")
			lines = code_lines.len()
			lang = item.lang


			if gobble == auto {
				gobble = code_lines.fold(100, (v, line) => {
					return calc.min(v, __count_tabs(line, default:v))
				})
			}

			for i in range(lines) {
				code_lines.at(i) = __tabs(code_lines.at(i), spaces:tab-indent, gobble:gobble)
			}
		}
	}

	style(s => {
		let lines_content = raw(range(lines).map(str).join("\n"))
		let m = measure(lines_content, s)

		block(
			fill:fill,
			stroke: border,
			inset: (x: 5pt, y: 10pt),
			radius: 4pt,
			breakable: true,
			width: 100%,
		)[
			// #place(top+left, dx:-5pt, block(width:m.width, breakable: true, align(right, text(fill:theme.muted, raw(range(lines).map(str).join("\n"))))))
			// #block(width:100%, inset:(left:m.width+5pt), breakable: true, raw(lang:lang, block:true, code_lines.join("\n")))
			#grid(
				columns: (m.width, 100% - m.width - gutter),
				column-gutter: gutter,
				align(right, text(fill:theme.muted,
					raw(range(lines).map(str).join("\n"))
				)),
				raw(lang:lang, block:true,
					code_lines.join("\n")
				)
			)
		]
	})
}

// Code mit highlight, aber inline
#let codeinline(body, lang: "java") = {
	if type(body) == "content" {
		raw(body.at("text"), block: false, lang: lang)
	} else {
		raw(body, block: false, lang: lang)
	}
}
#let codei(body, lang: "java") = codeinline(body, lang: lang)

// Operatoren
#let operator(body) = smallcaps(body)



// Kästen und Rahmen
#let container(
	width:  100%,
	stroke: 2pt + black,
	fill:   white,
	inset:  8pt,
	shadow: 0pt,
	radius: 0pt,
	..args,
	body
) = {
	let _inner = rect(width:width, stroke:stroke, fill:fill, inset:inset, radius:radius, ..args.named(), body)

	if shadow == true or shadow > 0pt {
		if type(shadow) == "boolean" {
			shadow = 4pt
		}
		move(dx:shadow, dy:shadow, rect(
			width:  width,
			radius: radius,
			fill:   gray,
			outset: 0pt,
			inset:  0pt,
			move(dx:-1 * shadow, dy:-1 * shadow, _inner)
		))
	} else {
		_inner
	}
}

#let rahmen = container.with(stroke:2pt + theme.secondary)
#let kasten = container.with(fill:theme.bg.muted, stroke:2pt + theme.secondary)
#let schattenbox = container.with(shadow:true)
#let infobox = container.with(radius:4pt, fill:theme.bg.primary, stroke:2pt + theme.primary, shadow:true)
#let warnungbox = container.with(radius:4pt, fill:cmyk(0%,6%,18%,2%), stroke:2pt + cmyk(0%,30%,100%,0%), shadow:true)


// Hinweiskästen
#let hinweis(typ: "Hinweis", icon: emoji.info, body) = {
	marginnote[#text(fill:theme.secondary)[#icon]]
	text(fill:theme.secondary)[*#typ:* ]
	body
}
#let info(body) = hinweis(typ:"Info", body)
#let tipp(body) = hinweis(typ:"Tipp", icon:emoji.lightbulb, body)


// Aufzählungen
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

// Vertikale Aufzählung
#let __c_tasks = counter("task")

#let task(format: "1)", init: false, body) = {
	if init {
		__c_tasks.update(1)
	}
	locate(loc => {
		enum(numbering: format, start: __c_tasks.at(loc).at(0), body)
		__c_tasks.step()
	})
}

#let tasks(cols: 3, gutter: (.5em, 1.5em), ..body) = {
	__c_tasks.update(1)
	grid(
		columns: for i in range(cols) { (1fr,) },
		rows: auto,
		column-gutter: gutter.at(0),
		row-gutter: gutter.at(1),
		..body.pos()
	)
}

// SI Einheiten
#let si(value, units) = {
	if type(units) == "array" [
		#value#h(0.2em)#{units.join()}
	] else [
		#value#h(0.2em)#units
	]
}
