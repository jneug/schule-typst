#import "../_deps.typ" as deps
#import deps.ccicons: ccicon, cc-is-valid

#import "../util/marks.typ"
#import "../util/args.typ"
#import "../theme.typ"

#let heading-size(max, min, level) = {
  if level <= 1 {
    max
  } else if level >= 5 {
    min
  } else {
    let t = (level - 1) / 4
    max - (max - min) * calc.sqrt(t)
  }
}

#let heading-weight(level) = {
  if level <= 1 {
    "bold"
  } else if level == 2 {
    "semibold"
  } else if level == 3 {
    "medium"
  } else {
    "regular"
  }
}

#let format-pagenumber(
  current,
  body-start,
  body-end,
  total-pages,
) = {
  if current < body-start or current > total-pages [
    // #sym.dash
  ] else if current > body-end {
    numbering("I", (current - body-end))
    if total-pages - body-end > 2 [
      von #numbering("I", (total-pages - body-end))
    ]
  } else {
    let body-pages = body-end - body-start + 1
    let body-current = current - body-start + 1
    if body-pages > 1 [ #body-current ]
    if body-pages > 2 [ von #body-pages ]
  }
}

#let header-left(doc) = [
  #args.if-none(doc.subject, () => [])
  #args.if-none(doc.class, () => [])
  #{
    let abbr = doc.author.filter(a => "abbr" in a)
    if abbr != () {
      "(" + abbr.map(a => a.at("abbr", default: none)).join(", ") + ")"
    }
  }
]
#let header-center(doc) = (
  context if marks.in-env("appendix") [
    Anhang
  ] else {
    if doc.date != none [
      Datum: #doc.date.display("[day].[month].[year]")
    ] else [
      Datum: #box(move(dy: 2pt, line(length: 3cm)))
    ]
  }
)

#let header-right(doc) = [
  #doc.type-long
  #args.if-none(doc.number, () => [], do: v => [Nr. #v])
  #args.if-none(
    doc.variant,
    () => [],
    do: v => if "variant-icons" in doc {
      doc.variant-icons.at(v, default: str(v))
    } else {
      [#sym.dash #v]
    },
  )
]

#let footer-left(doc) = [
  #args.if-none(doc.version, () => [], do: v => [v#v])
]
#let footer-center(doc) = [
  #args.if-none(
    doc.license,
    () => [],
    do: v => if cc-is-valid(v) {
      ccicon(v)
    } else {
      v
    },
  )
]
#let footer-right(doc) = [
  #context {
    format-pagenumber(
      here().page(),
      marks.get-page(<content-start>),
      marks.get-page(<content-end>),
      //counter(page).final().first(),
      marks.get-page(<post-pages-end>),
    )
  }
]

#let base-header(doc, body-left, body-center, body-right, rule: false) = {
  set text(.88em)
  grid(
    columns: (1fr, 2fr, 1fr),
    inset: 2mm,
    align: (left, center, right),
    body-left,
    body-center,
    ..if rule {
      (
        body-right,
        grid.hline(stroke: .6pt),
      )
    } else {
      (body-right,)
    },
  )
}
#let base-footer(doc, body-left, body-center, body-right, rule: false) = {
  set text(.88em, theme.muted)
  grid(
    columns: (1fr, 4fr, 1fr),
    inset: 2mm,
    align: (left, center, right),
    ..if rule {
      (
        grid.hline(stroke: .6pt + theme.muted),
        body-left,
      )
    } else {
      (body-left,)
    },
    body-center,
    body-right,
  )
}

#let base-title(
  doc,
  rule: true,
) = block(
  below: 0.65em,
  width: 100%,
  {
    set align(center)
    args.if-none(
      doc.topic,
      () => [],
      do: subject => {
        heading(level: 3, outlined: false, bookmarked: false, text(theme.text.subject, smallcaps(subject)))
      },
    )
    args.if-none(
      doc.title,
      () => [],
      do: title => move(
        dy: -0.4em,
        heading(level: 1, outlined: false, bookmarked: false, text(theme.primary, smallcaps(title))),
      ),
    )
    if rule {
      move(dy: -.8em, line(length: 100%))
    } else {
      v(.65em)
    }
  },
)
