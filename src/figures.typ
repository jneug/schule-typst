#import "./theme.typ"
#import "@preview/tablex:0.0.4": tablex, colspanx, rowspanx, cellx

// #import "@preview/wrap-it"

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


// =================================
//  Pretty refs
// =================================
#let pfigure(
	target,
	content,
	..args
) = [#figure(
	content,
	..args
)#target)]

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

#let prettyref( refs:("aufg": "Aufgabe"), keep-prefix:false, body ) = {
  show ref: r => {
    let p = str(r.target).position(":")
    if p != none {
      let prefix = str(r.target).slice(0, p)
      if prefix in refs {
        let target
        if keep-prefix {
          target = label(str(r.target))
        } else {
          target = label(str(r.target).slice(p + 1))
        }
        return ref(target, supplement: refs.at(prefix))
      }
    }
    return r
  }
  body
}


// ================================
// =           Tabellen           =
// ================================

// default fill formatter for tables
#let tablefill(
  fill: white,
  headerfill: theme.table.header,
  footerfill: theme.table.header,
  oddfill: theme.bg.muted,
  headers: 1,
  footers: 0,
  colheaders: 0,
  colfooters: 0,
  columns: auto,
  rows: auto,
  fills: (rows: (:), cols: (:))
) = (column, row) => {
	if row < headers or column < colheaders {
    return headerfill
  } else if rows != auto and (row >= rows - footers) {
    return footerfill
  } else if columns != auto and (column >= columns - colfooters) {
    return footerfill
  } else if str(row) in fills.rows {
    return fills.rows.at(str(row))
  } else if str(column) in fills.cols {
    return fills.cols.at(str(column))
  } else if calc.odd(row) {
    return oddfill
  } else {
    return fill
  }
}


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
	let _fill(c, r) = if r == -1 {theme.table.header}
	if fill != none {
		_fill = (c, r) => fill(c, r+1)
	}
	block(inset:insets)[
		#table(
			inset: inset,
			fill: _fill,
			..args
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
