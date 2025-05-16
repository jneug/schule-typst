#import "core/base.typ": base-template, appendix, document, layout

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
#import "_deps.typ" as deps: wrap-content, codly
