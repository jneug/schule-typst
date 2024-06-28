#import "../../src/schule.typ": pt
#import pt: *

#show: praesentation.with(
  /* @typstyle:off */
  titel:     "Informatik Leistungskurs Q1",
  reihe:     "Schuljahr 2024/25",
  datum:     "01.08.2024",

  nummer:    "1",
  fach:      "Informatik",
  kurs:      "Q1",

  autor: (
    name:    "J. Neugebauer",
    kuerzel: "Ngb",
  ),

  version:   "2024-06-24",
  theme: "digi"
)

#slide(subtitle: "Foo")[
  = Organisatorisches

  - *Bewertungskriterien*
    - Schriftliche Arbeiten (50 #sym.percent)
      - 2 Arbeiten _im Halbjahr_, jeweils 90 Minuten
]


#empty-slide[]

// #empty-slide[
//   #lorem(50)
// ]


// #slide()[
//   = Organisatorisches

//   - *Bewertungskriterien*
//     - Sonstige Mitarbeit (50 #sym.percent)
//       - (Eigenverantwortliche) Beteiligung am Unterricht (Qualität und Quantität)
//       - Präsentation von Lösungen und Zwischenprodukten
//       - Selbstständiges Arbeiten in Kleingruppen
//       - Projektergebnisse

//   #pause

//   #place(
//     center + horizon,
//     link(
//       "https://www.helmholtz-bi.de/lernen/faecher/mathematik-naturwissenschaften/informatik/bewertung-des-bereichs-sonstige-mitarbeit/",
//       note(width: 50%)[
//         Siehe Leistungsbewertungs-\
//         konzept Homepage
//       ],
//     ),
//   )
// ]

#section-slide("Speicherung primitiver Daten")

#image-slide(image("wallpaper.jpg"), align: left, title: "Foo")[
  #lorem(10)
]

#section-slide("Speicherung primitiver Daten", level: 2)

#slide[]

#full-image-slide(image("wallpaper.jpg"))

#subsection-slide[
  = Objektarrays
  #lorem(20)
]

#subsection-slide(level: 2)[
  = Objektarrays
  #lorem(20)
]

#quote-slide()[
  #lorem(33)
]

#link-slide("https://link.ngb.schule/arrays")

#code-slide(light: true)[
  ```java
  public class Muppet implements ComparableContent<Muppet> {
      private String name;
      private String color;
      private double height;
  }
  ```
]
