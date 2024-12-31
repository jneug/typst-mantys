#import "../../src/mantys.typ": mantys-init
#import "../../src/api/elements.typ": *

#import "../test-theme.typ": test-theme

#let (doc, page-init) = mantys-init(..toml("../test.toml"), theme: test-theme)

#show: page-init

#info-alert(lorem(50))

#warning-alert(lorem(50))

#error-alert(lorem(50))

#success-alert(lorem(50))
