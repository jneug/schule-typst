#import "@preview/oxifmt:0.2.0": strfmt

#let oxi-template = `
<svg
  width="{canvas-width}"
  height="{canvas-height}"
  xmlns="http://www.w3.org/2000/svg"
>
  <!-- Definitions for reusable components -->
  <defs>
    <filter id="shadow" x="-100%" y="-100%" width="300%" height="300%">
      <feFlood
         flood-opacity="{flood-opacity}"
         flood-color="{flood-color}" />
      <feComposite
         in2="SourceGraphic"
         operator="in" />

      <feGaussianBlur
         stdDeviation="{blur-x:?} {blur-y:?}"
         result="blur" />

    </filter>
  </defs>

  <rect x="{rect-x-offset}" y="{rect-y-offset}" rx="{radius:?}" ry="{radius:?}" width="{rect-width}" height="{rect-height}" style="filter:url(#shadow)"/>
</svg>
`.text

#let _resolve-blur(blur, styles, size) = {
  let typ = type(blur)
  if typ == type(1pt) {
    (x: blur, y: blur)
  } else if typ in (int, float) {
    (x: blur * 1pt, y: blur * 1pt)
  } else if typ == dictionary {
    (
      x: _resolve-blur(blur.x, styles, size).x,
      y: _resolve-blur(blur.y, styles, size).y,
    )
  } else if typ == ratio {
    let frac = blur / 100%
    (x: frac * size.width, y: frac * size.height)
  } else {
    panic("Unexpected blur type: `" + typ + "` for value `" + repr(blur) + "`")
  }
}

/// Shadow Box that uses svg filters to create the shadow effect.
///
/// *Example:*
/// #example(`harbinger.shadow-box(
///  radius: 5pt,
///  inset:1em,
///  fill:white,
///  dx: 2pt,
///  dy: 2pt,
///  blur:2,
/// )[This is a nice shadow box]
/// `)
/// - body (content): This is the content of the shadow box.
/// - shadow-fill (color): The color of the shadow.
/// -> content
/// - opacity (number): The opacity of the shadow.
/// - dx (number): The horizontal offset of the shadow.
/// - dy (number): The vertical offset of the shadow.
/// - radius (number): The radius of the shadow.
/// - blur (number): The blur of the shadow.
/// - margin (number): The margin of the shadow.
/// - ..args (dictionary): Additional arguments for the shadow box (width, height, fill, etc).
#let shadow-box(
  body,
  shadow-fill: black,
  opacity: 0.5,
  dx: 0pt,
  dy: 0pt,
  radius: 0pt,
  blur: 3,
  margin: 2,
  ..args,
) = {
  style(styles => layout(size => {
    let named = args.named()
    for key in ("width", "height") {
      if key in named and type(named.at(key)) == ratio {
        named.insert(key, size.at(key) * named.at(key))
      }
    }
    let blur = _resolve-blur(blur, styles, size)
    let opts = (blur-x: blur.x, blur-y: blur.y, radius: radius)
    let shadow-fill = shadow-fill.rgb().components().map(el => el / 100% * 255)
    opts.flood-color = strfmt("rgb({}, {}, {}, {})", ..shadow-fill)
    let boxed-content = box(body, radius: radius, ..named)
    let rect-size = measure(boxed-content, styles)
    let (rect-x-offset, rect-y-offset) = (
      blur.x * margin,
      blur.y * margin,
    )
    let canvas-size = (
      width: 2 * rect-x-offset + rect-size.width,
      height: 2 * rect-y-offset + rect-size.height,
    )
    opts += (
      rect-x-offset: rect-x-offset,
      rect-y-offset: rect-y-offset,
      rect-width: rect-size.width,
      rect-height: rect-size.height,
      canvas-width: canvas-size.width,
      canvas-height: canvas-size.height,
      flood-opacity: opacity,
    )
    let svg-shadow = image.decode(strfmt(oxi-template, ..opts), ..canvas-size)
    block({
      place(
        dx: dx - rect-x-offset,
        dy: dy - rect-y-offset,
        svg-shadow,
      )
      boxed-content
    })
  }))
}
