// #import "@preview/fauxreilly:0.1.0": orly
// #import "@preview/fauxreilly:0.1.1": orly
#let orly(..args) = []

#let primary = rgb("#b22784")
#let secondary = rgb("#0a0a0a")


#let fonts = (
  serif: "Liberation Serif",
  sans: ("Open Sans Condensed", "Open Sans", "Liberation Sans", "Helvetica Neue", "Helvetica"),
  mono: ("Liberation Mono",),
)

#let muted = (
  fill: luma(210),
)

#let text = (
  size: 12pt,
  font: fonts.serif,
  fill: rgb(35, 31, 32),
)

#let heading = (
  font: fonts.sans,
  fill: text.fill,
)

#let header = (
  size: 10pt,
  fill: text.fill,
)

#let footer = (
  size: 9pt,
  fill: muted.fill,
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

#let emph = (
  link: secondary,
  package: primary,
  module: rgb("#8c3fb2"),
)

#let commands = (
  argument: navy,
  command: blue,
  variable: rgb("#9346ff"),
  builtin: eastern,
  comment: gray,
  symbol: text.fill,
)

#let values = (
  default: rgb(181, 2, 86),
)


// TODO: Move type colors to types.typ?
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
      (rgb("#ffa49d"), 100%),
    ),
    gradient: gradient.linear(
      (rgb("#7cd5ff"), 0%),
      (rgb("#a6fbca"), 33%),
      (rgb("#fff37c"), 66%),
      (rgb("#ffa49d"), 100%),
    ),
    stroke: gray,
  )
}


#let page-init(doc) = (
  body => {
    show std.heading: it => {
      let level = it.at("level", default: it.at("depth", default: 2))
      let scale = (1.4, 1.2, 1.1).at(level - 1, default: 1.0)

      let size = 1em * scale
      let above = if level == 1 {
        1.8em
      } else {
        1.44em
      } / scale
      let below = 0.75em / scale

      set std.text(size: size, ..heading)
      set block(above: above, below: below)

      if level == 1 {
        pagebreak(weak: true)
        if it.numbering != none {
          set std.text(fill: secondary)
          [Part ]
          counter(std.heading).display()
          h(1.8em)
          v(-.64em)
          line(length: 100%, stroke: 2pt + secondary)
        }
        set std.text(fill: primary)
        it.body
      } else {
        block({
          set std.text(fill: secondary)
          if it.numbering != none {
            counter(std.heading).display()
            h(1.8em)
          }
          it.body
        })
      }
    }
    body
  }
)

#let _display-author(author) = block({
  smallcaps(author.name)
  set std.text(.88em)
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
  let title = if doc.title == none {
    doc.package.name
  } else {
    doc.title
  }

  orly(
    color: primary,
    font: heading.font,
    title: title,
    subtitle: doc.package.description,
    signature: [
      #set std.text(14pt)
      v#doc.package.version
      #if doc.date != none [
        #h(4em)
        #doc.date.display()
      ]
      #h(4em)
      #doc.package.license
    ],
    publisher: doc.package.authors.map(_display-author).join(", "),
    pic: doc.theme-options.at("title-image", default: none),
    top-text: doc.subtitle,
  )

  set page(header: none, footer: none)
  std.heading(depth: 1, title, numbering: none)

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

    v(1fr)
    std.heading(depth: 2, outlined: false, bookmarked: false, numbering: none, "Table of Contents")
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
