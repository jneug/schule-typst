#import "@local/schule:1.0.0": ab
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

#table(
  columns: 4,
  align: center,
  table.header(
    [Aa],
    [Bb],
    [Cc],
    [Dd],
  ),
  ..range(12).map(str)
)

#table(
  columns: 4,
  align: center,
  fill: table-fill(),
  table.header(
    [Aa],
    [Bb],
    [Cc],
    [Dd],
  ),
  ..range(12).map(str)
)
