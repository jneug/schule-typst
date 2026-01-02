#import "core/base.typ": appendix, base-template, document, layout

#import "util/marks.typ"
#import "util/args.typ"
#import "util/util.typ"

#import "util/typing.typ" as t
#import "theme.typ"

#import "api/typo.typ": *
#import "api/helper.typ": *
#import "api/content.typ": *
#import "api/aufgaben.typ": *

// Fachspezifische Importe
#import "subjects/computer-science.typ" as info
#import "subjects/math.typ" as mathe

// Some community packages to improve things
#import "_deps.typ" as deps: cetz, meander, shadowed.shadowed, zebraw

#let wrap(fixed, to-wrap, align: top + left, ..args) = meander.reflow({
  meander.placed(align, fixed)
  meander.container()
  meander.content(to-wrap)
})

#let wrap-content = wrap
