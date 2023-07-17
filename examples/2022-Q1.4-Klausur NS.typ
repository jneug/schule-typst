#import "../kl.typ": *
#import "../informatik.typ": *

#show: klausur.with(
	autor:   "J. Neugebauer",
	kuerzel: "Ngb",
	titel:   "4. Klausur",
	reihe:   "Nicht-lineare Datenstrukturen",
	nummer:  "4",
	fach:    "Informatik",
	kurs:    "Q1 LK",
	version: "2023-06-01",

	fontsize: 10pt,

	dauer: 180,
	datum: "05.06.2023",
	loesungen: "sofort",
)

#docstart()
#kltitel()

#aufgabe(titel:"Grundlagen nicht-linearer Datenstrukturen")[

#figure(
	image("images/2022-Q1.4-Abb_Graph.png", width: 50%),
	caption: [Beispielshafte Abbilung einer Graphenstruktur]
) <abb-graph>

#teilaufgabe[
	#operator[Erläutere] die Begriffe Graph, Grad, gewichtet, gerichtet und Kreis anhand des Beispiels in @abb-graph.

	#erwartung("Erläutert jeden der Begriffe mit Bezug zum Beispiel.", 5)

	#loesung[
		/ Graph: Ein Graph besteht aus einer Anzahl an Knoten, die über Kanten miteinander verbunden sind. Eine Kante verbindet immer genau zwei Knoten (wobei die beiden Knoten auch gleich sein können).

		/ Grad: Der Grad eines Knotens ist die Anzahl seiner Kanten. In einem gerichteten Graphen unterscheidet man den Eingangs- und Ausgangsgrad.

		/ gewichtet: Wenn ein Graph gewichtet ist, dann ist jeder Kante ein Kantengewicht (eine Zahl) zugeordnet. Sonst heißt der Graph ungewichtet.

		/ gerichtet: Wenn jede Kante eine Richtung hat, also nur in einer Richtung "befahrbar" ist, dann heißt der Graph gerichtet. Sonst ungerichtet.

		/ Kreis: Ein Kreis in einem Graph stellt einen Weg von einem Knoten über mindestens einen anderen dar, der wieder beim Startknoten endet. Dabei darf kein Knoten im Kreis mehrfach vorkommen.
	]
]

#teilaufgabe[
	#operator[Gib] den in @abb-graph gezeigten Graphen als Adjazenzmatrix an.

	#erwartung("Gibt die Adjazenzmatrix zum Graphen an.", 3)

	#loesung[
		#set align(center)
		#table(
			columns: 5,
			align: center+horizon,
			fill: (c,r) => if c == 0 or r == 0 {theme.tables.header } else { white },
			[], [BZS], [SH], [RH], [MK],
			[BZS], [], [5], [6], [7],
			[SH], [5], [], [2], [4],
			[RH], [6], [2], [], [3],
			[MK], [7], [4], [3], []
		)
	]
]

#teilaufgabe[
	#grid(
		columns: (100%-4.5cm, 4cm),
		[#operator[Gib] die Reihenfolge der Knoten des rechts gezeigten Zahlenbaumes in pre-order Traversierung #operator[an].],
		image("images/2022-Q1.4-Abb_Zahlenbaum.png", width: 4cm),
	)

	#erwartung([Gibt die Knoten in der passenden Reihenfolge an.], 2)

	#loesung[
		$ 29, 32, 1, 12, 43, 91, 15, 1, 7 $
	]
]


#teilaufgabe[
	_#operator[Nimm Stellung] zu der Aussage "_Wählt man einen beliebigen Knoten eines Graphen als Wurzel, dann kann man aus jedem Graphen einen Baum machen._"_.

	#erwartung([Erläutert, dass die Aussage im Allgemeinen nicht zutreffend ist.], 4)

	#loesung[
		Die Aussage kann nicht uneingeschränkt als korrekt angenommen werden. Ein GRaph hat zunächst keine erkennbare Wurzel. Zeichnet man einen Knoten als Wurzel aus, dann muss gleichzeitig angenommen werden, dass der Graph gerichtet ist und der Wurzelknoten keine Vorgänger besitzt. In einem ungerichteten Graphen kann es keine Wurzel geben.
	]
]

]

