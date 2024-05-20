#let default = (
  fonts: (
    serif: ("Linux Libertine", "Liberation Serif"),
    sans: ("Liberation Sans", "Helvetica Neue", "Helvetica"),
    mono: ("Liberation Mono"),

    text: ("Linux Libertine", "Liberation Serif"),
    headings: ("Liberation Sans", "Helvetica Neue", "Helvetica"),
    code: ("Liberation Mono")
  ),
  colors: (
    primary:   eastern,
    secondary: teal,
    argument:  navy,
    option:    rgb(214, 182, 93),
    value:     rgb(181, 2, 86),
    command:   blue,
    comment:   gray,
    module:    rgb(140, 63, 178),

    text:      rgb(35, 31, 32),
    muted:     luma(210),

    info:      rgb(23, 162, 184),
    warning:   rgb(255, 193, 7),
    error:     rgb(220, 53, 69),
    success:   rgb(40, 167, 69),

    types: {
      let red = rgb(255, 203, 195)
      let gray = rgb(239, 240, 243)
      let purple = rgb(230, 218, 255)

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
        color: gradient.linear(..color.map.spectral, angle: 180deg),
        gradient: gradient.linear(..color.map.spectral, angle: 180deg),
        stroke: gray,
      )
    }
  ),
)
