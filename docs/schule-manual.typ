#import "@local/mantys:0.1.4": *
#import "@preview/tidy:0.3.0"

#import "../src/schule.typ"

#let TeX = style(styles => {
  set text(font: "New Computer Modern")
  let e = measure("E", styles)
  let T = "T"
  let E = text(1em, baseline: e.height * 0.31, "E")
  let X = "X"
  box(T + h(-0.15em) + E + h(-0.125em) + X)
})

#let LaTeX = style(styles => {
  set text(font: "New Computer Modern")
  let a-size = 0.66em
  let l = measure("L", styles)
  let a = measure(text(a-size, "A"), styles)
  let L = "L"
  let A = box(scale(x: 110%, text(a-size, baseline: a.height - l.height, "A")))
  box(L + h(-a.width * 0.67) + A + h(-a.width * 0.25) + TeX)
})

#show: mantys.with(
  ..toml("../typst.toml"),
  date: datetime.today(),
  abstract: [
    SCHULE ist eine Sammlung von Typst Vorlagen zur Gestaltung von Arbeitsmaterialien (Arbeitsblätter, Klausuren, Wochenpläne ...) für die Schule. Das Paket ist eine Adaption meines #mty.footlink("https://github.com/jneug/arbeitsblatt", [#LaTeX Pakets]) für Typst.
  ],
  examples-scope: (
    schule: schule,
  ),
)

#let show-module(name, scope: (:)) = tidy-module(
  read("../src/" + name + ".typ"),
  name: name,
  include-examples-scope: true,
  scope: scope,
)

#let exampleout(name, cap: none) = {
  figure(
    mty.frame(width: 50%, image("examples/" + name + ".svg", width: 100%)),
    caption: if cap != none [#cap (#mty.rawc(theme.colors.secondary, "examples/" + name + ".pdf"))] else [#mty.rawc(
        theme.colors.secondary,
        "examples/" + name + ".pdf",
      )],
    kind: image,
  )
}
#let examplefile(name, cap: none) = {
  let code = read("examples/" + name + ".typ")
  mty.codelst.sourcefile(code.replace("../src/schule.typ", "@local/schule:0.1.1"), lang: "typ")

  exampleout(name, cap: cap)
}

= About

SCHULE ist ein Typst Paket, mit dem Arbeitsblätter, Klausuren und andere Materialien für den Informatikunterricht erstellt werden können.

Das Paket ist ein Port des #LaTeX Pakets #mty.gitlink("jneug/arbeitsblatt"), welches wiederum auf dem #mty.footlink("https://ctan.org/pkg/schule", "schule Paket") basierte.

Durch die Adaption für Typst wurden mit der Zeit Funktionalitäten ergänzt, entfernt und verändert, um das Paket an die modernere Typst-Umgebung und das wachsende Ökosystem von verfügbaren Paketen anzupassen.

= Verwendung der Vorlagen

== Installation

SCHULE ist derzeit nicht im Typst-Universum als öffentliche Vorlage verfügbar. Die Installation muss lokal erfolgen.

== Vorlagen

=== Arbeitsblatt

=== Klassenarbeit

=== Klausur

== Module

=== Aufgaben

=== Layout- und Text-Elemente
// #import "../src/api/content.typ": __all__
// #show-module("api/content", scope: __all__)
