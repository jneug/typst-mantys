#import "../../src/layout/main.typ" as layout
#import "../../src/core/themes.typ"

#show: layout.page-init((package: (name: "Test")), themes.default)
#set page(width: auto, height: auto, margin: 1em)

= Links
- #link("https://neugebauer.cc")
- #link("https://neugebauer.cc", "neugebauer.cc")
- #link("*https://neugebauer.cc", "neugebauer.cc")
- #link((page: 1, x: 0pt, y: 20cm), "neugebauer.cc")

= GitHub
-
