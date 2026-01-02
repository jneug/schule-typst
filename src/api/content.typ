#import "../_deps.typ": gentle-clues, heroic, showybox, zebraw

#import "../util/util.typ"
#import "../util/args.typ"
#import "../core/base.typ": appendix
#import "../theme.typ"

/// Setzt den Inhalt als Anhang für das Dokument.
/// Die Kopfzeile und die Nummerierung der Überschriften wird angepasst.
///
/// Der Anhang wird als neuer Seitenabschnitt erstellt und kann daher im Format vom Hauptteil abweichen. Die Argumente werden direkt an #typ.page weitergegeben.
///
/// Beispielsweise lässt sich der Anhang so im Querformat in zwei Spalten setzen:
/// ```typst
/// #anhang(flipped: true, columns: 2)[
///  #lorem(500)
/// ]
/// ```
/// -> content
#let anhang(
  /// Alle Argumente werden an #cmd[page] weitergegeben, um das Seitenformat des Anhangs zu ändern.
  /// -> any
  ..page-args,
) = appendix(..page-args)

/// Erzeugt eine Referenz zu einem Abschnitt im Anhang.
/// ```example
/// #anh("doku")
/// ```
/// -> content
#let anh(
  /// Ziel der Referenz.
  /// -> label | str
  label,
  /// Ergänzendes Etikett.
  /// -> str
  supplement: "Anhang",
  /// Prefix für Anhang-Labels.
  /// -> str
  prefix: "anh:",
) = {
  ref(supplement: supplement, std.label(prefix + str(label)))
}

///	Auszeichnung von Operatoren:
///
///	#example[```
///	#operator[Entwirf] einen Algorithmus und #operator[stelle] ihn in geeigneter Form #operator[dar].
///
///	#operator[Implementiere] den Algorithmus nach deinem Entwurf.
///	```]
/// -> content
#let operator(
  /// Operator zum hervorheben.
  /// -> string | content
  body,
) = smallcaps(body)

/// Darstellung eines Namens:
/// - #ex(`#name[Jonas Neugebauer]`)
/// - #ex(`#name[John William Mauchly]`)
/// - #ex(`#name[Adriaan van Wijngaarden]`)
/// - #ex(`#name("Adriaan", last:"van Wijngaarden")`)
/// - #ex(`#name(last:2)[Adriaan van Wijngaarden]`)
/// -> content
#let name(
  /// Name, der dargestellt werden soll.
  /// -> str | content
  name,
  /// Optionaler Nachname, falls dieser aus mehreren Teilen besteht. Falls dies ein #typ.t.int ist, werden die letzten #arg[last] Namensteile von #arg[name] als Nachname verwendet.
  /// -> str | int
  last: none,
) = {
  if type(name) == content {
    name = name.text
  }
  if last == none {
    let parts = name.split()
    last = parts.pop()
    name = parts.join(" ")
  } else if type(last) == int {
    let parts = name.split()
    let i = last
    last = parts.slice(-1 * i).join(" ")
    name = parts.slice(0, i - 1).join(" ")
  }
  [#name #smallcaps(last)]
}

/// Formatierung von Tasten.
/// - #ex(`#taste("Enter")`)
/// - #ex(`#taste(sym.arrow.l.hook)`)
/// -> content
#let taste(
  /// Aufschrift der Taste.
  /// -> string | content
  label,
) = box(
  stroke: .5pt + gray,
  inset: (x: .25em),
  outset: (y: .25em),
  radius: 2pt,
  // fill: gradient.linear(luma(100%), theme.bg.muted, angle:90deg),
  fill: gradient.linear(luma(100%), luma(88%), angle: 90deg),
  text(.88em, font: theme.fonts.code, label),
)

/// Formatierung von Tastenkürzeln.
/// - #ex(`#tastenkuerzel("Strg","C")`)
/// - #ex(`#tastenkuerzel("Strg","Cmd")`, sep:"/")
/// - #ex(`#tastenkuerzel("Strg","Shift","C", sep:sym.plus.o)`)
/// -> content
#let tastenkuerzel(
  /// Aufschriften der Tasten.
  /// -> str | content
  ..labels,
  /// Trennzeichen zwischen Tasten.
  /// -> str | content
  sep: box(inset: (x: .1em), "+"),
) = {
  labels.pos().map(taste).join(sep)
}

