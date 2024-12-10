
#import "../util/is.typ"
#import "../util/utils.typ"
#import "../util/typst.typ"
#import "../core/index.typ": idx
#import "../core/themes.typ": themable
#import "../core/styles.typ"

#import "icons.typ"
#import "values.typ"
#import "types.typ": dtype, dtypes
#import "links.typ": link-builtin
#import "elements.typ" as elements: module as _module


/// Highlight an argument name.
///
/// #shortex(`#meta[variable]`)
///
/// - name (string, content): Name of the argument.
/// - l (str, content, symbol): Prefix to #arg[name].
/// - r (str, content, symbol): Suffix to #arg[name].
/// -> content
#let meta(name, l: sym.angle.l, r: sym.angle.r) = styles.meta(name, l: l, r: r)


/// Shows an argument, either positional or named.
/// The argument name is highlighted with @cmd:meta and the value with @@value.
///
/// - #shortex(`#arg[name]`)
/// - #shortex(`#arg("name")`)
/// - #shortex(`#arg(name: "value")`)
/// - #shortex(`#arg("name", 5.2)`)
///
/// - ..args (any): Either an argument name (#dtype("string")) or a (`name`: `value`) pair either as a named argument or as exactly two positional arguments.
/// -> content
#let arg(..args, _value: values.value) = {
  let a = none
  if args.pos().len() == 1 {
    a = styles.arg(utils.get-text(args.pos().first()))
  } else if args.named() != (:) {
    a = {
      styles.arg(args.named().keys().first())
      utils.rawi(sym.colon + " ")
      _value(args.named().values().first())
    }
  } else if args.pos().len() == 2 {
    a = {
      styles.arg(args.pos().first())
      utils.rawi(sym.colon + " ")
      _value(args.pos().at(1))
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
///
/// - #shortex(`#barg[body]`)
///
/// - name (string): Name of the argument.
/// -> content
#let barg(name) = styles.barg(name)


/// Shows a "code" argument.
/// #info-alert(width:100%)[
///   "Code" are blocks og Typst code wrapped in braces: `{ ... }`. They are not an actual argument, but evaluate to some other type.
/// ]
/// - #shortex(`#carg[code]`)
///
/// - name (string): Name of the argument.
/// -> content
#let carg(name) = styles.carg(name)


/// Shows an argument sink.
/// - #shortex(`#sarg[args]`)
///
/// - name (string): Name of the argument.
/// -> content
#let sarg(name) = styles.sarg(name)


/// Creates a list of arguments from a set of positional and/or named arguments.
///
/// #dtype("string")s and named arguments are passed to #cmd-[arg], while #dtype("content")
/// arguments are passed to #cmd-[barg].
/// The result is to be unpacked as arguments to #cmd-[cmd].
/// #example[```
/// #cmd( "conditional-show", ..args(hide: false, [body]) )
/// ```]
///
/// - ..args (any): Either an argument name (#dtype("string")) or a (`name`: `value`) pair either as a named argument or as exactly two positional arguments.
/// -> array
#let args(..args) = {
  let arguments = args.pos().filter(is.str).map(arg)
  arguments += args.pos().filter(is.content).map(barg)
  arguments += args.named().pairs().map(v => arg(v.at(0), v.at(1)))
  arguments
}


/// Create a lambda function argument.
/// Lambda arguments may be used as an argument value with arg.
/// To show a lambda function with an argument sink, prefix the type with two dots.
///
/// - #shortex(`#lambda(int, str)`)
/// - #shortex(`#lambda("ratio", "length")`)
/// - #shortex(`#lambda("int", int, ret:bool)`)
/// - #shortex(`#lambda("int", int, ret:(int,str))`)
/// - #shortex(`#lambda("int", int, ret:(name: str))`)
///
/// - ..args (type, string): Argument types of the function parameters.
/// - ret (type): Type of the returned value.
/// -> content
#let lambda(..args, ret: none) = {
  // TODO: improve implementation
  args = args.pos().map(v => {
    if type(v) == str and v.starts-with("..") {
      ".." + dtype(v.slice(2))
    } else {
      dtype(v)
    }
  })
  if type(ret) == array and ret.len() > 0 {
    ret = sym.paren.l + ret.map(dtype).join(",") + if ret.len() == 1 {
      ","
    } + sym.paren.r
  } else if type(ret) == dictionary and ret.len() > 0 {
    ret = sym.paren.l + ret
      .pairs()
      .map(pair => {
          pair.first() + sym.colon + dtype(pair.last())
        })
      .join(",") + sym.paren.r
  } else {
    ret = dtype(ret)
  }
  // mty.mark-lambda(sym.paren.l + args.join(",") + sym.paren.r + " => " + ret)
  //return box(sym.paren.l + args.join(",") + sym.paren.r + sym.arrow.r + ret)
  styles.lambda(args, ret)
}


