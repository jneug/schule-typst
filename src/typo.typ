/********************************\
*    Typographic enhancements    *
\********************************/

#import "@preview/codelst:2.0.0"
#import "@preview/showybox:2.0.1": showybox
#import "@preview/t4t:0.3.2": get, def
#import "@preview/unify:0.4.0"

#import "lib/typopts/typopts.typ": options

#import "./theme.typ"

#let typst-stroke = stroke


// ============================
// Text scaling
// ============================

/// Skalierter text.
/// - #shortex(`#scaled[Hallo Welt.]`)
/// - #shortex(`#scaled(factor:.5)[Hallo Welt.]`)
/// - #shortex(`#scaled("Hallo Welt.", factor:120%)`)
///
/// - content (string, content): Zu skalierender Text.
/// - factor (float, ratio): Der Skalierungsfaktor.
#let scaled(content, factor: 0.8) = text(factor*1em, content)

/// Kleiner text.
/// - #shortex(`#small[#lorem(5)]`)
/// - #shortex(`#small(lorem(5))`)
///
/// - content (string, content): Zu skalierender Text.
#let small(content) = scaled(content, factor:0.88)

/// Großer text.
/// - #shortex(`#large[#lorem(5)]`)
/// - #shortex(`#large(lorem(5))`)
///
/// - content (string, content): Zu skalierender Text.
#let large(content) = scaled(content, factor:1.2)


// ============================
// New text decorations
// ============================
/// Doppelte Unterstreichung.
/// - #shortex(`#uunderline[#lorem(5)]`)
/// - #shortex(`#uunderline(lorem(5), stroke:2pt+red, offset:2pt, distance: 1pt)`)
///
/// - stroke (stroke): Linienstil für die Unterstreichung.
/// - offset (length): Abstand der oberen Linie zum Text.
/// - distance (length): Abstand der unteren Linie zur oberen Linien.
/// - extent (length): #arg[extent] vonn #cmd-[underline].
/// - evade (length): #arg[evade] vonn #cmd-[underline].
/// - body (string, content): Zu unterstreichender Text.
#let uunderline(
	stroke: auto,
	offset: auto,
  distance: auto,
	extent: 0pt,
	evade: true,
	body
) = {
  let thickness = def.if-auto(.0416em, stroke, do:(s) => typst-stroke(s).thickness)
  distance = def.if-auto(.25em, distance)
  underline(
    stroke: stroke,
    offset: def.if-auto(0pt, offset) + thickness + distance,
    extent: extent,
    evade: evade,
    underline(
      stroke: stroke,
      offset: offset,
      extent: extent,
      evade: evade,
      body
    )
  )
}

