#import "@local/schule:1.0.0": ka
#import ka: *
#import mathe: *

#show: klassenarbeit.with(
  autor: (name: "J. Neugebauer", kuerzel: "Ngb"),
  titel: "2. Mathearbeit",
  reihe: "Zuordnungen",
  nummer: "2",
  fach: "Mathematik",
  kurs: "07c",
  version: "2023-11-25",
  variante: "A",
  fontsize: 11pt,
  dauer: 45,
  datum: "27.11.2023",
  loesungen: "seite",
)

#let vielErfolg = {
  /* @typstyle:off */
  let mojis = (
    emoji.heart, emoji.hands.heart, emoji.arm.muscle,
    emoji.heart.box, emoji.frog.face, emoji.dog.face,
    emoji.monkey.face, emoji.hamster.face,
  )
  align(right, text(
    1.4em, theme.primary, weight: "bold", font: "Comic Neue",)[
      Viel Erfolg #mojis.at(calc.rem(datetime.today().day(), mojis.len()))
  ],)
}
#let lsg(x) = math.underline(math.underline(math.bold(x)))

#aufgabe(titel: "Rechnen mit rationalen Zahlen")[
  Berechne die Lösung der Aufgaben. Rechengesetze können Dir helfen.

  #unteraufgaben(cols: 2)[
    - #vari[
        $0,8 dot (-3) + 4,2 dot (-3)$
      ][
        $0,6 dot (-5) + 2,4 dot (-5)$
      ][
        $-2,3 dot 8,8 - 2,3 dot (-10,8)$
      ]
    - #vari[
        $(-20 + 21) dot (8 : (-4))$
      ][
        $((-9) : 3) dot (45 + (-46))$
      ][
        $(5 dot (-9)) : (-13 + 28)$
      ]
    - #vari[
        $0,25 dot 3 / 25 + (-2 / 5) dot 0,75 : 2,5$
      ][
        $5 / 8 dot 3,5 : 1,4 + (-1,25) dot 3 / 20$
      ][
        $0,25 dot 3 / 25 + (-2 / 5) dot 0,75 : 2,5$
      ]
  ]

  #erwartung([berechnet das korrekte Ergebnis der Terme.], 9)

  #loesung[
    + #vari[$
          &quad 0,8 dot (-3) + 4,2 dot (-3) \
          &= (0,8 + 4,2) dot (-3)\
          &= 5,0 dot (-3)\
          &= -15
        $][$
          &quad 0,6 dot (-5) + 2,4 dot (-5)\
          &= (0,6 + 2,4) dot (-5)\
          &= 3,0 dot (-5)\
          &= -15
        $][$
          &quad -2,3 dot 8,8 - 2,3 dot (-10,8)\
          &= -2,3 dot (8,8 - 10,8)\
          &= -2,3 dot (-2)\
          &= 4,6
        $]

    + #vari[$
          &quad (-20 + 21) dot (8 : (-4))\
          &= 1 dot (-2)\
          &= -2
        $][$
          &quad ((-9) : 3) dot (45 + (-46))\
          &= (-3) dot (-1)\
          &= 3
        $][$
          &quad (5 dot (-9)) : (-13 + 28)\
          &= -45 : 15\
          &= -3
        $]

    + #vari[$
          &quad 0,25 dot 3 / 25 + (-2 / 5) dot 0,75 : 2,5\
          &= 1 / 4 dot 3 / 25 + (-2 / 5) dot 3 / 4 : 5 / 2\
          &= 3 / 100 + (-2 / 5) dot 3 / 4 dot 2 / 5\
          &= 3 / 100 + (-(2 dot 3 dot 2) / (5 dot 4 dot 5))\
          &= 3 / 100 + (-12 / 100) \
          &= -9 / 100 = -0,09
        $][$
          &quad 5 / 8 dot 3,5 : 1,4 + (-1,25) dot 3 / 20 \
          &= 5 / 8 dot 7 / 2 : 7 / 5 + (-5 / 4) dot 3 / 20\
          &= 5 / 8 dot 7 / 2 dot 5 / 7 + (-(5 dot 3) / (4 dot 20))\
          &= (5 dot cancelup(7,1) dot 5) / (8 dot 2 dot canceldown(7,1)) + (-(5 dot 3) / (4 dot 20))\
          &= 25 / 16 + (-cancelup(15, 3) / canceldown(80,16)) \
          &= cancelup(28,7) / canceldown(16,4) = 1,75
        $][$
          &quad 0,25 dot 3 / 25 + (-2 / 5) dot 0,75 : 2,5\
          &= 1 / 4 dot 3 / 25 + (-2 / 5) dot 3 / 4 : 5 / 2\
          &= 3 / 100 + (-2 / 5) dot 3 / 4 dot 2 / 5\
          &= 3 / 100 + (-(2 dot 3 dot 2) / (5 dot 4 dot 5))\
          &= 3 / 100 + (-12 / 100) \
          &= -9 / 100 = -0,09
        $]
  ]
]

