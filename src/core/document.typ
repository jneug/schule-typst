#import "../util/types.typ" as t

#let _author-schema = t.dictionary(
  (
    name: t.string(),
    email: t.email(optional: true),
    abbr: t.string(optional: true),
  ),
  pre-transform: t.coerce.dictionary(it => (name: it)),
  aliases: (
    kuerzel: "abbr",
    abbreviation: "abbr",
  ),
)

#let _doc-schema = t.dictionary(
  (
    type: t.string(),
    type-long: t.string(),
    title: t.content(),
    topic: t.content(optional: true),
    subject: t.content(optional: true),
    number: t.string(
      optional: true,
      pre-transform: (_, v) => if v != none {
        str(v)
      },
    ),
    class: t.string(optional: true),
    author: t.array(
      _author-schema,
      pre-transform: t.coerce.array,
      optional: true,
    ),
    date: t.date(
      pre-transform: (_, it) => if type(it) == str {
        let parts
        if it.contains(".") {
          parts = it.split(".")
          return datetime(
            year: int(parts.at(2)),
            month: int(parts.at(1)),
            day: int(parts.at(0)),
          )
        } else if parts.contains("-") {
          parts = it.split("-")
          return datetime(
            year: int(parts.at(0)),
            month: int(parts.at(1)),
            day: int(parts.at(2)),
          )
        }
      } else {
        it
      },
      optional: true,
    ),
    license: t.string(default: "cc-by-sa"),
    version: t.string(
      optional: true,
      pre-transform: (_, it) => {
        if type(it) == datetime {
          it = it.display()
        }
        if it != none {
          it = str(it)
        }
        it
      },
    ),
    variant: t.string(
      optional: true,
      pre-transform: (_, it) => if "variant" in sys.inputs {
        sys.inputs.variant
      } else if it != none {
        str(it)
      },
    ),
    solutions: t.choice(
      ("none", "page", "here", "after"),
      default: "seite",
      aliases: (
        "seite": "page",
        "keine": "none",
        "sofort": "here",
        "folgend": "after",
      ),
    ),
  ),
  aliases: (
    "typ": "type",
    "typ-lang": "type-long",
    "titel": "title",
    "reihe": "topic",
    "thema": "topic",
    "fach": "subject",
    "klasse": "class",
    "kurs": "class",
    "nummer": "number",
    "no": "number",
    "nr": "number",
    "datum": "date",
    "authors": "author",
    "autor": "author",
    "autoren": "author",
    "vari": "variant",
    "variante": "variant",
    "ver": "version",
    "lizenz": "license",
    "solution": "solutions",
    "loesungen": "solutions",
  ),
)

#let create(..args, options: (:), aliases: (:)) = {
  let schema = _doc-schema
  schema.dictionary-schema += options
  if aliases != (:) {
    let _pre-transform = schema.pre-transform
    schema.pre-transform = (self, it) => {
      it = _pre-transform(self, it)
      for (src, dst) in aliases {
        let value = it.at(src, default: none)
        if (value != none) {
          it.insert(dst, value)
          let _ = it.remove(src)
        }
      }
      return it
    }
  }
  let doc = t.parse(args.named(), schema)

  doc.insert("_debug", sys.inputs.at("debug", default: false) in ("1", "true", 1, true))

  // add some utility function
  doc += (
    author-abbr: (sep: ", ", suffix: "(", prefix: ")") => {
      let abbr = doc.author.filter(a => "abbr" in a)
      if abbr != () {
        suffix + abbr.map(a => a.at("abbr", default: none)).join(", ") + prefix
      }
    },
  )

  doc
}

#let _state-document = state("schule.document", (:))

#let save(doc) = _state-document.update(doc)

#let save-meta(doc) = [#metadata(doc)<schule-document>]

#let update(func) = _state-document.update(doc => func(doc))

#let get(func) = _state-document.get()

#let use(func) = context func(_state-document.get())

#let get-value(key, default: none) = _state-document.get().at(key, default: default)

#let use-value(key, func, default: none) = context func(get-value(key, default: default))
