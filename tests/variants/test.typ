#import "../../src/schule.typ": ab
#import ab: *

#show: arbeitsblatt(
  titel: "Variants test",
  variant: "B",
)


#vari[
  Variant A
][
  Variant B
][
  Variant C
]

- `variant == "B"`: #document.use-value("variant", it => it == "B")
- `variants == ("A", "B", "C")`: #document.use-value("variants", it => it == ("A", "B", "C"))
