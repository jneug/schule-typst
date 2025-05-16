#import "_imports.typ": *

#let wochenplan(
  ..args,
) = (
  body => {
    let (doc, page-init, tpl) = base-template(
      type: "WP",
      type-long: "Wochenplan",

      title-block: doc => {
        heading(level: 1, outlined: false, bookmarked: false, doc.title)
        grid(
          columns: (auto, 1fr),
          align: center + horizon,
          column-gutter: 5pt,
          doc.calendar-icon,
          container(radius: 4pt, fill: theme.primary, stroke: 0pt)[
            #set align(center)
            #set text(1.2em, white)
            #show heading: set text(white)

            *#doc.from.display("[day].[month].[year]") bis #doc.to.display("[day].[month].[year]")*
          ],
        )
      },

      _tpl: (
        options: (
          from: t.date(
            pre-transform: t.coerce.date,
            default: datetime.today(),
          ),
          to: t.date(
            optional: true,
            pre-transform: (self, it) => {
              if it != none {
                return t.coerce.date(self, it)
              } else {
                let _today = datetime.today()
                return datetime(
                  year: _today.year(),
                  month: _today.month(),
                  day: _today.day(),
                )
              }
            },
          ),
          calendar-icon: t.content(default: icon("calendar", width: 1.5cm, color: theme.secondary)),
        ),
        aliases: (
          von: "from",
          bis: "to",
        ),
      ),

      ..args,
      body,
    )

    {
      show: page-init
      tpl
    }
  }
)

#let gruppe(titel, beschreibung, body) = container(
  radius: 6pt,
  fill: theme.bg.secondary,
  stroke: 1.5pt + theme.secondary,
  title-style: (boxed-style: (:)),
  title: text(fill: theme.text.secondary, weight: "bold", hyphenate: false, size: .88em, titel),
)[#small(beschreibung)#container(
    fill: white,
    radius: 3pt,
    stroke: 1pt + theme.secondary,
    body,
  )]
