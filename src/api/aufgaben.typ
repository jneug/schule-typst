
#import "../core/document.typ"
#import "../exercise/exercise.typ" as ex

#let aufgabe = ex.exercise
#let teilaufgabe = ex.sub-exercise

#let unteraufgaben = ex.tasks

#let loesung = ex.solution
#let erwartung = ex.expectation

/// Setzt eine Aufgabe in mehreren Varianten.
#let vari(..args) = {
  document.use-value(
    "variant",
    variant => {
      let vari = 0
      if variant != none {
        vari = "ABCDEFGHIJKLMN".position(variant)
      }
      if vari >= 0 {
        if args.pos().len() >= vari {
          args.pos().at(vari)
        } else {
          args.pos().last()
        }
      } else {
        args.pos().first()
      }
    },
  )
  document.update-value(
    "variants",
    vars => {
      let v = range(calc.min(14, args.pos().len())).map(i => "ABCDEFGHIJKLMN".at(i))
      if vars != none {
        v = vars + v
      }
      return v.dedup()
    },
  )
}
