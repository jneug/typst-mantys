#import "../../src/api/values.typ": *
#import "../../src/core/layout.typ"
#import "../../src/core/themes.typ"

#show: layout.page-init((package: (name: "Test"), git: none), themes.default)


= Values
#let x = "Hello, World"

- #value("string")
- #value([string])
- #value(true)
- #value(1.0)
- #value(3em)
- #value(50%)
- #value(left)
- #value(left + bottom)
- #value(ttb)
- #value((a: 1, b: 2))
- #value(x)
- #value("x", repr: false)

= Default values

- #default("string")
- #default([string])
- #default(true)
- #default(1.0)
- #default(3em)
- #default(50%)
- #default(left)
