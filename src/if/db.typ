#import "./erd.typ" as erd
#import "./erd-cetz.typ" as erd2

#let primary-key( name ) = underline(name)
#let foreign-key( name ) = box()[#sym.arrow.t.filled#name]

// #let schema( content ) = raw(block: false, content)
#let schema( content ) = text(weight: "bold", content)
