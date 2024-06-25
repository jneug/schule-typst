
#import "../theme.typ"

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

#let get-text-color(background, light: theme.text.light, dark: theme.text.default, threshold: 62%) = {
  if type(background) == gradient {
    background = background.sample(50%)
  }
  if color.hsl(background).components(alpha: false).last() < threshold {
    light
  } else {
    dark
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

/// Auto-joins items with #arg[sep] and #[last]. If #arg[items]
/// is an array, the items are joined, otherwise the value
/// is returened as is.
/// - items (any): The items to join.
/// - sep (content): The separator for joining.
/// - last (content): The last separator to use.
/// -> content
#let auto-join(items, sep: ", ", last: " and ") = if type(items) == "array" {
  items.map(str).join(", ", last: " und ")
} else {
  items
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
  context {
    let _m = measure(body)
    if position.x == right {
      place(position, dx: gutter + _m.width, dy: offset, body)
    } else {
      place(position, dx: -1 * gutter - _m.width, dy: offset, body)
    }
  }
}

#let combine-ranges(
  numbers,
  sep: ", ",
  last: " and ",
  range-sep: [#h(.2em)--#h(.2em)],
  max-items: 2,
) = {
  let numbers = numbers.dedup().sorted()
  let ranges = (
    (
      numbers.first(),
      numbers.first(),
    ),
  )

  for j in numbers.slice(1) {
    if j == ranges.last().last() + 1 {
      ranges.last().at(1) = j
    } else {
      ranges.push((j, j))
    }
  }

  ranges.map(((from, to)) => if from == to [#from] else if to - from < max-items {
    range(from, to + 1).map(str)
  } else [#from#range-sep#to]).flatten().join(
    sep,
    last: last,
  )
}

#let inset-at(direction, inset, default: 0pt) = {
  direction = repr(direction) // allows use of alignment values
  if type(inset) == "dictionary" {
    if direction in inset {
      return inset.at(direction)
    } else if direction in ("left", "right") and "x" in inset {
      return inset.x
    } else if direction in ("top", "bottom") and "y" in inset {
      return inset.y
    } else if "rest" in inset {
      return inset.rest
    } else {
      return default
    }
  } else if inset == none {
    return default
  } else {
    return inset
  }
}
