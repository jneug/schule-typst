// Import external dependencies
#import "@preview/t4t:0.3.2": is, def, assert, alias

// Import submodule dependencies
#import "lib/typopts/typopts.typ": options, states

#import "./theme.typ"
#import "./util.typ": *

#import "./layout.typ" as layout: *
#import "./typo.typ" as typo: *
#import "./aufgaben.typ" as aufgaben: *


#let arbeitsblatt(
	..args,

  // Additional subtype initialization,
  // that needs to get executed in the document
	module-init: none,

	body
) = {
	let fontsize = args.named().at("fontsize", default: 12pt)

	set document(..(
    title: get.text(args.named().at("titel", default:"Arbeitsblatt")),
    author: as-arr(args.named().at("autor", default:())).map(get.text)
  ))

  let from-args = def-args(args)

	// Configure page
	set page(
    ..get.args(args)(
      paper: "a4",
			flipped: false,
      margin: (
        y: 2cm,
        x: 1.69cm,
        left: if args.named().at("lochung", default:false) { 2.41cm } else { 1.69cm }
      ),
    ),
		header: kopfzeile(),
    // header-ascent: 5mm,
		footer: fusszeile()
	)
	// Configure text
  set par(
    leading: 1.2em,
    ..get.args(args, prefix:"par")(
      justify: true
    ),
	)
	set text(
		font: from-args(theme.fonts.default, "font"),
    size: from-args(13pt, "fontsize"),
		..get.args(args, prefix:"font")(
			weight: 300,
			fallback: true,
			lang: "de",
			region: "DE",
			hyphenate: auto,
		)
	)
	// Configure headings
	show heading: set text(
		font: theme.fonts.headings,
		fill: theme.primary
	)
	// Lists
	set enum(
		numbering: "1)"
	)
	// Configure code blocks
	show raw: set text(
		font: theme.fonts.code
	)
	show raw.where(block: false): set text(
		fill: theme.primary
	)
  show link: set text(fill: theme.secondary)
  // set raw(theme: "./BW.tmTheme")

	// Handle options (after setting up page with header / footer)
	for opt in (
    "autor", "kuerzel", "titel",
    "reihe", "nummer", "fach",
    "kurs", "version"
  ) {
    options.add-argument(opt)
  }

	options.add-argument(
		"datum",
		type: ("string", "datetime"),
    default: none,
		code: v => {
			if type(v) == "string" {
				let d = v.split(".")
				datetime(
					day:int(d.at(0)),
					month:int(d.at(1)),
					year:int(d.at(2))
				)
			} else {
        v
      }
		}
	)
	options.add-argument("typ", default:"Arbeitsblatt")
	options.add-argument("fontsize", default:13pt, type:"length")
  options.add-argument("loesungen", default:"sofort")

	// Subtype init
	if is.not-none(module-init) {
		for ini in as-arr(module-init) {
			ini()
		}
	}

	options.parseconfig(..args)

	place-label(<ab-start>)

  [#place-label(<body-start>)#body#place-label(<body-end>)]

  options.get("loesungen", v => {
    if v == "seite" { d_loesungen() }
  })

  place-label(<ab-end>)
}


// =================================
//  Dokumentendaten
// =================================

#let derautor = options.display("autor")
#let daskuerzel = options.display("kuerzel")
#let dertitel = options.display("titel")
#let diereihe = options.display("reihe")
#let dienummer = options.display("nummer")
#let dasfach = options.display("fach")
#let derkurs = options.display("kurs")
#let dertyp = options.display("typ")
#let dasdatum = options.display("datum", format:dt=>if dt != none {dt.display("[day].[month].[year]")})
#let dieversion = options.display("version")


// =================================
//  Titel des Dokuments
// =================================

#let titleblock(
	rule: false,
  ..args,
  body
) = {
  v(-1em)
  block(below:0.65em, width:100%, ..args, {
    body
    if rule {
      move(dy: -.8em, line(length: 100%))
    }
  })
}

#let abtitel(
	titel: none,
	reihe: none,
  rule: false
) = titleblock({
	if titel == none { titel = dertitel }
	if reihe == none { reihe = diereihe }

	set align(center)
	if reihe != none {
		heading(level:3, outlined: false, bookmarked: false, text(theme.text.subject, smallcaps(reihe)))
	}
  move(dy:-0.4em,
    heading(level:1, outlined: false, bookmarked: false, text(theme.primary, smallcaps(titel)))
  )
  if rule {
    move(dy: -.8em, line(length: 100%))
  } else {
    v(.65em)
  }
})


// =================================
//  Anhang
// =================================

#let anhang( body, title:[Anhang], ..args ) = [
	#set page(
		header: kopfzeile(
			mitte: () => title
		),
		..args.named(),
	)
  #set heading(numbering: (..n) => {
    let n = n.pos()
    let _ = n.remove(0)
    if n.len() > 0 { numbering("A.1", ..n) }
  })
	= Anhang <anhang>
	#body
]
#let anh(target) = ref(label("anh:"+target), supplement: "Anhang")


#let __all__ = typo.__all__ + layout.__all__ + aufgaben.__all__
