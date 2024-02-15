#import "./ab.typ": *
#import  "./bewertung.typ": *

#import "@preview/t4t:0.3.2": alias

// #import "./layout.typ": kopfzeile


#let klassenarbeit(
	..args,

	body
) = {
	show <ab-end>: body => {
		d_ew_unterstufe()
		body
	}

	arbeitsblatt(
		typ: "Klassenarbeit",

		..args,

		module-init: () => {
      options.add-argument(
				"variante",
				default: 0,
				type: ("integer", "string"),
				code: v => {
					let varis = "ABCDEFGHIJKLMN"
					if type(v) == "string" {
						if v in varis {
							varis.position(v) + 1
						} else {
							0
						}
					} else {
						v
					}
				}
			)
		},

		body
	)
}

#let katitel(
	titel: none,
	reihe: none,
  rule: false
) =titleblock({
	if titel == none { titel = dertitel }
	set align(center)
	text(theme.primary, heading(level: 1, titel))
})

#let dievariante(numbering: "A") = options.display(
	"variante",
	final:true,
	format:v => {
		if v != none and v > 0 {
			alias.numbering(numbering, v)
		} else {
			""
		}
	}
)

#let vari( ..args ) = {
	options.get("variante", vari => {
		if vari != none and vari > 0 {
			if args.pos().len() >= vari {
				args.pos().at(vari - 1)
			} else {
				[]
			}
		} else {
			args.pos().first()
		}
	})
}
