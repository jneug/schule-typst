

#let cancelup(base, new, dx: 2pt, dy: -1pt) = $cancel(base)^#move(dx: dx, dy: dy, $new$)$
#let canceldown(base, new, dx: 2pt, dy: 1pt) = $cancel(base)_#move(dx: dx, dy: dy, $new$)$

#let point(..coords) = $(#coords.pos().map(v => $#v$).join($thin|thin$))$
#let vect(name) = $accent(name, arrow)$
#let rem(r) = $med upright(sans("R"))#r$

#let koords(..coords) = $(#coords.pos().map(v => $#v$).join($thin|thin$))$
#let punkt(name, ..coords) = $#name#koords(..coords)$
#let vect(name) = $accent(name, arrow)$
#let rest(r) = $med upright(sans("R"))#r$

#let round(n, decimal) = calc.round(n / decimal) * decimal

#import "math-fractions.typ" as frac
}

