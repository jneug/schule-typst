// ================================
// =   Typographic enhancements   =
// ================================

#import "@preview/codelst:2.0.1"
#import "@preview/showybox:2.0.1": showybox
// TODO: Keep or drop?
#import "@preview/unify:0.6.0"

#import "../util/typst.typ"
#import "../util/args.typ"
#import "../util/util.typ"

#import "../theme.typ"

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
#let scaled(content, factor: 0.8) = text(factor * 1em, content)

/// Kleiner text.
/// - #shortex(`#small[#lorem(5)]`)
/// - #shortex(`#small(lorem(5))`)
///
/// - content (string, content): Zu skalierender Text.
#let small(content) = scaled(content, factor: 0.88)

/// Großer text.
/// - #shortex(`#large[#lorem(5)]`)
/// - #shortex(`#large(lorem(5))`)
///
/// - content (string, content): Zu skalierender Text.
#let large(content) = scaled(content, factor: 1.2)

// ============================
// New text decorations
// ============================
/// === Neue Textauszeichnungen
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
  body,
) = {
  let thickness = args.if-auto(.0416em, stroke, do: s => typst.stroke(s).thickness)
  distance = args.if-auto(.25em, distance)
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
      body,
    ),
  )
}

/// Zickzack Unterstreichung.
/// - #shortex(`#squiggly[#lorem(5)]`)
/// - #shortex(`#squiggly(lorem(5), stroke:2pt+red, offset: 4pt, amp:2, period: 2)`)
///
/// - stroke (stroke): Linienstil für die Unterstreichung.
/// - body (string, content): Zu unterstreichender Text.
#let squiggly(
  stroke: 1pt + black,
  offset: 0pt,
  amp: 1,
  period: 1,
  body,
) = {
  amp *= .5

  style(styles => {
    let m = measure(body, styles)
    let step = 2pt * period
    let i = 1

    box(width: m.width, clip: false, baseline: -1 * m.height)[
      #move(
        dy: m.height + 0.25em,
        while i * step < m.width {
          place(
            top + left,
            dy: offset,
            line(
              stroke: stroke,
              start: ((i - 1) * step, -amp * step),
              end: (i * step, amp * step),
            ),
          )
          place(
            top + left,
            dy: offset,
            line(
              stroke: stroke,
              start: (i * step, amp * step),
              end: ((i + 1) * step, -amp * step),
            ),
          )
          i += 2
        },
      )
      #place(top + left, body)
    ]
  })
}

/// Textabschnitt hervorheben (ersetzt #doc("text/highlight")).
/// - #shortex(`#highlight[#lorem(5)]`)
///
/// - color (color): Farbe der Hervorhebung.
/// - body (string, content): Hervorzuhebender Inhalt.
/// -> content
#let highlight(body, color: yellow) = box(fill: color, inset: (x: 0.2em), outset: (y: 0.2em), radius: 0.1em, body)

// ============================
// Text highlights
// ============================

// German number format for integers / floats
// - #shortex(`#num(2.3)`)
#let num = unify.num

// SI units
// - #shortex(`#si(3.5, $m^3$)`)
#let si(value, unit) = [#num(value)#h(0.2em)#unit]

// ============================
// Misc
// ============================
/// === Verschiedenes
/// Textlücken.
/// - #shortex(`#luecke()`)
/// - #shortex(`#luecke(width: 2cm, offset: 5pt)`)
/// - #shortex(`#luecke(text: "Hallo Welt!", stroke: .5pt+red)`)
///
/// - width (length): Breite der Textlücke, wenn #arg[text] nicht gegeben ist.
/// - text (length): Text, anhand dessen die Breite der Textlücke bestimmt werden soll. Falls angegeben, wird #arg[width] ignoriert.
/// - stroke (length): Linienstil der Unterstreichung.
/// - offset (length): Abstand der Linie zur Basislinie des umliegenden Textes.
/// -> content
#let luecke(width: 4cm, stroke: 1pt + black, offset: 2pt, text: none) = {
  if text != none {
    box(stroke: (bottom: stroke), inset: (bottom: offset), baseline: offset, text)
  } else {
    box(width: width, stroke: (bottom: stroke), inset: (bottom: offset), baseline: offset, [])
  }
}