/// Renders the command #arg[name] with arguments and adds an entry with
/// #arg(kind:"cmd") to the index.
///
/// #arg[args] is a collection of positional arguments created with #cmd[arg],
/// @cmd:barg and @cmd:sarg (or @cmd:args).
///
/// All positional arguments will be rendered first, then named arguments
/// and all body arguments will be added after the closing paranthesis. The relative order of each argument type is kept as given.
///
/// #example[```
///
/// - #cmd("cmd", arg[name], sarg[args], barg[body])
/// - #cmd("cmd", ..args("name", [body]), sarg[args], module:"mod")
/// - #cmd("clamp", arg[value], arg[min], arg[max], module:"math", ret:int, unpack:true)
/// ```]
///
/// - name (string): Name of the command.
/// - module (string): Name of a module, the command belongs to.
/// - ret (any): Returned type.
/// - index (boolean): Whether to add an index entry.
/// - unpack (boolean): If #value(true), the arguments are shown in separate lines.
/// - ..args (any): Arguments for the command, created with individual argument commands (@cmd:arg, @cmd:barg, @cmd:sarg) or @cmd:args.
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

  // TODO: Add module marker ?
  // themable(theme => text(theme.commands.command, utils.rawi(name)))
  styles.cmd(name, module: module)

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


/// Same as @@cmd, but does not create an index entry.
/// -> content
#let cmd- = cmd.with(index: false)


/// Shows the variable #arg[name] and adds an entry to the index.
/// - #shortex(`#var[colors]`)
///
/// - name (string, content): Name of the variable.
/// - module (string): Optional name of a module, the function is in.
/// - index (boolean): Set to #value(false) to not add this location to the index.
/// -> content
#let var(name, module: none, index: true) = {
  if index in (true, "main") {
    idx(
      name,
      kind: "var",
      main: index == "main",
      display: styles.cmd(name, module: module, color: "variable"),
    )
  }
  styles.cmd(name, module: module, color: "variable")
}


/// Same as @@var, but does not create an index entry.
/// -> content
#let var- = var.with(index: false)


/// Displays a built-in Typst function with a link to the documentation.
/// - #shortex(`#builtin[context]`)
/// - #shortex(`#builtin(module:"math")[clamp]`)
///
/// - name (string, content): Name of the function (eg. `raw`).
/// - module (string): Optional module name.
/// -> content
#let builtin(name, module: none) = {
  let name = utils.get-text(name)
  link-builtin(name, styles.cmd(name, color: "builtin", module: module))
}


/// Displays information of a command by formatting the name, description and arguments.
/// See this command description for an example.
///
/// The command is formated with @cmd:cmd and an index entry is set, that is marked as the
/// "main" index entry for this command.
///
/// - name (string): Name of the command.
/// - label (string, auto, none): Custom label for the command.
/// - ..args (content): List of arguments created with the argument functions (@cmd:arg, @cmd:barg, @cmd:sarg) or @cmd:args.
/// - body (content): A description for the command.
/// -> content
#let command(name, label: auto, ..args, body) = block()[
  // TODO refactor to use less mode changes
  #if args.named().at("module", default: none) != none {
    utils.place-reference(
      typst.label("cmd:" + args.named().module + "." + name),
      "cmd",
      "command",
    )
  } else {
    utils.place-reference(
      typst.label("cmd:" + name),
      "cmd",
      "command",
    )
  }
  #block(
    below: 0.65em,
    above: 1.3em,
    breakable: false,
    text(weight: 600, cmd(name, unpack: auto, index: "main", ..args)),
  )
  //#pad(left: 1em, body)//#cmd-label(mty.def.if-auto(name, label))
  // #__s_mty_command.update(none)
  // #v(.65em, weak:true)
  #block(inset: (left: 1em), width: 100%, body)
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
  // TODO also use terms for #argument?
  #set terms(hanging-indent: 0pt)
  #set par(first-line-indent: 0.65pt, hanging-indent: 0pt)
  #let types = (types,).flatten()
  / #var(name, index: "main")#if value != none {
      sym.colon + " " + values.value(value)
    }#if types != (none,) {
      h(1fr) + dtypes(..types)
    }: #block(inset: (left: 2em), body)
]


