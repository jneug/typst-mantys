#import "../../src/api/types.typ": *
#import "../../src/core/schema.typ" as s
#import "../../src/core/layout.typ"
#import "../../src/core/themes.typ": default

#show: layout.page-init((package: (name: "Test"), git: none), default)


= Build-in types

== Types by type

#block(
  width: 100%,
  height: 40%,
  columns(
    2,
    for (_, t) in _type-map [
      - #dtype(t)
    ],
  ),
)

== Types by name

#block(
  width: 100%,
  height: 40%,
  columns(
    2,
    for (t, _) in _type-map [
      - #dtype(t)
    ],
  ),
)

== Types by alias

- #dtype("str")
- #dtype("int")
- #dtype("arr")
- #dtype("dict")

== Types by value

- #dtype(1)
- #dtype(1.2)
- #dtype(true)

== Unknown types
- #dtype("unknown")

#pagebreak()
= Custom types

- #dtype("document")
- #link-custom-type("coordinates")
- #link-custom-type("author")
- #dtype("author")

== Coordinates
#custom-type("coordinates", color: red.lighten(80%))

#lorem(50)

== Author schema
#schema("author", s.author)

== Package schema
#schema("package", s.package)

== Document schema
#schema("document", s.document)