#aufgabe(titel: "Zuordnungen erkennen I")[
  #operator[Entscheide] für die Zuordnungen, ob sie _proportional_, _antiproportional_ oder _nichts von beidem_ sind. Notiere deine Antwort im Heft und #operator[begründe] deine Entscheidung jeweils.

  #unteraufgaben(cols: 2)[
    - #vari[
        Alter #sym.arrow.r Intelligenz][
        Anzahl Handwerker #sym.arrow.r Benötigte Arbeitszeit][
        Körpergröße #sym.arrow.r Intelligenz
      ]
    - #vari[
        Anzahl Spinnen #sym.arrow.r Anzahl Spinnenbeine][
        Umdrehungen des Rades #sym.arrow.r Gefahrene Strecke][
        Anzahl Autos #sym.arrow.r Anzahl Autoreifen
      ]
    - #vari[
        Anzahl Kinder #sym.arrow.r Anteil vom Geburtstagskuchen][
        Dicke eines Buches #sym.arrow.r Anzahl Bücher im Regal][
        Anzahl Personen #sym.arrow.r Anteil von einer Pizza
      ]
    - #vari[
        Mehl in kg #sym.arrow.r Preis in Euro][
        Länge des Schulwegs #sym.arrow.r Zeit für den Schulweg][
        Liter Milch #sym.arrow.r Preis in Euro
      ]
    - #vari[
        Körpergröße #sym.arrow.r Alter][
        Alter #sym.arrow.r Körpergröße][
        Intelligenz #sym.arrow.r Schulabschluss
      ]
    - #vari[
        Dicke einer Brotscheibe #sym.arrow.r Anzahl an Brotscheiben][
        Intelligenz #sym.arrow.r Alter][
        Volumen eines Glases #sym.arrow.r Anzahl Gläser, um einen Liter Cola komplett einzuschütten
      ]
  ]

  #erwartung([entscheidet sich jeweils für eine Zuordnungsart.], 6)
  #erwartung([begründet jede Entscheidung nachvollziehbar.], 6)

  #loesung[
    - #vari[
        *Alter #sym.arrow.r Intelligenz* #h(1em) nichts
      ][
        *Anzahl Handwerker #sym.arrow.r Benötigte Arbeitszeit* #h(1em) antiproportional (aber nicht unbegrenzt; mit Begründung auch nichts)
      ][
        *Körpergröße #sym.arrow.r Intelligenz* #h(1em) nichts
      ]
    - #vari[
        *Anzahl Spinnen #sym.arrow.r Anzahl Spinnenbeine*: proportional (falls alle Spinnen acht Beine haben)
      ][
        *Umdrehungen des Rades #sym.arrow.r Gefahrene Strecke*: proportional
      ][
        *Anzahl Autos #sym.arrow.r Anzahl Autoreifen Strecke*: proportional
      ]
    - #vari[
        *Anzahl Kinder #sym.arrow.r Anteil vom Geburtstagskuchen*: antiproportional (aber irgendwann werden die Stücke zu klein)
      ][
        *Dicke eines Buches #sym.arrow.r Anzahl Bücher im Regal*: antipropotional
      ][
        *Anzahl Personen #sym.arrow.r Anteil von einer Pizza*: antiproportional
      ]
    - #vari[
        *Mehl in kg #sym.arrow.r Preis in Euro*: proportional (sofern es keine Rabatte gibt)
      ][
        *Länge des Schulwegs #sym.arrow.r Zeit für den Schulweg*: proportional (mit Begründung auch nichts)
      ][
        *Liter Milch #sym.arrow.r Preis in Euro*: proportional (sofern es keine Rabatte gibt)
      ]
    - #vari[
        *Körpergröße #sym.arrow.r Alter*: nichts
      ][
        *Alter #sym.arrow.r Körpergröße*: nichts
      ][
        *Intelligenz #sym.arrow.r Schulabschluss*: nichts
      ]
    - #vari[
        *Dicke einer Brotscheibe #sym.arrow.r Anzahl an Brotscheiben*: antiproportional
      ][
        *Intelligenz #sym.arrow.r Alter*: nichts
      ][
        *Volumen eines Glases #sym.arrow.r Anzahl Gläser, um einen Liter Cola komplett einzuschütten*: antiproportional
      ]
  ]
]

