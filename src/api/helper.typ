#import "../theme.typ"



/// Hilfesfunktion für die Formatierung von Füllfarben für Tabellen.
/// ```example
/// #table(
///   columns: 4,
///   fill: table-fill(
///     footerfill: gradient.linear(..color.map.vlag, angle:90deg),
///     oddfill: color.map.vlag.first(),
///     headers: 2,
///     footers: 1,
///     colheaders: 1,
///     rows: 9
///   ),
///   ..range(36).map(str)
/// )
/// ```
#let table-fill(
  /// Default fill color for cells.
  /// -> color | gradient | tiling
  fill: white,
  /// Fill color for header rows.
  /// -> color | gradient | tiling
  headerfill: theme.table.header,
  /// Fill color for footer rows.
  /// -> color | gradient | tiling
  footerfill: theme.table.header,
  /// Fill color for footer rows.
  /// -> color | gradient | tiling
  oddfill: theme.bg.muted,
  striped: true,
  headers: 1,
  footers: 0,
  colheaders: 0,
  colfooters: 0,
  columns: auto,
  rows: auto,
  fills: (rows: (:), cols: (:)),
) = (column, row) => {
  if row < headers or column < colheaders {
    return headerfill
  } else if rows != auto and (row >= rows - footers) {
    return footerfill
  } else if columns != auto and (column >= columns - colfooters) {
    return footerfill
  } else if "rows" in fills and str(row) in fills.rows {
    return fills.rows.at(str(row))
  } else if "cols" in fills and str(column) in fills.cols {
    return fills.cols.at(str(column))
  } else if striped and calc.odd(row) {
    return oddfill
  } else {
    return fill
  }
}

#let eval-math(term) = {
  // eval(term.text, mode: "math")
  // " = "
  let _eval_term = term.text.replace(":", "/").replace("dot", "*")
  [#eval(_eval_term, mode: "code")]
}

#let repeat(n, sep: pagebreak, body) = {
  for i in range(n) {
    if i > 0 {
      sep()
    }
    body
  }
}

#let pnup(n, body) = {
  grid(
    columns: calc.ceil(calc.sqrt(n)),
    ..for i in range(n) {
      ([#body],)
    },
  )
}
