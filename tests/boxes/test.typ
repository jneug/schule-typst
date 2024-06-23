#import "../../src/schule.typ": ab
#import ab: *

#show: arbeitsblatt.with(
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


#rahmen[
  #lorem(100)
]


#kasten[
  #lorem(100)
]


#schattenbox[
  #lorem(100)
]


#infobox[
  #lorem(100)
]


#warnungbox[
  #lorem(100)
]


#hinweis[
  #lorem(33)
]

#tipp[
  #lorem(33)
]
