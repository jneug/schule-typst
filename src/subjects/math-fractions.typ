
#import "../util/util.typ"

#let field(
  a,
  b,
  num,
  size: 1cm,
  blank: white,
  fill: gray,
  flip: false,
  draw-node: (size, fill) => square(
    size: size,
    fill: fill,
    stroke: util.clamp(size / 10, .2pt, 2pt) + black,
  ),
) = box(
  width: a * size,
  height: b * size,
  baseline: (b * size) * 0.5,
  for j in range(b) {
    for i in range(a) {
      place(
        top + left,
        dx: i * size,
        dy: j * size,
        draw-node(
          size,
          if num > 0 {
            fill
          } else {
            blank
          },
        ),
      )
      num -= 1
    }
  },
)
