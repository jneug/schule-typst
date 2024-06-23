// ================================
// =   Typographic enhancements   =
// ================================

#import "@preview/unify:0.6.0"

#import "../util/typst.typ"
#import "../util/args.typ"
#import "../util/util.typ"

#import "../theme.typ"

// ============================
// Text scaling
// ============================

/// Skalierter text.
/// - #shortex(`#scaled[Hallo Welt.]`)
/// - #shortex(`#scaled(factor:.5)[Hallo Welt.]`)
/// - #shortex(`#scaled("Hallo Welt.", factor:120%)`)
///
/// - content (string, content): Zu skalierender Text.
/// - factor (float, ratio): Der Skalierungsfaktor.
#let scaled(content, factor: 0.8) = text(factor * 1em, content)

/// Kleiner text.
/// - #shortex(`#small[#lorem(5)]`)
/// - #shortex(`#small(lorem(5))`)
///
/// - content (string, content): Zu skalierender Text.
#let small(content) = scaled(content, factor: 0.88)

/// Großer text.
/// - #shortex(`#large[#lorem(5)]`)
/// - #shortex(`#large(lorem(5))`)
///
/// - content (string, content): Zu skalierender Text.
#let large(content) = scaled(content, factor: 1.2)

// ============================
// New text decorations
// ============================
/// === Neue Textauszeichnungen
/// Doppelte Unterstreichung.
/// - #shortex(`#uunderline[#lorem(5)]`)
/// - #shortex(`#uunderline(lorem(5), stroke:2pt+red, offset:2pt, distance: 1pt)`)
///
/// - stroke (stroke): Linienstil für die Unterstreichung.
/// - offset (length): Abstand der oberen Linie zum Text.
/// - distance (length): Abstand der unteren Linie zur oberen Linien.
/// - extent (length): #arg[extent] vonn #cmd-[underline].
/// - evade (length): #arg[evade] vonn #cmd-[underline].
/// - body (string, content): Zu unterstreichender Text.
#let uunderline(
  stroke: auto,
  offset: auto,
  distance: auto,
  extent: 0pt,
  evade: true,
  body,
) = {
  let thickness = args.if-auto(.0416em, stroke, do: s => typst.stroke(s).thickness)
  distance = args.if-auto(.25em, distance)
  underline(
    stroke: stroke,
    offset: def.if-auto(0pt, offset) + thickness + distance,
    extent: extent,
    evade: evade,
    underline(
      stroke: stroke,
      offset: offset,
      extent: extent,
      evade: evade,
      body,
    ),
  )
}

/// Zickzack Unterstreichung.
/// - #shortex(`#squiggly[#lorem(5)]`)
/// - #shortex(`#squiggly(lorem(5), stroke:2pt+red, offset: 4pt, amp:2, period: 2)`)
///
/// - stroke (stroke): Linienstil für die Unterstreichung.
/// - body (string, content): Zu unterstreichender Text.
#let squiggly(
  stroke: 1pt + black,
  offset: 0pt,
  amp: 1,
  period: 1,
  body,
) = {
  amp *= .5

  style(styles => {
    let m = measure(body, styles)
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
  })
}

/// Textabschnitt hervorheben (ersetzt #doc("text/highlight")).
/// - #shortex(`#highlight[#lorem(5)]`)
///
/// - color (color): Farbe der Hervorhebung.
/// - body (string, content): Hervorzuhebender Inhalt.
/// -> content
#let highlight(body, color: yellow) = box(fill: color, inset: (x: 0.2em), outset: (y: 0.2em), radius: 0.1em, body)

// ============================
// Text highlights
// ============================

// German number format for integers / floats
// - #shortex(`#num(2.3)`)
#let num = unify.num

// SI units
// - #shortex(`#si(3.5, $m^3$)`)
#let si(value, unit) = [#num(value)#h(0.2em)#unit]

