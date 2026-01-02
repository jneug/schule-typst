#import "../../src/schule.typ": kl
#import kl: *

#show: klausur(
  /* @typstyle:off */
  titel: "Arbeitsblatt",
  reihe: "Entwicklung eines Typst-Pakets",
  datum: datetime.today(),

  nummer: "1",
  fach: "Typst",
  kurs: "101",

  autor: (
    name: "J. Neugebauer",
    kuerzel: "Ngb",
  ),

  version: "2024-06-25",
)

#aufgabe(titel: "Grundgerüst erstellen", icon: (icons.partner, icons.computer))[
  #lorem(50)
]
