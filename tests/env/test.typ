#import "@local/schule:1.0.0": ab
#import ab: *

#let test-env(name) = context if marks.in-env(name) [
  In "#name".
] else [
  Not in "#name"
]

#test-env("content")

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

#test-env("content")

#test-env("appendix")

#test-env("test-env")
#marks.env-open("test-env")

#test-env("test-env")

#marks.env-close("test-env")
#test-env("test-env")

#anhang[
  #test-env("content")

  #test-env("appendix")
]

#test-env("content")

#test-env("appendix")
