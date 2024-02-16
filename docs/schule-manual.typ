#import "@local/mantys:0.1.0": *
#import "../src/schule.typ"

#show: mantys.with(
    name:       "schule-typst",
    title:      "Typst Vorlagen für die Schule",
    subtitle:   [Vorlagen für Arbeitsblätter, Klausuren und andere Materialien für die Schule.],
    info:		[#lorem(10)],
    authors:    "Jonas Neugebauer",
    url:        "https://github.com/jneug/schule-typst",
    version:    "0.0.5",
    date:       datetime.today(),
    abstract:   [
		  #lorem(50)
    ],

	examples-scope: (
    schule: schule,

    ..schule.ab.__all__
  )
)

#import "@local/tidy:0.2.0"

#let show-module(name, scope:(:)) = tidy-module(
  read("../src/" + name + ".typ"),
  name: name,
  include-examples-scope: true,
  tidy: tidy,
  extract-headings: 3
)

// #let footlink( url, label ) = [#link(url, label)#footnote(link(url))]
// #let gitlink( repo ) = footlink("https://github.com/" + repo, repo)
// #let pkglink( repo ) = footlink("https://github.com/" + repo, repo)

// #import "../src/util.typ": *
// #import "../src/typo.typ": *
// #import "../src/layout.typ": *

// End preamble

= About

= Verwendung der Vorlagen

== Installation

= Vorlagen

Kernstück von SCHULE-TYPST sind die Dokumentvorlagen.

== Arbeitsblatt (`ab`)

Die Vorlage #cmd[arbeitsblatt] ist die Basisvorlage für alle anderen Vorlagen und Grundlage für die Gestaltung von Arbeitsmaterialien. Alle Argumente, die von #cmd-[arbeitsblatt] akzeptiert werden, werden daher auch von allen anderen Vorlagen akzeptiert.

#command("arbeitsblatt",
  ..args(
    "autor", "kuerzel", "titel",
    "reihe", "nummer", "fach",
    "kurs", "version", "datum",

    typ: "Arbeitsblatt",
    loesungen: "sofort",

    fontsize: 13pt,

    paper: "a4",
    flipped: false,
    "margin",
    lochung: false,
  ),
  sarg("args"),
  barg("body")
)[
  Alle zusätzlichen Argumente in #barg[args] werden nach Prefix gefiltert und an die entsprechende Funktion weitergegeben. Beispielsweise wird #arg(par-justify: false) als #arg(justify: false) an #doc("text/par") weitergegeben.
  - `par-` an #doc("text/par")
  - `font-` an #doc("text/text")
]

=== Basisvorlage für ein Arbeitsblatt

#sourcecode[```typ
#import "@local/schule:0.1.0": ab
#import ab: *

#show: arbeitsblatt.with(
  titel: "Potenzmengenkonstruktion",
  reihe: "Endliche Automaten und formale Sprachen",
  nummer: "AB.IV.11",
  kurs: "Q2-LK",

  autor: "J. Neugebauer",
  kuerzel: "Ngb",

  version: "2024-02-16",
  datum: datetime.today()
)

#abtitel()

#lorem(100)
```]

== Klassenarbeit (`ka`)

== Klausur (`kl`)

= Allgemeine Kommandos

== Dokumentinformationen

== Auszeichnungen
#show-module("typo")

== Layout
#show-module("layout")
