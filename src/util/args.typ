// ================================
// =       Argument handling      =
// ================================
//
// Helpers for handling argument sinks and user supplied values.

/// Extracting arguments from an agument sink to pass to other functions.
///
/// Positional arguments are keys to extract from the named arguments of #arg[_args].
/// If the key is not present, the keys are ignored. The keys of named key-value
/// pairs will be searched, too. If they are not present, they will be added to the
/// resulting dictionary with a default value.
///
/// If a #arg[prefix] is given, it will be added to all keys when looking them up
/// in #arg[_args], but not in the resulting dictionary.
///
/// The function will always return a dictionary, possibly empty.
///
/// Example:
/// ```typst
/// #let arg-test(..args) = [
///   #set text(..util.extract-args(args, _prefix: "font", size: 2em, fill: red, "font"))
///   #block(..util.extract-args(args, _prefix: "block-", "stroke", inset: .5em))[
//     Hello World!
//   ]
/// ]
///
/// #arg-test()
/// #arg-test(fontfill: blue, fontsize: 3em, fontfont: ("Comic Neue"))
/// #arg-test(block-stroke: 2pt + blue)
/// ```
///
/// - _args (arguments): An argument sink.
/// - _prefix (str): An optional prefix to add to keys, when looking them up.
/// - ..keys (str): A list of key names and optionally default values.
/// -> dictionary
#let extract-args(_args, _prefix: "", ..keys) = {
  let vars = (:)
  for key in keys.pos() {
    let k = _prefix + key
    if k in _args.named() {
      vars.insert(key, _args.named().at(k))
    }
  }
  for (key, value) in keys.named() {
    let k = _prefix + key
    if k in _args.named() {
      vars.insert(key, _args.named().at(k))
    } else {
      vars.insert(key, value)
    }
  }

  return vars
}

/// Check #arg[value] for #value(auto) and execute #arg[default], if equal.
/// #arg[do] something with the value, if it is not #value(auto).
///
/// - value (any): The value to check.
#let if-auto(value, default, do: v => v) = if value == auto {
  default()
} else {
  do(value)
}

#let if-none(value, default, do: v => v) = if value == none {
  default()
} else {
  do(value)
}

#let if-has(dict, key, default, do: v => v) = if dict == none or key not in dict {
  default()
} else {
  do(dict.at(key))
}

#let as-arr(value) = if type(value) == type(()) {
  value
} else {
  (value,)
}

/// Inset type kind of like #type("stroke").
/// Creates a #type("dict") with the keys `top`, `right`, `left` and `bottom`.
#let inset(inset) = {
  (
    top: inset.at("top", default: inset.at("y", default: inset.at("rest", default: 0pt))),
    right: inset.at("right", default: inset.at("x", default: inset.at("rest", default: 0pt))),
    bottom: inset.at("bottom", default: inset.at("y", default: inset.at("rest", default: 0pt))),
    left: inset.at("left", default: inset.at("x", default: inset.at("rest", default: 0pt))),
  )
}
