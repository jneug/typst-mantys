
#import "../util/is.typ"
#import "../util/utils.typ"
#import "../core/index.typ": idx
#import "../core/themes.typ": themable

#import "values.typ": value
#import "types.typ": dtype, dtypes
#import "links.typ": link-builtin
#import "elements.typ": module as _module

/// Highlight an argument name.
/// #shortex(`#meta[variable]`)
///
/// - name (string, content): Name of the argument.
/// -> content
#let meta(name, l: sym.angle.l, r: sym.angle.r, ..args) = themable(
  theme => text(
    theme.commands.argument,
    utils.rawi(l + name + r),
  ),
  ..args,
)

/// Shows an argument, either positional or named. The argument name is highlighted with #cmd-[meta] and the value with #cmd-[value].
///
/// - #shortex(`#arg[name]`)
/// - #shortex(`#arg("name")`)
/// - #shortex(`#arg(name: "value")`)
/// - #shortex(`#arg("name", 5.2)`)
///
/// - ..args (any): Either an argument name (#dtype("string")) or a (`name`: `value`) pair either as a named argument or as exactly two positional arguments.
/// -> content
#let arg(..args) = {
  let a = none
  if args.pos().len() == 1 {
    a = meta(utils.get-text(args.pos().first()), kind: "arg")
  } else if args.named() != (:) {
    a = {
      meta(args.named().keys().first(), kind: "arg")
      utils.rawi(sym.colon + " ")
      value(args.named().values().first())
    }
  } else if args.pos().len() == 2 {
    a = {
      meta(args.pos().first(), kind: "arg")
      utils.rawi(sym.colon + " ")
      value(args.pos().at(1))
    }
  } else {
    panic("Wrong argument count. Got " + repr(args.pos()))
    return
  }
  a
}


/// Shows a body argument.
/// #info-alert(width:100%)[
///   Body arguments are positional arguments that can be given
///   as a separat content block at the end of a command.
/// ]
/// - #shortex(`#barg[body]`)
///
/// - name (string): Name of the argument.
/// -> content
#let barg(name) = {
  let b = {
    meta(utils.get-text(name), l: sym.bracket.l, r: sym.bracket.r, kind: "barg")
  }
  b
}


/// Shows a "code" argument.
/// #info-alert(width:100%)[
///   "Code" are blocks og Typst code wrapped in braces: `{ ... }`. They are not an actual argument, but evaluate to some type.
/// ]
/// - #shortex(`#carg[code]`)
///
/// - name (string): Name of the argument.
/// -> content
#let carg(name) = {
  let c = {
    meta(utils.get-text(name), l: sym.brace.l, r: sym.brace.r, kind: "carg")
  }
  c
}


/// Shows an argument sink.
/// - #shortex(`#sarg[args]`)
///
/// - name (string): Name of the argument.
/// -> content
#let sarg(name) = {
  let s = ".." + meta(utils.get-text(name), kind: "sarg")
  s
}

