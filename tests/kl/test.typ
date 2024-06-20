#import "@local/schule:1.0.0": kl
#import kl: *

#import "@preview/finite:0.3.0": automaton, layout, transition-table, cetz, draw, powerset

#show: klausur.with(
  autor: "J. Neugebauer",
  kuerzel: "Ngb",
  titel: "1. Klausur",
  reihe: "Automaten und formale Sprachen",
  nummer: "1",
  fach: "Informatik",
  kurs: "Q1 LK",
  version: "2023-09-10",
  fontsize: 10pt,
  dauer: 225,
  datum: "11.09.2023",
  loesungen: "seite",
)

#let vielErfolg = align(right, text(2em, kl.theme.primary, font: "Comic Neue")[Viel Erfolg!])
#let img(src, ..args) = image("2023-Q2.2/" + src, ..args)
#let b = $#h(.2em)|#h(.2em)$

#aufgabe(titel: "Endliche Automaten")[
  @abb:automat1 zeigt den Übergangsgraphen eines endlichen Automaten $G$.

  #figure(
    automaton(
      (
        q0: (q1: 0, q2: 0),
        q2: (q3: 1, q4: 0),
        q4: (q2: 0, q5: 0, q6: 0),
        q6: (q7: 1),
        q1: (q3: 1, q4: 0),
        q3: (q1: 1, q5: 1, q6: 1),
        q5: (q7: 1),
        q7: (),
      ),
      layout: layout.group.with(
        grouping: (
          ("q0",),
          ("q1", "q2", "q3", "q4", "q5", "q6"),
          ("q7",),
        ),
        spacing: 2,
        layout: (
          layout.linear,
          layout.grid.with(columns: 3, spacing: 2.6),
          layout.linear,
        ),
      ),
      style: (
        transition: (curve: 0),
        q1-q3: (curve: 1),
        q3-q1: (curve: 1),
        q2-q4: (curve: 1),
        q4-q2: (curve: 1),
        q1-q4: (label: (pos: .95)),
        q2-q3: (label: (pos: .95, dist: -.33)),
        q3-q6: (label: (pos: .95)),
        q4-q5: (label: (pos: .95, dist: -.33)),
      ),
    ),
    caption: [Übergangsgraph eines nicht-deterministischen endlichen Automaten $G$.],
  ) <abb:automat1>

  #teilaufgabe[
    #operator[Begründe], das es sich bei $G$ um einen nichtdeterministischen endlichen Automaten (NEA) handelt und #operator[erkläre], wie sich die formale Definition eines NEA zu der eines deterministischen endlichen Automaten (DEA) unterschiedet.

    #erwartung("Begründet, dass es nicht eindeutige Übergänge im Automaten gibt bzw. Übergänge im Automaten fehlen.", 2)
    #erwartung("Erklärt die Unterschiede zwischen NEAs und DEAs.", 4)

    #loesung[
      - Es gibt Zustände, von denen mehrere Übergänge mit demselben Buchstaben wegführen. (zum Beispiel $q_3$ mit $1$ nach $q_1$, $q_5$ und $q_6$).
      - Es gibt Zustände, für die nicht für alle Buchstaben aus $Sigma$ ein Übergang definiert ist. (Zum Beispiel hat $q_0$ keinen Übergang für $1$.)

      Die Formale Definition eines NEA unterschiedet sich zu einem DEA nur darin, dass die eindeutige _Übergangsfunktion_ des DEA eine _Übergangsrelation_ wird, die zu einer Kombination aus Zustand und Buchstabe auch mehrere Folgezustände (oder gar keinen) enthalten kann.

      In der allgemeinen Definition eines NEA dürfen auch mehrere Startzustände vorhanden sein, wobei wir nur welche mit einem eindeutigen Startzustand betrachten.
    ]
  ]

  #teilaufgabe[
    #operator[Gib] die vollständige formale Beschreibung des NEA $G$ #operator[an]. (Die Übergänge kannst Du in Form einer Übergangstabelle notieren.)

    #erwartung([Gibt das 5-Tupel des NEA $G$ an], 6)

    #loesung[
      #grid(
        columns: (1fr, 1fr),
        [
          $G = (Q, s, Sigma, F, delta)$

          - $Q = {q_0, q_1, dots, q_7}$
          - $Sigma = {0, 1}$
          - $s = q_0$
          - $F = {q_7}$
        ],
        [
          $delta =$
          #transition-table((
            q0: (q1: 0, q2: 0),
            q1: (q3: 1, q4: 0),
            q2: (q3: 1, q4: 0),
            q4: (q2: 0, q5: 0, q6: 0),
            q6: (q7: 1),
            q3: (q1: 1, q5: 1, q6: 1),
            q5: (q7: 1),
            q7: (),
          ))
        ],
      )
    ]
  ]

  #teilaufgabe[
    #operator[Zeige], dass die Worte `011111` und `0001` vom Automaten aus @abb:automat1 akzeptiert werden, indem du jeweils eine akzeptierende Zustandsfolge (Ableitung) #operator[angibst].

    #erwartung([Gibt eine Ableitung für das Wort `011111` an.], 2)
    #erwartung([Gibt eine Ableitung für das Wort `0001` an.], 2)

    #loesung[
      Ableitungen:
      - Ableitung `011111`: $q_0, q_1, q_3, q_1, q_3, q_5, q_7$
      - Ableitung `0001`: $q_0, q_2, q_4, q_6, q_7$
    ]
  ]

  #teilaufgabe[
    #operator[Gib] die beiden kürzesten Wörter #operator[an], die der Automat akzeptiert. (Für diese ist kein Ableitung notwendig)

    #erwartung([Gibt die kürzesten Wörter `0001` und `0111` an.], 2)

    #loesung[
      `0001` und `0111`
    ]
  ]

  #teilaufgabe[
    #operator[Beschreibe] möglichst präzise mit eigenen Worten, welche Sprache vom Automaten $G$ akzeptiert wird.

    #erwartung([Beschreibt präzise die Sprache $L(G)$.], 4)

    #loesung[
      Worte der Sprache $L(G)$ beginnen immer mit $0$ und enden mit $1$. Dazwischen wiederholen sich immer doppelte $0$ oder doppelte $1$ (also $00$ oder $11$) beliebig oft, aber mindestens einmal.
    ]
  ]

  #teilaufgabe[
    #operator[Gib] die Sprache $L(G)$ in Mengenschreibweise #operator[an].

    #erwartung([Gibt die Sprache $L(G)$ in Mengenschreibweise an.], 4)

    #loesung[
      $ L(G) = {0 (00|11)^n 1 | 0 < n in NN} $
    ]
  ]
]

