#import "@local/schule:1.0.0": ab
#import ab: *

#show: arbeitsblatt(
  /* @typstyle:off */
  titel: "2. Klausur",
  reihe: "Rechnernetze",
  datum: "27.11.2023",

  nummer: "2",
  fach: "Informatik",
  kurs: "Q1 LK",

  autor: (
    name: "J. Neugebauer",
    kuerzel: "Ngb",
  ),

  version: datetime.today(),
)

#lorem(600)
