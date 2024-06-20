#import "@local/schule:1.0.0": kl
#import kl: *

#show: klausur.with(
  autor: (
    name: "J. Neugebauer",
    kuerzel: "Ngb",
  ),
  titel: "2. Klausur",
  reihe: "Rechnernetze",
  nummer: "2",
  fach: "Informatik",
  kurs: "Q1 LK",
  // version: datetime.today(),
  dauer: 225,
  datum: "27.11.2023",
  loesungen: "seite"
)

#aufgabe(titel: "Grundlagen der informatisch-technischen Kommunikation")[
  #teilaufgabe[
    Das _Sender-Empfänger-Modell_ von Shannon und Weaver gilt als eines der ersten theoretischen Modelle zur technischen Kommunikation.

    _#operator[Skizziere] die wesentlichen Bestandteile des Modells._

    _#operator[Erläutere] das Modell anhand der "Zettelkommunikation" unter Schülerinnen und Schüler während einer Schulstunde._

    #text(
      .88em,
      [(Schülerinnen und Schüler schreiben sich Zettelchen, die untereinander unter den Tischen weitergegeben werden.)],
    )

    _#operator[Beurteile] die "Zettelkommunikation" anhand der Kriterien Geschwindigkeit, Reichweite, Zuverlässigkeit, Sicherheit, Komplexität und Zuverlässigkeit._

    #erwartung([Skizziert die wichtigsten Bestandteile des S-E-Modells.], 3)
    #erwartung([Erläutert das Modell anhand des genannten Beispiels.], 3)
    #erwartung([Beurteilt die Kommunikation anhand jedes der fünf Kriterien.], 4)

    #loesung[
      Wichtige Bestandteile: Sender, Empfänger, Sendegerät, Empfangsgerät, Übertragungskanal

      Codierung, Decodierung, Information, Nachricht
    ]
    #loesung[
      Die Staatsoberhäupter geben ihre Nachricht an den Dolmetscher, der die Nachricht von der Landessprache in die Sprache des Kommunikationspartners übersetzt (codiert). Die Nachricht kann über verschiedene Kanäle übertragen werden, als Schallwellen oder geschrieben. Beim Empfänger muss die Sprache nicht erneut decodiert werden, da die Sprache schon korrekt ist.

      Ob die beabsichtigte Information ankommt, hängt von der Interpretation der Sprache ab. Die Übersetzung zwischen Sprachen kann unter Umständen Mißverständnisse befördern.
    ]
    #loesung[
      - Die *Geschwindigkeit* hängt von den Fähigkeiten der DolmetscherInnen ab.
      - Die *Reichweite* vom gesprochenen Wort ist eher gering, kann aber durch technische Verstärkungen und Übertragungen erweitert werden.
      - Die *Sicherheit* hängt auch vom Kanal ab. Die Codierung in eine andere Sprache ist zunächst nicht sicher. Das Gesprochene Wort kann belauscht werden. Flüstert die DolmetscherIn die Worte aber direkt in das Ohr der EmpfängerIn, dann erhöht sich dei Sicherheit bedeutend.
      - Die *Komplexität* übertragbarer Nachrichten ist sehr hoch, da Sprache universale Nachrichten codieren kann.
      - Die *Zuverlässigeit* ist auch relativ hoch, sofern die DolmetscherInnen gut ausgebildet sind.
    ]

  ]

  #teilaufgabe[
    Schichtenmodelle stellen die Grundlage der technischen Kommunikation dar. Das ISO/OSI-Modell beschreibt sieben Schichten:

    #align(
      center,
      table(
        columns: (1cm, auto),
        align: left,
        [*Nr.*], [*Schicht*],
        [], [Transportschicht (_Transport Layer_)],
        [], [Darstellungsschicht (_Presentation Layer_)],
        [], [Sicherungsschicht (_Data Link Layer_)],
        [], [Bitübertragungsschicht (_Physical Layer_)],
        [], [Anwendungsschicht (_Application Layer_)],
        [], [Vermittlungsschicht (_Network Layer_)],
        [], [Sitzungsschicht (_Session Layer_)],
      ),
    )

    _#operator[Gib] die Reihenfolge der Schichten #operator[an], indem Du die Nummern 1 -- 7 in die Tabelle einträgst. (Beginne mit 1 bei der untersten Schicht.)_

    _#operator[Beschreibe] allgemein, wie die Schichten eines Schichtenmodells zusammenarbeiten, wenn eine Nachricht von einem Sender zu einem Empfänger verschickt wird. (Eine detallierte Beschreibung der Schichten im Einzelnen ist hier nicht nötig.)_

    #erwartung([Ordnet die siben Schichten passend an.], 2)
    #erwartung([Beschreibt den Ablauf einer Kommunikation durch mehrere Schichten hindurch.], 3)

    #loesung[
      #align(
        center,
        table(
          columns: (1cm, auto),
          align: (center, left),
          [*Nr.*], [*Schicht*],
          [*3*], [Vermittlungsschicht (_Network Layer_)],
          [*2*], [Sicherungsschicht (_Data Link Layer_)],
          [*7*], [Anwendungsschicht (_Application Layer_)],
          [*4*], [Transportschicht (_Transport Layer_)],
          [*6*], [Darstellungsschicht (_Presentation Layer_)],
          [*5*], [Sitzungsschicht (_Session Layer_)],
          [*1*], [Bitübertragungsschicht (_Physical Layer_)],
        ),
      )
    ]
    #loesung[
      Jede Schicht arbeitet mit der darüber und der darunter zusammen (die oberste und unterste jeweils nur mit einer).

      Bei ausgehenden Nachrichten nimmt die Schicht die Daten der Vorgängerschicht entgegen, reichert diese ggf. mit Metadaten (Headern) an, die zur Ausführung ihrer Funktion notwendig sind, und gibt die neue Nachricht an die nachfolgende Schicht weiter. Dabei werden die Daten unter Umständen in kleinere Teie zerlegt.

      Bei eingehenden Nachrichten werden die Daten der vorherigen Schicht entgegengenommen und auf die Metadaten der äquivalenten Sender-Schicht geprüft. Ggf. müssen dazu mehrere Datenpakete abgewartet werden, die zunächst wieder zusammengesetzt werden müssen. Den erhaltenen Daten werden dei Metadaten entfernt und an die Folgeschicht weitergegeben.
    ]
  ]

  #teilaufgabe[
    Aufgrund seiner Bedeutung für die Kommunikation im Internet ist das TCP/IP-Modell das am weitesten verbreitete Kommunikationsmodell. Es fasst einige Schichten des ISO/OSI-Modells zusammen und besteht nur aus vier Schichten. Die wichtigsten sind die Transport- und die Vermittlungsschicht.

    #erwartung([Beschreibt die Funktion der Schichten.], 3)
    #erwartung([Beschreibt die Adressierungsmethoden (IP und Portnummern).], 2)

    #loesung[
      Die Transportschicht (TCP) stellt eine persistente Verbindung zwischen Sender und Empfänger her. Die Transportschicht sorgt dafür, dass die Verbindung für die darüberliegende Schicht wie eine persistente Verbindung wirkt. Sie verwendet *Ports* als Adressierungsmethode.

      Die Internetschicht (IP) sorgt für dei Weiterleitung von Paketen und das Routing vom Sendegerät zum Empfangsgerät auch über mehrere Zwischenknoten hinweg. Es verwendet *IP-Adressen* zur Adressierung.
    ]
  ]
]