#aufgabe(titel:"Entscheide-Dich")[

#place(right, image("images/2022-Q1.4-Abb_Buecher.png", width:3cm))
#block(width:100%-3.5cm)[
	"Immer weniger Jugendliche lesen Bücher" -- solche Überschriften gibt es immer
	wieder. Um wieder mehr Jugendliche zum Lesen anzuregen, hat der Buchverlag _LiesMal_ eine besondere Variante des klassischen gedruckten Buchs wiederaufleben lassen: "Entscheide-Dich-Bücher". Am Ende jedes Kapitels kann man selbst entscheiden, wie es weitergehen soll.
]

#figure(
	image("images/2022-Q1.4-Abb_Adventure_Buch_2.png", width:60%),
	caption: [Beispiel für ein Kapitel aus einem Entscheide-Dich-Buch.],
) <abb-kapitel>

Die Entscheidungsstruktur solcher Bücher kann mit Hilfe eines gerichteten Graphen modelliert werden. Jeder Knoten stellt ein Kapitel dar, an dessen Ende eine Entscheidung getroffen wird. Die Nachfolger geben jeweils die Kapitel an, in denen weitergelesen werden kann. Die Entscheidung in @abb-kapitel könnte beispielsweise mit dem in @abb-kapitel-baum dargestellten Baum modelliert werden.

#grid(
	columns: (40%, 60%),
	gutter: 4mm,
	[#figure(
		image("images/2022-Q1.4-Abb_Adventure_Buch_2_Baum.png", width:4cm),
		caption: [Baumdarstellung der Entscheidung in Kapitel 7.],
	) <abb-kapitel-baum>],
	[#figure(
		table(
			columns: 2,
			fill: (c, r) => {
				if r == 0 { theme.tables.header }
				else { white}
			},
			[Kapitel der\ Entscheidung], [Kapitel der Optionen],
			 [1],  [3, 4],
			 [2],  [6],
			 [3],  [2, 5],
			 [4],  [2, 7],
			 [5],  [7, 10],
			 [7],  [3, 8, 9],
			 [9],  [2]
		),
		caption: [Beispielhafte Übersicht der Entscheidungen in einer Entscheide-Dich-Geschichte.],
	) <tab-buch-ablauf>],
)


#teilaufgabe[
	@tab-buch-ablauf zeigt eine tabellarische Übersicht einer solchen Entscheide-Dich-Geschichte.

	_#operator[Erkläre], warum sich die Entscheide-Dich-Bücher des Verlags _nicht_ als _Binärbaum_ modellieren lassen._

	_#operator[Stelle] mit Hilfe der Informationen aus @tab-buch-ablauf die Entscheide-Dich-Geschichte als ungewichteter, gerichteter Graph #operator[dar]._

	#erwartung("Erklärt, dass es teilweise mahr als zwei Entscheidungen bzw. Kreise gibt.", 2)
	#erwartung("Stellt einen zur Tabelle passenden Graphen dar.", 2)

	#loesung[
		#wrapfig(right,
			image("images/2022-Q1.4-Abb_Entscheide_Dich_2_Lsg.png", height:4cm)
		)[
		Da es Kapitel mit mehr als zwei Nachfolgern geben kann (beispielsweise Kapitel 7), kann es sich nicht um einen Binärbaum handeln, da in diesem immer nur maximal zwei  Nachfolger vorhanden sein dürfen. Da auch mehrere Kapitel auf dasselbe Kapitel verweisen können, können Kreise in der Geschichte entstehen, weshalb generell keien Baumstruktur möglich ist.

		#v(1.8cm)
		]
	]
]

Um die Qualität ihrer _Enscheide-Dich-Bücher_ zu optimieren, hat der Verlag _LiesMal_ sein vorhandenes Verwaltungssystem um Funktionen erweitert, mit denen die Autorinnen und Autoren ihre Werke besser planen können. Mit ihnen können die Entscheidungen des Buches analysiert und auf bestimmte Kriterien geprüft werden.

