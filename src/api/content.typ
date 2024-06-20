#import "typo.typ"
#import "../core/base.typ": appendix

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
  // fill: gradient.linear(luma(100%), typo.theme.bg.muted, angle:90deg),
  fill: gradient.linear(luma(100%), luma(88%), angle:90deg),
  text(.88em, font:typo.theme.fonts.code, label))
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
#let datei(name) = [#emoji.page#h(.1em)#typo.code(name)]

// Formatierung von Ordnernamen.
// - #shortex(`#ordner("arbeitsblaetter")`)
//
// - name (string, content): Name des Ordners.
// -> content
#let ordner(name) = [#emoji.folder#h(.1em)#typo.code(name)]

/// Formatierung von Programmnamen.
/// - #shortex(`#programm("VSCode")`)
///
/// - name (string, content): Name des Programms.
/// -> content
#let programm(name) = text(typo.theme.primary, weight: 400, name)

/// TYPO
// TODO: Del with typo.typ and add elements here
#let rahmen = typo.rahmen
#let kasten = typo.kasten
#let hinweis = typo.hinweis
#let tipp = typo.tipp
#let enuma = typo.enuma

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
  computer: emoji.laptop
)
