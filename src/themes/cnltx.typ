#import "../util/typst.typ"

#let primary = rgb(166, 9, 18)
#let secondary = primary


#let fonts = (
  serif: ("New Computer Modern", "Computer Modern", "Linux Libertine", "Liberation Serif"),
  sans: ("New Computer Modern Sans", "Computer Modern Sans", "Liberation Sans", "Helvetica Neue", "Helvetica"),
  mono: ("Liberation Mono",),
)

#let muted = (
  fill: rgb(128, 128, 128),
)

#let text = (
  size: 12pt,
  font: fonts.serif,
  fill: rgb(0, 0, 0),
)

#let header = (
  size: 10pt,
  fill: text.fill,
)
#let footer = (
  size: 9pt,
  fill: muted.fill,
)

#let heading = (
  font: fonts.serif,
  fill: text.fill,
)

#let emph = (
  link: primary,
  package: primary,
  module: rgb(5, 10, 122),
)

#let code = (
  size: 9pt,
  font: fonts.mono,
  fill: rgb("#999999"),
)

#let alerts = (
  info: rgb(23, 162, 184),
  warning: rgb(255, 193, 7),
  error: rgb(220, 53, 69),
  success: rgb(40, 167, 69),
)


#let commands = (
  argument: navy,
  command: rgb(153, 64, 39),
  variable: rgb(214, 181, 93),
  builtin: eastern,
  comment: rgb(128, 128, 128),
  symbol: text.fill,
)

#let values = (
  default: rgb(181, 2, 86),
)

#let types = {
  let red = rgb(255, 203, 195)
  let gray = rgb(239, 240, 243)
  let purple = rgb(230, 218, 255)

  (
    // fallback
    default: rgb(239, 240, 243),
    custom: rgb("#fcfdb7"),

    // special
    any: gray,
    "auto": red,
    "none": red,

    // foundations
    arguments: gray,
    array: gray,
    boolean: rgb(255, 236, 193),
    bytes: gray,
    content: rgb(166, 235, 229),
    datetime: gray,
    dictionary: gray,
    float: purple,
    function: gray,
    integer: purple,
    location: gray,
    plugin: gray,
    regex: gray,
    selector: gray,
    string: rgb(209, 255, 226),
    type: gray,
    label: rgb(167, 234, 255),
    version: gray,

    // layout
    alignment: gray,
    angle: purple,
    direction: gray,
    fraction: purple,
    length: purple,
    "relative length": purple,
    ratio: purple,
    relative: purple,

    // visualize
    color: gradient.linear(
      (rgb("#7cd5ff"), 0%),
      (rgb("#a6fbca"), 33%),
      (rgb("#fff37c"), 66%),
      (rgb("#ffa49d"), 100%)
    ),
    gradient: gradient.linear(
      (rgb("#7cd5ff"), 0%),
      (rgb("#a6fbca"), 33%),
      (rgb("#fff37c"), 66%),
      (rgb("#ffa49d"), 100%)
    ),
    stroke: gray,
  )
}



#let page-init(doc) = body => {
  show typst.heading: it => {
    let level = it.at("level", default: it.at("depth", default: 2))
    let scale = (1.6, 1.4, 1.2).at(level - 1, default: 1.0)

    let size = 1em * scale
    let above = if level == 1 {
      1.8em
    } else {
      1.44em
    } / scale
    let below = 0.75em / scale

    set typst.text(size: size, ..heading)
    set block(above: above, below: below)

    if level == 1 {
      pagebreak(weak: true)
      block({
        if it.numbering != none {
          typst.text(
            fill: primary,
            {
              [Part ]
              counter(typst.heading).display()
            },
          )
          linebreak()
        }
        it.body
      })
    } else {
      block({
        if it.numbering != none {
          typst.text(fill: primary, counter(typst.heading).display())
          [ ]
        }
        set typst.text(size: size, ..heading)
        it.body
      })
    }
  }
  body
}

#let _display-author(author) = block({
  smallcaps(author.name)
  set typst.text(.88em)
  if author.email != none {
    linebreak()
    " " + sym.lt + link("mailto://" + author.email, author.email) + sym.gt
  }
  if author.affiliation != () {
    linebreak()
    smallcaps(author.affiliation)
  }
  if author.urls != () {
    linebreak()
    author.urls.map(link).join(linebreak())
  }
  if author.github != none {
    linebreak()
    [GitHub: ] + link("https://github.com/" + author.github, author.github)
  }
})

#let title-page(doc) = {
  set align(center)
  set block(spacing: 2em)

  block(
    smallcaps(
      typst.text(
        40pt,
        primary,
        if doc.title == none {
          doc.package.name
        } else {
          doc.title
        },
      ),
    ),
  )
  if doc.subtitle != none {
    block(above: 1em, typst.text(18pt, doc.subtitle))
  }

  typst.text(14pt)[v#doc.package.version]
  if doc.date != none {
    h(4em)
    typst.text(14pt, doc.date.display())
  }
  h(4em)
  typst.text(14pt, doc.package.license)

  if doc.package.description != none {
    block(doc.package.description)
  }

  grid(
    columns: calc.min(4, doc.package.authors.len()),
    gutter: .64em,
    ..doc.package.authors.map(_display-author)
  )

  if doc.urls != none {
    block(doc.urls.map(link).join(linebreak()))
  }

  if doc.abstract != none {
    pad(
      x: 10%,
      {
        set align(left)
        // set par(justify: true)
        // show par: set block(spacing: 1.3em)
        doc.abstract
      },
    )
  }

  if doc.show-outline {
    set align(left)
    set block(spacing: 0.65em)
    show outline.entry.where(level: 1): it => {
      v(0.85em, weak: true)
      strong(link(it.element.location(), it.body))
    }

    typst.heading(level: 2, outlined: false, bookmarked: false, numbering: none, "Table of Contents")
    columns(
      2,
      outline(
        title: none,
        indent: 1em,
        depth: 3,
        fill: repeat("."),
      ),
    )
  }
}
