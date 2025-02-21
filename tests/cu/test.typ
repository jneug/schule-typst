#import "@local/schule:1.0.0": cu
#import cu: *

#show: checkup(
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

#lorem(50)


#checkup-table(
  ichkann("Lesen")[
    - #bu(110, 111)
    - #bu((112, 113), (1, 2, 4, 5, 6, 8, 10, 11))
  ],
  trenner("Neues Thema"),
  ichkann("Lesen")[
    - #ab(110, 111)
    - #ah((112, 113), (1, 2, 4, 5, 6, 8, 10, 11))
  ],
)
