
#let page = (
  paper: "a4",
  margin: auto
)


#let fonts = (
  serif: ("Linux Libertine", "Liberation Serif"),
  sans: ("Liberation Sans", "Helvetica Neue", "Helvetica"),
  mono: ("Liberation Mono"),

  text: ("Linux Libertine", "Liberation Serif"),
  headings: ("Liberation Sans", "Helvetica Neue", "Helvetica"),
  code: ("Liberation Mono")
)

#let font-sizes = (
  text: 12pt,
  headings: 12pt,   // Used as a base size, scaled by heading level
  code: 9pt
)


#let colors = (
  primary:   eastern,   // rgb(31, 158, 173),
  secondary: teal,      // rgb(18, 120, 133),
  argument:  navy,      // rgb(0, 29, 87),
  option:    rgb(214, 182, 93),
  value:     rgb(181, 2, 86),
  command:   blue,      // rgb(75, 105, 197),
  comment:   gray,      // rgb(128, 128, 128),
  module:    rgb("#8c3fb2"),

  text:      rgb(35, 31, 32),
  muted:     luma(210),

  info:      rgb(23, 162, 184),
  warning:   rgb(255, 193, 7),
  error:     rgb(220, 53, 69),
  success:   rgb(40, 167, 69),

  // Datatypes taken from typst.app
  dtypes: {
    let red = rgb(255, 203, 195)
    let gray = rgb(239, 240, 243)
    let purple = rgb(230, 218, 255)
    let gradient-colors = (
      (rgb("#7cd5ff"), 0%),
      (rgb("#a6fbca"), 33%),
      (rgb("#fff37c"), 66%),
      (rgb("#ffa49d"), 100%),
    )

    (
      // special
      any: gray,
      "auto": red,
      "none": red,

      // foundations
      arguments: gray,
      array: gray,
      bool: rgb(255, 236, 193),
      bytes: gray,
      content: rgb(166, 235, 229),
      datetime: gray,
      dictionary: gray,
      float: purple,
      function: gray,
      int: purple,
      location: gray,
      plugin: gray,
      regex: gray,
      selector: gray,
      str: rgb(209, 255, 226),
      type: gray,
      label: rgb(167, 234, 255),

      // layout
      alignment: gray,
      angle: purple,
      direction: gray,
      fraction: purple,
      length: purple,
      ratio: purple,
      relative: purple,

      // visualize
      color: gradient.linear(..gradient-colors),
      gradient: gradient.linear(..gradient-colors),
      stroke: gray,
    )
  }
)
