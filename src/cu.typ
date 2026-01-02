#import "_imports.typ": *

#let checkup(
  ..args,
) = (
  body => {
    let (
      doc,
      page-init,
      tpl,
    ) = base-template(
      type: "CU",
      type-long: "Checkup",

      _tpl: (
        options: (
          checkmark-icon: t.content(default: icon("document-check", height: 2cm, solid: false)),
        ),
      ),

      title-block: doc => {
        heading(
          level: 1,
          outlined: false,
          bookmarked: false,
        )[#doc.title: #text(fill: theme.secondary, doc.topic)]
      },

      ..args,

      body,
    )

    {
      show: page-init

      tpl
    }
  }
)

#let skala2-icons = (emoji.thumb.up, emoji.thumb.down)
#let skala3-icons = (emoji.face.beam, emoji.face.neutral, emoji.face.weary)
#let skala4-icons = (emoji.face.beam, emoji.face.happy, emoji.face.diagonal, emoji.face.weary)
#let skala5-icons = (emoji.face.beam, emoji.face.happy, emoji.face.neutral, emoji.face.diagonal, emoji.face.weary)
#let skala6-icons = (
  emoji.face.beam,
  emoji.face.grin,
  emoji.face.happy,
  emoji.face.diagonal,
  emoji.face.frown,
  emoji.face.weary,
)


#let skala(..icons, spacing: .5em) = grid(
  columns: icons.pos().len(),
  column-gutter: spacing,
  ..icons.pos()
)
#let skala2 = skala(..skala2-icons)
#let skala3 = skala(..skala3-icons)
#let skala4 = skala(..skala4-icons)
#let skala5 = skala(..skala5-icons)
#let skala6 = skala(..skala6-icons)

#let ichkann(
  body,
  aufgaben,
  skala: skala4,
  rowspan: 1,
) = {
  let row = (
    [#sym.dots #body],
    [#skala],
  )
  if rowspan > 0 {
    row += (
      table.cell(
        rowspan: if rowspan == 0 {
          1
        } else {
          rowspan
        },
      )[#aufgaben],
    )
  }
  return row
}


#let trenner(content) = (table.cell(colspan: 3, fill: theme.table.header, content),)

#let checkup-table(..cells) = {
  let fills = (
    rows: (:),
    cols: (:),
  )
  for (i, row) in cells.pos().enumerate() {
    if row.first().at("colspan", default: 1) > 1 {
      fills.rows.insert(str(i + 1), theme.table.header)
    }
  }
  table(
    columns: (1fr, auto, auto),
    fill: table-fill(fills: fills),
    align: (c, r) => (left + horizon, center + horizon, left + horizon).at(c),
    [*Ich kann #sym.dots*],
    [],
    [*Informationen &
    Aufgaben*],
    ..cells.pos().flatten(),
  )
}

#let checkmark-img = document.use-value("checkmark-icon", v => [#v])
