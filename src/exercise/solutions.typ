
#import "../util/util.typ"
#import "../theme.typ"
#import "grading.typ": display-points-list, display-points, display-expectations-list, display-total
#import "../core/document.typ"

#let _solution-block = block.with(
  width: 100%,
  inset: 0.5em,
  fill: theme.bg.solution,
  radius: 4pt,
)


#let display-solution(body, title: "Lösung") = _solution-block[
  === #title
  #body
]

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
  _solution-block[
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
  ]
}

#let display-solutions-page(exercises, title: "Lösung", numbering: "(i)") = {
  pagebreak()

  for (ex-id, ex) in exercises {
    heading(
      level: 3,
      [#title Aufgabe #std.numbering("1", ex.display-number) #h(1fr) (#if ex.sub-exercises != (:) {
          display-total(ex)
        } else { display-points-list(ex, format: p => p.map(str).join(" + ")) })],
    )

    if ex.grading.expectations != () {
      _solution-block(
        document.use-value(
          "solutions-show-expectations",
          value => if value {
            display-expectations-list(ex)
          },
        ),
      )
    }

    util.auto-enum(
      numbering: numbering,
      ..ex.solutions,
    )

    if ex.sub-exercises != () {
      enum(
        numbering: "a)",
        ..for sub-ex in ex.sub-exercises {
          (
            [
              #document.use-value(
                "solutions-show-expectations",
                value => if value and sub-ex.grading.expectations != () {
                  _solution-block(display-expectations-list(sub-ex))
                },
              )

              #if sub-ex.solutions != () {
                util.auto-enum(
                  numbering: numbering,
                  ..sub-ex.solutions,
                )
              } else {
                sym.dash
              }
            ],
          )
        },
      )
    } else if ex.solutions == () {
      sym.dash
    }
  }
}
