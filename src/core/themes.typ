#import "../themes/default.typ"
#import "../themes/modern.typ"


// #let themeable(element, tag) = [#element#label("mantys-theme-" + tag)]

#let themable(func, kind: "themable", ..args) = [#metadata((func: func, args: args.pos(), kind: kind))<mantys:themable>]
