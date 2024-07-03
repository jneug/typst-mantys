#import "../_deps.typ" as deps
#import "../_api.typ" as api

#import "../util/utils.typ"

#import deps.tidy.utilities: *

// TODO: handle Tidy settings like label-prefix, locale ...

// Internal version of #eval_docstring.
// Adds Mantys API as preamble.
#let _eval-docstring(docstring, style-args) = deps.tidy.utilities.eval-docstring(
  utils.add-preamble(docstring, ("mantys": "*")),
  style-args,
)

/// Shows the outline of a module (list pf functions).
///
/// - module-doc (dictionary): Parsed module data.
/// - style-args (dictionary): Styling arguments.
/// -> content
#let show-outline(module-doc, style-args: (:)) = {
  let prefix = module-doc.label-prefix
  let items = ()
  for fn in module-doc.functions.sorted(key: fn => fn.name) {
    items.push(api.cmdref(fn.name))
  }

  if items != () {
    let cols_num = 3
    let per_col = calc.ceil(items.len() / cols_num)
    let cols = ()
    for i in range(items.len(), step: per_col) {
      cols.push(
        items.slice(
          i,
          calc.min(i + per_col, items.len()),
        ).join(linebreak()),
      )
    }
    api.frame({
      set text(.88em)
      grid(
        columns: (1fr,) * cols_num,
        ..cols
      )
    })
  }
}


/// Uses @cmd:dtype to create a colorful type-box.
#let show-type(type, style-args: (:)) = api.dtype(type)



#let show-parameter-list(fn, style-args) = {
  block(
    fill: rgb("#d8dbed"),
    width: 100%,
    inset: (x: 0.5em, y: 0.7em),
    {
      set text(font: "Cascadia Mono", size: 0.85em, weight: 340)
      text(fn.name, fill: blue)
      "("
      let inline-args = fn.args.len() < 5
      if not inline-args {
        "\n  "
      }
      let items = ()
      for (arg-name, info) in fn.args {
        if style-args.omit-private-parameters and arg-name.starts-with("_") {
          continue
        }
        let types
        if "types" in info {
          types = ": " + info.types.map(x => show-type(x)).join(" ")
        }
        items.push(box(arg-name + types))
      }
      items.join(if inline-args {
        ", "
      } else {
        ",\n  "
      })
      if not inline-args {
        "\n"
      } + ")"
      if fn.return-types != none {
        box[~-> #fn.return-types.map(x => show-type(x)).join(" ")]
      }
    },
  )
}


#let show-parameter-block(
  name,
  types,
  content,
  style-args,
  show-default: false,
  default: none,
) = api.argument(
  if name.starts-with("..") {
    name.slice(2)
  } else {
    name
  },
  is-sink: name.starts-with(".."),
  types: types,
  default: if show-default {
    default
  } else {
    "__none__"
  },
  _value: api.value.with(parse-str: true),
  content,
)


#let show-function(
  fn,
  style-args,
) = {
  // add mantys api to scope
  style-args.scope.insert("mantys", api)
  style-args.scope.insert("property", api.property)

  // evaluate docstring
  let descr = _eval-docstring(fn.description, style-args)

  // remove private parameters
  if style-args.omit-private-parameters {
    for (name, arg) in fn.args {
      if name.starts-with("_") {
        _ = fn.args.remove(name)
      }
    }
  }

  [
    #api.command(
      fn.name,
      ..fn.args.pairs().map(((a, info)) => {
        if a.starts-with("..") {
          api.sarg(a.slice(2))
        } else if "types" in info and info.types == ("content",) and "default" not in info {
          api.barg(a)
        } else {
          if "default" in info {
            api.arg(a, info.default, _value: api.value.with(parse-str: true))
          } else {
            api.arg(a)
          }
        }
      }),
      ret: fn.return-types,
      {
        descr

        for (name, info) in fn.args {
          let description = info.at("description", default: "")
          if description in ("", []) and style-args.omit-empty-param-descriptions {
            continue
          }
          (style-args.style.show-parameter-block)(
            name,
            info.at("types", default: ()),
            _eval-docstring(description, style-args),
            style-args,
            show-default: "default" in info,
            default: info.at("default", default: none),
          )
        }
      },
    )
    // #label(style-args.label-prefix + fn.name + "()")
  ]
}


// TODO: implement
#let show-variable(
  var,
  style-args,
) = {
  set par(justify: false, hanging-indent: 1em, first-line-indent: 0em)

  let type = if "type" not in var {
    none
  } else {
    show-type(var.type, style-args: style-args)
  }

  block(
    breakable: style-args.break-param-descriptions,
    fill: rgb("#d8dbed"),
    width: 100%,
    inset: (x: 0.5em, y: 0.7em),
    stack(
      dir: ltr,
      spacing: 1.2em,
      if style-args.enable-cross-references [
        #set text(font: "Cascadia Mono", size: 0.85em, weight: 340)
        #text(var.name, fill: blue)
        #label(style-args.label-prefix + var.name)
      ] else [
        #set text(font: "Cascadia Mono", size: 0.85em, weight: 340)
        #text(var.name, fill: blue)
      ],
      type,
    ),
  )
  pad(x: 0em, _eval-docstring(var.description, style-args))

  v(4em, weak: true)
}


// TODO: implement
#let show-reference(label, name, style-args: none) = {
  // link(label, raw(name, lang: none))
  // text(red, strong(str(label)))
  // api.cmdref(name)
  api.cmdref(name)
}
