#import "../util/typst.typ"

#let primary = eastern
#let secondary = teal


#let fonts = (
  serif: ("Linux Libertine", "Liberation Serif"),
  sans: ("Liberation Sans", "Helvetica Neue", "Helvetica"),
  mono: ("Liberation Mono",),
)

#let text = (
  size: 12pt,
  font: fonts.serif,
  fill: rgb(35, 31, 32),
)

#let muted = (
  fill: luma(210),
)

#let heading = (
  size: 15pt,
  font: fonts.sans,
  fill: primary,
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
  option: rgb(214, 182, 93),
  command: blue,
  builtin: eastern,
  comment: gray,
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
  show typst.heading.where(level: 1): it => {
    pagebreak(weak: true)
    set typst.text(fill: text.fill)
    block(
      width: 100%,
      breakable: false,
      [#if it.numbering != none {
          typst.text(
            weight: "semibold",
            primary,
            [Part ] + counter(typst.heading.where(level: it.level)).display(it.numbering),
          ) + h(1.28em)
        }\
        #it.body],
    ) + v(.64em)
  }
  body
}

#let title-page(doc) = {
  set align(center)
  v(2fr)

  block(
    width: 100%,
    inset: (y: 1.28em),
    stroke: (bottom: 2pt + secondary),
    [
      #set typst.text(40pt)
      #doc.title
    ],
  )

  if doc.subtitle != none {
    typst.text(18pt, doc.subtitle)
    v(1em)
  }

  typst.text(14pt)[Version #doc.package.version]
  if doc.date != none {
    h(3em)
    typst.text(14pt, doc.date.display())
  }
  h(3em)
  typst.text(14pt, doc.package.license)

  v(1fr)
  pad(
    x: 10%,
    {
      set align(left)
      doc.abstract
    },
  )
  v(1fr)
  if doc.show-outline {
    typst.heading(level: 2, outlined: false, numbering: none, "Table of Contents")
    columns(
      2,
      outline(title: none),
    )
  }
  v(2fr)
}
