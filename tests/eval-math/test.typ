#import "../../src/schule.typ": ab
#import ab: *

#show: arbeitsblatt(
  /* @typstyle:off */
  titel:     "Base template test",
  reihe:     "TYPST-TEST",
  datum:     "15.06.2024",

  nummer:    "1",
  fach:      "Typst",
  kurs:      "101",

  autor: (
    name:    "J. Neugebauer",
    kuerzel: "Ngb",
  ),

  version:   "2024-06-15",
)

// #eval-math($12 + 12$)

#eval-math(`12 + 12`)

#eval-math(`(12 + 12) / 6`)

- #eval-math(`12 - (7 - 2)`)
- #eval-math(`120 : (4 dot 15)`)
- #eval-math(`4 dot (25 : (15 : 3))`)
- #eval-math(`(25 - 13) : (11 - 7)`)
- #eval-math(`22 : (33 : (5 - 2))`)
- #eval-math(`50 : (30 - (25 - 5))`)
