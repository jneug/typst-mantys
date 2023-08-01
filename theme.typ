#let page = (
  paper: "a4",
	margin: auto
)


#let fonts = (
  serif: ("Linux Libertine"),
  sans: ("Liberation Sans", "Helvetica Neue", "Helvetica"),
  mono: ("Liberation Mono"),

  text: ("Linux Libertine"),
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

  text:      rgb(35, 31, 32),
  muted:     luma(210),

	info:      rgb(23, 162, 184),
	warning:   rgb(255, 193, 7),
	error:     rgb(220, 53, 69),
	success:   rgb(40, 167, 69),

  // Datatypes taken from typst.app
	dtypes: (
		length: rgb(230, 218, 255),
		integer: rgb(230, 218, 255),
		float: rgb(230, 218, 255),
		fraction: rgb(230, 218, 255),
		ratio: rgb(230, 218, 255),
		"relative length": rgb(230, 218, 255),
		"none": rgb(255, 203, 195),
		"auto": rgb(255, 203, 195),
		"any": rgb(255, 203, 195),
		"regular expression": rgb(239, 240, 243),
		dictionary: rgb(239, 240, 243),
		array: rgb(239, 240, 243),
		stroke: rgb(239, 240, 243),
		location: rgb(239, 240, 243),
		alignment: rgb(239, 240, 243),
		"2d alignment": rgb(239, 240, 243),
		boolean: rgb(255, 236, 193),
		content: rgb(166, 235, 229),
		string: rgb(209, 255, 226),
		function: rgb(249, 223, 255),
		color: (
			rgb(133, 221, 244),
			rgb(170, 251, 198),
			rgb(214, 247, 160),
			rgb(255, 243, 124),
			rgb(255, 187, 147)
		)
	)
)

#let color-map = (
    black: black,
    gray: gray,
    silver: silver,
    white: white,
    navy: navy,
    blue: blue,
    aqua: aqua,
    teal: teal,
    eastern: eastern,
    purple: purple,
    fuchsia: fuchsia,
    maroon: maroon,
    red: red,
    orange: orange,
    yellow: yellow,
    olive: olive,
    green: green,
    lime: lime
)

#let convert-color( v, default:black ) = {
  if type(v) == "string" and v in color-map {
    return color-map.at(v)
  } else if type(v) == "integer" {
    return luma(v)
  } else if type(v) == "array" {
    if v.len() == 3 {
      return rgb(v.at(0), v.at(1), v.at(2))
    } else if v.len() == 4 {
      return cmyk(v.at(0), v.at(1), v.at(2), v.at(3))
    }
  }
  default
}

#let toml-theme = toml("theme.toml")

#for (k,v) in toml-theme.at("colors", default:(:)) {
  if type(v) != "dictionary" {
    toml-theme.at("colors").at(k) = convert-color(v)
  }
}
#for (k, v) in toml-theme.at("colors", default:(:)).at("dtypes", default:(:)) {
  if k == "color" {
    for (i, vv) in v.enumerate() {
      toml-theme.at("colors").at("dtypes").at("color").at(i) = convert-color(vv)
    }
  } else {
    toml-theme.at("colors").at("dtypes").at(k) = convert-color(v)
  }
}
#for (k,v) in toml-theme.at("font-sizes", default:(:)) {
  toml-theme.at("font-sizes").at(k) = v * 1pt
}
#if toml-theme.at("page").at("margin") == "auto" {
  toml-theme.at("page").at("margin") = auto
}
