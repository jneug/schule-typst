#import "../../src/schule.typ": pt
#import pt: *

#show: praesentation(
  /* @typstyle off */
  titel:         [Touying presentation],
  reihe:         [TYPST-TEST],

  datum:        datetime.today(),

  autor: (
    name:    "J. Neugebauer",
    kuerzel: "Ngb",
    email: "j.neugebauer@helmholtz-gym.de",
    einrichtung: "Helmholtz-Gymnasium Bielefeld"
  ),

  version:       datetime.today(),

  // pt options
  show-progress: true,
  // progress-bar-height: 8pt,
)

= First section

== First slide

#lorem(80) *foo* #lorem(10)

== Second slide

#note(level: 2, lorem(10))

= Second section

== Third slide

=== A heading

#lorem(12)

---

=== Fourth slide

#lorem(10)

#empty-slide()

#image-slide(
  image("wallpaper.jpg", width: 10cm),
)[
  #lorem(10)
]

#full-image-slide(
  image("wallpaper.jpg"),
  mode: "stretch",
)

#focus-slide[
  Attention!
]

#quote-slide(attribution: "Albert Einstein")[
  Something important:
][
  $ E = M C^2 $
]

#link-slide("https://github.com/jneug")

#code-slide[
  ```typst
  #import "@preview/schule:1.0.0": ab
  #import ab: *
  ```
]

= Helper functions

== Notes
#note(lorem(20))

== Helper grid
#draft-grid()

== Positioning
#position((4cm, 3cm), [Some content])
#position((10cm, 8cm), [Some content], angle: 45deg)
