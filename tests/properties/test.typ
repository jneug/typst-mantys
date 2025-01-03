
// Test: properties
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

#import "../../src/api/commands.typ": property, _properties

#figure("") <cmd:xx>

/ deprecated: #property(deprecated: true)
/ deprecated: #property(deprecated: version(0, 1, 2))

/ since: #property(since: version(0, 1, 0))
/ until: #property(until: version(0, 1, 0))
/ requires-context: #property(requires-context: true)
/ see: #property(see: "https://ngb.schule")
/ todo: #property(todo: lorem(10))