#pagebreak()
#aufgabe(titel: "Routing in vermaschten Netzen")[
  In einem Netzwerk sind zwei Rechner mit den folgenden IPs vorhanden:

  #align(
    center,
    table(
      columns: 2,
      [*IP*], [*Subnetmaske*],
      [`192.168.0.10`], [`255.255.252.0`],
      [`192.168.1.23`], [`255.255.252.0`],
    ),
  )

  #teilaufgabe[
    _#operator[Gib] für beide Rechner den Netzwerk- und Geräteteil, die Brodcastadresse und das Default-Gateway, sowie den IP-Bereich (Min./Max. IP) an._

    #erwartung([Gibt die gesuchten Informationen über das Netzwerk an.], 4)

    #loesung[
      #align(
        center,
        table(
          columns: (4cm, auto, auto),
          align: left,
          [], [`192.168.0.10`], [`192.168.1.23`],
          [Netzwerkteil], [`192.168.0.0`], [`192.168.0.0`],
          [Geräteteile], [`0.0.0.10`], [`0.0.0.10`],
          [Broadcast], [`192.168.3.255`], [`192.168.3.255`],
          [Minimale IP], [`192.168.0.1`], [`192.168.0.1`],
          [Maximale IP], [`192.168.3.254`], [`192.168.3.254`],
        ),
      )

      Beide Rechner liegen im selben Netzwerk.
    ]
  ]

  Ein neuer Rechner mit der IP `192.168.5.17` und der Subnetmaske `255.255.252.0` wird in das Netzwerk eingebunden.

  #teilaufgabe[
    _#operator[Ermittele], mit welchem der obigen Rechner der Neue im selben _logischen Netzwerk_ liegt._

    #erwartung([Mit keinem, die die Netzwerkadresse `192.168.4.0` lautet.], 2)

    #loesung[
      Netzteil: `192.168.4.0` #sym.arrow.r *Nicht im selben Netzwerk!*
    ]
  ]

  #teilaufgabe[
    #quote[Eine Paket im Internet nimmt immer den kürzesten Weg vom Sender zum Empfänger.]

    _#operator[Beurteile] diese Aussage mit Deinem Wissen über das Routing in vermaschten Netzwerken._

    #erwartung([Beurteilt die Aussage hinreichend genau.], 4)

    #loesung[
      Ein Paket in einem vermaschten Netzwerk wird über verschiedene Zwischentsationen vom Sender zum Empfänger geleitet. Jede Station entscheidet autonom, an welchen nächsten Knoten die Nachricht weitergeleitet wird. In der Regel versucht dabei jeder Knoten einen möglichst effizienten (schnellen) Weg zu nehmen. Dies ist aber nicht garantiert. Knoten können anders (oder falsch) konfiguriert sein, und kein Knoten kennt das komplette Netzwerk. Daher ist der kürzeste Weg nicht garantiert.
    ]
  ]
]

