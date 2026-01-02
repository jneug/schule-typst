
#import "../api/typo.typ": num


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


#let _do-op(op, op1, op2, precision: 8) = {
  let ops = (
    "+": (o1, o2) => o1 + o2,
    "-": (o1, o2) => o1 - o2,
    "*": (o1, o2) => o1 * o2,
    "dot": (o1, o2) => o1 * o2,
    ":": (o1, o2) => o1 / o2,
    "/": (o1, o2) => o1 / o2,
  )
  return calc.round((ops.at(op))(op1, op2), digits: precision)
}

#let number-pyramid(
  nums,
  size: 2cm,
  height: 1cm,
  inset: 2mm,
  stroke: 1pt + black,
  fill: white,
  fill-empty: silver,
  op: "+",
) = {
  let depth = nums.len()
  let max = nums.at(-1).len()
  let mid = max * size / 2
  let stone = rect.with(width: size, height: height, inset: inset, stroke: stroke, fill: fill)

  // Prepare auto values
  for (y, row) in nums.rev().enumerate() {
    let yy = depth - y - 1
    for (x, cell) in row.enumerate() {
      if cell == auto {
        let next-row = nums.at(yy + 1, default: ())
        if next-row.len() >= x + 1 and (next-row.at(x) != none and next-row.at(x + 1) != none) {
          nums.at(yy).at(x) = _do-op(op, next-row.at(x), next-row.at(x + 1))
        } else {
          nums.at(yy).at(x) = none
        }
      }
    }
  }

  block(
    width: max * size,
    height: nums.len() * height,
    {
      for (y, row) in nums.rev().enumerate() {
        let y = depth - y - 1
        for (x, cell) in row.enumerate() {
          place(
            top + left,
            dx: mid - (row.len() / 2 * size) + x * size,
            dy: y * height,
            if cell == none {
              stone(fill: fill-empty)
            } else {
              stone(align(center + horizon, num(cell)))
            },
          )
        }
      }
    },
  )
}
#let zahlenmauer = number-pyramid




#let permutations(curr: (), arr) = {
  if arr != () {
    let perms = ()
    for (i, elem) in arr.enumerate() {
      let raa = arr
      let _ = raa.remove(i)
      perms = perms + permutations(curr: curr + (elem,), raa)
    }
    return perms
  } else {
    return (curr,)
  }
}

#let _primes = (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97)

#let factorize(num, format: n => math.bold(n)) = {
  let factors = ()
  let prime-idx = _primes.position(p => p > num)
  if prime-idx == none {
    prime-idx = _primes.len() - 1
  } else {
    prime-idx = prime-idx - 1
  }
  let prime = _primes.at(prime-idx)
  let remindar = num

  while remindar > 1 {
    if calc.rem(remindar, prime) == 0 {
      factors.push(prime)
      remindar = calc.quo(remindar, prime)
    } else {
      prime-idx -= 1
      prime = _primes.at(prime-idx)
    }
  }
  factors = factors.sorted()

  let dividers = ((factors: (), value: 1),)
  for perm in permutations(factors) {
    for i in range(perm.len() + 1) {
      let facs = perm.slice(0, i)
      dividers.push((
        factors: facs,
        value: facs.fold(1, (p, f) => p * f),
      ))
    }
  }
  dividers = dividers.dedup(key: div => div.value).sorted(key: div => (div.factors.len(), div.value))

  // Generate table output
  table(
    columns: 2,

    table.cell(align: center, colspan: 2, math.equation(str(num) + $=$ + factors.map(str).join($dot$))),

    ..for i in range(factors.len() + 1) {
      (
        if i == 1 [1 Faktor] else [#i Faktoren],
        dividers
          .filter(div => div.factors.len() == i)
          .map(div => {
            if i > 1 {
              $#div.factors.map(str).join($dot$) = #format[#div.value]$
            } else {
              $#format[#div.value]$
            }
          })
          .join(", "),
      )
    },

    table.cell(colspan: 2, align: center)[Insgesamt #format[#dividers.len()] Teiler],
  )
}
