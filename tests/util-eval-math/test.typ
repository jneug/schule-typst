#import "../../src/schule.typ": ab
#import ab: *

#show: arbeitsblatt(titel: "Evaluate math test")

#eval-math(`12 + 12`)

#eval-math(`(12 + 12) / 6`)

#let terme = (
  `12 - (7 - 2)`,
  `120 : (4 dot 15)`,
  `4 dot (25 : (15 : 3))`,
  `(25 - 13) : (11 - 7)`,
  `22 : (33 : (5 - 2))`,
  `50 : (30 - (25 - 5))`,
)

#for term in terme [
  - #eval-math(term)
]