/// Formatierung von Dateinamen.
/// - #ex(`#datei("beispiel.typ")`)
/// -> content
#let datei(
  /// Name der Datei.
  /// -> str | content
  name,
) = [#heroic.hi("document", solid: false)#h(.2em)#raw(block: false, util.get-text(name))]

/// Formatierung von Ordnernamen.
/// - #ex(`#ordner("arbeitsblaetter")`)
/// -> content
#let ordner(
  /// Name des Ordners.
  /// -> str | content
  name,
) = [#heroic.hi("folder", solid: false)#h(.2em)#raw(block: false, util.get-text(name))]

/// Formatierung von Programmnamen.
/// - #ex(`#programm("VSCode")`)
/// -> content
#let programm(
  /// Name des Programms.
  /// -> str | content
  name,
) = text(theme.primary, weight: 400, name)

/// Symbols
#let icon = heroic.hi

#let icons = (
  // Sozialformen
  einzel: icon("user"),
  partner: icon("users"),
  gruppe: icon("user-group"),
  // Geräte
  stift: icon("pencil"),
  heft: icon("book"),
  mappe: icon("document-text"),
  tablet: icon("device-tablet"),
  computer: icon("computer-desktop"),
  // Verschiedene
  stern: icon("star"),
)

/// Erstellt ein neues Format zur Auflistung von Aufgabennummern.
/// Die erstelle Funktion fasst ihre Argumente automatisch zu
/// Bereichen zusammen und gibt sie möglichst kompakt aus.
/// ```example
/// #let nr = aufg-neu("Nr.")
///
/// - #nr(1,)
/// - #nr(1,3)
/// - #nr(1,2,3)
/// - #nr(1,2,3,6,7,8)
/// - #nr(1,2,3,6,7,8,12)
/// ```
/// -> function
#let aufg-neu(
  /// Prefix für die Angabe.
  /// -> str | content
  prefix,
  /// Trennzeichen für Prefix und Nummernbereiche.
  /// -> str | content
  sep: h(0.166667em),
  /// Trennzeichen zwischen Nummernbereichen.
  /// -> str | content
  range-sep: ", ",
) = (
  (..aufg-args) => [#prefix#sep#util.combine-ranges(aufg-args.pos(), sep: range-sep, last: " und ")]
)

/// Seitennummern
/// - #ex(`#seiten(1,2,3,6,7,8,12)`)
/// -> content
#let seiten = aufg-neu("S.")

/// Aufgabennummern
/// - #ex(`#aufg(1,2,3,6,7,8,12)`)
/// -> content
#let aufg = aufg-neu("Aufg.")

/// Erstellt eine neue Funktion für Quellenangaben, die sich aus Seiten- und optionalen Aufgabennummern zusammensetzen.
/// ```example
/// #let pp = quelle-neu(
///   "Präsentation",
///   seiten-format: aufg-neu("Folie", sep: " "),
///   sep: ", "
/// )
///
/// - #pp(4,3,2)
/// - #pp(79, (1,2,3))
/// - #pp((101,102), 16)
/// - #pp((101,102),       range(16, 19))
/// - #pp((101,102), 13,   range(16, 19))
/// - #pp((101,102), 13, ..range(16, 19))
/// - #pp( 101,102 , 13, ..range(16, 19))
/// - #pp( 101,102 , 13,   range(16, 19))
/// ```
/// Die erstellte Funktion
/// -> function
#let quelle-neu(
  name,
  seiten-format: seiten,
  aufgaben-format: aufg,
  sep: ": ",
) = {
  name = if name.len() > 0 {
    name + " "
  } else {
    ""
  }

  (..q-args) => {
    let pages = ()
    let tasks = ()
    let collect-pages = true

    for arg in q-args.pos() {
      if collect-pages {
        if type(arg) == array {
          collect-pages = false
          if pages.len() == 0 {
            pages = arg
          } else {
            tasks = arg
            break
          }
        } else {
          pages.push(arg)
        }
      } else {
        if type(arg) == array {
          tasks += arg
          break
        } else {
          tasks.push(arg)
        }
      }
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

/// Textlücken.
/// - #ex(`#luecke()`)
/// - #ex(`#luecke(width: 2cm, offset: 5pt)`)
/// - #ex(`#luecke(text: "Hallo Welt!", stroke: .5pt+red)`)
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
  fill: tiling(
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
// Frames and Boxes
// ============================

/// Eine generische Box um Inhalte. Verwendet #universe("Showybox").
/// Im Allgemeinen werden die spezifischeren Boxen benutzt:
/// - @cmd:rahmen
/// - @cmd:kasten
/// - @cmd:schattenbox
/// - @cmd:infobox
/// - @cmd:warnungbox
///
/// - width (length): Breite der Box.
/// - stroke (stroke): Rahmenlinie um die Box.
/// - fill (color): Hintergrundfarbe der Box.
/// - inset (length, dictionary): Innenabstände der Box.
/// - shadow (length): Schattenabstand.
/// - radius (length): Radius der abgrundeten Ecken.
/// - ..box-args (any): Weitere Argumente, die an #package[Showybox] weitergereicht werden.
/// -> content
#let container(
  width: 100%,
  stroke: 2pt + black,
  fill: white,
  inset: .64em,
  shadow: 0pt,
  radius: 3pt,
  ..box-args,
  body,
) = showybox.showybox(
  frame: (
    border-color: std.stroke(stroke).paint,
    title-color: std.stroke(stroke).paint,
    footer-color: fill,
    body-color: fill,
    radius: radius,
    thickness: std.stroke(stroke).thickness,
  ),
  shadow: (
    offset: shadow,
    color: args.if-auto(silver, std.stroke(stroke).paint).darken(40%),
  ),
  width: width,
  inset: inset,
  ..box-args,
  body,
)

/// Ein Rahmen um Inhalte.
/// #example[```
/// #rahmen[#lorem(10)]
/// ```]
///
/// - ..args (any): Argumente für @cmd:container.
/// -> content
#let rahmen = container.with(stroke: 2pt + theme.secondary)

/// Ein Kasten um Inhalte.
/// #example[```
/// #kasten[#lorem(10)]
/// ```]
///
/// - ..args (any): Argumente für @cmd:container.
/// -> content
#let kasten(..args) = container.with(fill: theme.bg.muted, stroke: 2pt + theme.secondary)(..args)

/// Eine Box mit Schatten um Inhalte.
/// #example[```
/// #schattenbox[#lorem(10)]
/// ```]
///
/// - ..args (any): Argumente für @cmd:container.
/// -> content
#let schattenbox(..args) = container.with(shadow: 3pt)(..args)

/// Eine Infobox um Inhalte.
/// #example[```
/// #infobox[#lorem(10)]
/// ```]
///
/// - ..args (any): Argumente für @cmd:container.
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
/// - ..args (any): Argumente für @cmd:container.
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
#let hinweis(typ: "Hinweis", icon: icon("information-circle"), ..clue-args, body) = gentle-clues.clue(
  // title: typ,
  accent-color: theme.secondary,
  // icon: text(theme.secondary, icon),
  ..clue-args,
  [
    #if icon != none {
      text(theme.secondary, weight: "bold")[#icon]
    }#if typ != none {
      text(theme.secondary, weight: "bold")[#typ:]
    } #body
  ],
)

#let tipp(body) = hinweis(typ: "Tipp", icon: icon("light-bulb"), body)


// ============================
// Code
// ============================

#let code-frame = container.with(..theme.raw)

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
#let sourcecode(..args) = code-frame(zebraw.zebraw(..args))

#let quelltext(..args) = sourcecode(frame: code-frame, ..args)

#let snippet(..args, body) = zebraw.zebraw(
  number-format: none,
  ..args,
  body,
)


// #let lineref = codelst.lineref.with(supplement: "Zeile")
// #let lineref- = codelst.lineref.with(supplement: "")

#let linerange-(from, to, sep: [ -- ]) = [#lineref-(from)#sep#lineref-(to)]
#let linerange(from, to, supplement: "Zeilen", sep: [ -- ]) = [#supplement #linerange-(from, to)]

/// Inline-Code mit Syntax-Highlighting. Im Prinzip gleichwertig
/// mit der Auszeichungsvariante mit drei Backticks:
/// - #ex(`#code(lang:"python", "print('Hallo, Welt')")`)
/// - #ex(raw("```python print('Hallo, Welt')```"))
/// -> content
#let code(body, lang: none) = raw(block: false, lang: lang, util.get-text(body))

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
#let enuma(body) = {
  set enum(numbering: "ai)")
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
  set enum(numbering: "1i)", tight: false, spacing: 1.5em)
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
  set enum(numbering: "(1i)")
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

