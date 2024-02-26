#import "@preview/finite:0.3.0" as finite: automaton


// #let grammatik( ..produktionen ) = {
//   set text(weight:"bold")
//   grid(
//     columns: (auto, auto, auto, auto, auto),
//     row-gutter: .8em,
//     column-gutter: 3pt,
//     ..produktionen.pos().enumerate().map(
//       ((i, P)) => {
//         let (N, T) = (..P)
//         (
//           if i == 0 [P = {] else [], [], align(right)[#N], align(center, sym.arrow.r), align(left, if type(T) == array {T.join(" | ")} else [#T])
//         )
//       }
//     ).flatten(),
//     align(right)[}]
//   )
// }
// #grammatik(
//   ("S", "A C A B"),
//   ("A", ("X", "X C X")),
//   ("B", ("A B", "A")),
//   ("C", ("$", "1"))
// )
