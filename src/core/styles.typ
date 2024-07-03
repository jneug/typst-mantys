#import "themes.typ": themable
#import "../util/utils.typ": rawi

#let rawc(fill, code) = text(fill, rawi(code))

#let meta(name, l: none, r: none, kind: "arg") = themable(
  theme => {
    if l != none {
      rawc(theme.commands.symbol, l)
    }
    rawc(theme.commands.argument, name)
    if r != none {
      rawc(theme.commands.symbol, r)
    }
  },
  kind: kind,
)

// TODO: Use styles consistently
#let arg = meta.with(l: sym.angle.l, r: sym.angle.r, kind: "arg")

#let sarg = meta.with(l: ".." + sym.angle.l, r: sym.angle.r, kind: "sarg")

#let barg = meta.with(l: sym.bracket.l, r: sym.bracket.r, kind: "barg")

#let carg = meta.with(l: sym.brace.l, r: sym.brace.r, kind: "carg")

#let cmd(name, module: none, color: "command") = themable(
  theme => {
    rawc(theme.commands.symbol, sym.hash)
    if module != none {
      rawc(theme.emph.module, module)
      rawc(theme.commands.symbol, ".")
    }
    rawc(theme.commands.at(color, default: theme.commands.command), name)
  },
  kind: "cmd",
)