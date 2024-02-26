#import "./erd.typ"

#let primary-key( name ) = underline(stroke:.1em, offset:2pt, name)
#let foreign-key( name ) = box()[#sym.arrow.t.filled#name]

// #let schema( content ) = raw(block: false, content)
// #let schema( content ) = text(weight: "bold", content)
// #let schema( name, ..attributes ) = {
//   text(weight: "bold", name); [(#attributes.pos().join(", "))]
// }

#let schema( ..relations ) = {
  if relations.pos().len() == 0 {
    return []
  }

  if type(relations.pos().first()) == str {
    let (name, ..attris) = (..relations.pos())
    text(weight: "bold", name + "("); [#attris.join(", ")]; text(weight: "bold", name + ")")
  } else {
    set align(left)
    list(
      marker: "",
      ..relations.pos().map(
        ((name, ..attris)) => text(weight: "bold", name + "(") + [#attris.join(", ")] + text(weight: "bold", ")")
      )
    )
  }
}
