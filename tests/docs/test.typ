#import "../../src/schule.typ": ab, info
#import ab: *
#import info: docs

#show: arbeitsblatt(
  /* @typstyle:off */
  titel: "Base template test",
  reihe: "TYPST-TEST",
  datum: "15.06.2024",

  nummer: "1",
  fach: "Typst",
  kurs: "101",

  autor: (
    name: "J. Neugebauer",
    kuerzel: "Ngb",
  ),

  version: "2024-06-15",
  fontsize: 12.8pt,
)

#page(flipped: true, columns: 2)[
  // #set text(.88em)
  #docs.display("databaseconnector")
  #docs.display("queryresult")
]
