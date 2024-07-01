#import "../../src/core/layout.typ"
#import "../../src/core/themes.typ"

#show: layout.page-init((package: (name: "Test")), themes.default)


#import "../../src/api/commands.typ": *


= Commands
== `#cmd`

- #cmd("cmd-name")
- #cmd[cmd-name]
- #cmd(module: "foo")[cmd-name]


== `#command`

- #command("cmd-name", arg("foo"), barg("body"), sarg("args"))[
    #lorem(25)
  ]
