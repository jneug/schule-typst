
#import "@preview/codelst:2.0.2"
#import "@preview/showybox:2.0.3": showybox

#import "../util/util.typ"
#import "../util/typst.typ"
#import "../util/args.typ"
#import "../core/base.typ": appendix
#import "../theme.typ"

// Setzt den Inhalt als Anhang für das Dokument.
// Die Kopfzeile und die Nummerierung der Überschriften wird angepasst.
//
// Der Anhang wird als neuer Seitenabschnitt erstellt und kann daher im Format vo Hauptteil abweichen. Die Argumente werden direkt an #cmd-[page] weitergegeben.
//
// Beispielsweise lässt sich der Anhang so im Querformat in zwei Spalten setzen:
// ```typst
// #anhang(flipped: true, columns: 2)[
//   #lorem(500)
// ]
// ```
//
// - ..page-args: Alle Argumente werden an #cmd[page] weitergegeben, um das Seitenformat des Anhangs zu ändern.
// -> content
#let anhang = appendix

//	Auszeichnung von Operatoren:
//
//	#example[```
//	#operator[Entwirf] einen Algorithmus und #operator[stelle] ihn in geeigneter Form #operator[dar].
//
//	#operator[Implementiere] den Algorithmus nach deinem Entwurf.
//	```]
//
// - body (string, content): Operator zum hervorheben.
// -> content
#let operator(body) = smallcaps(body)

// Darstellung eines Namens:
// - #shortex(`#name[Jonas Neugebauer]`)
// - #shortex(`#name[John William Mauchly]`)
// - #shortex(`#name[Adriaan van Wijngaarden]`)
// - #shortex(`#name("Adriaan", last:"van Wijngaarden")`)
//
// - name (string, content): Name, der dargestellt werden soll.
// - last (string): Optionaler Nachname, falls dieser aus mehreren Teilen besteht.
// -> content
#let name(name, last: none) = {
  if type(name) == content {
    name = name.text
  }
  if last == none {
    let parts = name.split()
    last = parts.pop()
    name = parts.join(" ")
  }
  [#name #smallcaps(last)]
}

// Formatierung von Tasten.
// - #shortex(`#taste("Enter")`)
//
// - label (string, content): Aufschrift der Taste.
// -> content
#let taste(
  label,
) = box(
  stroke: .5pt + gray,
  inset: (x: .25em),
  outset: (y: .25em),
  radius: 2pt,
  // fill: gradient.linear(luma(100%), theme.bg.muted, angle:90deg),
  fill: gradient.linear(luma(100%), luma(88%), angle:90deg),
  text(.88em, font:theme.fonts.code, label))
)

// Formatierung von Tastenkürzeln.
// - #shortex(`#tastenkuerzel("Strg","C")`)
// - #shortex(`#tastenkuerzel("Strg","Cmd")`, sep:"/")
// - #shortex(`#tastenkuerzel("Strg","Shift","C", sep:"")`)
//
// - ..labels (string, content): Aufschriften der Tasten.
// - sep (string): Separator zwischen Tasten.
// -> content
#let tastenkuerzel(..labels, sep: box(inset: (x: .1em), "+")) = {
  labels.pos().map(taste).join(sep)
}

// Formatierung von Dateinamen.
// - #shortex(`#datei("beispiel.typ")`)
//
// - name (string, content): Name der Datei.
// -> content
#let datei(name) = [#emoji.page#h(.1em)#raw(block: false, util.get-text(name))]

// Formatierung von Ordnernamen.
// - #shortex(`#ordner("arbeitsblaetter")`)
//
// - name (string, content): Name des Ordners.
// -> content
#let ordner(name) = [#emoji.folder#h(.1em)#raw(block: false, util.get-text(name))]

/// Formatierung von Programmnamen.
/// - #shortex(`#programm("VSCode")`)
///
/// - name (string, content): Name des Programms.
/// -> content
#let programm(name) = text(theme.primary, weight: 400, name)

// Symbols
#let icon = (
  // Sozialformen
  einzel: emoji.person.stand,
  partner: emoji.handholding.woman.man,
  gruppe: emoji.family,
  // Geräte
  stift: emoji.pencil,
  heft: emoji.book.open,
  mappe: emoji.book.spiral,
  tablet: emoji.phone,
  computer: emoji.laptop,
  // Verschiedene
  stern: emoji.star,
)

#let aufg-neu(prefix) = (
  (..aufg-args) => [#prefix
    #util.combine-ranges(aufg-args.pos(), last: " und ")]
)

#let seiten = aufg-neu("S.")
#let aufg = aufg-neu("Aufg.")

#let quelle-neu(
  name,
  seiten-format: seiten,
  aufgaben-format: aufg,
  sep: ": ",
) = {
  // Maybe strip unnecessary whitespace
  name = if name.len() > 0 {
    name + " "
  } else {
    ""
  }

  (..q-args) => {
    let pages = ()
    let tasks = ()
    if type(q-args.pos().first()) == array {
      pages = q-args.pos().first()
      if q-args.pos().len() > 1 {
        tasks = q-args.pos().at(1)
      }
    } else {
      pages = q-args.pos()
    }

    if tasks.len() > 0 [
      #name#seiten-format(..pages)#sep#aufgaben-format(..tasks)
    ] else [
      #name#seiten-format(..pages)
    ]
  }
}

#let bu = quelle-neu("Buch")
#let ah = quelle-neu("AH")
#let ab = quelle-neu("", seiten-format: aufg-neu("AB"))


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

#let linien(number-of-lines: 3, line-height: 1cm, stroke: 1pt + black) = block(
  fill: pattern(
    size: (1cm, line-height),
    place(line(start: (0%, 100% - stroke.thickness), end: (100%, 100% - stroke.thickness), stroke: stroke)),
  ),
  height: line-height * number-of-lines,
  width: 100%,
)

#let karos(width: 5, height: 5, unit: 5mm, stroke: 1pt + black, body: none) = block(
  fill: pattern(
    size: (unit, unit),
    place(rect(width: 100%, height: 100%, stroke: stroke)),
  ),
  height: height * unit,
  width: width * unit,
  body,
)

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

#let quelltext(..args) = codelst.sourcecode(frame: codelst.code-frame.with(fill: theme.bg.code), ..args)


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
#let infobox(..args, body) = container.with(
  radius: 4pt,
  fill: theme.bg.primary,
  stroke: 2pt + theme.primary,
  shadow: 3pt,
)(..args)[
  // #set text(fill: theme.primary, weight: 400)
  #body
]

/// Eine Warnungsbox um Inhalte.
/// #example[```
/// #warnungbox[#lorem(10)]
/// ```]
///
/// - ..args (any): Argumente für @@container.
/// -> content
#let warnungbox(..args, body) = container.with(
  radius: 4pt,
  fill: cmyk(0%, 6%, 18%, 2%),
  stroke: 2pt + cmyk(0%, 30%, 100%, 0%),
  shadow: 3pt,
)(..args)[
  #set text(fill: cmyk(0%, 20.72%, 74.77%, 56.47%), weight: 400)
  #body
]

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
  set text(size: .88em)
  text(fill: theme.secondary)[#icon]
  h(.2em)
  text(fill: theme.secondary)[*#typ:* ]
  emph(body)
}

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

#let _counter-numbering = counter("@ab-numbering")

#let reset-numbering() = _counter-numbering.update(0)

#let arabic = {
  _counter-numbering.step()
  context _counter-numbering.display("1.")
}
#let alph = {
  _counter-numbering.step()
  context _counter-numbering.display("a)")
}
#let roman = {
  _counter-numbering.step()
  context _counter-numbering.display("I")
}