#aufgabe(titel: "Zuordnungen erkennen II")[
  #operator[Entscheide] für die Zuordnungen, ob sie _proportional_ oder _antiproportional_ sind. (Sie sind auf jeden Fall eines von beidem!) Ergänze dann jeweils die fehlenden Werte in den Tabellen.

  #unteraufgaben(cols: 2)[
    - #vari[#table(
          columns: (1cm,) * 7,
          rows: 1cm,
          align: center + horizon,
          fill: (c, r) => if c == 0 {
            luma(244)
          },
          [*x*],
          [0,5],
          [2],
          [3],
          [5],
          [],
          [],
          [*y*],
          [36],
          [],
          [6],
          [],
          [2],
          [1],
        )][#table(
          columns: (1cm,) * 7,
          rows: 1cm,
          align: center + horizon,
          fill: (c, r) => if c == 0 {
            luma(244)
          },
          [*x*],
          [0,25],
          [2],
          [4],
          [],
          [8],
          [],
          [*y*],
          [56],
          [],
          [3,5],
          [2],
          [],
          [1],
        )][#table(
          columns: (1cm,) * 7,
          rows: 1cm,
          align: center + horizon,
          fill: (c, r) => if c == 0 {
            luma(244)
          },
          [*x*],
          [0,25],
          [2],
          [4],
          [],
          [8],
          [],
          [*y*],
          [56],
          [],
          [3,5],
          [2],
          [],
          [1],
        )]
    - #vari[#table(
          columns: (1cm,) * 7,
          rows: 1cm,
          align: center + horizon,
          fill: (c, r) => if c == 0 {
            luma(244)
          },
          [*x*],
          [3],
          [6],
          [],
          [13],
          [15],
          [],
          [*y*],
          [],
          [14],
          [$56 / 3$],
          [],
          [35],
          [70],
        )][#table(
          columns: (1cm,) * 7,
          rows: 1cm,
          align: center + horizon,
          fill: (c, r) => if c == 0 {
            luma(244)
          },
          [*x*],
          [3],
          [4],
          [],
          [13],
          [16],
          [],
          [*y*],
          [25],
          [],
          [75],
          [],
          [$400 / 3$],
          [175],
        )][#table(
          columns: (1cm,) * 7,
          rows: 1cm,
          align: center + horizon,
          fill: (c, r) => if c == 0 {
            luma(244)
          },
          [*x*],
          [3],
          [4],
          [],
          [13],
          [16],
          [],
          [*y*],
          [25],
          [],
          [75],
          [],
          [$400 / 3$],
          [175],
        )]
  ]

  #erwartung([entscheidet sich jeweils für eine Zuordnungsart.], 2)
  #erwartung([berechnet jeweils die fehlenden Werte.], 8)

  #loesung[
    #unteraufgaben(cols: 2)[
      - #vari[#table(
            columns: (1cm,) * 7,
            rows: 1cm,
            align: center + horizon,
            fill: (c, r) => if c == 0 {
              luma(244)
            },
            [*x*],
            [0,5],
            [2],
            [3],
            [5],
            [*9*],
            [*18*],
            [*y*],
            [36],
            [*9*],
            [6],
            [*3,6*],
            [2],
            [1],
          )][#table(
            columns: (1cm,) * 7,
            rows: 1cm,
            align: center + horizon,
            fill: (c, r) => if c == 0 {
              luma(244)
            },
            [*x*],
            [0,25],
            [2],
            [4],
            [*7*],
            [8],
            [*14*],
            [*y*],
            [56],
            [*7*],
            [3,5],
            [2],
            [*1,75*],
            [1],
          )][antiproportional#table(columns: (1cm,)*7, rows: 1cm, align: center+horizon, fill:(c,r) => if c == 0 {luma(244)},
        [*x*], [0,25], [2], [4], [8], [*7*], [*14*],
        [*y*], [56], [*7*], [3,5], [*1,75*], [2], [1]
      )]
      - #vari[#table(
            columns: (1.3cm,) * 7,
            rows: 1cm,
            align: center + horizon,
            fill: (c, r) => if c == 0 {
              luma(244)
            },
            [*x*],
            [3],
            [6],
            [*8*],
            [13],
            [15],
            [*30*],
            [*y*],
            [*7*],
            [14],
            [$56 / 3$],
            [*30 $1/3$*],
            [35],
            [70],
          )][#table(
            columns: (1.3cm,) * 7,
            rows: 1cm,
            align: center + horizon,
            fill: (c, r) => if c == 0 {
              luma(244)
            },
            [*x*],
            [3],
            [4],
            [*9*],
            [13],
            [16],
            [*21*],
            [*y*],
            [25],
            [*33 $1/3$*],
            [75],
            [*108 $1/3$*],
            [$400 / 3$],
            [175],
          )][proportional#table(columns: (1.3cm,)*7, rows: 1cm, align: center+horizon, fill:(c,r) => if c == 0 {luma(244)},
        [*x*], [3], [4], [*9*], [13], [16], [*21*],
        [*y*], [25], [*33$1/3$*], [75], [*108$1/3$*], [133$1/3$], [175]
      )]
    ]
  ]
]

