#import "../theme.typ"

// TODO: Add bonuspoints!

#let get-points(exercise) = if exercise != none and "grading" in exercise {
  exercise.grading.expectations.fold(
    0,
    (a, exp) => a + exp.points,
  )
} else {
  0
}

#let get-total-points(exercise) = {
  let points = get-points(exercise)
  if "sub-exercises" in exercise and exercise.sub-exercises != () {
    points += exercise.sub-exercises.map(get-points).sum()
  }
  return points
}

#let display-points(points, singular: "Punkt", plural: "Punkte") = {
  if points == 0 [] else if points == 1 [#points #singular] else [#points #plural]
}

#let display-total(exercise, singular: "Punkt", plural: "Punkte") = {
  let total = 1
  let total = get-points(exercise)
  if "sub-exercises" in exercise and exercise.sub-exercises != () {
    total += exercise.sub-exercises.map(get-points).sum()
  }
  display-points(total, singular: singular, plural: plural)
}

#let display-points-list(exercise, format: points => points.map(str).join(", ")) = {
  if exercise.grading.expectations != () {
    format(exercise.grading.expectations.map(exp => exp.points))
  }
}

#let display-grading-table(
  exercises,
  grading-table,
) = {
  let (names, thresholds) = (grading-table.keys(), grading-table.values())

  let total-points = exercises.values().map(get-total-points).sum(default: 0)
  let cells = ([Note],)
  for grade in names.rev() {
    cells.push([#grade])
  }
  cells.push([Prozent])
  for thres in thresholds.rev() {
    cells.push([#{
        calc.round(thres * 100)
      }%])
  }
  cells.push([Schwelle])
  for thres in thresholds.rev() {
    cells.push([#{
        calc.floor(total-points * thres)
      }])
  }

  set text(size: 8pt)
  table(
    columns: grading-table.len() + 1,
    inset: 4pt,
    fill: (col, row) => {
      if row == 0 {
        theme.table.header
      } else if row == 1 {
        theme.table.odd
      } else {
        theme.table.even
      }
    },
    align: center + horizon,
    ..cells,
  )
}

// TODO: Add options for tables
#let display-expectations-table(
  exercises,
) = {
  let total-points = exercises.values().map(get-total-points).sum(default: 0)

  let muted-cell = table.cell.with(fill: theme.table.even)
  let header-cell = table.cell.with(fill: theme.table.header)

  set par(leading: .75em)
  table(
    columns: (auto, 1fr, auto, auto),
    inset: 5pt,
    fill: theme.table.odd,
    align: (col, row) => {
      if col in (0, 2, 3) {
        center + horizon
      } else if col == 1 {
        left + horizon
      } else {
        left
      }
    },
    table.header(
      repeat: true,
      header-cell[*Aufg.*],
      header-cell[*Die Schülerin / Der Schüler #sym.dots.h*],
      header-cell[*mögl. \ Punkte*],
      header-cell[*erreicht*],
    ),
    ..for ex in exercises.values() {
      (
        (
          muted-cell[*#{ex.display-number}*],
          muted-cell({
            if ex.title != "" and ex.title != none [*#ex.title*\ ]
            if ex.grading.expectations != () {
              list(
                marker: sym.dots.h,
                body-indent: .2em,
                ..ex.grading.expectations.map(exp => emph(exp.text)),
              )
            }
          }),
          muted-cell({
            if ex.sub-exercises == () {
              display-total(ex, singular: "", plural: "")
            }
          }),
          muted-cell[ ],
        )
          + for sub-ex in ex.sub-exercises {
            if sub-ex.grading.expectations != () {
              (
                numbering("a)", sub-ex.number),
                {
                  if sub-ex.grading.expectations != () {
                    list(
                      marker: sym.dots.h,
                      body-indent: .2em,
                      ..sub-ex.grading.expectations.map(exp => emph(exp.text)),
                    )
                  }
                },
                [#display-total(sub-ex, singular: "", plural: "")],
                [ ],
              )
            }
          }
      )
    },
    header-cell(colspan: 2)[
      #set align(right)
      *Insgesamt*:
    ],
    header-cell[*#total-points*],
    header-cell[],
  )
}

#let display-expectations-table-expanded(exercises) = {
  let total-points = exercises.values().map(get-total-points).sum()

  let muted-cell = table.cell.with(fill: theme.bg.muted)
  let header-cell = table.cell.with(fill: theme.table.header)
  let stroked-cell(i, ..args) = table.cell(
    stroke: (
      top: if i > 0 {
        theme.table.stroke
      },
    ),
    ..args,
  )

  // Build table-rows
  let cells = ()
  for ex in exercises.values() {
    // Add exercise header
    cells += (
      muted-cell(
        rowspan: ex.grading.expectations.len() + 1,
        strong[#ex.display-number],
      ),
      muted-cell(strong(ex.title)),
      muted-cell(strong[#sym.sum #get-total-points(ex)]),
      muted-cell([ ]),
    )
    // Add exercise expectations
    if ex.grading.expectations != () {
      for (i, exp) in ex.grading.expectations.enumerate() {
        cells += (
          stroked-cell(i, text(.88em, emph(exp.text))),
          stroked-cell(i, text(.88em, [#exp.points])),
          stroked-cell(i)[],
        )
      }
    }

    cells += for sub-ex in ex.sub-exercises {
      if sub-ex.grading.expectations.len() > 0 {
        // Number of expectations
        (
          muted-cell(
            rowspan: sub-ex.grading.expectations.len(),
            numbering("a)", sub-ex.number),
          ),
          ..for (i, exp) in sub-ex.grading.expectations.enumerate() {
            (
              stroked-cell(i, emph(exp.text)),
              stroked-cell(i)[#exp.points],
              stroked-cell(i)[],
            )
          },
        )
      }
    }
  }

  set par(leading: .75em)
  table(
    columns: (auto, 1fr, auto, auto),
    inset: 5pt,
    fill: none,
    align: (col, row) => {
      if col in (0, 2, 3) {
        center + horizon
      } else {
        left + horizon
      }
    },
    table.header(
      repeat: true,
      header-cell[*Aufg.*],
      header-cell[*Die Schülerin / Der Schüler #sym.dots.h*],
      header-cell[*mögl. \ Punkte*],
      header-cell[*erreicht*],
    ),
    ..cells,
    header-cell(colspan: 2)[
      #set align(right)
      *Insgesamt*:
    ],
    header-cell[*#total-points*],
    header-cell[],
  )
}

#let display-competencies(
  exercises,
  symbols: (
    emoji.face.smile,
    emoji.face.unhappy,
  ),
  header: "Kompetenz",
) = {
  let comp = (:)
  for (_, ex) in exercises {
    for (key, text) in ex.competencies {
      if key not in comp {
        comp.insert(key, (text: text, exercises: ()))
      }
      comp.at(key).exercises.push(ex.display-number)
    }
  }
  let cells = exercises
    .values()
    .map(ex => ex.competencies)
    .filter(comp => comp.len() > 0)
    .map(c => c.map(x => x.text))
    .flatten()
    .dedup()

  table(
    columns: (auto, auto, 6cm),
    fill: (_, r) => if r == 0 {
      theme.table.header
    } else {
      (theme.table.even, theme.table.odd).at(calc.rem(r, 2))
    },
    align: (left + horizon, center + horizon, auto),
    table.header(
      strong(header),
      strong[Aufg.],
      symbols.join(h(1fr)),
    ),
    ..for (_, c) in comp {
      (c.text, c.exercises.map(str).join(", "), [])
    }
  )
}
