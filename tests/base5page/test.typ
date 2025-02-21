#import "@local/schule:1.0.0": ab
#import ab: *

#show: arbeitsblatt(
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

#for i in range(5) {
  if i > 0 {
    pagebreak()
  }
  heading(level: 2, [Heading #{i+1}])
  lorem(300)
}
