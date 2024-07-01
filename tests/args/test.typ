#import "../../src/api/commands.typ": *
#import "../../src/core/layout.typ"
#import "../../src/core/themes.typ"

#show: layout.page-init((package: (name: "Test")), themes.default)

= Arguments and variables

- #meta("meta-name")

- #arg("arg-name")
- #arg("arg-name", true)
- #arg(arg-name: false)
- #arg(foo: "bar")

- #sarg("sarg-name")
- #barg("barg-name")
- #carg("carg-name")

== `#repr`

- #repr(arg("name"))
