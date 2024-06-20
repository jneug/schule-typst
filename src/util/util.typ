
// ================================
// =       General utilities      =
// ================================

#let get-text(element, sep: "") = {
  if type(element) == "content" {
    if element.has("text") {
      element.text
    } else if element.has("children") {
      element.children.map(text).join(sep)
    } else if element.has("child") {
      text(element.child)
    } else if element.has("body") {
      text(element.body)
    } else {
      ""
    }
  } else if type(element) in ("array", "dictionary") {
    return ""
  } else {
    str(element)
  }
}

/// Use in a #cmd-[show] rule to fix the decimal separator in math
/// mode from a dot to a comma.
/// - body (content): Body of the document.
/// -> content
#let decimal-fix(body) = {
  show math.equation: it => {
    show regex("\d+\.\d+"): it => {
      show ".": {
        "," + h(0pt)
      }
      it
    }
    it
  }
  body
}

/// Creates an #cmd-[enum] from the supplied #sarg[args].
/// If only one argument is given, the content is shown as is,
/// without wrapping it in an enum.
/// - ..args (content): Content lines.
/// - func (function): A content function to wrap multiple lines
///                    in (like #cmd-[enum] or #cmd-[list]).
/// -> content
#let auto-enum(..args, func: enum) = {
  let items = args.pos().flatten()
  if items.len() > 1 {
    func(..args.named(), ..items)
  } else if items.len() > 0 {
    items.first()
  }
}

/// Clamps a value between `min` and `max`.
///
/// In contrast to @cmd-(module:"math")[clamp] this function works for other values
/// than numbers, as long as they are comparable.
/// #codesnippet[```typ
/// // text-size = math.clamp(0.8em, 1.2em, text-size) // fails
/// text-size = util.clamp(0.8em, 1.2em, text-size)    // works
/// ```]
///
/// // Tests
/// #test(
///   `util.clamp(0, 100, 50) == 50`,
///   `util.clamp(33%, 99%, 100%) == 99%`,
///   `util.clamp(-5in, 8in, -6in) == -5in`,
///   `util.clamp(-5in, 8in, 4in) == 4in`,
/// )
///
/// - min (integer, float, length, relative length, fraction, ratio): Minimum for `value`.
/// - min (integer, float, length, relative length, fraction, ratio): Maximum for `value`.
/// - value (integer, float, length, relative length, fraction, ratio): The value to clamp.
/// -> any
#let clamp(min, max, value) = {
  assert.eq(type(min), type(max), message: "Can't clamp values of different types!")
  assert.eq(type(min), type(value), message: "Can't clamp values of different types!")
  if value < min {
    return min
  } else if value > max {
    return max
  } else {
    return value
  }
}

/// Alias for #cmd[raw] with #arg(block: false) set.
#let rawi = raw.with(block: false)

/// Positions #arg[body] in the margin of the page
/// #example[```
/// #marginnote(gutter:1cm, offset:-5pt)[Hallo\ Welt]
/// ```]
///
/// - position (alignment): Either #value(left) or #value(right).
/// - gutter (length): Gutter between text and note.
/// - offset (length): How much to offset the note along the y-axis.
/// - body (content): Content of the note.
/// -> content
#let marginnote(position: left, gutter: .5em, offset: 0pt, body) = {
  style(styles => {
    let _m = measure(body, styles)
    if position == right {
      place(position, dx: gutter + _m.width, dy: offset, body)
    } else {
      place(position, dx: -1 * gutter - _m.width, dy: offset, body)
    }
  })
}
