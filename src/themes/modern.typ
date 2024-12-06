#import "../util/typst.typ"

#let primary = rgb("#ed592f")
#let secondary = rgb("#05b5da")

#let fonts = (
  serif: ("Linux Libertine", "Liberation Serif"),
  sans: ("Source Sans Pro", "Roboto"),
  mono: ("Fira Code", "Liberation Mono"),
)

#let muted = (
  fill: luma(80%),
)

#let text = (
  size: 12pt,
  font: fonts.sans,
  fill: rgb("#333333"),
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
  size: 15pt,
  font: fonts.sans,
  fill: primary,
)

#let alerts = (
  info: rgb(23, 162, 184),
  warning: rgb(255, 193, 7),
  error: rgb(220, 53, 69),
  success: rgb(40, 167, 69),
)

#let code = (
  size: 12pt,
  font: fonts.mono,
  fill: rgb("#999999"),
)

#let emph = (
  link: secondary,
  package: primary,
  module: rgb("#8c3fb2"),
)

#let commands = (
  argument: rgb("#3c5c99"),
  option: rgb(214, 182, 93),
  command: blue, // rgb(75, 105, 197),
  builtin: eastern,
  comment: gray, // rgb(128, 128, 128),
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
    show typst.heading.where(level: 1): it => {
      pagebreak(weak: true)
      set typst.text(fill: primary)
      block(
        width: 100%,
        breakable: false,
        inset: (bottom: .33em),
        stroke: (bottom: .6pt + secondary),
        [#if it.numbering != none {
            typst.text(
              weight: "semibold",
              secondary,
              [Part ] + counter(typst.heading.where(level: it.level)).display(it.numbering),
            ) + h(1.28em)
          } #it.body],
      )
    }
    body
  }
)

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
