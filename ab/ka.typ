#import "./ab.typ": *
#import  "./bewertung.typ": *
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

		_init: () => {
			options.addconfig(
				"variante",
				default: 0,
				type: ("integer", "string"),
				code: v => {
					let varis = "ABCDEFGHIJKLMN"
					if type(v) == "string" and v in varis {
						varis.position(v) + 1
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
	reihe: none
) = {
	if titel == none { titel = dertitel }
	set align(center)
	text(fill: theme.primary)[= #smallcaps(titel)]
}

#let dievariante(fmt: "A") = options.display(
	"variante",
	final:true,
	format:v => {
		if v != none and v > 0 {
			numbering(fmt, v)
		} else {
			[]
		}
	})

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
