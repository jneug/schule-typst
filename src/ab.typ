#import "_imports.typ": *

#let arbeitsblatt(
  ..args,
  body,
) = {
  let (
    doc,
    page-init,
    tpl,
  ) = base-template(
    type: "AB",
    type-long: "Arbeitsblatt",
    //_tpl: (:),
    ..args,
    body,
  )

  {
    show: page-init
    tpl
  }
}
