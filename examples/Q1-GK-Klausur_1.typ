#import "@local/schule:0.1.1": kl, informatik
#import kl: *
#import informatik: docs

#show: klausur.with(
	autor:   "J. Neugebauer",
	kuerzel: "Ngb",
	titel:   "1. Klausur",
	reihe:   "Objektorientierte Programmierung",
	nummer:  "1",
	fach:    "Informatik",
	kurs:    "Q1 GK",
	version: "2023-09-20",

	fontsize: 10pt,

	dauer: 135,
	datum: "20.09.2023",
	loesungen: "seite",
  punkte-pro-erwartung: true
)

#let key(label) = box(stroke:.5pt + gray, inset:(x:2pt), outset:(y:2pt), radius:2pt, fill:theme.bg.muted, text(.88em, label))

#let arr( len, ..data ) = {
  let d = data.pos() + ([],) * calc.max(0, (len - data.pos().len()))
  table(
    columns: (auto,) + (8mm,) * len,
    fill: (c,r) => if r == 1 { theme.bg.muted },
    align: center,
    [*Inhalt*], ..d.map((v) => [#v]),
    [*Index*], ..range(len).map(str).map(raw)
  )
}

#kltitel()

#aufgabe(titel:"Variablen und Arrays")[
  #teilaufgabe[
    _#operator[Beschreibe], was der Gültigkeitsbereich einer Variablen in Java ist._

    _#operator[Gib] jeweils ein Beispiel an, bei dem der Gültigkeitsbereich einer Variablen eingehalten bzw. verletzt wird._

    #erwartung([Beschreibt das Konzept "Gültigkeitsbereich".], 2)
    #erwartung([Gibt ein Beispiel mit korrektem Gültigkeitsbereich an.], 2)
    #erwartung([Gibt ein Beispiel mit verletztem Gültigkeitsbereich an.], 2)

    #loesung[
      Der _Gültigkeitsbereich_ einer Variablen ist der Bereich einer Methode oder Klasse, in der die Variable _gültig_ ist, also benutzt werden kann. Der Gültigkeitsbereich beginnt ab der Deklaration der Variablen und besteht bis zum Ende des aktuellen Blocks. Dabei ist die Variable auch in verschachtelten Blöcken gültig.

      Eine Ausnahme sind Attribute, die immer in der gesamten Klasse gültig sind.

      *Beispiel:*
      ```java
      int zahl = 0;
      if( zahl > 0 ) {
        int wahr = true;
      }
      if( wahr ) {  // nicht korrekt, da wahr nicht mehr gültig
        zahl = 1;   // korrekt, da verschachtelter Block
      }
      ```
    ]
  ]

  #teilaufgabe[
    _Arrays_ sind eine häufig genutzte lineare Datenstruktur in vielen Programmiersprachen.

    _#operator[Erkläre] die Funktion von Arrays zur Datenspeicherung anhand passender Beispiele._

    #erwartung([Erklärt die Funktion von Arrays zur Datenspeicherung.], 2)
    #erwartung([Gibt passende Beispiele an.], 2)

    #loesung[
      Arrays speichern eine Reihe Variablen gleichen Typs in einer linearen Anordnung im Speicher. Die einzelnen Elemente des Arrays können dann über einen Index angesprochen werden, der bei `0` beginnt.

      Ein Array hat eine feste Größe, die später nicht mehr geändert werden kann. Bei der Initialiierung wird der nötige Speicher für das Array reserviert.
    ]
  ]

  #teilaufgabe[
    _#operator[Analysiere] den Quelltext links, indem du jeweils die Werte der Variablen `a`, `b` und `c` in der Tabelle #operator[notierst]._

	  #hinweis[
      Der `+`-Operator verknüpft zwei Strings miteinander zu einem neuen (Konkatenation): #align(center)[#code(`"Hallo " + "Welt"`) #sym.arrow.r #code(`"Hallo Welt"`)]
    ]

    #table(
      columns: (1fr, 2cm, 2cm, 2cm),
      align: (left, center, center, center),
      [Algorithmus], [`a`], [`b`], [`c`],
      sourcecode[```java
      String a = "x";
      int b = 10;
      for( int c = 1; c < b; c++ ) {
        a = a + "x";
      }
      ```], [], [], [],
      sourcecode[```java
      int a = 0;
      int c = 10;
      for( ; c > 0;  ) {
        a += 1;
        int b = a-1;
        c = c-1;
      }
      ```], [], [], [],
      sourcecode[```java
      int[] arr = new int[4];
      int a = 1;
      while( a <= arr.length ) {
        arr[a-1] = a*a;
        a += 1;
      }
      int b = arr[2];
      int c = arr[3];
      ```], [], [], [],
    )

    #erwartung([Gibt die Werte der Variablen im ersten Code korrekt an.], 2)
    #erwartung([Gibt die Werte der Variablen im zweiten Code korrekt an.], 2)
    #erwartung([Gibt die Werte der Variablen im dritten Code korrekt an.], 2)

    #loesung[
      #table(
        columns: (auto, 2cm, 2cm),
        align: (center, center, center),
        [`a`], [`b`], [`c`],
        `"xxxxxxxxxx"`, `10`, `10`,
        `10`, `9`, `0`,
        `4`, `9`, `16`
      )
    ]
  ]

  #teilaufgabe[
    _#operator[Analysiere] den Quelltext in @lst:arr-wasMacheIch und #operator[beschreibe] möglichst exakt seine Funktionsweise. #operator[Erläutere] dabei insbesondere die Verwendung von Arrays im Algorithmus. Nimm bei deinen Erklärungen Bezug zu den jeweiligen Zeilennummern._

		#figure(
      sourcecode[```java
      public int[] wasMacheIch( int[] a ) {
        int[] b = new int[a.length];

        for( int n = a.length; n > 0; n -= 1 ) {
          for( int i = 0; i < n; i += 1 ) {
            b[n-1] += a[i];
          }
        }

        return b;
      }
      ```],
      caption: [Quelltext der Methode `wasMacheIch`.]
    )<lst:arr-wasMacheIch>

    #erwartung([Analysiert die Methode und beschreibt ihre Funktion.], 6)

    #loesung[

    ]
  ]

  #teilaufgabe[
    Gegegeben ist die Methode #code(`void fuelleArray()`) in @lst:arr-fuelleArray, die ein Array mit Zahlen füllt.

    #figure(sourcecode[```java
      public void fuelleArray( int[] zahlen ) {
        Scanner input = new Scanner(System.in);

        zahlen[0] = 1;
        for( int i = 1; i < zahlen.length; i += 1 ) {
          int neueZahl = input.nextInt();
          zahlen[i] = zahlen[i-1] * neueZahl + i;
        }
      }
      ```],
      caption: [Quelltext der Methode `fuelleArray`.]
    )<lst:arr-fuelleArray>

		In Zeile 6 werden mittels eines Objektes der Klasse `Scanner` Zahlen vom Benutzer abgefragt. Es wird folgende Reihe von Zahlen eingegeben und jeweils mit #key[ENTER] bestätigt:
		#align(center)[1, 8, 0, 10, 4]

		Die Methode wird mit einem leeren Array der Länge sechs aufgerufen:

    #align(center, arr(7))

    #hinweis[Die Methode `nextInt()` der Klasse `Scanner` liest eine vom Benutzer eingegebene Zahl von der Kommandozeile ein.]

		_#operator[Gib] den Zustand des Arrays _nach Zeile 4_ und _nach jeder eingegeben Zahl_ in der oben gezeigten Tabellenform #operator[an]. (Insgesammt also _sechs_ Tabellen.)_

    #erwartung([Gibt die sechs Zustände des Arrays an.], 6)

    #loesung[
      1. #arr(7, 1,0,0,0,0,0,0)
      2. #arr(7, 1,2,0,0,0,0,0)
      3. #arr(7, 1,2,18,0,0,0,0)
      4. #arr(7, 1,2,18,3,0,0,0)
      5. #arr(7, 1,2,18,3,34,0,0)
      6. #arr(7, 1,2,18,3,34,141,0)
    ]
  ]

  #teilaufgabe[
    Die Methode #code(`boolean and( boolean[] pArray )`) erhält ein Array mit Wahrheitswerten als Parameter und prüft, ob _alle_ Werte im Array #code(`true`) sind. Ist dies der Fall, wird #code(`true`) zurückgeleifert, ansonsten #code(`false`). Ist das Array leer, dann ist das Ergebnis auch #code(`false`).

    _#operator[Implementiere] die Methode `and` vollständig._

    #erwartung([Implementiert die Methode entsprechend der Vorgabe.], 4)

    #loesung[
      #sourcecode[```java
      public boolean and(boolean[] pArray) {
        if( pArray.length == 0 ) {
          return false;
        }

        for( int i = 0; i < pArray.length; i += 1 ) {
          if( !pArray[i] ) {
            return false;
          }
        }
        return true;
      }
      ```]
    ]
  ]

  #teilaufgabe[
    Die Methode `shiftArray` in @lst:arr-shiftArray soll die Elemente des Arrays `pArray` um `pShift` Stellen innerhalb des Arrays verschieben. Wird die Methode beispielsweise mit `3` für `pShift` aufgerufen, dann soll das Element an Index `1` an den Index `1 + 3 = 4` verschoben werden.

    _#operator[Beurteile], ob es bei der Ausführung der Methode `shiftArray` zu einer `ArrayIndexOutOfBoundsException` kommen kann. #operator[Begründe] deine Antwort und #operator[erläutere] dabei auch, was diese Exception bedeutet._

    #figure(sourcecode[```java
      public String[] shiftArray( String[] pArray, int pShift ) {
        for( int i = 0; i < pArray.length; i += 1 ) {
          pArray[i + pShift] = pArray[i];
        }
        return pArray;
      }
      ```],
      caption: [Quelltext der Methode `shiftArray`.]
    )<lst:arr-shiftArray>

    #erwartung([Begründet, dass es zu einer Exception kommen kann.], 2)
    #erwartung([Erläutert die Bedeutung der Exception.], 2)

    #loesung[
      Es kommt zu einer `ArrayIndexOutOfBoundsException` sobald der Index `i` den Wert `pArray.length - shift` erreicht. Dann wird versucht auf den Index `i + shift` zuzugreifen, welcher nicht im Array existiert, da er gleich `pArray.length` ist.

      Die Exception tritt auf, wenn ein Index im Array nicht existiert.
    ]
  ]
]

#aufgabe(titel:"Heldenspiel")[
  Eine kleines Startup möchte ein einfaches Rollenspiel mit Helden und Monstern entwickeln. Dazu wurde nach folgender Beschreibung vorgegangen:

  #rahmen[
    Im Spiel gibt es Helden und Monster, die bekämpft werden müssen.
		Helden und Monster können eine Waffe tragen. Eine Waffe hat eine Qualität und einen Waffenbonus. Der Angriffswert einer Waffe berechnet sich aus seiner Qualität multipliziert mit seinem Bonus. Der Angriffswert eines Monsters berechnet sich aus dem Angriffswert des Monsters plus dem Angriffswert seiner Waffe.

		Ein Kampf im Spiel läuft nach einer Kampfregel in Runden ab. Zuerst werden in einer Runde die Angriffswerte der Gegner berechnet und verglichen. Der höhere Angriffswert gewinnt und der Verlierer bekommt 5 Lebenspunkte abgezogen. Ist der Angriffswert des Verlierers aber mindestens halb so groß wie der des Gewinners, dann bekommt auch der Gewinner 2 Lebenspunkte abgezogen.

		Nach einem erfolgreichen Angriff (also wenn dem jeweiligen Gegner Lebenspunkte abgezogen wurden), verliert die benutzte Waffe an Qualität. Diese wird um eins reduziert. Haben beide Gegner noch Lebenspunkte übrig beginnt nun die nächste Kampfrunde.

		Wenn zum Beispiel ein Monster mit einem Angriffswert von $4,5$ und einer Waffe mit dem Bonus $2,5$ und einer Qualität von $8$ gegen einen Helden mit dem berechneten Angriffswert 32 antritt, dann berechnet sich der Angriffswert des Monsters durch $4,5 + 2,5 * 8 = 24,5$. Der Held hat einen Höheren berechneten Angriffswert und gewinnt diese Kampfrunde. Das Monster verliert $5$ Lebenspunkte. Da $24,5$ größer als $32 : 2 = 16$ ist, verliert der Held auch $2$ Punkte. Beide Waffen reduzieren ihre Qualität um eins, da beide Gegner getroffen haben.
  ]

  @abb:heldenspiel-impl zeigt einen Ausschnitt der Modellierung für das Heldenspiel.

	Die Methode `reduziereQualitaet` in der Klasse `Waffe` reduziert die Qualität um eins. Die Methode `addiereLebenspunkte` in `Monster` und `Held` addiert die angegebene Zahl zu den Lebenspunkten und gibt die neuen Lebenspunkte zurück.

  #figure(
    image("images/2023-Q1.1-Abb_Heldenspiel_2.png", width:80%),
    caption: [Implementationsdiagramm zum Heldenspiel.]
  ) <abb:heldenspiel-impl>

	#teilaufgabe[
		Die Klasse `Held` wurde bisher nicht korrekt ins Implementationsdiagramm überführt.

		_#operator[Überführe] die Klasse in ein Implementationsdiagramm, indem Du Dich anhand der Beschreibung oben für passende Datentypen für die Attribute entscheidest. Entscheide für jedes Attribut auch, ob ein Getter und / oder Setter sinnvoll ist. #operator[Begründe] Deine Entscheidungen kurz._

    #erwartung([Gibt Datentypen für alle Attribute an und begründet die Entscheidungen.], 4)
    #erwartung([Entscheidet sich für Getter und Setter und begründet die Entscheidungen.], 4)
  ]

  #teilaufgabe[
      #operator[Implementiere] die Methode #code(`double angriffswertBerechnen()`) in der Klasse `Monster` passend zur Beschreibung oben.

      #erwartung([Implementiert die Methode `angriffswertBerechnen` passend zur Beschreibung.], 6)

      #loesung[
        #sourcecode[```java
        public double angriffswertBerechnen() {
          return waffe.angriffswertBerechnen() + angriffswert;
        }
        ```]
      ]
  ]

  #teilaufgabe[
    #operator[Implementiere] die Methode ```java void kampf(Held pHeld, Monster pMonster)``` der Klasse `Kampfregel` passend zur Beschreibung eines Kampfes. Der Kampf soll dabei immer bis zum Ende durchlaufen (also bis einer der Gegner keine Lebenspunkte mehr hat).

    #erwartung([Implementiert die Methode `kampf` passend zur Beschreibung.], 10)

    #loesung[
      #sourcecode[```java
      public void kampf( Held pHeld, Monster pMonster ) {
        while( pHeld.getLebenspunkte() > 0 && pMonster.getLebenspunkte() > 0 ) {
          double aHeld    = pHeld.angriffswertBerechnen();
          double aMonster = pMonster.angriffswertBerechnen();
          if( aHeld >= aMonster ) {
            pMonster.addiereLebenspunkte(-5);
            pHeld.getWaffe().reduziereQualitaet();
            if( aMonster > aHeld/2 ) {
              pHeld.addiereLebenspunkte(-2);
              pMonster.getWaffe().reduziereQualitaet();
            }
          } else {
            pHeld.addiereLebenspunkte(-5);
            pMonster.getWaffe().reduziereQualitaet();
            if( aHeld > aMonster/2 ) {
              pMonster.addiereLebenspunkte(-2);
              pHeld.getWaffe().reduziereQualitaet();
            }
          }
        }
      }
      ```]
    ]
  ]

  #hinweis[Du kannst bei jeder Teilaufgabe die Methoden der anderen Klassen nutzen, als wären sie vollständig implementiert.]
]
