#import "@local/mantys:0.1.0": *
#import "@local/tidy:0.2.0"
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
    name:       "schule-typst",
    title:      "Typst Vorlagen für die Schule",
    subtitle:   [Vorlagen für Arbeitsblätter, Klausuren und andere Materialien für die Schule.],
    info:		[#lorem(10)],
    authors:    "Jonas Neugebauer",
    url:        "https://github.com/jneug/schule-typst",
    version:    "0.1.0",
    date:       datetime.today(),
    abstract:   [
		  SCHULE-TYPST ist eine Sammlung von Typst Vorlagen zur Gestaltung von Arbeitsmaterialien (Arbeitsblätter, Klausuren, Wochenpläne ...) für die Schule. Das Paket ist eine Adaption meines #LaTeX Pakets für Typst.
    ],

	examples-scope: (
    schule: schule,

    ..schule.ab.__all__.fold((:), (a, b) => {a.insert(repr(b), b); a})
  )
)


#let show-module(name, scope:(:)) = tidy-module(
  read("../src/" + name + ".typ"),
  name: name,
  include-examples-scope: true,
  tidy: tidy,
  extract-headings: 3
)

#let exampleout( name, cap: none ) = {
  figure(
    mty.frame(width: 50%, image("../examples/" + name + ".svg", width:100%)),
    caption: if cap != none [#cap (#mty.rawc(theme.colors.secondary, "examples/" + name + ".pdf"))] else [#mty.rawc(theme.colors.secondary, "examples/" + name + ".pdf")],
    kind: image
  )
}

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
  nummer: "IV.11",
  kurs: "Q2-LK",

  autor: "J. Neugebauer",
  kuerzel: "Ngb",

  version: "2024-02-16",
  datum: datetime.today()
)

#abtitel()

#lorem(100)

#aufgabe[
  #lorem(50)
]
```]

#exampleout("ab", cap:[Ausgabe der Basisvorlage])

== Klassenarbeit (`ka`)

== Klausur (`kl`)

= Allgemeine Kommandos

== Dokumentinformationen

== Auszeichnungen
// #show-module("typo")

== Layout
#show-module("layout")

= Beispiele

#let example-file(
  filename,
  size: .5em,
  pages: 1,
  preview:(0,70),
  caption: auto,
  as-grid: auto,
  columns: 2
) = [
  #pagebreak(weak:true)
  === #raw(block:false, "examples/" + filename + ".typ")
  #figure({
    set text(size: size)
    sourcecode(
      numbers-style: (n) => text(luma(160), n),
      showrange:preview,
      raw(lang:"typ", read("../examples/" + filename + ".typ"))
    )},
    caption: if caption == auto [Quelltextvorschau des Beispiels #filename] else {caption}
  )

  #if as-grid == auto {
    as-grid = pages > 1
  }

  #let p = ()
  #for n in range(pages) {
    p.push("../examples/" + filename + "-" + str(n+1) + ".svg")
  }

  #if as-grid {
    grid( columns: (1fr, )*columns, gutter: .63em,
      ..for page in p {
        (mty.frame(image(page, width: 100%)), )
      }
    )
  } else {
    for page in p [
      #pagebreak(weak:true)
      #align(center, mty.frame(image(page, width: 100%)))
    ]
  }
]

== Vorlage Arbeitsblatt

#example-file("10Diff-AB.IV.09-Listen")

#pagebreak()
=== Vorlage Klausur

#example-file("Q1-GK-Klausur_1", pages:7)