// ============================
// Code
// ============================
/// === Quelltexte
/// Zeigt Quelltext mit Zeilennummern und in einem #cmd[frame] an.
/// Alias für #cmd("sourcecode", module:"codelst").
/// #example[````
/// #sourcecode[```python
/// print("Hello, World!")
/// ```]
/// ````]
///
/// - ..args (any): Argument für #cmd-("sourcecode", module:"codelst").
/// -> content
#let sourcecode(..args) = codelst.sourcecode(frame: codelst.code-frame.with(fill: theme.bg.code), ..args)

#let lineref = codelst.lineref.with(supplement: "Zeile")
#let lineref- = codelst.lineref.with(supplement: "")
#let linerange-(from, to, sep: [ -- ]) = [#lineref-(from)#sep#lineref-(to)]
#let linerange(from, to, supplement: "Zeilen", sep: [ -- ]) = [#supplement #linerange-(from, to)]

/// Inline-Code mit Syntax-Highlighting. Im Prinzip gleichwertig
/// mit der Auszeichungsvariante mit drei Backticks:
/// - #shortex(`#code(lang:"python", "print('Hallo, Welt')")`)
/// - #shortex(raw("```python print('Hallo, Welt')```"))
#let code(body, lang: none) = raw(block: false, lang: lang, util.get-text(body))

// ============================
// Frames and Boxes
// ============================
/// === Kästen und Rahmen
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
  width: 100%,
  stroke: 2pt + black,
  fill: white,
  inset: 8pt,
  shadow: 0pt,
  radius: 3pt,
  ..box-args,
  body,
) = showybox(
  frame: (
    border-color: typst.stroke(stroke).paint,
    title-color: typst.stroke(stroke).paint,
    footer-color: fill,
    body-color: fill,
    radius: radius,
    thickness: typst.stroke(stroke).thickness,
  ),
  shadow: (
    offset: shadow,
    color: args.if-auto(silver, typst.stroke(stroke).paint).darken(40%),
  ),
  ..box-args,
  body,
)
/// Ein Rahmen um Inhalte.
/// #example[```
/// #rahmen[#lorem(10)]
/// ```]
///
/// - ..args (any): Argumente für @@container.
/// -> content
#let rahmen = container.with(stroke: 2pt + theme.secondary)

/// Ein Kasten um Inhalte.
/// #example[```
/// #kasten[#lorem(10)]
/// ```]
///
/// - ..args (any): Argumente für @@container.
/// -> content
#let kasten(..args) = container.with(fill: theme.bg.muted, stroke: 2pt + theme.secondary)(..args)

/// Eine Box mit Schatten um Inhalte.
/// #example[```
/// #schattenbox[#lorem(10)]
/// ```]
///
/// - ..args (any): Argumente für @@container.
/// -> content
#let schattenbox(..args) = container.with(shadow: 3pt)(..args)

/// Eine Infobox um Inhalte.
/// #example[```
/// #infobox[#lorem(10)]
/// ```]
///
/// - ..args (any): Argumente für @@container.
/// -> content
#let infobox(..args) = container.with(
  radius: 4pt,
  fill: theme.bg.primary,
  stroke: 2pt + theme.primary,
  shadow: 3pt,
)(..args)

/// Eine Warnungsbox um Inhalte.
/// #example[```
/// #warnungbox[#lorem(10)]
/// ```]
///
/// - ..args (any): Argumente für @@container.
/// -> content
#let warnungbox(..args) = container.with(
  radius: 4pt,
  fill: cmyk(0%, 6%, 18%, 2%),
  stroke: 2pt + cmyk(0%, 30%, 100%, 0%),
  shadow: 3pt,
)(..args)

// ============================
// Hints
// ============================
/// === Hinweise
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
  util.marginnote[#text(fill: theme.secondary)[#icon]]
  text(fill: theme.secondary)[*#typ:* ]
  body
}
#let info(body) = hinweis(typ: "Info", body)
#let tipp(body) = hinweis(typ: "Tipp", icon: emoji.lightbulb, body)

// ============================
// Lists and enums
// ============================
/// === Listen und Aufzählungen
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
#let enuma(body) = {
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
#let enumn(body) = {
  set enum(numbering: "1)", tight: false, spacing: 1.5em)
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
#let enumnn(body) = {
  set enum(numbering: "(1)")
  body
}

