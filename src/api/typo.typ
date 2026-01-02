
// TODO: Refactorings
// ================================
// =   Typographic enhancements   =
// ================================

#import "../_deps.typ": unify

#import "../util/args.typ"
#import "../util/util.typ"

#import "../theme.typ"

// ============================
// Text scaling
// ============================

/// Skalierter text.
/// - #ex(`#scaled[Hallo Welt.]`)
/// - #ex(`#scaled(factor:.5)[Hallo Welt.]`)
/// - #ex(`#scaled("Hallo Welt.", factor:120%)`)
///
/// -> content
#let scaled(
  /// Zu skalierender Text.
  /// -> string | content
  content,
  /// Der Skalierungsfaktor.
  /// float | ratio
  factor: 0.8,
) = text(factor * 1em, content)

/// Kleiner text.
/// - #ex(`#small[#lorem(5)]`)
/// - #ex(`#small(lorem(5))`)
/// -> content
#let small(
  /// Zu skalierender Text.
  /// -> string | content
  content,
) = scaled(content, factor: 0.88)

/// Großer text.
/// - #ex(`#large[#lorem(5)]`)
/// - #ex(`#large(lorem(5))`)
/// -> content
#let large(
  /// Zu skalierender Text.
  /// -> string | content
  content,
) = scaled(content, factor: 1.2)

// ============================
// New text decorations
// ============================

/// Doppelte Unterstreichung.
/// - #ex(`#uunderline[#lorem(5)]`)
/// - #ex(`#uunderline(lorem(5), stroke:2pt+red, offset:2pt, distance: 1pt)`)
/// -> content
#let uunderline(
  /// Linienstil für die Unterstreichung.
  /// -> stroke
  stroke: auto,
  /// Abstand der oberen Linie zum Text.
  /// -> length
  offset: auto,
  /// Abstand der unteren Linie zur oberen Linien.
  /// -> length
  distance: auto,
  /// #arg[extent] von underline.
  /// -> length
  extent: 0pt,
  /// #arg[evade] von underline.
  /// -> length
  evade: true,
  /// Zu unterstreichender Text.
  /// string | content
  body,
) = {
  let thickness = args.if-auto(.0416em, stroke, do: s => std.stroke(s).thickness)
  distance = args.if-auto(.15em, distance)
  underline(
    stroke: stroke,
    offset: args.if-auto(.15em, offset) + thickness + distance,
    extent: extent,
    evade: evade,
    underline(
      stroke: stroke,
      offset: args.if-auto(.15em, offset),
      extent: extent,
      evade: evade,
      body,
    ),
  )
}

/// Zickzack Unterstreichung.
/// - #ex(`#squiggly[#lorem(5)]`)
/// - #ex(`#squiggly(lorem(5), stroke:2pt+red, offset: 4pt, amp:2, period: 2)`)
/// -> content
#let squiggly(
  /// Linienstil für die Unterstreichung.
  /// -> stroke
  stroke: 1pt + black,
  offset: 0pt,
  amp: 1,
  period: 1,
  /// Zu unterstreichender Text.
  /// -> string, content
  body,
) = {
  amp *= .5

  context {
    let m = measure(body)
    let step = 2pt * period
    let i = 1

    box(width: m.width, clip: false, baseline: -1 * m.height)[
      #move(
        dy: m.height + 0.25em,
        while i * step < m.width {
          place(
            top + left,
            dy: offset,
            line(
              stroke: stroke,
              start: ((i - 1) * step, -amp * step),
              end: (i * step, amp * step),
            ),
          )
          place(
            top + left,
            dy: offset,
            line(
              stroke: stroke,
              start: (i * step, amp * step),
              end: ((i + 1) * step, -amp * step),
            ),
          )
          i += 2
        },
      )
      #place(top + left, body)
    ]
  }
}

/// Textabschnitt hervorheben (ersetzt highlight).
/// - #ex(`#highlight[#lorem(5)]`)
/// -> content
#let highlight(
  /// Farbe der Hervorhebung.
  /// -> color
  color: yellow,
  /// Hervorzuhebender Inhalt.
  /// -> string, content
  body,
) = box(fill: color, inset: (x: 0.2em), outset: (y: 0.2em), radius: 0.1em, body)

// ============================
// Text highlights
// ============================

/// Deutsches Nummernformat. Basiert auf #universe("unify").
/// - #ex(`#num(2.3)`)
#let num(n) = unify.num(util.decimal-fixer(n))

/// Formatierung von Größen mit Einheit. Basiert auf #universe("unify").
/// - #ex(`#unit("m^3")`)
/// -> content
#let unit = unify.unit.with(per: "/")

/// SI units mit einem Wert und einer Einheit.
/// Nutzt @cmd:num und @cmd:unit.
/// - #ex(`#si(3.5, "m^3")`)
#let si(
  /// Wert der Größe.
  /// -> decimal | float | int
  n,
  /// Einheit der Größe, wie bei @cmd:unit beschrieben.
  /// -> str
  u,
) = {
  num(n)
  h(0.166667em)
  unit(u)
}
//#let si(n, u) = unify.qty(util.decimal-fixer(n), u, per: "/")

/// Formatierung von Eurobeträgen mit dem Euro-Symbol (€).
/// - #ex(`#eur(30.4)`)
/// -> content
#let eur(
  /// Geldbetrag
  /// -> float | int | decimal
  n,
) = si(n, "eur")

/// Formatierung von Gradzahlen.
/// - #ex(`#degr(45)`)
/// -> content
#let degr(
  /// Winkel
  /// -> float | int | decimal
  n,
) = si(n, "deg")

/// Formatierung von Prozentzahlen.
/// - #ex(`#perc(45)`)
/// -> content
#let perc(
  /// Prozente
  /// -> float | int | decimal
  n,
) = si(n, "percent")

