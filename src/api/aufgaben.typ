
#import "../core/document.typ"
#import "../exercise/exercise.typ" as ex

#let aufgabe = ex.exercise
#let teilaufgabe = ex.sub-exercise

#let unteraufgaben = ex.tasks

#let loesung = ex.solution
#let erwartung = ex.expectation

/// Setzt eine Aufgabe in mehreren Varianten.
#let vari(..args) = {
  document.get-value(
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
}
