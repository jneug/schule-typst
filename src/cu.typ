#import "_imports.typ": *

#let checkup(
  ..args,
  body,
) = {
  let (
    doc,
    page-init,
    tpl,
  ) = base-template(
    type: "CU",
    type-long: "Checkup",

    //_tpl: (:),
    title-block: (doc) => {
        place(right, image("assets/checkmark.svg", width:2cm))
        heading(
        level: 1,
        outlined: false,
        bookmarked: false,
      )[Checkup zur #doc.title: #text(fill:theme.secondary, doc.topic)]
    },

    ..args,
    body,
  )

  {
    show: page-init

    tpl
  }
}

#let skala(..icons, spacing: .5em) = grid(
  columns: icons.pos().len(),
  column-gutter: spacing,
  ..icons.pos()
)
#let skala2 = skala(emoji.thumb.up, emoji.thumb.down)
#let skala3 = skala(emoji.face.beam, emoji.face.neutral, emoji.face.weary)
#let skala4 = skala(emoji.face.beam, emoji.face.happy, emoji.face.diagonal, emoji.face.weary)
#let skala5 = skala(emoji.face.beam, emoji.face.happy, emoji.face.neutral, emoji.face.diagonal, emoji.face.weary)
#let skala6 = skala(
  emoji.face.beam,
  emoji.face.grin,
  emoji.face.happy,
  emoji.face.diagonal,
  emoji.face.frown,
  emoji.face.weary,
)

#let ichkann(
  body,
  aufgaben,
  skala: skala4,
) = (
  [#sym.dots #body],
  [#skala],
  [#aufgaben],
)


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
    [*Ich kann #sym.dots*], [], [*Informationen &
  Aufgaben*],
    ..cells.pos().flatten()
  )
}