Qualitätsmerkmale eines guten Buches sind beispielsweise eine ausreichend hohe Anzahl verschiedener Enden der Geschichte, damit das Buch mehrfach gelesen werden kann, oder eine ungefähr gleiche länge der Geschichte, egal, zu welchem Ende man liest.

@abb-cd-verwaltung zeigt einen Ausschnitt der Modellierung des Systems.

#figure(
	image("images/2022-Q1.4-Abb_CD_Buch_Verwaltung_2.png", width:100%),
	caption: [Teilmodellierung eines Informatiksystems zur Buchverwaltung.],
) <abb-cd-verwaltung>

#teilaufgabe[
	Um zu ermitteln, ob die kürzesten Wege zu den Enden der Geschichte ungefähr gleicht sind, wird eine Breitensuche vom ersten Kapitel zu allen anderen ausgeführt.

	Außerdem soll ermittelt werden, ob jedes Kapitel in mindestens einem der Wege vorkommt, oder ob einzelne Kapitel auch vollständig "überlesen" werden könnten. Dies sollte vermieden werden.

	_#operator[Stelle] den _Breitensuchbaum_ des Graphen #operator[dar], wenn die Breitensuche beim ersten Kapitel gestartet wird._

	_#operator[Erkläre], woran man die gewünschten Eigenschaften am Breitensuchbaum erkennen kann und #operator[beurteile], ob die vorliegende Geschichte die Kriterien erfüllt._

	#erwartung([Stellt den Breitensuchbaum korrekt dar.], 3)
	#erwartung([Erklärt, dass die erste Eigenschaft erfüllt ist, wenn die Enden in derselben Ebene liegen.], 1)
	#erwartung([Erklärt, dass die erste Eigenschaft erfüllt ist, wenn alle Blätter Enden sind.], 2)
	#erwartung([Zeigt, dass die Geschichte die zweite Eigenschaft verletzt.], 1)

	#loesung[
		#wrapfig(right,
			image("images/2022-Q1.4-Abb_Breitensuchbaum_Lsg.png", width: 4cm)
		)[
		Ob die Wege ungefähr gleich sind erkennt man an der Ebene, in der die Endkapitel liegen. Wenn sie in der gleichen Ebene oder ggf. alle nur mit einer Ebene unterschied liegen, dann sind die kürzeseten Wege ungefähr gleich.

		Gibt es im Baum ein Blatt, dass kein Endkapitel ist, dann ist dies ein Kapitel, dass "überlesen" werden kann.

		Im vorliegenden Fall sind alle Kapitel in der dritten Ebene, die Geschichte erfüllt also dieses Kriterium. Kapitel 9 liegt allerdings auch in Ebene drei und hat keine Nachfolger. Das bedeutet, man könnte jedes Ende erreichen, ohne Kapitel 9 jemals gelesen zu haben.

		#v(5mm)
		]
	]
]

