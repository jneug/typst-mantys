#import "../../src/core/layout.typ"
#import "../../src/core/themes.typ"

#show: layout.page-init(
  document.create(
    title: "typst-test",
    ..toml("../../typst.toml"),
  ),
  themes.default,
)
#set page(width: auto, height: auto, margin: 1em)
