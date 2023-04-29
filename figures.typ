#import "./theme.typ"

// Utilities
#let __setstate( abbr, supplement ) = {
	state("@pref-" + abbr).update(supplement)
}
#let __getstate( abbr ) = {
	state("@pref-" + abbr)
}
#let __getrefabbr( target ) = {
	target.split("-").first()
}


// ================================
// =         Pretty refs          =
// ================================
#let pfigure(
	target,
	content,
	..args
) = [#figure(
	content,
	..args
) #label(str(target))]

#let newref( abbr, supplement ) = {
	let _ = __setstate(abbr, supplement)
	pfigure.with(kind: abbr, supplement: supplement)
}

#let pref( target ) = {
	if type(target) == "string" {
		target = label(target)
	}

	locate(loc => {
		let abbr = __getrefabbr(str(target))
		let _state = __getstate(abbr)

		_state.display(supl => {
			if supl != none {
				ref(target, supplement:supl)
			} else {
				ref(target)
			}
		})
	})
}


// ================================
// =           Tabellen           =
// ================================
#let tabular(
	inset: 5pt,
	fill: none,
	line-height: 1.5em,
	header: none,
	footer: none,
	..args
) = {
	let insets = (top: 0pt, bottom: 0pt)
	if header != none { insets.top = line-height + inset }
	if footer != none { insets.bottom = line-height + inset }
	let _fill(c, r) = if r == -1 {theme.tables.header}
	if fill != none {
		_fill = (c, r) => fill(c, r+1)
	}
	block(inset:insets)[
		#table(
			inset: inset,
			fill: _fill,
			..args.named(),
			..args.pos(),
		)
		#if header != none {
			place(top+left, dy:-1*insets.top)[
				#block(
					width: 100%,
					height: insets.top,
					inset: inset,
					fill: _fill(0, -1),
					stroke: if "stroke" in args.named() { args.named().at("stroke") } else { 1pt + black })[
					#align(left + horizon)[#header]
				]
			]
		}
	]
}
