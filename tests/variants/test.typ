#import "../../src/schule.typ": ab
#import ab: *

#show: arbeitsblatt(
  /* @typstyle:off */
  titel:     "Variants test",
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

  variant: "B"
)


#vari[
  Variant A
][
  Variant B
][
  Variant C
]

- `variant == "B"`: #document.use-value("variant", it => it == "B")
- `variants == ("A", "B", "C")`: #document.use-value("variants", it => it == ("A", "B", "C"))