#teilaufgabe[
	Unter der _Reichhaltigkeit_ eines Kapitels versteht man die Anzahl der minimal nötigen Entscheidungen, um zu dem Kapitel zu gelangen. Die Reichhaltigkeit lässt sich anhand des Breitensuchbaumes eines Entschiede-Dich-Buches ermitteln, dem _Entscheidungsbaum_.

	_#operator[Gib] die Reichhaltigkeit der Kapitel 2, 4 und 10 des Entscheide-Dich-Buchs zur @tab-buch-ablauf #operator[an]._

	_#operator[Entwickele] eine allgemeine algorithmische Strategie zur Ermittlung der Reichhaltigkeit eines Kapitels in einem Entscheide-Dich-Buches basierend auf dem Breitensuchbaum und #operator[stelle] sie in geeigneter Form #operator[dar]._

	_#operator[Implementiere] die Methode `ermitteleReichhaltigkeit(int pKapitel, BinaryTree<Integer> pEntscheidungen)` der Klasse `BuchPruefer`._

	#hinweis[Zur Vereinfachung nehmen wir an, dass der Breitensuchbaum eine binäre Struktur hat! Es kann davon ausgegeangen werden, dass der Breitensuchbaum schon vorliegt und dem Algorithmus als Paramter übergeben wird. Des Weiteren nehmen wir an, dass nur Kapitelnummern übergeben werden, die auch im Buch existieren.]

	#erwartung([Ermittelt die Reichhaltigkeiten $2$, $1$ und $3$ für die Kapitel.], 1)
	#erwartung([Entwickelt eine sinnvolle Strategie zur Ermittlung der Reichhaltigkeit.], 4)
	#erwartung([Implementiert die Methode in einem syntaktisch korrekten Algorithmus.], 4)

	#loesung[
		Die Reichhaltigkeit eines Kapitels entspricht der der Länge des Weges zum Kapitel im Baum. Anhand des Breitesuchbaumes lässt sich daher ablesen:

		#align(center, table(
			columns:2,
			align: center,
			[*Kapitel*], [*Reichhaltigkeit*],
			[2], [2],
			[4], [1],
			[10], [3]
		))

		Der Baum der Entscheidungen wird mit einer beliebigen Traversierungsart rekursiv durchsucht, bis der gesuchte Knoten gefunden wurde. Bei jedem Rekursionsaufruf wird ein Zähler erhöht, der die Rekursionstiefe mitzählt. Sobald der gesuchte Knoten gefunden wurde, wird dieser Zähler als Ergebnis zurückgeliefert.

		Sobald die Suche an einem Blatt ankommt, das nicht das gesuchte Kapitel ist, wird -1 zurückgeliefert, als Signal, das die Suche fortgesetzt werden muss.

		#code[
		```java
		public int ermitteleReichhaltigkeit(
			int pKapitel,
			BinaryTree<Integer> pEntscheidungen
		) {
			return ermitteleReichhaltigkeitHilf(
				pKapitel, pEntscheidungen, 0
			);
		}

		private int ermittleleReichhaltigkeitHilf(
			int pKapitel,
			BinaryTree<Integer> pEntscheidungen,
			int pTiefe
		) {
			if( pEntscheidungen.getContent().isEmpty() ) {
				return -1;
			}
			if( pEntscheidungen.getContent() == pKapitel ) {
				return pTiefe;
			}

			return Math.max(
				ermitteleReichhaltigkeitHilf(
					pKapitel, pEntscheidungen.getLeftTree(), pTiefe+1
				),
				ermitteleReichhaltigkeitHilf(
					pKapitel, pEntscheidungen.getRightTree(), pTiefe+1
				)
			)
		}
		```
		]
	]
]