#aufgabe(titel: "Potenzmengenkonstruktion")[
  Bei der Übertragung von binär codierten Daten werden Datenpakete mit mindestens drei Bit immer mit einem Terminatorsymbol aus zwei Nullen (`00`) abgeschlossen. Die Daten zuvor können beliebige Kombinationen aus `1` und `0` sein.

  Der Automat $G_D$ in @abb:automat2 akzeptiert die Sprache
  $L_D = { w | w #text[ist ein gültiges Datenpaket] }$.

  #figure(
    automaton(
      (
        q0: (q1: (0, 1)),
        q1: (q2: (0, 1), q0: (0, 1)),
        q2: (q3: (0, 1), q0: (0, 1)),
        q3: (q4: 0, q0: (0, 1)),
        q4: (q5: 0),
        q5: (),
      ),
      layout: layout.linear.with(spacing: 1.2),
      style: (
        q1-q0: (curve: .5, label: (pos: .2)),
        q2-q0: (curve: 1, label: (pos: .15)),
        q3-q0: (curve: 1.5, label: (pos: .1)),
      ),
    ),
    caption: [Übergangsgraph eines nicht-deterministischen endlichen Automaten $G_D$.],
  ) <abb:automat2>

  #teilaufgabe[
    #operator[Wende] die Potenzmengenkonstruktion auf den NEA $G_D$ an und #operator[gib] den Übergangsgraphen eines äquivalenten DEAs #operator[an], der die Sprache $L_D$ akzeptiert.

    #operator[Zeige], dass die Worte `0100100` und `00000000` von Deinem DEA akzeptiert werden.

    #erwartung([Erstellt einen vollständigen DEA, der genau die Sprache $L_D$ akzeptiert.], 8)
    #erwartung([Gibt Ableitung im DEA für die Worte `0100100` und `00000000` an.], 2)

    #loesung[
      #grid(
        columns: (auto, 1fr),
        gutter: 5mm,
        [
          *Übergangstabelle*
          #transition-table((
            q0: (q1: (0, 1)),
            q1: (q2: (0, 1), q0: (0, 1)),
            q2: (q3: (0, 1), q0: (0, 1)),
            q3: (q4: 0, q0: (0, 1)),
            q4: (q5: 0),
            q5: (),
          ))],
        [
          *Potenzmengenkonstruktion*
          #transition-table(
            powerset((
              q0: (q1: (0, 1)),
              q1: (q2: (0, 1), q0: (0, 1)),
              q2: (q3: (0, 1), q0: (0, 1)),
              q3: (q4: 0, q0: (0, 1)),
              q4: (q5: 0),
              q5: (),
            )),
          )
        ],
      )

      *Übergangsdiagramm*
      #figure(
        automaton(
          powerset((
            q0: (q1: (0, 1)),
            q1: (q2: (0, 1), q0: (0, 1)),
            q2: (q3: (0, 1), q0: (0, 1)),
            q3: (q4: 0, q0: (0, 1)),
            q4: (q5: 0),
            q5: (),
          )),
          final: ("{q0,q1,q2,q3,q5}", "{q0,q1,q2,q3,q4,q5}"),
          layout: (
            "{q0}": (0, 0),
            "{q1}": (2, 0),
            "{q0,q2}": (4, 0),
            "{q0,q1,q3}": (6, 0),
            "{q0,q1,q2}": (6, -2),
            "{q0,q1,q2,q3}": (4, -3),
            "{q0,q1,q2,q4}": (8, 0),
            "{q0,q1,q2,q3,q4}": (4, -6),
            "{q0,q1,q2,q3,q5}": (8, -4),
            "{q0,q1,q2,q3,q4,q5}": (1, -3),
          ),
          style: (
            transition: (curve: 0),
            "{q0,q1,q2,q4}-{q0,q1,q2,q3}": (curve: 1.2),
          ),
        ),
      )

      Ableitungen:
      - Ableitung `0100100`: ${q_0}, {q_1}, {q_0,q_2}, {q_0,q_1,q_3}, {q_0,q_1,q_2,q_4}, {q_0,q_1,q_2,q_3},$ ${q_0,q_1,q_2,q_3,q_4},{q_0,q_1,q_2,q_3,q_4,q_5}$
      - Ableitung `00000000`: ${q_0}, {q_1}, {q_0,q_2}, {q_0,q_1,q_3}, {q_0,q_1,q_2,q_4}, {q_0,q_1,q_2,q_3,q_5},$ ${q_0,q_1,q_2,q_3,q_4}, {q_0,q_1,q_2,q_3,q_4,q_5}, {q_0,q_1,q_2,q_3,q_4,q_5}$
    ]
  ]

  Damit auch mehrere Datenpakete hintereinander übertragen werden können, soll das Format geändert werden. Der Terminator eines Paketes soll nun aus viermal `0` bestehen (`0000`), dafür dürfen die Datenbits zuvor nicht viermal `0` hintereinander enthalten. Akzeptierte Worte sind beispielsweise `11010000`, `11110000` oder auch `000000`.Nicht akzeptiert werden `000010000` oder `111000`. Jedes Paket muss mindestens ein Datenbit enthalten (`0000` ist also nicht gültig).

  #teilaufgabe[
    #operator[Entwickele] eine reguläre Grammatik, die die neue Sprache für Datenpakete produziert und #operator[gib] ihre formale Definition vollständig #operator[an].

    #erwartung([Entwickelt eine Grammatik, die die Sprache produziert.], 6)

    #loesung[
      $G = (N,T,S,P)$

      - $N = {S, A, B, C}$
      - $T = {0, 1}$
      - $P:$
        - $S #sym.arrow.r 0 A #b 1 A$
        - $A #sym.arrow.r 0 B #b 1 A$
        - $B #sym.arrow.r 0 C #b 1 A$
        - $C #sym.arrow.r 0 D #b 1 A$
        - $D #sym.arrow.r 0 #b 1 A$
    ]
  ]

  Damit ein Empfänger die Korrektheit der Daten überprüfen kann, soll den Datenpaketen ein _Prüfbit_ angehängt werden. Als Prüfbit kann beispielsweise `1` gewählt werden, wenn die Anzahl an `1` im Datenpaket gerade ist, ansonsten ist das Prüfbit `0`. Das Prüfbit sorgt also dafür, dass die Anzhal der `1` im Datenpaket immer ungerade ist. Man nennt diese Art eines Prüfbits "Paritätsbit".

  #teilaufgabe[
    #operator[Entscheide begründet], ob es einen endlichen Automaten geben kann, der genau die Datenpakete mit Prüfbit akzeptiert, die ein korrektes Paritätsbit angehängt bekommen haben.

    #erwartung(
      [Begründet, dass ein solcher Automat existieren kann, da ein DEA zwar nicht zählen kann, aber in diesem Fall nur gerade / ungerade entscheiden muss, was möglich ist.],
      4,
    )

    #loesung[
      Es kann einen solchen Automaten geben, da der Automat nicht die Anzahl der `1` "zählen" muss, sondern nur, ob die `1` immer paarweise vorkommen. Dies lässt sich mittels zweier Zustände prüfen, die immer untereinander wechseln.

      #automaton((
        q0: (q1: 1, q0: 0),
        q1: (q0: 1, q1: 0),
      ))
    ]
  ]
]

