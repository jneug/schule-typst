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

    // Template options
    // _tpl: (:),

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
#let _counter-cards-help = counter("schule.aid-cards")

#let card-header-height = 3em
#let card-footer-height = 6mm

#let _help-ref(kind: "card-help") = it => {
  if it.element != none and it.element.kind == kind {
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

#let _card-header(
  title,
  counter: _counter-cards,
  no: auto,
  icon: none,
  fill: theme.bg.muted,
  label: none,
) = {
  let fake-heading = text.with(font: theme.fonts.sans, size: 1.2em, weight: "bold")
  let content-block = block.with(
    width: 100%,
    height: 100%,
    radius: 6pt,
    stroke: .6pt + rgb(33%, 33%, 33%, 33%),
  )

  place(
    top + center,
    {
      if counter != none {
        counter.step()
        if label != none {
          marks.place-reference(label, "card", "Karte")
        }
      }

      block(
        width: 100%,
        height: card-header-height,
        clip: true,
        breakable: false,
        grid(
          columns: (1.5cm, 1fr, 1.5cm),
          column-gutter: 2mm,
          align: center + horizon,
          content-block(
            fill: theme.bg.muted,
            {
              if counter != none and no != none {
                fake-heading(if no == auto {
                  counter.display()
                } else if type(no) == function {
                  counter.display(no)
                } else {
                  str(no)
                })
              } else if type(no) in (str, int) {
                fake-heading(fill: theme.text.default, str(no))
              }
            },
          ),
          content-block(
            fill: fill,
            fake-heading(fill: util.get-text-color(fill), title),
          ),
          content-block(
            fill: theme.bg.muted,
            fake-heading(size: 1.8em, icon),
          ),
        ),
      )
    },
  )
}

#let _card-header-back(
  title,
  fill: theme.bg.muted,
) = {
  let fake-heading = text.with(font: theme.fonts.sans, size: 1.2em, weight: "bold")

  place(
    top + center,
    {
      block(
        width: 100%,
        height: card-header-height,
        radius: 6pt,
        stroke: .6pt + rgb(33%, 33%, 33%, 33%),
        fill: fill,
        clip: true,
        breakable: false,
        {
          set align(center + horizon)
          fake-heading(fill: util.get-text-color(fill), upper(title))
        },
      )
    },
  )
}

#let _card-body(body) = {
  block(
    width: 100%,
    inset: (x: .64em, top: card-header-height + 1.28em, bottom: card-footer-height + .64em),
    clip: true,
    breakable: false,
    body,
  )
}

#let _card-footer(infotext: none) = place(
  bottom + left,
  block(
    width: 100%,
    height: card-footer-height,
    clip: true,
    breakable: false,
    stroke: (top: .6pt + theme.muted),
    {
      set align(center + horizon)
      set text(9pt, theme.muted)
      grid(
        columns: (auto, 1fr, auto),
        column-gutter: 1em,
        {
          document.use-value(
            "class",
            class => [#{
                class
              }.],
          )
          document.use-value("number", v => [#v])
          " "
          document.use-value("title", v => [#v])
          ", "
          document.use-value("version", ver => [v#ver])
        },
        align(
          center,
          document.use-value(
            "license",
            l => if cc-is-valid(l) {
              ccicon(l)
            },
          ),
        ),
        align(right, infotext),
      )
    },
  ),
)

#let _help-token(label) = box(
  fill: theme.cards.help,
  stroke: .6pt + rgb(33%, 33%, 33%, 33%),
  inset: (x: .33em, y: .5em),
  radius: 30%,
  text(util.get-text-color(theme.cards.help), weight: "bold", sym.arrow.t + label),
)

#let hilfe-marker(..labels) = {
  place(
    top + right,
    dx: -1cm,
    dy: -2em,
    labels.pos().map(target => {
      show link: set text(util.get-text-color(theme.cards.help), weight: "bold")
      show ref: it => context link(
        it.element.location(),
        box(
          fill: theme.cards.help,
          stroke: .6pt + rgb(33%, 33%, 33%, 33%),
          inset: (x: .33em, y: .5em),
          radius: 30%,
          sym.arrow.t + numbering(
            it.element.numbering,
            ..it.element.counter.at(it.element.location()),
          ),
        ),
      )
      ref(target)
    }).join(h(.2em)),
  )
}

#let karte(
  titel: auto,
  infotext: none,
  nr: auto,
  icon: none,
  fill: theme.bg.muted,
  hilfen: none,
  label: none,
  body,
) = {
  let (titel, body) = (titel, body)
  if titel == auto {
    (titel, body) = util.extract-title(body)
  }

  pagebreak(weak: true)

  _card-header(titel, counter: _counter-cards, no: nr, fill: fill, icon: icon, label: label)
  _card-body({
    if hilfen != none {
      hilfe-marker(..hilfen)
    }
    body
  })
  _card-footer(infotext: infotext)
}

#let karte1 = karte.with(fill: theme.cards.type1)
#let karte2 = karte.with(fill: theme.cards.type2)
#let karte3 = karte.with(fill: theme.cards.type3)

#let hilfekarte(
  titel: auto,
  infotext: none,
  nr: auto,
  icon: emoji.ringbuoy,
  fill: theme.cards.help,
  label: auto,
  body,
) = {
  let (titel, body) = (titel, body)
  if titel == auto {
    (titel, body) = util.extract-title(body)
  }

  if nr == auto {
    nr = (
      n,
      ..,
    ) => [H#n#if label != auto {marks.place-reference(label, "card-help", "Hilfekarte", numbering: "H1")}]
  }

  pagebreak(weak: true)
  _card-header(titel, counter: _counter-cards-help, no: nr, fill: fill, icon: icon, label: none)
  _card-body(body)
  _card-footer(infotext: infotext)
}

#let rueckseite(
  titel: auto,
  infotext: none,
  icon: none,
  fill: theme.cards.back,
  body,
) = {
  let (titel, body) = (titel, body)
  if titel == auto {
    (titel, body) = util.extract-title(body)
  }

  pagebreak(weak: true)
  _card-header-back(titel, fill: fill)
  _card-body(body)
  _card-footer(infotext: infotext)
}

#let leer() = {
  pagebreak(weak: false)
}

// #let loesung = rueckseite.with(titel: "Lösung")

#let loesungskarte(..args) = {
  rueckseite(titel: "Lösungen")[
    #if args.pos() != () {
      args.pos().first()
    }

    #context ex.solutions.display-solutions(ex.get-current-exercise(), title: none)

    #if args.pos().len() > 1 {
      args.pos().last()
    }
  ]
}

#let infotext-loesung(sol) = rotate(180deg, sol)
