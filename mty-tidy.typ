
#import "./mty.typ": frame
#import "./api.typ": dtype, cmd, cmd-, arg, sarg, barg, command, argument
#import "./theme.typ"

// Color to highlight function names in
#let fn-color = theme.colors.command

// Colors for Typst types
#let type-colors = theme.colors.dtypes

#let get-type-color(type) = type-colors.at(type, default: theme.colors.dtypes.at("any"))

#let show-outline(module-doc) = {
  let prefix = module-doc.label-prefix
  let items = ()
  for fn in module-doc.functions.sorted(key: (fn) => fn.name) {
    items.push(link(label(prefix + fn.name + "()"), cmd-(fn.name)))
  }

  let cols_num = 3
  let per_col = calc.floor(items.len() / cols_num)
  let cols = ()
  for i in range(cols_num) {
    cols.push(items.slice(i * per_col,(i+1) * per_col).join(linebreak()))
  }
  frame(
    frame: (
      border-color: theme.colors.secondary,
      thickness: .75pt,
      radius: 4pt
    ),
    {
      set text(.88em)
      grid(
        columns: (1fr,) * cols_num,
        ..cols
      )
    }
  )
}

// Create beautiful, colored type box
#let show-type = dtype

#let show-parameter-list(fn, display-type-function) = {
  cmd(
    fn.name,
    ..fn.args.pairs().map(((a, info)) => {
      if a.starts-with("..") {
        sarg(a.slice(2))
      } else {
        if "default" in info {
          arg(a, info.default)
        } else {
          arg(a)
        }
      }
    }),
    ret:fn.return-types
  )
}



// Create a parameter description block, containing name, type, description and optionally the default value.
#let show-parameter-block(
  name, types, content, style-args,
  show-default: false,
  default: none,
) = {
  argument(
    if name.starts-with("..") { name.slice(2) } else { name },
    is-sink: name.starts-with(".."),
    types: types,
    default: if show-default { eval(default) } else { "__none__" },
    content
  )
}


#let show-function(
  fn, style-args,
) = [
  #command(
    fn.name,
    ..fn.args.pairs().map(((a, info)) => {
      if a.starts-with("..") {
        sarg(a.slice(2))
      } else {
        if "default" in info {
          arg(a, eval(info.default))
        } else {
          arg(a)
        }
      }
    }),
    [
      #fn.description

      #for (name, info) in fn.args {
        let description = info.at("description", default: "")
        if description in ("", []) and style-args.omit-empty-param-descriptions { continue }
        (style-args.style.show-parameter-block)(
          name,
          info.at("types", default: ()),
          description,
          style-args,
          show-default: "default" in info,
          default: info.at("default", default: none)
        )
      }
    ]
  )
  #label(style-args.label-prefix + fn.name + "()")
]

