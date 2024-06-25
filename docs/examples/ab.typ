#import "../../src/schule.typ": ab
#import ab: *

#show: arbeitsblatt.with(
  /* @typstyle:off */
  titel:     "Arbeitsblatt",
  reihe:     "Entwicklung eines Typst-Pakets",
  datum:     datetime.today(),

  nummer:    "1",
  fach:      "Typst",
  kurs:      "101",

  autor: (
    name:    "J. Neugebauer",
    kuerzel: "Ngb",
  ),

  version:   "2024-06-25",
)

#infobox[
  = Was ist Typst
  #lorem(100)
]

#aufgabe(titel: "Grundgerüst erstellen", icon: (icon.partner, icon.computer))[
  #lorem(50)
]
