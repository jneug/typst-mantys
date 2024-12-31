#import "../../src/core/document.typ"
#import "../../src/core/layout.typ"

#import "../test-theme.typ": test-theme

#show: layout.page-init(
  document.create(
    title: "typst-test",
    ..toml("../../typst.toml"),
  ),
  test-theme,
)
#set page(width: auto, height: auto, margin: 1em)
