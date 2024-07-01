#import "../../src/core/document.typ"
#import "../../src/layout/main.typ" as layout
#import "../../src/core/themes.typ"

#import "../../src/api/links.typ": *

#show: layout.page-init(
  document.create(
    title: "typst-test",
    ..toml("../../typst.toml"),
  ),
  themes.default,
)
#set page(width: 10cm, height: auto, margin: 1em)

= Links
- #link("https://neugebauer.cc")
- #link("https://neugebauer.cc", "neugebauer.cc")
- #link("*https://neugebauer.cc", "neugebauer.cc")
- #link("https://neugebauer.cc", "neugebauer.cc", footnote: false)
- #link("https://neugebauer.cc", "neugebauer.cc", footnote: true)
- #link((page: 1, x: 0pt, y: 20cm), "neugebauer.cc")

= GitHub
- #github("jneug/mantys")
- #github("https://github.com/jneug/mantys")

= Typst Universe
- #universe("mantys")
- #universe("codelst")

= Typst `@preview`
- #preview("mantys")
- #preview("mantys:0.1.4")
- #preview("mantys", ver: version(0, 1, 4))
