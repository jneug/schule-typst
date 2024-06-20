#import "_imports.typ": *

#import "@preview/ccicons:1.0.0": ccicon, cc-is-valid

#let lerntheke(
  ..args,
  body,
) = {
  let (
    doc,
    page-init,
    tpl,
  ) = base-template(
    type: "LT",
    type-long: "Lerntheke",

    // defaults
    paper: "a5",
    flipped: true,
    margin: 1cm,
    fontsize: 11pt,

    // disable title
    title-block: (..) => [],

    //_tpl: (:),

    ..args,
    body,
  )

  {
    show: page-init.with(
      header: (..) => [],
      footer: (..) => [],
    )

    tpl
  }
}

#let _counter-cards = counter("schule.cards")
#let _counter-aid-cards = counter("schule.aid-cards")

#let fake-heading = text.with(font: theme.fonts.sans, size: 1.2em, weight: "bold")

#let get-text-color(clr) = {
  if type(clr) == gradient {
    clr = clr.sample(50%)
  }
  if color.hsl(clr).components(alpha: false).last() < 62% {
    white
  } else {
    theme.text.default
  }
}

#let get-stroke-color(clr) = {
  if type(clr) == gradient {
    clr = clr.sample(50%)
  }
  clr.darken(33%)
}

#let card-header-height = 3em
#let card-footer-height = 6mm

#let href() = it => {
  if it.element != none and it.element.kind == "card-help" {
    context link(
      it.element.location(),
      numbering(
        it.element.numbering,
        ..it.element.counter.at(it.element.location()),
      ),
    )
  } else {
    it
  }
}