/// Renders the command #arg[name] with arguments and adds an entry with
/// #arg(kind:"command") to the index.
///
/// #arg[args] is a collection of positional arguments created with #cmd[arg],
/// #cmd[barg] and #cmd[sarg].
///
/// All positional arguments will be rendered first, then named arguments
/// and all body arguments will be added after the closing paranthesis.
///
/// - #shortex(`#cmd("cmd", arg[name], sarg[args], barg[body])`)
/// - #shortex(`#cmd("cmd", ..args("name", [body]), sarg[args])`)
///
/// - name (string): Name of the command.
/// - module (string): Name of a module, the command belongs to.
/// - ret (any): Returned type.
/// - index (boolean): Whether to add an index entry.
/// - unpack (boolean): If #value(true), the arguments are shown in separate lines.
/// - ..args (any): Arguments for the command, created with the argument commands above or @@args.
/// -> content
#let cmd(name, module: none, ret: none, index: true, unpack: false, ..args) = {
  if index in (true, "main") {
    idx(
      name,
      kind: "cmd",
      main: index == "main",
      display: styles.cmd(name, module: module),
    )
  }

  utils.rawi(sym.hash)
  if module != none {
    _module(module) + `.`
  } else {
    // mty.place-marker("cmd-module")
  }
  themable(theme => text(theme.commands.command, utils.rawi(name)))

  let fargs = args.pos().filter(arg => not is.barg(arg))
  let bargs = args.pos().filter(is.barg)

  if fargs == () { } else if unpack == true or (unpack == auto and fargs.len() >= 5) {
    utils.rawi(sym.paren.l) + [\ #h(1em)]
    fargs.join([`,`\ #h(1em)])
    [\ ] + utils.rawi(sym.paren.r)
  } else {
    utils.rawi(sym.paren.l)
    fargs.join(`, `)
    utils.rawi(sym.paren.r)
  }
  bargs.join()
  if ret != none {
    ret = (ret,).flatten()
    box(inset: (x: 2pt), sym.arrow.r) //utils.rawi("->"))
    ret.map(dtype).join(" | ") //dtypes(..ret)
  }
}

#let cmd- = cmd.with(index: false)

/// Displays a built-in Typst function with a
/// link to the documentation.
/// - name (string, content): Name of the function (eg. `raw`).
/// -> content
#let builtin(name) = {
  themable(theme => {
    utils.rawi(sym.hash)
    link-builtin(utils.get-text(name), text(theme.commands.builtin, name))
  })
}

/// Displays information of a command by formatting the name, description and arguments.
/// See this command description for an example.
///
/// - name (string): Name of the command.
/// - label (string): Custom label for the command. Defaults to #value(auto).
/// - ..args (content): List of arguments created with the argument functions like @@arg.
/// - body (content): Description for the command.
/// -> content
#let command(name, label: auto, ..args, body) = [
  // #__s_mty_command.update(name)
  #block(
    below: 0.65em,
    above: 1.3em,
    breakable: false,
    text(weight: 600)[#cmd(name, unpack: auto, index: "main", ..args)<cmd>],
  )
  #pad(left: 1em, body)//#cmd-label(mty.def.if-auto(name, label))
  // #__s_mty_command.update(none)
  // #v(.65em, weak:true)
]

/// Displays information for a variable defintion.
/// #example[```
/// #variable("primary", types:("color",), value:green)[
///   Primary color.
/// ]
/// ```]
///
/// - name (string): Name of the variable.
/// - types (array): Array of types to be passed to @@dtypes.
/// - value (any): Default value.
/// - body (content): Description of the variable.
/// -> content
#let variable(name, types: none, value: none, label: auto, body) = [
  #set terms(hanging-indent: 0pt)
  #set par(first-line-indent: 0.65pt, hanging-indent: 0pt)
  / #var(name)#{
    if value != none {
      " " + sym.colon + " " + _v(value)
    }
  }#{
    if types != none {
      h(1fr) + dtypes(..types)
    }
  }<var>: #block(inset: (left: 2em), body)#var-label(mty.def.if-auto(name, label))
]

/// Displays information for a command argument.
/// See the argument list below for an example.
///
/// - name (string): Name of the argument.
/// - is-sink (boolean): If this is a sink argument.
/// - types (array): Array of types to be passed to @@dtypes.
/// - choices (array): Optional array of valid values for this argument.
/// - default (any): Optional default value for this argument.
/// - body (content): Description of the argument.
/// -> content
#let argument(
  name,
  is-sink: false,
  types: none,
  choices: none,
  default: "__none__",
  title: "Argument",
  body,
) = {
  types = (types,).flatten()

  v(.65em)
  themable(theme => block(
    above: .65em,
    stroke: .75pt + theme.muted.fill,
    inset: (top: 10pt, left: -1em + 8pt, rest: 8pt),
    outset: (left: 1em),
    radius: 2pt,
    {
      place(
        top + left,
        dy: -15.5pt,
        dx: 5.75pt,
        box(inset: 2pt, fill: white, text(size: .75em, font: theme.fonts.sans, theme.muted.fill, title)),
      )
      if is-sink {
        sarg(name)
      } else if default != "__none__" {
        arg(name, default)
      } else {
        arg(name)
      }
      h(1fr)
      if types != (none,) {
        dtypes(..types)
      } else if default != "__none__" {
        dtype(default)
      }
      block(width: 100%, below: .65em, inset: (x: .75em), body)
    },
  ))
}
