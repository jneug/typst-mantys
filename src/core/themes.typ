#import "../themes/default.typ"
#import "../themes/modern.typ"
#import "../themes/cnltx.typ"
#import "../themes/orly.typ"


#let themable(func, kind: "themable", ..args) = [#metadata((func: func, args: args.pos(), kind: kind))<mantys:themable>]


#let create-theme() = { }
