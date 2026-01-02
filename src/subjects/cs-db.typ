#import "./cs-erd.typ" as erd
#import "../api/helper.typ": table-fill

#import "../theme.typ"

#let primary-key(name) = underline(stroke: .1em, offset: 2pt, name)
#let foreign-key(name) = box()[#sym.arrow.t.filled#name]

#let pkey = primary-key
#let fkey = foreign-key
#let fpkey(name) = primary-key(foreign-key(name))

// #let schema( content ) = raw(block: false, content)
// #let schema( content ) = text(weight: "bold", content)
// #let schema( name, ..attributes ) = {
//   text(weight: "bold", name); [(#attributes.pos().join(", "))]
// }

#let schema(..relations) = block({
  if relations.pos().len() == 0 {
    return []
  }

  set text(font: theme.fonts.sans)

  if type(relations.pos().first()) == str {
    let (name, ..attris) = (..relations.pos(),)
    text(weight: "bold", name + "(")
    [#attris.join(", ")]
    text(weight: "bold", name + ")")
  } else {
    set align(left)
    list(
      marker: "",
      ..relations
        .pos()
        .map(((name, ..attris)) => (
          text(weight: "bold", name + "(")
            + [#attris.join(", ")]
            + text(
              weight: "bold",
              ")",
            )
        )),
    )
  }
})

#let example-data(name: none, headers: (), ids: none, ..data) = {
  let gen-ids = false
  if ids == auto {
    ids = "id"
  }
  if type(ids) == str {
    headers.insert(0, ids)
    gen-ids = true
  }

  let h-len = headers.len()
  headers = headers.map(h => text(hyphenate: false, weight: "bold", h))

  if name != none {
    headers.insert(0, table.cell(colspan: h-len, raw(block: false, name)))
  }

  let data = data.pos()
  if gen-ids {
    data = for (id, row) in data.chunks(h-len - 1).enumerate() {
      row.insert(0, [#id])
      rowf
    }
  }

  table(
    columns: h-len,
    fill: table-fill(
      headers: if name != none {
        2
      } else {
        1
      },
    ),
    table.header(..headers),
    ..data,
  )
}
