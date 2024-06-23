#import "../../src/util/util.typ": combine-ranges


#let cases = (
  (1,),
  (1, 2),
  (1, 2, 3),
  (1, 2, 3, 4),
  (1, 2, 4, 6),
  (1, 2, 4, 5, 6),
  (3, 4, 5, 6),
  (2, 3, 4, 5, 6, 12, 13, 14, 15, 16),
  (1, 2, 3, 4, 5, 6),
  (100, 100, 105, 104, 102, 103),
)

#for case in cases [
  - #case #sym.arrow.r #combine-ranges(case)
]


#for case in cases [
  - #case #sym.arrow.r #combine-ranges(case, sep: "; ", range-sep: h(.2em) + sym.arrow.double.r + h(.2em), last: ", ")
]

#for case in cases [
  - #case #sym.arrow.r #combine-ranges(case, max-items: 4)
]