#aufgabe(titel: "Kommentare in Quelltexten")[
  In höheren Programmiersprachen gibt es in der Regel zwei Arten, den Quelltext mit Kommentaren zu versehen: Zeilen- und Blockkommentare. In Java werden Zeilenkommentare mit `//` eingeleitet. Sie können an einer beliebigen Stelle im Quellcode stehen und ab dem Kommentar bis zum Zeilenende bzw. dem Ende des Quelltextes. Gültige Blockkommentare werden mit `/*` begonnen und enden mit `*/`. die Zeichen `/` und `*` können auch in anderen Kontexten im Quellcode vorkommen.

  #operator[Entwickle] einen deterministischen endlichen Automaten über dem Alphabet $Sigma = { \/, *, \#, z }$, der einen Quelltext darauf prüft, ob er nur gültige (oder keine) Kommentare enthält. (Also alle Worte mit keinen oder gültigen Kommentaren akzeptiert.)

  Dabei steht das Symbol "\#" für ein Zeilenende und "z" für ein beliebiges Zeichen, das nicht eines der anderen Zeichen des obigen Alphabets ist.

  #hinweis[Es reicht die Angabe eines Übergangsgraphen.]

  #erwartung([Zeichnet einen vollständigen DEA, der genau die Kommentar-Sprache akzeptiert.], 10)

  #loesung[
    #set align(center)
    #automaton(
      (
        q0: (q0: "#,*,z", q1: "/"),
        q1: (q0: "#,z,", q2: "/", q3: "*"),
        q2: (q0: "#", q2: "*,/,z"),
        q3: (q4: "*", q3: "#,/,z"),
        q4: (q0: "/", q4: "*", q3: "#,z"),
      ),
      layout: (
        q0: (0, 0),
        q1: (6, 0),
        q2: (3, 4),
        q3: (6, -6),
        q4: (0, -6),
      ),
      style: (
        q0-q0: (anchor: top + left),
        q1-q2: (curve: -1),
        q2-q0: (curve: -1),
        q3-q3: (anchor: right),
        q4-q4: (anchor: left),
      ),
    )
  ]
]