#teilaufgabe[
	Der folgende Programmcode ist in der Klasse `EntscheideDichBuchPruefer` gegeben.

	#code[
	```java
	public int wasTueIch() {
		List<Integer> l = new List<>();

		List<Vertex> v = buch.getEntscheidungen().getVertices();
		v.toFirst();
		while( v.hasAccess() ) {
			Vertex vv = v.getContent();

			int id = Integer.parseInt(vv.getID());
			int r = buch.getReichhaltigkeit(id, buch.getEntscheidungsbaum());

			l.toFirst();
			while( l.hasAccess() ) {
				int rr = buch.getReichhaltigkeit(
					l.getContent(),
					buch.getEntscheidungsbaum()
				);
				if( rr < r ) {
					l.insert(id);
					break;
				} else {
					l.next();
				}
			}
			if( !l.hasAccess() ) {
				l.append(id);
			}

			v.next();
		}

		l.toFirst();
		return l.getContent();
	}
	```
	]

	_#operator[Analysiere] die Methode indem Du die Veränderung der Liste `l` dokumentierst und die funktionsweise des Algorithmus #operator[erläuterst]._

	_#operator[Erläutere], welche Informationen die Methoden im Sachzusammenhang ermitteln._

	#erwartung([Stellt die Veränderungen der Liste `l` dar.], 3)
	#erwartung([Erläutert die Funktionsweise des Algotihmus.], 3)
	#erwartung([Erläutert die Methoden im Sachzusammenhang.], 2)

	#loesung[
		Die Methode `wasTueIch` dient als initialer Aufruf der rekursiven Methode `wasMacheIch` mit dem Baum der Entscheidungen und dem Wert `0` (Zeile 1).

		Die Methode `wasMacheIch` prüft zunächst, ob der übergebene Teilbaum `t` leer ist und liefer in diesem Fall den Wert des Parameters `i` zurück (Zeile 5 bis 7). Dies stellt den *Rekursionsabbruch* dar.

		Dann wird - sofern es mindestens einen linken Teilbaum gibt - der maximale Wert aus den Differenzen des Wurzelinhalts mit den Inhalten der beiden Teilbäume festgestellt und in der Variablen `m` gespeichert (Zeile 9 bis 16).

		Dann wird als Rückgabe das Maximum der Variablen `m` und der Rückgaben von zwei rekursiven Aufrufen der Methode `wasMacheIch` auf den beiden Teilbäumen von `t` gebildet (Zeile 18 bis 24). In Zeile 21 und 22 finden also *Rekursionsaufrufe* statt. Dabei findet eine *Reduktion des Problems*  statt, da Teilbäume mindestens einen Knoten weniger (die Wurzel von `t`) enthalten.

		Die Methode ermittelt im Sachzusammenhang den größten Sprung zwischen zwei Kapiteln, der durch eine Entscheidung verursacht wird.

		Die Bedingung in Zeile 11 ist hier ausreichend, da per Definition im Baum eines Entscheide-Dich-Buchs jeder Knoten entweder keine oder genau zwei Nachfogler besitzt. Daher reicht es zu prüfen, ob ein linker Nachfolger existiert, da dann auch immer ein rechter exisitieren muss.
	]
]

// #teilaufgabe[
// 	Unter einem _vollständigen Binärbaum_ versteht man einen Binärbaum, bei dem alle Knoten entweder 0 oder 2 Nachfolger und alle Blätter dieselbe Tiefe haben.

// 	_#operator[Beurteile] die Überlegung des Verlags, in Zukunft ausschließlich Entscheid-Dich-Bücher zu veröffentlichen, bei denen der zugehörige Binärbaum vollständig ist, im Sachzusammenhang._

// 	#erwartung([Beurteilt die Überlegung hinsichtlich des exponentiellen Wachstums eines Binärbaumes.], 3)
// ]

#teilaufgabe[
	Nach den ersten Veröffentlichungen der neuen _Entscheide-Dich-Bücher_ hat der Verlag Rückmeldungen von ihren Leser:innen erhalten. Ein häufiger Kritikpunkt war, dass die Kapitel teilweise mehrfach gelesen wurden. Einige Kund:innen gaben sogar an, immer wieder dieselben Kapitel zu lesen, ohne ein Ende zu erreichen, bis sie frustiert aufgaben.

	Der Verlag möchte seine Analysewerkzeuge erweitern, um dieser Kritik zu begegnen.

	_#operator[Erläutere], was die Ursache der genannten Probleme sein könnte._

	_#operator[Beschreibe] eine Idee für einen Analysalgorithmus, der den genannten Problemen vorbeugen könnte._

	#erwartung([Erläutert das Problem hinsichtlich entstehender Kreise im Baum.], 3)
	#erwartung([Beschreibt eine Idee für einen Algorithmus.], 2)

	#loesung[
		Der Vorschlag lässt sich mit einem Baum nicht umsetzen, da dies Kreise erzeugen würde, in denen man zu einem Vorgängerknoten eines Knotens "springen" könnte. Dies ist in Baumstrukturen nicht erlaubt.

		Eine Alternative stellt die Datenstruktur Graph dar, da diese keine Einschränkung an die Verbindungen der Knoten vorgibt.
	]
]

// #teilaufgabe[
// 	Eine findige Leserin möchte alle möglichen Optionen, die ein Entscheide-Dich-Buch bietet, entdecken. Dazu geht sie wie folgt vor: Sie wählt am Ende eines Kapitels zunächst immer die erste Option. Wenn sie ein Geschichtsende erreicht, geht sie bis zum nächsten Kapitel zurück, an dessen Ende sie noch mindestens eine Option nicht gewählt hat. Dabei wählt sie immer zuerst die linke und dann die rechte Option. Dies macht sie, bis sie alle Optionen abgearbeitet hat.

