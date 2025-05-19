#import "../../src/schule.typ": ab
#import ab: *

#table(
  columns: 4,
  align: center,
  table.header(
    [Aa],
    [Bb],
    [Cc],
    [Dd],
  ),
  ..range(12).map(str)
)

#table(
  columns: 4,
  align: center,
  fill: table-fill(),
  table.header(
    [Aa],
    [Bb],
    [Cc],
    [Dd],
  ),
  ..range(12).map(str)
)
