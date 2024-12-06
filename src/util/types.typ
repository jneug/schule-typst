// TODO: Rename to "typing.typ"
/// Wrapper module for valkyrie to add some missing types and augment existing
/// ones.

#import "typst.typ"

#import "@preview/valkyrie:0.2.1": *

// Aliases for the original valkyrie types.
#let _choice = choice
#let _content = content

/// Augmented #cmd-[choice] function that adds an #arg[aliases] argument similar
/// to the @cmd-[dictionary] type.
///
/// - aliases (dictionary): A dictionary of alias to option mappings.
/// - ..args (any): Same arguments as for valkyries #cmd-[choice].
/// -> dictionary
#let choice(..args, aliases: (:)) = {
  let pre-transform = (self, it) => aliases.at(it, default: it)
  if "pre-transform" in args.named() {
    pre-transform = (self, it) => args.named().pre-transform(self, pre-transform(self, it))
  }
  _choice(..args, pre-transform: pre-transform)
}

/// Schema for a field that always will be set to a constant value, no matter
/// the value supplied for that key. The value is taken from the supplied
/// types default value.
///
/// - type (dictionary): Any of the valkyrie types with a default value set.
/// -> dictionary
#let constant(type) = {
  type.optional = true
  type.pre-transform = (..) => type.default
  type
}

/// Augments the content type to include #dtype("symbol") as allowed type.
#let content = base-type.with(name: "content", types: (typst.content, str, symbol))

/// Type for Typst build-in #dtype("version").
#let version = base-type.with(name: "version", types: (version,))
/// Type for Typst build-in #dtype("symbol").
#let symbol = base-type.with(name: "symbol", types: (symbol,))
/// Type for Typst build-in #dtype("label").
#let label = base-type.with(name: "label", types: (label,))
/// Type for Typst build-in #dtype("auto").
#let aut0 = base-type.with(name: "auto", types: (type(auto),))