// 	_#operator[Entscheide begründet], welcher Baumtraversierung die Strategie dieser Leserin entspricht._
// ]

Das Verlagsportfolio von _LiesMal_ wird für den effizienten Zugriff zentral gespeichert. Dazu werden Objekte der Klasse `Buch` mit dem Buchtitel als Suchkriterium in einem binären Suchbaum verwaltet (vgl. @abb-cd-verwaltung)

#teilaufgabe[
	_#operator[Erläre] das Ordnungsprinzip eines binären Suchbaums._

	_#operator[Gib] ein alternatives Kriterium #operator[an], nach dem Objekte der Klasse `Buch` sinnvoll im Suchbaum abgelegt werden könnten, sowie ein Kriterium, das nicht sinnvoll erscheint._

	_#operator[Begründe] Deine Wahl jeweils._

	#erwartung([Erklärt das Ordnungsprinzip (linker Teilbaum kleiner, rechter Teilbaum größer).], 2)
	#erwartung([Gibt ein sinnvolles und ein weniger sinnvolles Kriterium an.], 2)
	#erwartung([Begründet die Wahl der Kriterien sinnvoll.], 2)

	#loesung[
		In einem binären Suchbaum werden Inhaltsobjekte entsprechend einer Ordnungsrelation einsortiert. Dabei gilt für jeden Knoten im Baum, dass Inhaltsobjekte in seinem linken Teilbaum kleiner als das sein Inhalt sind und Inhaltsobjekte im rechten Teilbaum größer.

		Ein sinnvolles Kriterium ist die ISBN Nummer, da diese eindeutig pro Buch ist.

		Ein nicht sinnvolles Kriterium wäre die Seitenzahl oder auch der Autor / die Autorin, da diese in der Regel nicht eindeutig sind und somit Kollisionen im Suchbaum erzeugt werden würden. Da der Suchbaum keine doppelten Elemente enthalten kann, würden so ggf. Bücher nicht einsortiert werden.
	]
]

#teilaufgabe[
	_#operator[Implementiere] die Methoden `boolean isGreater(Buch pAnderesBuch)`, `boolean isLess(Buch pAnderesBuch)` und `boolean isEqual(Buch pAnderesBuch)` der Klasse `Buch`, so dass Bücher anhand ihres Titels verglichen werden._

	#erwartung([Implementiert die Methoden passend zu den Vorgaben in der Dokumentation.], 4)

	#loesung[
		#code[
		```java
		public boolean isGreater( Buch pContent ) {
			return titel.compareTo(pContent.getTitel()) > 0;
		}

		public boolean isEqual( Buch pContent ) {
			return titel.compareTo(pContent.getTitel()) == 0;
		}

		public boolean isLess( Buch pContent ) {
			return titel.compareTo(pContent.getTitel()) < 0;
		}
		```
		]
	]
]

@abb-suchbaum-verlag zeigt einen Ausschnitt aus dem Protfolio des Verlags. Zur Vereinfachung wurden die in @tab-suchbaum-abk gezeigten Abkürzungen für die Buchtitel verwendet (auch als Sortierschlüssel).

#grid(
	columns: (4.5cm, 100%-4.9cm),
	gutter: 4mm,
	[#figure(
		image("images/2022-Q1.4-Abb_Suchbaum_Verlag.png", width:4cm),
		caption: [Ausschnitt des Suchbaumes des Verlagsportfolios.],
	) <abb-suchbaum-verlag>],
	[#figure(
		table(
			columns: 2,
			fill: (c, r) => {
				if r == 0 { theme.tables.header }
				else { white}
			},
			align: (c, _) => (center, left).at(c),
			[Abkürzung], [Buchtitel],
			[DE], [Drei Entscheidungen für Charlie],
			[AE], [Abenteuerliche Entscheidung],
			[BE], [Biss zur Entscheidung],
			[EE], [Endstation Entscheidung],
			[EM], [Entscheidung bei Mitternacht],
			[GE], [Gute Entscheidungen, Schlechte Entscheidungen],
		),
		caption: [Liste der Abkürzungen für Buchtitel.],
	) <tab-suchbaum-abk>],
)