/// Displays information for a command argument.
/// See the argument list below for an example.
///
/// #example[```
/// #argument("category", default:"utilities")[
///   #lorem(10)
/// ]
///
/// #argument("category", choices: ("a", "b", "c"), default:"d")[
///   #lorem(10)
/// ]
///
/// #argument("style-args", title:"Style Arguments",
///     is-sink:true, types:(length, ratio))[
///   #lorem(10)
/// ]
/// ```]
///
/// - name (string): Name of the argument.
/// - is-sink (boolean): If this is a veriadic argument .
/// - types (array, none): Array of types to be passed to #cmd-[dtypes].
/// - choices (array): Optional array of valid values for this argument.
/// - default (any): Optional default value for this argument. Will be automatically included in #arg[choices], if it is missing. To allow #value(none) as a default value, the default is #value("__none___").
/// - title (string, none): Sets the title of the argument box.
/// - body (content): Description of the argument.
/// -> content
#let argument(
  name,
  is-sink: false,
  types: none,
  choices: none,
  default: "__none__",
  title: "Argument",
  _value: values.value,
  body,
) = {
  types = (types,).flatten()

  v(.65em)
  // TODO: use showybox here?
  themable(theme => block(
    width: 100%,
    above: .65em,
    stroke: .75pt + theme.muted.fill,
    inset: (top: 10pt, rest: 8pt),
    radius: 2pt,
    {
      // Place title
      if title != none {
        place(
          top + left,
          dy: -15.5pt,
          dx: 5.75pt,
          box(
            inset: 2pt,
            fill: white,
            text(size: .75em, font: theme.fonts.sans, theme.muted.fill, title),
          ),
        )
      }
      if is-sink {
        sarg(name)
      } else if default != "__none__" {
        arg(name, default, _value: _value)
      } else {
        arg(name)
      }
      h(1fr)
      if types != (none,) {
        dtypes(..types)
      } else if default != "__none__" {
        dtype(type(default))
      }
      block(width: 100%, below: .65em, inset: (x: .75em), body)
    },
  ))
}


/// Creates a reference to the command #arg[name].
/// This is equivalent to using `@cmd:name`.
/// - #shortex(`#cmdref("builtin")`)
/// - #shortex(`@cmd:builtin`)
#let cmdref(name, module: none) = if module == none {
  ref(label("cmd:" + name))
} else {
  ref(label("cmd:" + module + "." + name))
}


/// Creates a reference to the custom type #arg[name].
/// This is equivalent to using `@type:name`.
///
/// //- #shortex(`#typeref("author")`)
/// //- #shortex(`@cmd:builtin`)
#let typeref(name) = ref(label("type:" + name))


// Internal map of known command properties.
#let _property-spacing = 2pt
#let _properties = (
  default: (k, v) => elements.alert(color: luma(80%), spacing: _property-spacing)[*#utils.rawi(k)*: #utils.rawi(v)],
  //
  deprecated: (
    _,
    v,
  ) => elements.warning-alert(spacing: _property-spacing)[#text(fill: rgb("#ffc008"), icons.warning) this function is *`deprecated`*#if v != true [ and will be removed in version *#v*]],
  //
  since: (
    _,
    v,
  ) => elements.info-alert(spacing: _property-spacing)[#text(fill: rgb("#14a2b8"), icons.info) since version *#v*],
  //
  until: (
    _,
    v,
  ) => elements.warning-alert(spacing: _property-spacing)[#text(fill: rgb("#ffc008"), icons.info) until version *#v*],
  //
  requires-context: (
    _,
    v,
  ) => elements.warning-alert(spacing: _property-spacing)[#text(fill: rgb("#ffc008"), icons.warning) *`requires-context`*],
  //
  see: (
    _,
    v,
  ) => elements.info-alert(spacing: _property-spacing)[#icons.icon("link-external") see #{(v,).flatten().map(t => if is.str(t) { link(t, t) } else { ref(t) } ).join(", ")}],
  //
  todo: (_, v) => elements.alert(
    spacing: _property-spacing,
    color: green,
  )[#text(fill: green)[#icons.icon("check") *TODO*] #v],
)
// #let _properties = (
//   default: (k, v) => [- #themable(t => [#utils.rawc(t.alerts.info, k): #v])],
//   requires-context: (k, _) => [- #themable(t => utils.rawc(t.alerts.error, k)) ],
//   see: (k, v) => [- #themable(t => utils.rawc(t.alerts.info, k))#list(
//         ..v.map(t => if is.str(t) {
//           link(t, t)
//         } else {
//           ref(t)
//         }),
//       )],
// )


/// Shows a command property (annotation).
/// This should be used in the #barg[body] of #cmd-[command] to
/// annotate a function with some special meaning.
///
/// Properties are provided as named arguments to the #cmd-[property]
/// function.
///
/// The following properties are currently known to MANTYS:
/// / requires-context #dtype(bool): Requires a function to be used inside #builtin[context].
///   #property(requires-context: true)
/// / since #dtypes(version, str): Marks this function as available since a given package version.
///   #property(since: version(1,0,0))
/// / until #dtypes(version, str): Marks this function as available until a given package version.
///   #property(until: version(0,1,4))
/// / deprecated #dtypes(bool, version, str): Marks this function as deprecated. If set to a version, the function is supposed to stay availalbel until the given version.
///   #property(deprecated: version(1,0,1))
/// / see #dtype(array) of #dtypes(str, label): Adds references to other commands or websites.
///   #property(see: (<cmd:mantys>, "https://github.vom/jneug/typst-mantys"))
/// / todo #dtypes(str, content): Adds a todo note to the function.
///   #property(todo: [- Add documentation.
///   - Add #arg[foo] paramter.])
///
/// Other named properties will be shown as is:
/// #property(module: "utilities")
#let property(..args) = {
  for (k, v) in args.named() {
    if k in _properties {
      (_properties.at(k))(k, v)
    } else {
      (_properties.default)(k, v)
    }
  }
}
