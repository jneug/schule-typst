/// Wrapper module for valkyrie to add some missing types and augment existing
/// ones.

#import "../_deps.typ": valkyrie
#import valkyrie: *

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
  valkyrie.choice(..args, pre-transform: pre-transform)
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
#let content = valkyrie.base-type.with(name: "content", types: (std.content, str, symbol))

/// Type for Typst build-in #dtype("auto").
#let aut0 = valkyrie.base-type.with(name: "auto", types: (std.type(auto),))