#teilaufgabe[
	Die folgenden Operationen werden auf dem in @abb-suchbaum-verlag gezeigten Suchbaum ausgeführt:

	- Das Buch "Am Abgrund" (`AA`) wird eingefügt.
	- Das Buch "Freie Entscheidung" (`FE`) wird eingefügt.
	- Das Buch "Gute Entscheidungen, Schlechte Entscheidungen" (`GE`) wird gelöscht.
	- Das Buch "Abenteuerliche Entscheidung" (`AE`) wird gelöscht.

	(Die verwendeten Abkürzungen sind in den Klammern aufgeführt.)

	_#operator[Skizziere] den Suchbaum jeweils, nachdem jede einzelne der Operationen ausgeführt wurde (also insgesamt viermal). Verwende jeweils den Zustand nach einer Operation als Ausgangspunkt für die Ausführung der nächsten._

	_#operator[Erläutere] mit Bezug auf das Beispiel, welche Fälle beim Löschen eines Elements aus einem binären Suchbaum beachtet werden müssen._

	#erwartung([Skizziert den Suchbaum nach jeder Operation.], 4)
	#erwartung([Erläutert die drei Fälle beim Löschen aus einem Suchbaum.], 4)

	#loesung[
		#image("images/2022-Q1.4-Abb_Operationen_Lsg.png", width:100%)


		Beim Löschen kann es drei Fälle geben:

		1. _Der Knoten hat keine Nachfolger (ist ein Blatt)._ Der Knoten kann einfach gelöscht werden.

		  Zum Beispiel könnte in der Ausgangssituation der Knoten "BE" einfach gelöscht werden.
		2. _Der Knoten hat genau einen Nachfolger._ Der Nachfolger des Knotens nimmt den Platz des zu löschenden Knotens ein und wird Nachfolger dessen Vorgängers.

		  Im Beispiel ist dies die dritte Operation ("GE" löschen). Hier wird die Verbindung von der Wurzel "EE" direkt zu "EM" gesetzt.
		3. _Der Knoten hat zwei Nachfolger._ Der Knoten mit dem kleinsten Inhalt aus dem rechten Teilbaum wird gesucht und an die Stelle des zu löschenden Knotens gesetzt. Der alte Knoten mit dem kleinsten Inhalt wird aus dem rechten Teilbaum gelöscht. Da dieser nur maximal einen Nachfolger haben kann, tritt dabei einer der ersten beiden Fälle ein.

		  Dies ist die vierte Operation ("AE" löschen). Hier wird im rechten Teilbaum von "AE" das kleinste Element ("BE") gesucht und an die Stelle von "AE" gesetzt. Dann wird "BE" gelöscht. Da "BE" keine Nachfolger hat, entspricht dies Fall 1.
	]
]

]

#show: anhang.with(flipped:true, columns:2)
#set text(size:0.88em)

== Klassendokumentationen <anhang:dokumentationen>
=== Ausschnitt aus der Dokumentation der Klasse Buch <anh:doc-buch>

Objekte der Klasse `Buch` speichern die Daten eines Buchs im Portfolio des Verlags _LiesMal_.

