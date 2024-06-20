// ================================
// =   Hidden labels and states   =
// ================================
//
// Place hidden metadata and marks in the document.

#import "args.typ": if-auto

/// Opens an environment to be used in contextual functions.
/// - name (str): Name of the environment.
/// -> content
#let env-open(name) = state("schule.env." + name).update(true)

/// Opens an environment.
/// - name (str): Name of the environment.
/// -> content
#let env-close(name) = state("schule.env." + name).update(false)

/// Checks if this command is called within a previously opened environment.
/// ```typst
/// context {
///   #marks.in-env("appendix")    // false
///   #marks.env-open("appendix")
///   #marks.in-env("appendix")    // true
///   #marks.env-close("appendix")
/// }
/// ```
/// #hint[Needs to be called in a `context`.]
/// #propert(context: true)
/// - name (str): Name of the environment.
/// -> content
#let in-env(name) = state("schule.env." + name).get() not in (none, false)

/// Places hidden meta-data in the document that can be queried via @cmd[query].
/// - label (label): Label to attach to the metadata.
/// - data (any): Arbitrary data to optionally place with the metadata.
/// -> content
#let place-meta(label, data: auto) = [#metadata(if-auto(data, () => str(label)))#label]

/// Places a hidden figure in the document, that can be referenced via the
/// usual `@label-name` syntax.
/// - label (label): Label to reference.
/// - kind (str): Kind for the reference to properly step counters.
/// - supplement (str): Supplement to show when referencing.
/// - numbering (str): Numbering schema to use.
/// -> content
#let place-reference(
  label,
  kind,
  supplement,
  numbering: "1",
) = place()[#figure(
    kind: kind,
    supplement: supplement,
    numbering: numbering,
    [],
  )#label]



/// Iterates over all items with a certain label found in the document (usually @cmd[metadata]).
/// #hint[Needs to be called in a `context`.]
/// #property(context: true)
/// - label (label): Label to query for.
/// - do (function): Function to execute on each item.
/// - before (bool): Set to true to only look for items before this call.
/// -> content
#let foreach(label, do: (it, loc) => none, before: false) = {
  let items
  if before {
    items = query(selector(label).before(here()))
  } else {
    items = query(label)
  }
  for it in items {
    if type(it) == metadata {
      do(it.value, it.location())
    } else {
      do(it, none)
    }
  }
}

#let get-page(target) = {
  let loc = query(target)
  if loc != () {
    loc.first().location().page()
  } else {
    none
  }
}
