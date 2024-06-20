
#import "../util/util.typ": clamp

#let field(a, b, num, size: 1cm, blank: white, fill: gray, flip: false) = box(
  width: a * size,
  height: b * size,
  baseline: (b * size) * 0.5,
  for j in range(b) {
    for i in range(a) {
      place(
        top + left,
        dx: i * size,
        dy: j * size,
        square(
          size: size,
          fill: if num > 0 {
            fill
          } else {
            blank
          },
          stroke: clamp(size / 10, .2pt, 2pt) + black,
        ),
      )
      num -= 1
    }
  },
)
