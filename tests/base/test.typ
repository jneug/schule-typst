#import "@local/schule:1.0.0": ab
#import ab: *

#show: arbeitsblatt.with(
  /* @typstyle:off */
  titel:     "Base template test",
  reihe:     "TYPST-TEST",
  datum:     "15.06.2024",

  nummer:    "2",
  fach:      "Informatik",
  kurs:      "Q1 LK",

  autor: (
    name:    "J. Neugebauer",
    kuerzel: "Ngb",
  ),

  version:   "2024-06-15",
)

= Header 1
#lorem(100)

== Header 2
#lorem(100)
