#import "@local/mantys:1.0.0": *

#import "../src/schule.typ"

#import "@preview/swank-tex:0.1.0": TeX, LaTeX

#show: mantys(
  ..toml("../typst.toml"),
  title: "Das SCHULE Paket",

  subtitle: "Hilfen für den Schulalltag",
  date: datetime.today(),

  url: "ngb.schule",

  abstract: [
    SCHULE ist eine Sammlung von Typst Vorlagen zur Gestaltung von Arbeitsmaterialien (Arbeitsblätter, Klausuren, Wochenpläne ...) für die Schule. Das Paket ist eine Adaption meines #link("https://github.com/jneug/arbeitsblatt", [#LaTeX Pakets]) für Typst.
  ],

  examples-scope: (
    schule: schule,
  ),

  theme: themes.cnltx,
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

= Über das Paket <part:ueber>

SCHULE ist ein Typst Paket, mit dem Arbeitsblätter, Klausuren und andere Materialien für den Informatikunterricht erstellt werden können.

Das Paket ist ein Port des #LaTeX Pakets #github("jneug/arbeitsblatt"), welches wiederum auf dem #link("https://ctan.org/pkg/schule", "schule Paket") basierte.

Durch die Adaption für Typst wurden mit der Zeit Funktionalitäten ergänzt, entfernt und verändert, um das Paket an die modernere Typst-Umgebung und das wachsende Ökosystem von verfügbaren Paketen anzupassen.

= Verwendung der Vorlagen <part:verwendung>

== Installation <sec:installation>

Eine manuelle Installation ist nicht notwendig. Das Paket wird automatisch installiert, wenn es in einem Dokument verwendet wird. Dazu wird es einfach im Dokument importiert:

#show-import(imports: "ab", code: `#import ab: *`)

== Vorlagen <sec:vorlagen>

Das Kernstück des Pakets sind die verschiedenen Vorlagen für verschiedene Arten von Dokumente. Dazu gehören Arbeitsblätter, Klassenarbeiten und Präsentationen.

=== Arbeitsblatt (ab) <subsec:ab>

=== Klassenarbeit (ka) <subsec:ka>

=== Klausur (kl) <subsec:kl>

=== Präsentation (pt) <subsec:pt>

=== Lerntheke (lt) <subsec:lt>

== Module <sec:module>

=== Aufgaben

Ein zentrales Modul des Pakets sind #module[aufgaben].

=== Layout- und Text-Elemente