#aufgabe(titel: "Mensa-App")[
  An einer Universität können die Studierenden ihr Essen in der Mensa bis zu drei Tage im Voraus bestellen. Dazu müssen sie ihren Essenswunsch in der Mensa angeben. Dieser wird auf einem Zettel notiert und in die Küche gegeben. Dabei ist es in der Vergangenheit immer wieder dazu gekommen, dass Essen vergessen oder nicht abgeholt wurden.

  Um diesen Problemen zu begegnen hat die Univerwaltung eine App in Auftrag gegeben, mit der das Essen im Voraus per bestellt werden kann. Dazu wurde schon eine Client-App entwickelt, die mit dem Mensa-Server kommunizieren soll.

  An jedem Tag gibt es jeweils zwei Hauptgerichte und zwei Nachspeisen, aus denen die Studierenden jeweils eins beziehungsweise eine wählen können.

  Für Freitag, den 15.09.2023, mit den Hauptgerichten Vegetarisches Risotto und Weißwurst mit Brezel sowie den Nachtischen gemischtes Eis und Schokoladenpudding haben zwei Mitarbeitende folgende Bestellungen notiert:

  #grid(
    columns: (1fr, 1fr),
    figure(
      {
        set align(left)
        table(
          columns: (4cm, 3cm),
          stroke: none,
          fill: luma(220),
          [Fr., 15|09|23], [],
          [Veg.Risotto], [IIII],
          [Wurst], [III],
          [], [],
          [gem. Eis], [III],
          [Pudding], [III],
          [Obst], [],
        )
      },
      caption: [Bestellung Mitarbeitende I],
    ),
    figure(
      {
        set align(left)
        table(
          columns: (4cm, 3cm),
          stroke: none,
          fill: luma(220),
          [], [für morgen],
          [Risotto], [4],
          [Weißwurst], [3],
          [], [],
          [Eis], [3],
          [Pudding], [3],
          [Obst], [keins],
        )
      },
      caption: [Bestellung Mitarbeitende II],
    ),
  )

  Innerhalb der App sollen Studierende nach der Anmeldung mit ihrer Martrikelnummer und dem persönlichen Passwort das Essen der kommenden drei Tage einsehen und Bestellungen für jeden oder einzelne der drei Tage abgeben können (jeweils ein Hauptgericht und eine Nachspeise). Sie sollen außerdem ihre bisher getätigten Bestellungen einsehen können. Eine Stornierung ist in der ersten Version nicht vorgesehen.

  Die Mensaküche soll in der Lage sein, alle Bestellungen für einen beliebigen Tag abzurufen.

  #teilaufgabe[
    _#operator[Beschreibe] ausgehend von der bisherigen Notation der Bestellungen die Unterschiede zwischen menschlicher und informatisch-technischer Kommunikation._

    _#operator[Erläutere] darüber hinaus den Sinn von Protokollen in der technisch-informatischen Kommunikation._

    #erwartung([Beschreibt die bisherige Notation.], 3)
    #erwartung([Erläutert den Sinn von Protokollen.], 3)

    #loesung[
      Menschen erfassen Muster viel schnelle rals Maschinen und können aus verschiedenen Darstellungen von Informationen leicht auf dieselbe Information schließen. Beispielsweise wird in der bisherigen Notation eine Zahl auf verschiedene Arten codiert (Ziffer und Strichliste).

      Eine Maschine benötigt genaue Anweisungen, wie Daten zu interpretieren sind. Sie kann zwar auch Muster erkennen, aber nur bis zu einem gewissen grad und unter großem Aufwand. Technische Kommunikation ist daher auf genau Festlegungen der Formate angewiesen.

      Protokolle übernehmen diese Aufgabe, der Kommunikation einen klaren Rahmen mit genauen Befehlen, Verhalten und Formaten zu geben. Beide Seiten können sich auf dieses Protokoll berufen und die Daten entsprechend der Festlegungen leicht verarbeiten.
    ]
  ]

  #teilaufgabe[
    _#operator[Entwickele] basierend auf den bisherigen Bestellungen konkrete _Formate_ für die folgenden Fälle, die in ein Protokoll für die Bestell-App einfließen sollten._

    1. Abruf der verfügbaren Mahlzeiten innerhalb der nächsten drei Tage.
    2. Abgeben einer Bestellung für einen Tag (Hauptgericht plus Nachspeise).

    #hinweis[Eine Angabe von Befehlen ist nicht nötig, sondern nur das Format, in dem die Daten übermittelt werden sollen.]

    #erwartung([Entwickelt Formate für die genannten Fälle.], 4)

    #loesung[
      Notwendige Bestandteile der SchülerInnen-Lösung:

      - Angabe des Tages
      - Liste der Mahlzeiten (dem Tag zugeordnet)
    ]
  ]

  #teilaufgabe[
    _#operator[Entwirf] ein möglichst vollständiges Protokoll für die Vorbestellung von Mahlzeiten._ (Der Abruf durch die Mensa muss nicht berücksichtigt werden.)

    #erwartung([Entwickelt ein vollständiges, sinnvolles Protokoll.], 8)

    #loesung[
      #table(
        columns: 3,
        [*Befehl*], [*Bedeutung*], [*Erwartete Antwort*],
        [`LOGIN <username> <password>`],
        [Anmeldung am Server mittels Nutzernamen und Passwort.],
        [`++ Willkommen bei der Mensa-App`],

        [`MEALS <datum>`], [], [],
        [`ORDER <datum> <mahlzeit> <dessert>`], [], [],
      )
    ]
  ]

  Für den Abruf der Bestellungen vom Server gibt es in der Mensa-Küche einen Computer, der tagesaktuell die Bestellungen anzeigt. Für den Abruf wurde das folgende Protokoll definiert:

  #figure(
    {
      set text(.88em)
      set align(left)
      table(
        columns: 3,
        [*Befehl*], [*Bedeutung*], [*Erwartete Antwort*],
        [`LOGIN <username> <password>`],
        [Anmeldung am Server mittels Nutzernamen und Passwort.],
        [`++ Willkommen bei der Mensa-App`

          _oder im Fehlerfall_

          `-- Keine Anmeldung möglich`],

        [`DATE <YYYY-MM-DD>`],
        [Legt das Datum des Tages fest, von dem Daten abgerufen werden sollen.],
        [`++ Datum auf <DD.MM.YYYY> gesetzt`

          _oder im Fehlerfall eines von_

          - `-- Datumsformat nicht erkannt`\
          - `-- Datum schon vergangen`\
          - `-- Datum zu weit in der Zukunft`],

        [`FETCH (MAIN|DESSERT)`],
        [Abruf der Bestelldaten für Hauptgerichte (`MAIN`) bzw. Nachspeisen (`DESSERT`) des vorher gewählten Datums.],
        [
          Der Server sendet Zeilenweise eine Liste der Bestellungen im Format `<Name des Gerichts> :: <Anzahl Bestellungen>`. Beendet wird die Liste von einem einzelnen Punkt (`.`).

          `++ Hauptspeisen 15.09.2023`\
          `RISOTTO_VEG :: 4`\
          `WEISSWURST :: 3`\
          `.`

          _ oder im Fehlerfall_

          `-- Kein Datum gewählt`
        ],
      )
    },
    caption: [Protokoll zum Abruf der Bestelldaten.],
  )

  #teilaufgabe[
    _#operator[Skizziere] ein Sequenzdiagramm zum Abruf der Bestelldaten nach folgendem Ablauf:_

    + Der Küchen-Computer baut eine Verbindung auf und meldet sich mit den Zugangsdaten `mensa-01` / `123456` am Server an.
    + Der Computer setzt das Datum auf den 27.11.2023.
    + Der Computer ruft die bestellten Hauptspeisen vom Server ab.
    + Der Computer ruft die bestellten Nachspeisen vom Server ab.

    Die Bestellungen für den 27.11.2023 sind:
    #align(
      center,
      grid(
        columns: 2,
        gutter: 1cm,
        [Hauptgerichte
          #table(
            columns: (auto, 1.8cm),
            [*Name*], [*Anzahl*],
            [`PIZZA_MARG`], [124],
            [`PIZZA_SALA`], [56],
            [`PIZZA_THUN`], [77],
            [`PASTA_PESTO`], [98],
          )],
        [ Nachspeisen
          #table(
            columns: (auto, 1.8cm),
            [*Name*], [*Anzahl*],
            [`EIS`], [86],
            [`PUDDING`], [12],
            [`OBSTSALAT`], [64],
          )],
      ),
    )

    #erwartung([Skizziert ein Sequenzdiagramm zum angegebenen Ablauf.], 8)

    #loesung[
      Schülerlösung
    ]
  ]

  #teilaufgabe[
    Der Verein "Studierende für Datensicherheit" gibt bei der Universitätsverwaltung zu bedenken, dass die Verwendung einer App für die Bestellungen dazu führen könnte, dass die persönlichen Daten der Studierenden über das Internet ausgespäht werden. Der Aufbau des Internets wäre zu unsicher, da in einem vermaschten Netz nicht kontrolliert werden kann, wer alles mithört. Außerdem sehen sie es als wichtig an, dass das System ausfallsicher ist, damit das leibliche Wohl der Studierenden nicht gefährdet wird, wenn sie kein Essen bestellen können.

    Der Verein schlägt vor, die Bestellungen ausschließlich von den Computern innerhalb der der Universität durchführen zu lassen. Die Rechner der Uni sind alle in einer großen Ring-Topologie vernetzt.

    _#operator[Beurteile] den Vorschlag des Studierenden-Vereins hinsichtlich der geforderten Kriterien._

    #erwartung([Beurteilt den Vorschlag hinreichen genau.], 4)

    #loesung[
      In einer Ring-Topologie ist die Sicherheit gering, da alle Clients im Netzwerk die Nachricht mitlesen können (zumindest die zwischen Sender und Empfänger). Sofern nicht auf weitere Verschlüsselungen zurückgegriffen wird, wäre diese Idee unzureichend.
    ]
  ]
]
