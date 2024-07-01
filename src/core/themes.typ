#import "../themes/default.typ"
#import "../themes/modern.typ"


#let themable(func, kind: "themable", ..args) = [#metadata((func: func, args: args.pos(), kind: kind))<mantys:themable>]
