#import "@local/schule:1.0.0": wp
#import wp: *

#show: wochenplan(
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

#gruppe("Pflichtaufgaben")[
  #lorem(10)
][
  - #bu((1, 2, 3, 4), (1, 2, 3))
]

#gruppe("Pflichtaufgaben")[
  #lorem(10)
][
  - #bu((1, 2, 3, 4), (1, 2, 3))
]
