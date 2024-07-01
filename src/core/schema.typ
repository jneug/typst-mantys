#import "../util/typing.typ" as t
#import "../util/is.typ"


#let author = t.dictionary(
  (
    name: t.string(),
    email: t.email(optional: true),
    github: t.string(optional: true),
    urls: t.array(t.url(), optional: true, pre-transform: t.coerce.array),
    affiliation: t.string(optional: true),
  ),
  pre-transform: (self, it) => {
    if is.str(it) {
      let m = it.match(regex("^([^<]+?)<([^>]+?)>$"))
      it = (
        name: it,
      )

      if m != none {
        it.name = m.captures.first().trim()

        let _info = m.captures.last()
        if _info.starts-with("@") {
          it.insert("github", _info)
        } else if _info.starts-with("http") {
          it.insert("urls", (_info,))
        } else {
          it.insert("email", _info)
        }
      }
    }
    it
  },
  aliases: (
    url: "urls",
  ),
)

#let package = t.dictionary((
  name: t.string(),
  version: t.version(),
  entrypoint: t.string(),
  authors: t.array(author, pre-transform: t.coerce.array),
  license: t.string(),
  description: t.string(),
  homepage: t.url(optional: true),
  repository: t.url(optional: true),
  keywords: t.array(t.string(), optional: true),
  categories: t.array(
    t.choice((
      "components",
      "visualization",
      "model",
      "layout",
      "text",
      "scripting",
      "languages",
      "integration",
      "utility",
      "fun",
      "book",
      "paper",
      "thesis",
      "flyer",
      "poster",
      "presentation",
      "office",
      "cv",
    )),
    assertions: (t.assert.length.max(3),),
    optional: true,
  ),
  disciplines: t.array(
    t.choice((
      "agriculture",
      "anthropology",
      "archaeology",
      "architecture",
      "biology",
      "business",
      "chemistry",
      "communication",
      "computer-science",
      "design",
      "drawing",
      "economics",
      "education",
      "engineering",
      "fashion",
      "film",
      "geography",
      "geology",
      "history",
      "journalism",
      "law",
      "linguistics",
      "literature",
      "mathematics",
      "medicine",
      "music",
      "painting",
      "philosophy",
      "photography",
      "physics",
      "politics",
      "psychology",
      "sociology",
      "theater",
      "theology",
      "transportation",
    )),
    optional: true,
  ),
  compiler: t.version(optional: true),
  exclude: t.array(t.string(), optional: true),
))

#let template = t.dictionary((
  path: t.string(),
  entrypoint: t.string(),
  thumbnail: t.string(optional: true),
))

#let document = t.dictionary(
  (
    // Document info
    title: t.content(),
    subtitle: t.content(optional: true),
    urls: t.array(t.url(), optional: true, pre-transform: t.coerce.array),
    date: t.date(pre-transform: t.optional-coerce(t.coerce.date), optional: true),
    abstract: t.content(optional: true),

    // General package-info
    // Will be pre-transform to the package dict
    // TODO: Should this be allowed to override package?
    // name: t.string(),
    // description: t.content(),
    // authors: t.array(author),
    // repository: t.url(optional: true),
    // version: t.version(),
    // license: t.string(),

    // Data loaded from typst.toml
    package: package,
    template: t.optional(template),

    // Configuration options
    show-index: t.boolean(default: true),
    show-outline: t.boolean(default: true),
    show-urls-in-footnote: t.boolean(default: true),
    examples-scope: t.dictionary(
      (
        scope: t.dictionary((:)),
        imports: t.dictionary((:), optional: true)
      ),
      optional: true,
      pre-transform: t.coerce.dictionary(it => (scope: it)),
      post-transform: (_, it) => {
        if it == none {
          it = (:)
        }
        return (scope:(:), imports:(:)) + it
      }
    ),
    assets: t.array(
      t.dictionary((
        id: t.string(),
        src: t.string(),
        dest: t.string()
      )),
      default: (),
      pre-transform: (_, it) => {
        if type(it) == dictionary {
          let assets = ()
          for (id, spec) in it {
            assets.push((
              id: id,
              src: if type(spec) == str { spec } else { spec.src },
              dest: if type(spec) == str { id } else { spec.at("dest", default: id) }
            ))
          }
          return assets
        } else {
          return it
        }
      }
    ),

    // Git info
    // TODO: remove git info?
    git: t.string(
      optional: true,
      // post-transform: (self, it) => {
      //   if is.str(it) {
      //     return it.split("\n").map(v => v.split("\t"))
      //   }
      //   it
      // }
    ),
  ),
  pre-transform: (self, it) => {
    // If package info is not loaded from typst.toml,
    // the keys are moved to the "package" dictionary.
    if "package" not in it {
      it.insert("package", (:))

      for key in ("name", "description", "repository", "version", "license") {
        if key in it {
          it.package.insert(key, it.remove(key))
        }
      }
    }

    // Mantys allows for authors to have more fields than package authors.
    if "authors" in it {
      it.package.insert("authors", it.remove("authors"))
    }
    if "author" in it {
      it.package.insert("authors", it.remove("author"))
    }

    // Set empty title
    if "title" not in it and "name" in it.package {
      if "template" in it {
        it.insert("title", [The #raw(block:false, it.package.name)<mantys-theme-pkg> template])
      } else {
        it.insert("title", [The #raw(block:false, it.package.name)<mantys-theme-pkg> package])
      }
    }
    it
  },
  aliases: (
    url: "urls",
    author: "authors",
  ),
)
