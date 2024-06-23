#import "solutions.typ"
#import "grading.typ"

#import "../util/marks.typ"
#import "../util/typst.typ"
#import "../util/util.typ"
#import "../core/document.typ"
#import "../theme.typ"

// =================================
//  Validation schema
// =================================
#import "../util/types.typ" as t

#let _grading-schema = t.dictionary(
  (expectations: t.array()),
  default: (expectations: ()),
)
#let _sub-exercise-schema = t.dictionary((
  id: t.string(),
  number: t.integer(),
  grading: t.constant(_grading-schema),
  solutions: t.constant(t.array()),
))
#let _exercise-schema = t.dictionary(
  (
    id: t.string(optional: true),
    number: t.integer(),
    display-number: t.integer(optional: true),
    title: t.string(optional: true),
    icons: t.array(t.content(), default: (), pre-transform: t.coerce.array),
    use: t.boolean(default: true),
    header: t.boolean(default: true),
    pagebreak: t.boolean(default: false),
    label: t.label(
      optional: true,
      pre-transform: (_, it) => if it != none and type(it) == str {
        label(it)
      } else {
        it
      },
    ),
    // grading: t.array(
    //   optional: true,
    //   pre-transform: (..) => (),
    // ),
    grading: t.constant(_grading-schema),
    solutions: t.constant(t.array()),
    sub-exercises: t.constant(t.array()),
  ),
  post-transform: (_, it) => {
    if it.id == none {
      it.id = "ex" + str(it.number)
    }
    if it.display-number == none and it.use {
      it.display-number = it.number
    }
    it
  },
  aliases: (
    "titel": "title",
    "no": "number",
    "nummer": "number",
    "nr": "number",
    "angezeigte-nummer": "display-number",
    "icon": "icons",
    "symbol": "icons",
    "symbole": "icons",
    "anzeigen": "use",
    "nutzen": "use",
    "ueberschrift": "header",
    "neue-seite": "pagebreak",
  ),
)

// =================================
//  States and counters
// =================================
#let _counter-exercises = counter("schule.exercises")
#let _state-exercises = state("schule.exercises", (:))

#let get-exercises(final: true) = {
  if final {
    return _state-exercises.final()
  } else {
    return _state-exercises.get()
  }
}

#let get-exercise(id, final: true) = {
  get-exercises(final: final).at(id, default: none)
}

#let get-current-exercise() = {
  let exercises = get-exercises(final: false)
  if exercises != (:) {
    return exercises.values().last()
  } else {
    return none
  }
}

#let get-current-sub-exercise() = {
  let exercises = get-exercises(final: false)
  if exercises != (:) {
    let ex = exercises.values().last()
    if ex.sub-exercises != () {
      return ex.sub-exercises.last()
    }
  }
  return none
}

#let update-exercises(update-func) = {
  _state-exercises.update(update-func)
}

#let update-exercise(id, func) = {
  update-exercises(exercises => {
    if id in exercises {
      exercises.at(id) = update-func(exercises.at(id))
    }
    exercises
  })
}

#let update-current-exercise(update-func) = {
  update-exercises(exercises => {
    if exercises != (:) {
      let id = exercises.keys().last()
      let ex = exercises.at(id)
      exercises.at(id) = update-func(ex)
    }
    exercises
  })
}

#let update-sub-exercise(id, sub-ex, update-func) = {
  update-exercises(exercises => {
    if id in exercises {
      let ex = exercises.at(id)
      if ex.sub-exercises.len() >= sub-ex {
        ex.sub-exercises.at(sub-ex - 1) = update-func(ex.sub-exercises.at(sub-ex - 1))
      }
      exercises.at(id) = ex
    }
    exercises
  })
}

#let update-current-sub-exercise(update-func) = {
  update-exercises(exercises => {
    if exercises != (:) {
      let (id, ex) = exercises.pairs().last()
      if ex.sub-exercises != () {
        let sub-ex = ex.sub-exercises.pop()
        ex.sub-exercises.push(update-func(sub-ex))
      }
      exercises.at(id) = ex
    }
    exercises
  })
}

#let _get_next-exercise-number() = {
  query(selector(<exercise>).before(here())).len() + 1
}

#let in-exercise() = marks.in-env("exercise")
#let in-sub-exercise() = marks.in-env("sub-exercise")

// ================================
// =        Point utilities       =
// ================================
#let points-format-join(points, sep: [#h(.1em)+#h(.1em)], prefix: "(", suffix: ")") = {
  align(
    right,
    emph(prefix + points.map(str).join(sep) + suffix),
  )
}

#let points-format-total(points, prefix: "(", suffix: ")") = {
  align(right, prefix + grading.display-points(points.sum()) + suffix)
}

#let points-format-margin(points) = {
  util.marginnote(
    position: right,
    gutter: .64em,
    block(
      stroke: .6pt + theme.muted,
      fill: theme.bg.muted,
      inset: .2em,
      radius: 10%,
      grading.display-points(
        points.sum(),
        singular: "P",
        plural: "P",
      ),
    ),
  )
}

