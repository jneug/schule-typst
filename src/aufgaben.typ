/********************************\
*      Exercises and points      *
\********************************/

#import "lib/typopts/typopts.typ": options, states

#import "./theme.typ"
#import "./layout.typ": kopfzeile, fusszeile, d_seitenzahl, pagenumber-format
#import "./typo.typ": luecke, marginnote
#import "./util.typ": place-label


// =================================
//  Counter
// =================================
#let __c-aufgaben = counter("aufgaben")
#let __c-punkte   = counter("punkte")


// =================================
//  States
// =================================
#let __s-aufgaben = state("aufgaben", ())
#let __s-in_aufgabe = state("in-aufgabe", false)
#let __s-in_teilaufgabe = state("in-teilaufgabe", false)
#let __s-erwartungen = state("erwartungen", ())


// =================================
//  Hilfsfunktionen
// loesung=================================
#let __foreach(
	s,
	func,
	filter: elem => true,
	final: true,
	loc: none,
) = {
	assert.eq(type(s), "state")
	assert.eq(type(func), "function")

	let it = l => {
		let data = none
		if final {
			data = s.final(l)
		} else {
			data = s.at(l)
		}
		data = data.filter(filter)

		let i = 0
		for elem in data {
			func(i, elem, data.len())
			i += 1
		}
	}

	if loc == none {
		locate(it)
	} else {
		assert(type(loc) == "location")
		it(loc)
	}
}
#let __foreach_aufg = __foreach.with(__s-aufgaben)


#let __get_aufg( nr, func, loc: none ) = {
	let _func(l) = {
		// Hack to solve bug with direct array access
		for aufg in __s-aufgaben.final(l) {
			if aufg.nummer == nr {
				func(aufg)
				break
			}
		}
	}

	if loc == none {
		locate(_func)
	} else {
		assert(type(loc) == "location")
		_func(loc)
	}
}
#let __update_aufg( nr:none, updater ) = {
	__s-aufgaben.update(a => {
		if nr == none {
			a.at(a.len() - 1) = updater(a.last())
		} else {
			a.at(nr - 1) = updater(a.at(nr - 1))
		}
		a
	})
}

#let __akt_aufgnr( func, loc:none ) = {
	let _func(l) = {
		func(__c-aufgaben.at(l).at(0))
	}
	if loc == none {
		locate(_func)
	} else {
		_func(loc)
	}
}
#let __akt_aufg( func, loc: none ) = {
	let _func(l) = {
		func(__s-aufgaben.at(l).last())
		// let n = __c-aufgaben.at(l).at(0)
		// __get_aufg(n, func, loc:l)
	}
	if loc == none {
		locate(_func)
	} else {
		_func(loc)
	}
}
#let __akt_taufgnr( func, loc: none ) = {
	let _func(l) = {
		let cnt = __c-aufgaben.at(l)
		if cnt.len() == 1 {
			func(0)
		} else {
			func(cnt.at(1))
		}
	}
	if loc == none {
		locate(_func)
	} else {
		_func(loc)
	}
}

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %     Display Funktionen       %
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#let d_aufg(
	label:  "Aufgabe",
	format: "1",
	nr:     auto
) = [#label
	#if nr in (none, auto) {
		__c-aufgaben.display(
			(..c) => numbering(format, c.pos().first())
		)
	} else {
		numbering(format, nr)
	}
]
#let d_punkte(
	punkte,
	singular: "Punkt",
	plural: "Punkte"
) = {
	if punkte == 1 [#punkte #singular]
	else [#punkte #plural]
}

#let punkte( nr:none, func:d_punkte ) = {
	locate(loc => {
		let n = nr
		if nr == none {
			n = __akt_aufgnr(v=>v, loc:loc)
		}
		func(__s-erwartungen.final(loc)
			.filter(erw => erw.aufgabe == n)
			.fold(0, (p, erw) => p + erw.punkte))
	})
}

#let d_erwpunkte( aufg:none, teil:none, format:punkte => [#align(right)[_(#punkte.join(" + "))_]] ) = {
	locate(loc => {
		let n = aufg
		if aufg == none {
			n = __akt_aufgnr(v=>v, loc:loc)
		}
		let t = teil
		if( teil == none ) {
			t = __akt_taufgnr(v=>v, loc:loc)
		}
		let p = __s-erwartungen.final(loc)
			.filter(erw => {
				erw.aufgabe == n and (
					t == none or t == erw.teil
				)
			})
			.map(erw => str(erw.punkte))

		format(p)
	})
}

#let d_enum( ..args ) = {
	let items = args.pos().flatten()
	if items.len() > 1 {
		enum(..args.named(), ..items)
	} else if items.len() > 0 {
		items.first()
	}
}

#let __d_loesung( aufg ) = [
	#d_enum(
		numbering: "(1)",
		..aufg.loesung
			.filter(l=> l.teil == 0)
			.map(l => l.body)
	)
	#let enums = ()
	#for t in range(aufg.teile) {
		enums.push(d_enum(numbering:"(1)",
			..aufg.loesung
				.filter(l => l.teil == t + 1)
				.map(l => l.body)
			)
		)
	}
	#if enums.len() > 0 {
		enum(numbering:"a)", ..enums)
	}
]