#docs.method[Buch(String pTitel, String pAutor, int pAnzahlSeiten, int pISBN)][
	Erstellt ein neues Buch mit den übergebenen Werten.
]
#docs.method[String getTitel()][
	Die Methode liefert den Titel des Buchs als String zurück.
]
#docs.method[String getAutor()][
	Die Methode liefert den Namen des Autors bzw. der Autorin des Buchs als String zurück.
]
#docs.method[int getAnzahlSeiten()][
	Die Methode liefert die Anzahl der Seiten des Buchs als Integer zurück.
]
#docs.method[int getISBN()][
	Die Methode liefert die ISBN des Buchs als Integer zurück. (Nur die Ziffern der ISBN ohne Trennzeichen.)
]
#docs.method[boolean isGreater(Buch pAnderesBuch)][
	Wenn festgestellt wird, dass das Objekt, von dem die Methode aufgerufen wird, bzgl. der gewünschten Ordnungsrelation größer als das Objekt `pAnderesBuch` ist, wird `true` geliefert. Sonst wird `false` geliefert.
]
#docs.method[boolean isEqual(Buch pAnderesBuch)][
	Wenn festgestellt wird, dass das Objekt, von dem die Methode aufgerufen wird, bzgl. der gewünschten Ordnungsrelation gleich dem Objekt `pAnderesBuch` ist, wird `true` geliefert. Sonst wird `false` geliefert.
]
#docs.method[boolean isLess(Buch pAnderesBuch)][
	Wenn festgestellt wird, dass das Objekt, von dem die Methode aufgerufen wird, bzgl. der gewünschten Ordnungsrelation kleiner als das Objekt `pAnderesBuch` ist, wird `true` geliefert. Sonst wird `false` geliefert.
]

=== Ausschnitt aus der Dokumentation der Klasse EntscheideDichBuch <anh:doc-entscheidedichbuch>

Objekte der Klasse `EntscheideDichBuch` erweitern die Klasse `Buch` um einen Baum, der die möglichen Entscheidungen im Buch repräsentiert.

#docs.method[EntscheideDichBuch(String pTitel, String pAutor, int pAnzahlSeiten, int pISBN, BinaryTree<Integer> pEntscheidungen)][
Erstellt ein neues Entscheide-Dich-Buch mit den übergebenen Werten.
]
#docs.method[Graph getEntscheidungen()][
	Die Methode liefert den Graph mit Kapiteln des Buchs zurück. Kanten repräsentieren Entscheidungen, die im Buch getroffen werden können.
]
#docs.method[BinaryTree<Integer> getEntscheidungsbaum()][
	Die Methode liefert den Baum mit Entscheidungen des Buchs zurück, nachdem der Graph der Kapitel mit einer Breitensuche durchlaufen wurde, beginnend ab Kapitel 1.
]

=== Ausschnitt aus der Dokumentation der Klasse EntscheideDichBuchPruefer <anh:doc-entscheidedichbuchpruefer>

Objekte der Klasse `EntscheideDichBuchPruefer` erlauben die Analyse verschiedener Aspekte eines Objekts der KLasse `EntscheideDichBuch`.

#docs.method[EntscheideDichBuchPruefer(EntscheideDichBuch pBuch)][
Erstellt einen neuen `EntscheideDichBuchPruefer` für das übergebene `EntscheideDichBuch`.
]
#docs.method[int ermitteleReichhaltigkeit(int pKapitel, BinaryTree<Integer> pEntscheidungen)][
	Ermittelt die _Reichhaltigkeit_ des Kapitels `pKapitel` des Entscheide-Dich-Buches. Die Reichhaltigkeit beschreibt die Anzahl minimal nötiger Entscheidungen, um das Kapitel zu erreichen.
]
#docs.method[int wasTueIch()][
	_Fehlende Dokumentation_
]

=== Dokumentation einzelner Methoden der Java-Bibliothek <anh:doc-java>

==== Methoden der Klasse `String`
#docs.method[compareTo(String pOther)][
	Vergleicht das aktuelle String-Objekt lexikographisch mit dem angegebenen String `pOther`. Die Methode liefert `0`, wenn die Strings gleich sind, `-1`, wenn das aktuelle String-Objekt lexikographisch "kleiner" ist, als der andere String und `1` sonst.
]

==== Methoden der Klasse `Math`
#docs.method[int Math.abs(int pZahl)][
	Liefert den Absolutbetrag der angegebenen Zahl `pZahl`.
]
#docs.method[int Math.max(int a, int b)][
	Liefert das Maximum der angegebenen Zahlen `a` und `b`.
]

#docs.display("binarytree")
#docs.display("binarysearchtree")
#docs.display("comparablecontent")
#docs.display("graph")

#docend()