#aufgabe(titel: "Cockatil-Misch-Maschine")[
  In der Bar "DIY-Drinks" können sich die Gäste an einer Cocktail-Misch-Maschine selber eigene Cocktails mischen lassen. Damit die Mischungen auf jeden Fall einigermaßen schmecken, arbeitet die Machine mit einem Mischautomaten, der bestimmte Verhältnisse der Zutaten einhalten soll.

  Als Zutaten können verschiedene Liköre (`l`), Säfte (`s`) und süße Sirupsorten (`i`) eingemischt werden. Der Automat in @abb:automat-cocktails prüft bei der Eingabe, ob ein Rezept dem Mischverhältnis entspricht.

  #figure(
    cetz.canvas({
      import cetz.draw: *
      import draw: *

      set-style(transition: (curve: 0))

      state((0, 0), "q0", initial: true)
      state((5, 0), "q1")
      state((9, 0), "q2", final: true)

      transition("q0", "q0", label: (text: [$(\#,l): A A \#$\ $(A,l): A A A$], dist: .5))
      transition("q0", "q1", label: (text: [$(\#,s): X \#$\ $(A,s): X$\ $(A,i): epsilon$], dist: .75))
      transition("q1", "q1", label: (text: [$(X,s): epsilon$\ $(A,s): X$\ $(A,i): epsilon$], dist: .75))
      transition("q1", "q2", label: (text: [$(\#,epsilon): epsilon$]))
    }),
    caption: [Übergangsgraph eines deterministischen endlichen Kellerautomaten $G_3$.],
  ) <abb:automat-cocktails>

  #teilaufgabe[
    #operator[Beschreibe] die Lesweise und Bedeutung der Übergänge $(\#,l): A A \#$ und $(\#,epsilon): epsilon$ anhand des Automaten $G_3$.

    #operator[Gib] an, nach welchem Mischverhältnis Likör, Saft und Sirup gemischt werden.

    #erwartung([Beschreibt die Lesart für Übergänge in einem Kellerautomaten.], 4)
    #erwartung([Gibt die Verhältnisse an.], 2)

    #loesung[
      $(\#,l): A A \#$ bedeutet, dass das kellersymbol $\#$ ist und als Eingabesymbol ein $l$ gelesen wird. Wenn dies der Fall ist, dann werden die Symbole rechts auf den Keller gelegt zwar von rechts nach links gelesen. Also zuerst ein $\#$ und dann zweimal $A$.

      Der erste Übergang stellt die erste Auswahl einer Zutat dar, da der Keller noch leer ist. In diesem Fall wurde eine Einheit Likör gewählt.

      Der zweite Übergang stellt das Ende eines gültigen Rezepts dar, denn der ÜBergang führt zum einzigen akzeptierenden Zustand und kann nur ausgeführt werden, wenn Keller und Eingabewort leer sind.
    ]
  ]

  Die folgende kontextfreie Grammatik produziert gültige Cocktail-Rezepte.

  #set enum(numbering: n => $p_#n$)
  1. $S #sym.arrow.r l A #b s X$
  2. $A #sym.arrow.r B C$
  3. $B #sym.arrow.r s X #b i #b l A C$
  4. $C #sym.arrow.r s X #b i$
  5. $X #sym.arrow.r s$

  (Beachte: Eine kontextfreie Grammatik unterliegt nicht den Einschränkungen einer regulären Grammatik und darf auf der rechten Seite auch mehr als ein Nichtterminal stehen haben.)

  #teilaufgabe[
    Produziere mit Hilfe der Grammatik ein Rezept für einen alkoholischen und einen alkoholfreien Cocktail.

    #erwartung([Produziert zwei Worte der Sprache (eines mit `l`am Anfang und eines mit `s`.], 2)

    #loesung[
      *alkoholisch* (eine Einheit Likör und zwei Einheiten Sirup):
      $S #sym.arrow.r l A #sym.arrow.r l B C #sym.arrow.r l i C #sym.arrow.r l i i$

      *nicht-alkoholisch* (zwei Einheiten Saft):
      $S #sym.arrow.r s X #sym.arrow.r s s$
    ]
  ]

  #teilaufgabe[
    #operator[Entwickele] schrittweise eine Ableitung für das Rezept `lllssissssiss`, indem Du für jede Ersetzung die angewandte Produktion ($p_1$ bis $p_5$) notierst.

    #erwartung([Gibt eine schrittweise Ableitung des Wortes an.], 4)

    #loesung[
      / $p_1$: $S #sym.arrow.r l A$
      / $p_2$: $#hide[S ]#sym.arrow.r l B C$
      / $p_3$: $#hide[S ]#sym.arrow.r l l A C C$
      / $p_2$: $#hide[S ]#sym.arrow.r l l B C C C$
      / $p_3$: $#hide[S ]#sym.arrow.r l l l A C C C C$
      / $p_2$: $#hide[S ]#sym.arrow.r l l l B C C C C C$
      / $p_3$: $#hide[S ]#sym.arrow.r l l l s X C C C C C$
      / $p_5$: $#hide[S ]#sym.arrow.r l l l s s C C C C C$
      / $p_4$: $#hide[S ]#sym.arrow.r l l l s s i C C C C$
      / $p_4$: $#hide[S ]#sym.arrow.r l l l s s i s X C C C$
      / $p_5$: $#hide[S ]#sym.arrow.r l l l s s i s s C C C$
      / $p_4$: $#hide[S ]#sym.arrow.r l l l s s i s s s X C C$
      / $p_5$: $#hide[S ]#sym.arrow.r l l l s s i s s s s C C$
      / $p_4$: $#hide[S ]#sym.arrow.r l l l s s i s s s s i C$
      / $p_4$: $#hide[S ]#sym.arrow.r l l l s s i s s s s i s X$
      / $p_5$: $#hide[S ]#sym.arrow.r l l l s s i s s s s i s s$
    ]
  ]

  #teilaufgabe[
    #operator[Erkläre] anhand des Automaten $G_3$, warum Gäste der Bar, die keinen Alkohol trinken wollen, eher enttäuscht sind vom Angebot der Bar.

    #erwartung([Erklärt, dass nicht-alkoholische Cocktails nur aus zwei Einheiten Saft bestehen können.], 2)

    #loesung[
      Der Automat kann derzeit nur alkoholfreie Cocktails mischen, die aus zweimal Saft bestehen.
    ]
  ]

  Um ihren Gästen eine größere Auswahl zu bieten, hat "DIY-Drinks" einen neuen Automaten in Auftrag gegeben, der nur nicht-alkoholische Cocktails mixt. Dazu soll je zwei Einheiten Saft (`s`) mit einer Einheit Sodawasser (`w`) und jede Einheit Sirup (`i`) mit zwei Einheiten Sodawasser (`w`) gemischt werden. Zunächst wählen die Kunden Säfte und Sirup aus und am Ende wir das Sodawasser zugegeben.

  #teilaufgabe[
    #operator[Entwickele] den Übergangsgraphen eines Kellerautomaten, der Rezepte der neuen Maschine akzeptiert.

    #erwartung([Entwickelt einen Automaten zur Sprache.], 6)

    #loesung[
      Es reicht, wenn der Automat nur Rezepte akzeptiert, die zweimal `s` hintereinander erkennen und einmal `s` gefolgt von `i` nicht.

      *eingeschränkte Lösung*
      #cetz.canvas({
        import cetz.draw: set-style
        import draw: *

        set-style(transition: (curve: 0))

        state((0, 0), "q0", initial: true)
        state((5, 0), "q1")
        state((9, 0), "q2", final: true)

        transition(
          "q0",
          "q0",
          label: (text: [$(\#,s): X \#$\ $(\#,i): A A \#$\ $(X,s): A$\ $(A,s): X A$\ $(A,i): A A A$], dist: 1.25),
        )
        transition("q0", "q1", label: (text: [$(A,w): epsilon$]))
        transition("q1", "q1", label: (text: [$(A,w): epsilon$]))
        transition("q1", "q2", label: (text: [$(\#,epsilon): epsilon$]))
      })

      *Lösung mit beliebigen `s` und `i` Kombinationen*
      #cetz.canvas({
        import cetz.draw: set-style
        import draw: *

        set-style(transition: (curve: .8))

        state((0, 0), "q0", initial: true)
        state((5, 0), "q1")
        state((9, 0), "q2", final: true)
        state((4, -4), "q3")

        transition("q0", "q0", label: (text: [$(\#,i): A A \#$\ $(A,i): A A A$], dist: .75))
        transition("q0", "q1", label: (text: [$(A,w): epsilon$]))
        transition("q1", "q1", label: (text: [$(A,w): epsilon$]))
        transition("q1", "q2", label: (text: [$(\#,epsilon): epsilon$]))
        transition("q0", "q3", label: (text: [$(\#,s): \#$]))
        transition("q3", "q3", label: (text: [$(\#,i): A A \#$\ $(A,i): A A A$]))
        transition("q3", "q0", label: (text: [$(\#,s): A$]))
      })
    ]
  ]

  Da die Zutaten der ersten Misch-Maschine $G_3$ in @abb:automat-cocktails recht teuer sind, soll eine neue Version der Maschine die Cocktails am Ende des Mischvorgangs pro Anteil Likör mit vier Anteilen Sodawasser auffüllen.

  #teilaufgabe[
    #operator[Beurteile], ob eine solche Änderung am aktuellen Modell des Automaten umsetzbar ist und #operator[begründe] Deine Antwort.

    #erwartung([Begründet, dass die neue Sprache für Rezepte nicht mehr kontextfrei ist.], 4)

    #loesung[
      Die Änderung ist mit einem Kellerautomaten nicht umsetzbar, da der Keller leer ist, nachdem Saft / Sirup eingefüllt wurde und der Automat nicht mehr feststellen kann, wie viel Likör zuvor eingefüllt wurde. Es handelt sich also um eine kontextsensitive Sprache.
    ]
  ]
]

#vielErfolg
