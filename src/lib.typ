#import "packages.typ" as _pkg
#import "component.typ"

// Import main library functions
#import "./mty.typ"
// Import t4t functions
#import "./mty.typ": is-none, is-auto, is, def
// Import main user api
#import "api.typ"
#import "./api.typ": *

#import "./theme.typ"

// Import tidy theme
#import "./mty-tidy.typ"

/// The main template function.
#let mantodea(
  name: none,
  description: none,
  authors: (),
  repository: none,
  version: none,
  license: none,

  package: none,  // loaded toml file

  // Additional info
  title: none,
  subtitle: none,
  url: none,

  date: none,
  abstract: [],

  titlepage: titlepage,
  index: auto,

  examples-scope: (:),

  ..args,

  body
) = {
  mty.assert.that(
    is.not-none(name) or is.not-none(package),
    message:"You need to specifiy the package name or load the package info via ..toml(\"typst.toml\")."
  )

  if is-none(name) {
    ( name, description, authors,
      repository, version, license
    ) = ( "name", "description", "authors",
          "repository", "version", "license").map(
              (k) => package.at(k, default:none)
            )
  }

	set document(
		title: mty.get.text( mty.def.if-none(name, title) ),
		author: def.as-arr(mty.def.if-none(authors, "")).map((a) => if is.dict(a) { a.name } else { a }).first()
	)

	set page(
		..theme.page,
		header: context {
      let section = context hydra(2, display: (_, it) => {
        numbering("1.1", ..counter(heading).at(it.location()))
        [ ]
        it.body
      })
      align(center, emph(section))
    },
		footer: align(center, counter(page).display("1"))
	)
	set text(
    font: theme.fonts.text,
		size: theme.font-sizes.text,
		lang: "en",
		region: "EN",
    fill: theme.colors.text
	)
	set par(
		justify:true,
	)
	set heading(numbering: "I.1.")
	show heading: it => block([
		#v(0.3em)
		#text(fill:theme.colors.primary, counter(heading).display())
		#it.body
		#v(0.8em)
	])
	show heading.where(level: 1): it => {
		pagebreak(weak: true)
		block([
			#text(fill:theme.colors.primary,
			[Part #counter(heading).display()])\
			#it.body
			#v(1em)
		])
	}
	show heading: it => {
		set text(
      font:theme.fonts.headings,
      size://calc.max(theme.font.sizes.text, theme.font-sizes.headings * ( it.level))
        mty.math.map(4, 1, theme.font-sizes.text, theme.font-sizes.headings * 1.4, it.level)
    )
    it
	}

  // TODO: This would be a nice short way to set examples, but will
  // have weird formatting due to raw text having set the default
  // font and size before the show rule takes effect.
	// show raw.where(block:true, lang:"example"): it => mty.code-example(imports:example-imports, it)
	// show raw.where(block:true, lang:"side-by-side"): it => mty.code-example(side-by-side:true, imports:example-imports, it)
  show raw: set text(font:theme.fonts.code, size:theme.font-sizes.code)
  state("@mty-imports-scope").update(examples-scope)

  // Some common replacements
	show upper(name): mty.package(name)
	show "Mantys": mty.package
  // show "Typst": it => text(font: "Liberation Sans", weight: "semibold", fill: eastern)[typst] // smallcaps(strong(it))

  show figure.where(kind: raw): set block(breakable: true)

	titlepage(name, title, subtitle, description, authors, (url,repository).filter(is.not-none), version, date, abstract, license)

	body

	if index != none and index != () and index != (:) {
		[= Index]
    set text(.88em)
		if type(index) == "array" or type(index) == "string" {
			mty.make-index(kind:(index,).flatten())
		} else if type(index) == "dictionary" {
			for (header, kind) in index {
				[== #header]
				mty.make-index(kind:(kind,).flatten())
			}
		} else {
			mty.make-index()
		}
	}
}
