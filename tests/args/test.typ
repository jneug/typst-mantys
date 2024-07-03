#import "../../src/api/commands.typ": *
#import "../../src/core/layout.typ"
#import "../../src/core/themes.typ"

#show: layout.page-init((package: (name: "Test")), themes.default)

= Arguments and variable

#table(
  columns: 3,
  [command], [as string], [as content],
  ..for x in (meta, arg, barg, carg, sarg) {
    (
      sym.hash + repr(x),
      x("arg-name"),
      x[arg-name],
    )
  }
)

- #arg("arg-name", true)
- #arg("arg-name", 1.5pt)
- #arg(arg-name: center)
- #arg(arg-name: "bar")

== `kind`

/ arg: #arg("name").value.kind
/ barg: #barg("name").value.kind
/ carg: #carg("name").value.kind
/ sarg: #sarg("name").value.kind

== `#argument`

#argument("arg-name")[
  #lorem(20)
]

#argument("arg-name", default: 1cm)[
  #lorem(20)
]

#argument("arg-name", default: 1cm, types: (length, ratio))[
  #lorem(20)
]
