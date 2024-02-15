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
    schule: schule
  )
)

// #let footlink( url, label ) = [#link(url, label)#footnote(link(url))]
// #let gitlink( repo ) = footlink("https://github.com/" + repo, repo)
// #let pkglink( repo ) = footlink("https://github.com/" + repo, repo)

// #import "../src/util.typ": *
// #import "../src/typo.typ": *
// #import "../src/layout.typ": *

// End preamble

= About

= Usage

= Command reference

// == typo.typ


// #command("operator", barg[operator])[
// 	Auszeichnung von Operatoren:

// 	#example(```
// 	#operator[Entwirf] einen Algorithmus und #operator[stelle] ihn in geeigneter Form #operator[dar].

// 	#operator[Implementiere] den Algorithmus nach deinem Entwurf.
// 	```)
// ]

// #command("name", arg(last:none), barg[name])[
// 	Darstellung eines Namens:

// 	#example(```
// 	- #name[Jonas Neugebauer]
// 	- #name[John William Mauchly]
// 	- #name[Adriaan van Wijngaarden]
// 	- #name("Adriaan", last:"van Wijngaarden")
// 	```)
// ]

// #command("uunderline", ..args(stroke: auto, offset: auto, extent: 0pt, evade: true), barg[content])[
// 	Doppelte Untertstreichung:

// 	- #quickex(`#uunderline[doppelt unterstrichen]`)

// 	Die Argumente entsprechen denen von #doc("text/underline").
// ]
// #command("suiggly", arg(stroke:1pt + black), barg[content])[
// 	Unterschlängelung:

// 	- #quickex(`#squiggly[unterschlängelt]`)

// 	#arg[stroke] bestimmt die Linienart der Unterschlängelung.
// ]

// #command("rahmen", barg[body])[
// 	#example(```
// 	#rahmen[#lorem(50)]
// 	```)
// ]

// #command("kasten", barg[body])[
// 	#example(```
// 	#kasten[#lorem(50)]
// 	```)
// ]

// #command("schattenbox", barg[body])[
// 	#example(```
// 	#schattenbox[#lorem(50)]
// 	```)
// ]

// #command("infobox", barg[body])[
// 	#example(```
// 	#infobox[#lorem(50)]
// 	```)
// ]

// #command("warnungbox", barg[body])[
// 	#example(```
// 	#warnungbox[#lorem(50)]
// 	```)
// ]

// #command("hinweis", barg[body])[
// 	#example(```
// 	#hinweis[#lorem(50)]
// 	```)
// ]

// #command("tipp", barg[body])[
// 	#example(```
// 	#tipp[#lorem(50)]
// 	```)
// ]

// #command("info", barg[body])[
// 	#example(```
// 	#info[#lorem(50)]
// 	```)
// ]

// #command("tasks", ..args(cols: 3, gutter: 4%, numbering: "1)", [body]))[
// 	Erzeugt eine vertikale Liste.

// 	#example[```
// 	#tasks[
// 		- Aufgabe 1
// 		- Aufgabe 2
// 		- Aufgabe 3
// 	]
// 	```]
// ]

// #command("si", arg[value], arg[unit])[
// 	Erzeugt einen Wert mit Einheit.

// 	#example[```
// 	- #num(3.2)
// 	- #si[4.5][m]
// 	- #si[4.5][$frac("k", "mh")$]
// 	```]
// ]
