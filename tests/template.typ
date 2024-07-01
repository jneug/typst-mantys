#import "../../src/layout/main.typ" as layout
#import "../../src/core/themes.typ"

#show: layout.page-init(
  document.create(
    title: "typst-test",
    ..toml("../../typst.toml"),
  ),
  themes.default,
)
#set page(width: auto, height: auto, margin: 1em)
