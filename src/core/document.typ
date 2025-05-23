#import "../util/typing.typ" as t

#let _author-schema = t.dictionary(
  (
    name: t.string(),
    email: t.string(optional: true), // t.email(optional: true),
    abbr: t.string(optional: true),
    institution: t.string(optional: true),
  ),
  pre-transform: t.coerce.dictionary(it => (name: it)),
  aliases: (
    kuerzel: "abbr",
    abbreviation: "abbr",
    institute: "institution",
    einrichtung: "institution",
    institut: "institution",
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
        } else if it.contains("-") {
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
        "ohne": "none",
        "sofort": "here",
        "folgend": "after",
      ),
    ),
    solutions-show-expectations: t.boolean(default: true),
    preferred-theme: t.string(default: "default"),
    colors: t.boolean(default: true),
    nup: t.integer(default: 1),
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
    "loesungen-mit-erwartungen": "solutions-show-expectations",
    "erwartungen-in-loesungen": "solutions-show-expectations",
    "erwartungen-in-loesungen-zeigen": "solutions-show-expectations",
    "theme": "preferred-theme",
    "farbig": "colors",
    "farben": "colors",
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
    author-formatted: (
      sep: ",",
      format: a => {
        a.name
        if a.institution != none {
          [#footnote(a.institution)]
        }
        if a.abbr != none {
          [ (#a.abbr)]
        }
        if a.email != none {
          [ <#link("mailto:" + a.email, a.email)>]
        }
      },
    ) => {
      return doc.author.map(format).join(sep)
    },
  )

  doc
}

#let _state-document = state("schule.document", (:))

#let update(func) = _state-document.update(doc => func(doc))

#let update-value(key, func) = _state-document.update(doc => {
  doc.insert(key, func(doc.at(key, default: none)))
  doc
})

#let get() = _state-document.get()

#let final() = _state-document.final()

#let use(func) = context func(_state-document.get())

#let get-value(key, default: none) = _state-document.get().at(key, default: default)

#let use-value(key, func, default: none) = context func(get-value(key, default: default))

#let save(doc) = _state-document.update(doc)

#let save-meta(doc) = (
  context {
    [#metadata(final())<schule-document>]
  }
)
