#import "./ab.typ": *
#import "./bewertung.typ": *

#import "@preview/t4t:0.3.2": alias

// #import "./layout.typ": kopfzeile

#let klassenarbeit(
  ..args,
  body,
) = {
  show <ab-end>: body => {
    d_ew_unterstufe()
    body
  }

  let transform-vari(v) = {
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

  arbeitsblatt(
    typ: "Klassenarbeit",
    ..args,
    module-init: () => {
      options.add-argument(
        "variante",
        default: if "variante" in sys.inputs {
          transform-vari(sys.inputs.variante)
        } else {
          0
        },
        type: ("integer", "string"),
        code: transform-vari,
      )
    },
    body,
  )
}

#let katitel(
  titel: none,
  reihe: none,
  rule: false,
) = titleblock({
  if titel == none {
    titel = dertitel
  }
  set align(center)
  text(theme.primary, heading(level: 1, outlined: false, bookmarked: false, titel))
})

#let dievariante(numbering: "A") = options.display(
  "variante",
  final: true,
  format: v => {
    if v != none and v > 0 {
      alias.numbering(numbering, v)
    } else {
      ""
    }
  },
)

#let vari(..args) = {
  options.get(
    "variante",
    vari => {
      if vari != none and vari > 0 {
        if args.pos().len() >= vari {
          args.pos().at(vari - 1)
        } else {
          // []
          args.pos().last()
        }
      } else {
        args.pos().first()
      }
    },
  )
}
