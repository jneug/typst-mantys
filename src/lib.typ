#import "packages.typ" as _pkg

#import "component.typ"
#import "theme.typ"
#import "style.typ"
#import "util.typ"

#let _version = version

/// The main template function, this returns a function which is used in a
/// `show`-all rule.
///
/// - title (str, content): The title for of this document.
/// - subtitle (str, content, none): A subtitle shown below the title.
/// - authors (str, content, array): The authors of the document.
/// - urls (str, array, none): One or more URLs relevant to this document.
/// - version (str, version): The version of this document. A string can be
///   passed explicitly to avoid the automatic `v` prefix.
/// - date (datetime): The date at which this document was created.
/// - abstract (str, content, none): An abstract outlining the purpose and
///   contents of this document.
/// - license (str, content, none): The license of this document or a related
///   piece of intellectual property.
/// - theme (theme): The theme to use for this document.
/// -> function
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
  let assert-maybe-text = _pkg.t4t.assert.any-type.with(str, content, type(none))

  assert-text(title)
  assert-maybe-text(subtitle)
  assert-text(array, authors)
  _pkg.t4t.assert.any-type(str, array, type(none), urls)
  assert-maybe-text(abstract)
  _pkg.t4t.assert.any-type(_version, version)
  assert-maybe-text(license)
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