#let d_loesung() = {
	__akt_aufg(aufg => block(
		inset:0.5em,
		fill: theme.bg.muted.lighten(50%),
		radius:4pt,
    width: 100%
	)[
		=== Lösungen #d_aufg()
		#__d_loesung(aufg)
	])
}

#let d_loesungen() = page(
	numbering: "I",
	header: kopfzeile(
		mitte: () => [Lösungen]
	),
	footer: fusszeile(
		rechts: () => {
			set text(fill:theme.text.default)
			d_seitenzahl(format:(cur, body, total) => {
				if cur > body {
					numbering("I", cur - body)
				} else [#pagenumber-format(cur, body, total)]
			})
		}
	)
)[= Lösungen <loesungen>
	#__foreach_aufg(
		final:true,
		filter: a=>a.loesung.len()>0,
		(i, aufg, count) => [
			== #d_aufg(nr:aufg.nummer) #h(1fr) #text(fill:theme.secondary, size:0.88em)[#punkte(nr:aufg.nummer)]
			#__d_loesung(aufg)
		]
	)
]

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
// %           Aufgaben           %
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#let aufgabe(
	titel: none,
	icons: none,
	use: true,
	header: true,
	page:  false,
  number: auto,
  label: none,
	body
) = {
	if use {
		__c-aufgaben.step()
		__akt_aufgnr(n => {
			__s-aufgaben.update(a => {
				a.push((
          id:          n,
					nummer:      if number == auto { n } else { number },
					titel:       titel,
					teile:       0,
					loesung:     (),
					erwartungen: ()
				))
				a
			})
		})
		let ic = ""
		if icons != none {
			ic = marginnote(dy:.2em)[#text(size:0.88em)[#{(icons,).flatten().join()}]]
		}
		if page { pagebreak() }
		if header [== #ic#d_aufg(nr:number)#if titel != none [#h(2em)#text(fill:theme.text.default)[#titel]]#h(1fr)#punkte(func:p=>if p > 0 {text(fill:theme.secondary,size:0.88em)[#d_punkte(p)]}) <aufgabe>]
		// if type(icons) != none {
		// 	icons = (icons,).flatten()
		// 	marginnote(dy:-1.5em)[#icons.join()]
		// }
    if label != none {
      // place-label(label, kind:"Aufgabe")
      place([#figure(kind:"aufgabe", supplement:"Aufgabe", [])#label])
    } else {
      place([#figure(kind:"aufgabe", supplement:"Aufgabe", [])])
    }
		body
		options.get("loesungen", value => {
			if value == "folgend" [
				#d_loesung()
			]
		})
	}
}

#let teilaufgabe(
	use: true,
	body
) = {
	if use {
		__c-aufgaben.step(level:2)
		__s-in_teilaufgabe.update(true)

		__akt_aufgnr(n => {
			__s-aufgaben.update(a => {
				if a.len() >= n {
					a.at(n - 1).teile += 1
				}
				a
			})
		})
		__akt_taufgnr(
			taufg => enum(
				numbering: "a)",
				start: taufg,
				tight: false,
				spacing: auto,
				body + [<teilaufgabe>]
			)
		)

		__s-in_teilaufgabe.update(false)
	}
}

#let loesung(
	aufg:none,
	teil:none,
	body,
) = {
	locate(loc => {
		//let nr = __c-aufgaben.at(loc).at(0)
		// if _ab_s_in_teilaufgabe.at(loc) {
		// 	let  t = _ab_c_aufgaben.at(loc).at(1)
		// }
		let t = teil
		if t == none {
			if __s-in_teilaufgabe.at(loc) {
				t = __c-aufgaben.at(loc).at(1)
			} else {
				t = 0
			}
		}
		__update_aufg(nr:aufg, a => {
			a.loesung.push((
				teil: t,
				body: body
			))
			a
		})
	})
	options.get("loesungen", value => {
		if value == "sofort" {
			block(
				width: 100%,
				inset:0.5em,
				fill:theme.bg.muted.lighten(50%),
				radius:4pt
			)[=== Lösung
				#body]
		}
	})
}

#let erwartung(
	text,
	punkte,
	aufg:none,
	teil:none,
) = {
	locate(loc => {
		let n = aufg
		if n == none {
			n = __akt_aufgnr(v=>v, loc:loc)
		}
		let t = teil
		if t == none {
			if __s-in_teilaufgabe.at(loc) {
				t = __akt_taufgnr(v=>v, loc:loc)
			} else {
				t = 0
			}
		}
		__c-punkte.update(c => c + punkte)
		__s-erwartungen.update(e => {
			e.push((
				aufgabe: n,
				teil: t,
				text: text,
				punkte: punkte
			))
			e
		})
	})
}