// =================================
//  Content functions
// =================================
// TODO: use points format function ?
#let exercise(
  ..args,
  body,
) = {
  _counter-exercises.step()

  context {
    let ex-data = args.named()
    ex-data.insert(
      "number",
      _counter-exercises.get().first(),
    )

    ex-data = t.parse(
      ex-data,
      _exercise-schema,
    )

    if ex-data.use {
      ex-data.display-number = _get_next-exercise-number()
    }

    if ex-data.use {
      marks.place-meta(<exercise>, data: ex-data)
      update-exercises(exercises => {
        exercises.insert(ex-data.id, ex-data)
        exercises
      })

      let ic = []
      if ex-data.icons != () {
        ic = marginnote(
          offset: .2em,
          text(size: .88em, theme.secondary, (ex-data.icons,).flatten().join()),
        )
      }

      if ex-data.pagebreak {
        pagebreak()
      }

      heading(level: 2)[
        // Icons
        #ic
        // Numbering
        Aufgabe #numbering("1", ex-data.display-number)
        // Title
        #if ex-data.title != none [
          #h(1.28em)
          #text(theme.text.default, ex-data.title)
        ]
        // Points
        #h(1fr)
        #text(
          theme.secondary,
          .88em,
          context {
            grading.display-total(get-exercise(ex-data.id))
          },
        )
      ]
      if ex-data.label != auto {
        marks.place-reference(
          ex-data.label,
          "exercise",
          "Aufgabe",
        )
      } else {
        marks.place-reference(
          label("ex" + str(ex-data.display-number)),
          "exercise",
          "Aufgabe",
        )
      }

      marks.env-open("exercise")
      body
      marks.env-close("exercise")

      document.get-value(
        "solutions",
        opt => {
          if opt == "after" {
            solutions.display-solutions-block(get-current-exercise())
          }
        },
      )
    }
  }
}

#let sub-exercise(
  use: true,
  points-format: points => none,
  ..args,
  body,
) = {
  if use {
    _counter-exercises.step(level: 2)
    marks.env-open("sub-exercise")

    context {
      let no = _counter-exercises.get().at(1)

      update-current-exercise(ex => {
        let sub-ex = t.parse(
          (
            id: ex.id + "-" + str(no),
            number: no,
            display-number: numbering("a)", no),
            solutions: (),
          ),
          _sub-exercise-schema,
        )

        ex.sub-exercises.push(sub-ex)
        ex
      })
    }

    _counter-exercises.display((ex-no, sub-ex-no, ..) => {
      enum(
        numbering: "a)",
        start: sub-ex-no,
        tight: false,
        spacing: auto,
        {
          marks.place-reference(
            label("ex" + str(ex-no) + "." + str(sub-ex-no)),
            "sub-exercise",
            "Teilaufgabe",
            numbering: "1.a",
          )
          [#body<sub-exercise>]
        },
      )
    })

    marks.env-close("sub-exercise")
    context grading.display-points-list(get-current-sub-exercise(), format: points-format)
  }
}

#let _counter-tasks = counter("schule.tasks")
/// Horizontal angeordnete Aufzählungsliste (z.B. für Unteraufgaben).
/// #example[```
/// #tasks[
///   + Eins
///   + Zwei
///   + Drei
///   + Vier
///   + Fünf
/// ]
/// #tasks(cols: 4, numbering:"(a)")[
///   + Eins
///   + Zwei
///   + Drei
///   + Vier
///   + Fünf
/// ]
/// ```]
///
/// - cols (int): Anzahl Spalten.
/// - gutter (length): Abstand zwischen zwei Spalten.
/// - numbering (string): Nummernformat für die Einträge.
/// - aub-numbering (string): Nummernformat für die Einträge in Teilaufgaben.
/// - body (content): Inhalt mit einer Aufzählungsliste.
/// -> content
#let tasks(
  cols: 3,
  gutter: 4%,
  numbering: "a)",
  sub-numbering: "(1)",
  body,
) = {
  _counter-tasks.update(0)
  grid(
    columns: (1fr,) * cols,
    gutter: gutter,
    ..body.children.filter(c => c.func() in (enum.item, list.item)).map(it => {
      _counter-tasks.step()
      context if in-sub-exercise() {
        _counter-tasks.display(sub-numbering)
      } else {
        _counter-tasks.display(numbering)
      }
      h(.5em)
      it.body
    }),
  )
}

#let solution(body) = {
  context {
    if in-sub-exercise() {
      update-current-sub-exercise(sub-ex => {
        sub-ex.solutions.push(body)
        sub-ex
      })
    } else {
      update-current-exercise(ex => {
        ex.solutions.push(body)
        ex
      })
    }
  }

  document.get-value(
    "solutions",
    opt => {
      if opt == "here" {
        solutions.display-solution(body)
      }
    },
  )
}

#let expectation(text, points) = {
  context {
    if in-sub-exercise() {
      update-current-sub-exercise(sub-ex => {
        sub-ex.grading.expectations.push((
          text: text,
          points: points,
        ))
        sub-ex
      })
    } else {
      update-current-exercise(ex => {
        ex.grading.expectations.push((
          text: text,
          points: points,
        ))
        ex
      })
    }
  }
}