#aufgabe(titel: "Dreisatz")[
  #operator[Berechne] falls möglich die Antwort mit Hilfe des Dreisatzes.

  #enuma[
    + #vari[
        Aus 250 kg Äpfeln erhält man 120 l Apfelsaft. Wie viel Saft erhält man aus 20 kg Äpfeln?
      ][
        12 Brötchen kosten 3,84 €. Wie viele Brötchen kosten 2,24 €?
      ][
        Aus 250 kg Äpfeln erhält man 120 l Apfelsaft. Wie viel Saft erhält man aus 20 kg Äpfeln?
      ]
    + #vari[
        Zwei Maler brauchen 53 Minuten, um ein Zimmer mit 28 m#super[2] zu streichen. Dabei verbrauchen sie 8 l Farbe. Wie lange brauchen 5 Maler für ein Zimmer der gleichen Größe und wie viel Farbe brauchen sie?
      ][
        Vier Freunde fahren in den Urlaub. Sie wechseln sich beim Fahren so ab, dass jeder 93,5 km fährt und sie brauchen 4 Stunden. Wie viele Kilometer müsste jeder fahren, wenn noch zwei Freunde mehr mitkommen? Wie lange brauchen sie dann für den Weg?
      ][
        Drei Bagger brauchen 1,8 Stunden, um eine Grube auszugraben. Sie schichten dabei einen Erdhügel von 2,3 Meter auf. Wie lange brauchen 8 Bagger und wie hoch ist der Erdhügel dann?
      ]
  ]

  #erwartung([berechnet die Lösung (#vari[9,6 Liter][2,24 €][9,6 Liter]) mit dem Dreisatz.], 3)
  #erwartung([berechnet die Lösung (#vari[21,2 Minuten][62 $1/3$ km][0,675 Stunden]) mit dem Dreisatz.], 3)
  #erwartung([erkennt, dass sich die zweite Größe nicht ändert.], 1)

  #loesung[
    + #vari[$
          250 "kg" &arrow.r 120 "liter" \
          10 "kg" &arrow.r 4,8 "liter" \
          20 "kg" &arrow.r 9,6 "liter" \
        $][$
          12 &arrow.r 3,84 €\
          1 &arrow.r 0,32 €\
          7 &arrow.r 2,24 €
        $][$
          250 "kg" &arrow.r 120 "liter" \
          10 "kg" &arrow.r 4,8 "liter" \
          20 "kg" &arrow.r 9,6 "liter" \
        $]
    + #vari[$
          2 &arrow.r 53 "min" \
          1 &arrow.r 106 "min" \
          5 &arrow.r 21,2 "min" \
        $

        Die Menge an Farbe ändert sich nicht, da die zu streichende Fläche gleich bleibt.
      ][$
          4 &arrow.r 93,5 "km"\
          1 &arrow.r 374 "km"\
          6 &arrow.r 62 1 / 3 "km"\
        $
        Die Fahrzeit ändert sich nicht, da die Fahrtstrecke gleich bleibt.
      ][$
          3 &arrow.r 1,8\
          1 &arrow.r 5,4\
          8 &arrow.r 0,675\
        $
        Die Höhe des Berges ändert sich nicht, da die Gleiche Menge an Erde ausgehoben wird.
      ]
  ]
]

#aufgabe(titel: "Personenaufzug")[
  Bei der Planung von Aufzügen geht man meist von einem Durchschnittsgewicht von 80 kg pro Person aus. Der Aufzug eines Kinos ist für #vari[8][12][9] Personen zugelassen.

  Eine Schulklasse mit 30 Kindern, die im Durchschnitt #vari[45][45][48] kg wiegen, möchte mit dem Fahrstuhl in den zweiten Stock fahren. (Die Lehrerinnen nehmen die Treppe.)

  Wie oft muss der Fahrstuhl bei Einhaltung der Vorschriften nach oben fahren, bis alle Kinder im zweiten Stock angekommen sind?

  #erwartung([findet eine passende Rechnung zur Aufgabe.], 1)
  #erwartung([berechnet die Lösung der Aufgabe.], 1)
  #erwartung([formuliert einen passenden Antwortsatz.], 1)

  #loesung[
    Für die Lösung reicht es, die Anzahl der Kinder durch die Anzahl zulässiger Personen pro Fahrt zu teilen und aufzurunden.

    #vari[
      $ 30 : 8 = 3 "R"6 arrow.r 4 "Fahrten" $
    ][
      $ 30 : 12 = 2 "R"6 arrow.r 4 "Fahrten" $
    ][
      $ 30 : 9 = 3 "R"3 arrow.r 4 "Fahrten" $
    ]
  ]
]