/// Zickzack Unterstreichung.
/// - #shortex(`#squiggly[#lorem(5)]`)
/// - #shortex(`#squiggly(lorem(5), stroke:2pt+red, offset: 4pt, amp:2, period: 2)`)
///
/// - stroke (stroke): Linienstil für die Unterstreichung.
/// - body (string, content): Zu unterstreichender Text.
#let squiggly(
	stroke:1pt + black,
  offset: 0pt,
  amp: 1,
  period: 1,
	body
) = {
  amp *= .5

	style(styles => {
		let m = measure(body, styles)
		let step = 2pt * period
		let i = 1

		box(width:m.width, clip:false, baseline:-1*m.height)[
			#move(
				dy:m.height + 0.25em,
				while i*step < m.width {
					place(top + left,
            dy: offset,
						line(
							stroke:stroke,

							start:((i - 1)*step, -amp*step),
							end:(i*step, amp*step)
						)
					)
					place(top + left,
              dy: offset,
							line(
								stroke:stroke,
								start:(i*step, amp*step),
								end:((i + 1)*step, -amp*step)
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

///	Auszeichnung von Operatoren:
///
///	#example[```
///	#operator[Entwirf] einen Algorithmus und #operator[stelle] ihn in geeigneter Form #operator[dar].
///
///	#operator[Implementiere] den Algorithmus nach deinem Entwurf.
///	```]
///
/// - body (string, content): Operator zum hervorheben.
/// -> content
#let operator( body ) = smallcaps(body)

/// Darstellung eines Namens:
/// - #shortex(`#name[Jonas Neugebauer]`)
/// - #shortex(`#name[John William Mauchly]`)
/// - #shortex(`#name[Adriaan van Wijngaarden]`)
/// - #shortex(`#name("Adriaan", last:"van Wijngaarden")`)
///
/// - name (string, content): Name, der dargestellt werden soll.
/// - last (string): Optionaler Nachname, falls dieser aus mehreren Teilen besteht.
/// -> content
#let name( name, last:none ) = {
	if last == none {
		let parts = get.text(name).split()
		last = parts.pop()
		name = parts.join(" ")
	}
	[#name #smallcaps(last)]
}

/// Textabschnitt hervorheben.
/// - #shortex(`#highlight[#lorem(5)]`)
#let highlight( body, color:yellow ) = box(fill:color, inset:(x:0.2em), outset:(y:0.2em), radius:0.1em, body)

/// German number format for integers / floats
/// - #shortex(`#num(2.3)`)
#let num( value ) = {
	get.text(value).replace(".", ",")
}

/// SI units
/// - #shortex(`#si(3.5, $m^3$)`)
#let si(value, unit) = [#num(value)#h(0.2em)#unit]

/// Keys
/// - #shortex(`#key("Enter")`)
#let key(label) = box(
  stroke:.5pt + gray,
  inset:(x:2pt),
  outset:(y:2pt),
  radius:2pt,
  // fill:theme.bg.muted,
  fill: gradient.linear(luma(100%), luma(88%), angle:90deg),
  text(.88em, raw(label))
)

/// Dateien
/// - #shortex(`#datei("beispiel.typ")`)
#let datei(name) = [#emoji.page#raw(block:false, get.text(name))]

/// Ordner
/// - #shortex(`#ordner("arbeitsblaetter")`)
#let ordner(name) = [#emoji.folder#raw(block:false, get.text(name))]

/// Programme
/// - #shortex(`#programm("VSCode")`)
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

/// Eine generische Box um Inhalte. Verwendet #package[Showybox].
/// Im Allgemeinen werden die spezifischeren Boxen benutzt:
/// - @@rahmen
/// - @@kasten
/// - @@schattenbox
/// - @@infobox
/// - @@warnungbox
///
/// - width (length): Breite der Box.
/// - stroke (stroke): Rahmenlinie um die Box.
/// - fill (color): Hintergrundfarbe der Box.
/// - inset (length, dictionary): Innenabstände der Box.
/// - shadow (length): Schattenabstand.
/// - radius (length): Radius der abgrundeten Ecken.
/// - ..args (any): Weitere Argumente, die an #package[Showybox] weitergereicht werden.
/// -> content
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
		border-color: typst-stroke(stroke).paint,
		title-color: typst-stroke(stroke).paint,
		footer-color: fill,
    body-color: fill,
		radius: radius,
		thickness: typst-stroke(stroke).thickness,
	),
	shadow: (
		offset: shadow,
		color: typst-stroke(stroke).paint.darken(40%)
	),
	..args,
	body
)

/// Ein Rahmen um Inhalte.
/// #example[```
/// #rahmen[#lorem(10)]
/// ```]
///
/// - ..args (any): Argumente für @@container.
/// -> content
#let rahmen( ..args ) = container.with(stroke:2pt + theme.secondary)(..args)

/// Ein Kasten um Inhalte.
/// #example[```
/// #kasten[#lorem(10)]
/// ```]
///
/// - ..args (any): Argumente für @@container.
/// -> content
#let kasten( ..args ) = container.with(fill:theme.bg.muted, stroke:2pt + theme.secondary)(..args)

/// Eine Box mit Schatten um Inhalte.
/// #example[```
/// #schattenbox[#lorem(10)]
/// ```]
///
/// - ..args (any): Argumente für @@container.
/// -> content
#let schattenbox( ..args ) = container.with(shadow:3pt)( ..args )

/// Eine Infobox um Inhalte.
/// #example[```
/// #infobox[#lorem(10)]
/// ```]
///
/// - ..args (any): Argumente für @@container.
/// -> content
#let infobox( ..args ) = container.with(radius:4pt, fill:theme.bg.primary, stroke:2pt + theme.primary, shadow:3pt)( ..args )

/// Eine Warnungsbox um Inhalte.
/// #example[```
/// #warnungbox[#lorem(10)]
/// ```]
///
/// - ..args (any): Argumente für @@container.
/// -> content
#let warnungbox( ..args ) = container.with(radius:4pt, fill:cmyk(0%,6%,18%,2%), stroke:2pt + cmyk(0%,30%,100%,0%), shadow:3pt)( ..args )

// ============================
// Hints
// ============================

/// Zeigt einen hervorgehobenen Hinweis an.
/// #example[```
/// #pad(left:10pt, hinweis[#lorem(8)])
///
/// #hinweis(typ:"Tipp", icon:emoji.face.halo)[#lorem(8)]
/// ```]
///
/// - typ (string): Art des Hinweises.
/// - icon (symbol): Ein Symbol für den Hinweis..
/// - body (content): Inhalte des Hinweises.
/// -> content
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

/// Setzt das Nummernformat für Aufzählungen im #arg[body] auf `a)`.
/// #example[```
/// #enuma[
///   + Eins
///   + Zwei
///   + Drei
/// ]
/// ```]
///
/// - body (content): Inhalte mit Aufzählungen.
/// -> content
#let enuma( body ) = {
	set enum(numbering: "a)")
	body
}

/// Setzt das Nummernformat für Aufzählungen im #arg[body] auf `1)`.
/// #example[```
/// #enumn[
///   + Eins
///   + Zwei
///   + Drei
/// ]
/// ```]
///
/// - body (content): Inhalte mit Aufzählungen.
/// -> content
#let enumn( body ) = {
	set enum(numbering: "1)", tight:false, spacing:1.5em)
	body
}

/// Setzt das Nummernformat für Aufzählungen im #arg[body] auf `(1)`.
/// #example[```
/// #enumnn[
///   + Eins
///   + Zwei
///   + Drei
/// ]
/// ```]
///
/// - body (content): Inhalte mit Aufzählungen.
/// -> content
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

#let __all__ = (
  scaled,
  small,
  large,
  uunderline,
  squiggly,
  operator,
  name,
  highlight,

  num,
  si,
  key,
  datei,
  ordner,
  programm,

  luecke,
  marginnote,

  container,
  rahmen,
  kasten,
  infobox,
  schattenbox,
  warnungbox,

  hinweis,
  info,
  tipp,

  enuma,
  enumn,
  enumnn,
  tasks
).fold((:), (a, b) => {a.insert(repr(b), b); a})
