/********************************\
*          Page layout           *
\********************************/

#import "lib/typopts/typopts.typ": options

#import "./theme.typ"
#import "./typo.typ": small, luecke

#import "@preview/tablex:0.0.4": tablex, colspanx, rowspanx, cellx
#import "@preview/wrap-it:0.1.0": wrap-content

// ============================
// Page numbers
// ============================
/// === Seitenzahlen
/// Formatiert die Seitenzahl basierend auf der Anzahl Textseiten, die durch den
/// Inhalt des Dokument erzeugt werden und der Gesamtanzahl Seiten, die im finalen
/// Dokument vorhanden sind. Diese kann von der Anzahl Textseiten abweichen, wenn
/// Inhalte automatisch generiert werden (beispielsweise Lösungen oder
/// Erwartungshorizonte).
/// - #shortex(`#seitenzahl-format(1, 1, 1)`)
/// - #shortex(`#seitenzahl-format(3, 2, 3)`)
/// - #shortex(`#seitenzahl-format(4, 2, 3)`)
/// - #shortex(`#seitenzahl-format(4, 3, 5)`)
/// - #shortex(`#seitenzahl-format(5, 3, 5)`)
///
/// - current (int): Aktuelle Seitenzahl.
/// - body (int): Gesamtanzahl Textseiten im Dokument.
/// - total (int): Gesamtanzahl Seiten im Dokument inklusive automatisch generierte Seiten wie Lösungen.
/// -> content
#let seitenzahl-format(
  current,
  body,
  total,
) = {
  if current > total [
    #sym.dash
  ] else if current > body {
    numbering("I", (current - body))
    if total - body > 2 [
      von #numbering("I", (total - body))
    ]
  } else {
    if body > 1 [ #current ]
    if body > 2 [ von #body ]
  }
}

/// Zeigt die aktuelle Seitenzahl an. Als Standard wird die Seitenzahl mit
/// @@seitenzahl-format formatiert. Es kann aber auch eine eigene Formatfunktion
/// angegeben werden.
/// - #shortex(`#seitenzahl()`)
/// - #shortex(`#seitenzahl(format: (c, b, t) => [#c/#b])`)
///
/// - format (function): Eine Funktion #lambda("int", "int", "int", ret:"content"). Für eine Beschreibung der Paramter siehe @@seitenzahl-format.
#let seitenzahl(format: seitenzahl-format) = locate(loc => {
  let bodyend = query(<body-end>, loc)
  if bodyend != () {
    bodyend = bodyend.first().location().page()
  } else {
    bodyend = counter(page).final(loc).first()
  }
  format(
    counter(page).at(loc).first(),
    bodyend,
    counter(page).final(loc).first(),
  )
})

// =================================
//  Kopf- / Fußzeile
// =================================

/// === Kopf- und Fußzeilen
/// Format für den linken Teil der Kopfzeile.
#let kopfLinks() = [
  #options.display("fach", final: true)
  #options.display("kurs", final: true)
  #options.display(
    "kuerzel",
    format: v => {
      if v != none [(#v)]
    },
    final: true,
  )
]

/// Format für den mittleren Teil der Kopfzeile.
#let kopfMitte() = [
  Datum: #options.display("datum", format: v=>{if v != none [#v.display("[day].[month].[year]")] else [#luecke()]}, final:true)
]

/// Format für den rechten Teil der Kopfzeile.
#let kopfRechts() = [
  #options.display("typ", final: true)
  #options.display(
    "nummer",
    format: v => {
      if v != none [Nr. #v]
    },
    final: true,
  )
]

/// Formatierung der Kopfzeile in drei Teilen: #arg[links], #arg[mitte], #arg[rechts].
#let kopfzeile(
  links: kopfLinks,
  mitte: kopfMitte,
  rechts: kopfRechts,
) = {
  set text(theme.text.header, 0.88em)
  grid(
    columns: (25%, 50%, 25%),
    links(),
    {
      set align(center)
      mitte()
    },
    {
      set align(right)
      rechts()
    },
  )
  box(line(length: 100%, stroke: .5pt))
}

/// Format für den linken Teil der Fußzeile.
#let fussLinks() = [
  #options.display(
    "version",
    format: v => {
      if v != none [ver.#v]
    },
    final: true,
  )
]

/// Format für den mittleren Teil der Fußzeile.
#let fussMitte() = "cc-by-sa-4"

/// Format für den rechten Teil der Fußzeile.
#let fussRechts() = [
  #seitenzahl()
]

/// Formatierung der Fusszeile in drei Teilen: #arg[links], #arg[mitte], #arg[rechts].
#let fusszeile(
  links: fussLinks,
  mitte: fussMitte,
  rechts: fussRechts,
) = {
  set text(theme.text.footer, 0.88em)
  grid(
    columns: (25%, 50%, 25%),
    links(),
    {
      set align(center)
      mitte()
    },
    {
      set align(right)
      rechts()
    },
  )
}

// =================================
//  Figures and tables
// =================================
/// === Abbildungen und Tabellen
/// #example[```
/// #wrapfig(
///   left + horizon,
///   rect(fill:gradient.linear(..color.map.rainbow), width:2cm, height:1.4cm, radius:4pt),
///   lorem(100),
///   gutter: 5mm
/// )
/// ```]
#let wrapfig(
  align,
  width: auto,
  gutter: 0.75em,
  element,
  body,
) = {
  if align.y == none {
    align = align + top
  } else if align.y == horizon {
    align = align.x + top
  }
  if align.x == none {
    align = left + align
  }
  let align-inv = align.inv()

  wrap-content(
    align: align,
    box(
      inset: (
        repr(align-inv.x): gutter,
        repr(align-inv.y): gutter,
      ),
      element,
    ),
    body,
  )
}

/// Hilfesfunktion für die Formatierung von Füllfarben für Tabellen.
/// Die Funktion wird mit der
/// #example[```
/// #table(
///   columns: 4,
///   fill: tablefill(
///     footerfill: gradient.linear(..color.map.vlag, angle:90deg),
///     oddfill: color.map.vlag.first(),
///     headers: 2,
///     footers: 1,
///     colheaders: 1,
///     rows: 9
///   ),
///   ..range(36).map(str)
/// )
/// ```]
#let tablefill(
  fill: white,
  headerfill: theme.table.header,
  footerfill: theme.table.header,
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

/// #example[```
/// #tabular(
///   header: [Eine Tabelle],
///   columns: 4,
///   ..range(36).map(str)
/// )
/// ```]
#let tabular(
  inset: 5pt,
  fill: none,
  line-height: 1.5em,
  header: none,
  footer: none,
  ..args,
) = {
  let insets = (top: 0pt, bottom: 0pt)
  if header != none {
    insets.top = line-height + inset
  }
  if footer != none {
    insets.bottom = line-height + inset
  }
  let _fill(c, r) = if r == -1 {
    theme.table.header
  }
  if fill != none {
    _fill = (c, r) => fill(c, r + 1)
  }
  block(inset: insets)[
    #table(
      inset: inset,
      fill: _fill,
      ..args,
    )
    #if header != none {
      place(top + left, dy: -1 * insets.top)[
        #block(
          width: 100%,
          height: insets.top,
          inset: inset,
          fill: _fill(0, -1),
          stroke: if "stroke" in args.named() {
            args.named().at("stroke")
          } else {
            1pt + black
          },
        )[
          #align(left + horizon)[#header]
        ]
      ]
    }
  ]
}

#let __all__ = (
  seitenzahl-format,
  seitenzahl,
  wrapfig,
  tablefill,
  tabular,
)

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
