/********************************\
*       Utility functions        *
\********************************/

///
#let if-arg( default, do:none, args, key ) = if key not in args.named() {
  return default
} else if do == none {
  args.named().at(key)
} else {
  do(args.named().at(key))
}

/// Always returns an array containing all `values`.
/// Any arrays in #arg[values] are unpacked into the resulting
/// array.
///
/// This is useful for arguments, that can have one element
/// or an array of elements:
/// ```typ
/// #def.as-arr(author).join(", ")
/// ```
///
/// // Tests
/// #test(
///   `def.as-arr("a") == ("a",)`,
///   `def.as-arr(("a",)) == ("a",)`,
///   `def.as-arr("a", "b", "c") == ("a", "b", "c")`,
///   `def.as-arr(("a", "b"), "c") == ("a", "b", "c")`,
///   `def.as-arr(("a", "b", "c")) == ("a", "b", "c")`,
///   `def.as-arr(("a",), ("b",), "c") == ("a", "b", "c")`,
///   `def.as-arr(("a",), (("b",), "c")) == ("a", ("b", ), "c")`,
/// )
#let as-arr( ..values ) = values.pos().fold((), (arr, v) => {
  if type(v) == "array" {
    arr += v
  } else {
    arr.push(v)
  }
  arr
})

/// Recursivley merges the passed in dictionaries.
/// #codesnippet[```typ
/// #get.dict-merge(
///     (a: 1, b: 2),
///     (a: (one: 1, two:2)),
///     (a: (two: 4, three:3))
/// )
///    // gives (a:(one:1, two:4, three:3), b: 2)
/// ```]
///
/// // Tests
/// #test(
///   `get.dict-merge(
///     (a: 1, b: 2),
///     (a: (one: 1, two:2)),
///     (a: (two: 4, three:3))
///   ) == (a:(one:1, two:4, three:3), b: 2)`
/// )
///
/// Based on work by #{sym.at + "johannes-wolf"} for #link("https://github.com/johannes-wolf/typst-canvas/", "johannes-wolf/typst-canvas").
///
/// - ..dicts (dictionary): Dictionaries to merge.
/// -> dictionary
#let dict-merge( ..dicts ) = {
  if all-of-type("dictionary", ..dicts.pos()) {
    let c = (:)
    for dict in dicts.pos() {
      for (k, v) in dict {
        if k not in c {
          c.insert(k, v)
        } else {
          let d = c.at(k)
          c.insert(k, dict-merge(d, v))
        }
      }
    }
    return c
  } else {
    return dicts.pos().last()
  }
}

/// Creats a function to extract values from an argument sink #arg[args].
///
/// The resulting function takes any number of positional and
/// named arguments and creates a dictionary with values from
/// `args.named()`. Positional arguments to the function are
/// only present in the result, if they are present in `args.named()`.
/// Named arguments are always present, either with their value
/// from `args.named()` or with the provided value as a fallback.
///
/// If a #arg[prefix] is specified, only keys with that prefix will
/// be extracted from #arg[args]. The resulting dictionary will have
/// all keys with the prefix removed, though.
/// #sourcecode[```typ
/// #let my-func( ..options, title ) = block(
///     ..get.args(options)(
///         "spacing", "above", "below",
///         width:100%
///     )
/// )[
///     #text(..get.args(options, prefix:"text-")(
///         fill:black, size:0.8em
///     ), title)
/// ]
///
/// #my-func(
///     width: 50%,
///     text-fill: red, text-size: 1.2em
/// )[#lorem(5)]
/// ```]
///
/// // Tests
/// #test(
///   scope:(
///     fun: (..args) => get.args(args)("a", b:4),
///     fun2: (..args) => get.args(args, prefix:"pre-")("a", b:4)
///   ),
///   `fun(a:1, b:2) == (a:1, b:2)`,
///   `fun(a:1) == (a:1, b:4)`,
///   `fun(b:2) == (b:2)`,
///   `fun2(pre-a:1, pre-b:2) == (a:1, b:2)`,
///   `fun2(pre-a:1, b:2) == (a:1, b:4)`,
///   `fun2(pre-b:2) == (b:2)`
/// )
///
/// - args (arguments): Argument of a function.
/// - prefix (string): A prefix for the argument keys to extract.
/// -> dictionary
#let get-args(
	args,
	prefix: ""
) = (..keys) => {
	let vars = (:)
  for key in keys.pos() {
    let k = prefix + key
    if k in args.named() {
			vars.insert(key, args.named().at(k))
		}
  }
	for (key, value) in keys.named() {
	  let k = prefix + key
		if k in args.named() {
			vars.insert(key, args.named().at(k))
		} else {
			vars.insert(key, value)
		}
	}

	return vars
}

#let def-args(args) = (default, do:none, key) => if key not in args.named() {
  return default
} else if do == none {
  args.named().at(key)
} else {
  do(args.named().at(key))
}

/// Recursively extracts the text content of #arg[element].
///
/// If #arg[element] has children, all child elements are converted
/// to text and joined with #arg[sep].
///
/// // Tests
/// #test(
///   `get.text([Hello World!]) == "Hello World!"`,
///   `get.text(list([Hello], [World!]), sep:"-") == "Hello-World!"`,
///   `get.text(5) == "5"`,
///   `get.text(5.3) == "5.3"`,
///   `get.text((:)) == ""`,
///   `get.text(()) == ""`,
/// )
///
/// - element (any)
/// - sep (string, content)
/// -> string
#let get-text( element, sep: "" ) = {
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

// Place a hidden label in the content
#let place-label( label ) = [#place(box(width:0pt, height:0pt, clip:true, ""))#label]


#let decimal-fix(body) = {
  show math.equation: it => {
      show regex("\d+\.\d+"): it => {show ".": {","+h(0pt)}
          it}
      it
  }
  body
}

#let __all__ = (
  if-arg: if-arg,
  def-args: def-args,
  as-arr: as-arr,
  place-label: place-label,
  decimal-fix: decimal-fix
)
