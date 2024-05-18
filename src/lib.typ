#import "packages.typ" as _pkg

#import "component.typ"
#import "theme.typ"
#import "style.typ"

#let _version = version

// TODO: cleanup
// #import "mty.typ"
// #import "api.typ"

/// The main template function.
#let mantodea(
  title: [Title],
  subtitle: [Subtitle],
  authors: "John Doe <john@doe.com>",
  urls: "https://github.com/typst-community/mantodea",
  date: datetime(year: 1970, month: 1, day: 1),
  version: version(0, 1, 0),
  abstract: lorem(100),
  license: "MIT",
  theme: theme.default,
) = body => {
  let assert-text = _pkg.t4t.assert.any-type.with(str, content)
  assert-text(title)
  assert-text(type(none), subtitle)
  assert-text(array, authors)
  _pkg.t4t.assert.any-type(str, array, type(none), urls)
  assert-text(abstract)
  _pkg.t4t.assert.any-type(_version, version)
  assert-text(license)
  _pkg.t4t.assert.any-type(dictionary, theme)

  let authors = authors
  if authors != none {
    authors = _pkg.t4t.def.as-arr(authors)
  }

  let urls = urls
  if urls != none {
    urls = _pkg.t4t.def.as-arr(urls)
  }

  set document(title: title, author: authors)
  show: style.default(theme: theme)

  component.make-title-page(
    title: title,
    subtitle: subtitle,
    authors: authors,
    urls: urls,
    version: version,
    date: date,
    abstract: abstract,
    license: license,
    theme: theme,
  )

  component.make-table-of-contents(
    title: heading(outlined: false, numbering: none, level: 2)[Table of Contents],
    columns: 1,
    theme: theme,
  )

  body
}
