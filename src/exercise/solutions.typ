
#import "../util/typst.typ"
#import "../util/util.typ"
#import "../theme.typ"

#let display-solution(body, title: "Lösung") = {
  block(
    width: 100%,
    inset: 0.5em,
    fill: theme.bg.solution,
    radius: 4pt,
    [
      === #title
      #body
    ],
  )
}

#let display-solutions(exercise, title: "Lösungen", numbering: "(i)") = {
  if title != none [
    === #title Aufgabe #exercise.display-number
  ]
  util.auto-enum(
    numbering: numbering,
    ..exercise.solutions,
  )
  enum(
    numbering: "a)",
    ..for sub-ex in exercise.sub-exercises {
      if sub-ex.solutions != () {
        (
          util.auto-enum(
            numbering: "(i)",
            ..sub-ex.solutions,
          ),
        )
      } else {
        (sym.dash,)
      }
    },
  )
}

#let display-solutions-block(exercise, title: "Lösungen", numbering: "(i)") = {
  block(
    width: 100%,
    inset: 0.5em,
    fill: theme.bg.solution,
    radius: 4pt,
    [
      #if title != none [
        === #title Aufgabe #exercise.display-number
      ]
      #util.auto-enum(
        numbering: numbering,
        ..exercise.solutions,
      )
      #enum(
        numbering: "a)",
        ..for sub-ex in exercise.sub-exercises {
          if sub-ex.solutions != () {
            (
              util.auto-enum(
                numbering: "(i)",
                ..sub-ex.solutions,
              ),
            )
          } else {
            (sym.dash,)
          }
        },
      )
    ],
  )
}

#let display-solutions-page(exercises, title: "Lösung", numbering: "(i)") = {
  pagebreak()
  for (ex-id, ex) in exercises {
    heading(level: 3, [#title Aufgabe #typst.numbering("1", ex.display-number)])

    util.auto-enum(
      numbering: numbering,
      ..ex.solutions,
    )

    if ex.sub-exercises != () {
      enum(
        numbering: "a)",
        ..for sub-ex in ex.sub-exercises {
          if sub-ex.solutions != () {
            (
              util.auto-enum(
                numbering: numbering,
                ..sub-ex.solutions,
              ),
            )
          } else {
            (sym.dash,)
          }
        },
      )
    } else if ex.solutions == () {
      sym.dash
    }
  }
}
