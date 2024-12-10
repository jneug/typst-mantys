
#import "../_deps.typ" as deps
#import "../_api.typ" as api

#import "../core/tidy.typ" as tidy-style
#import "../core/document.typ"

// Internal helper to pre-configure tidy
#let _show-module = deps.tidy.show-module.with(
  first-heading-level: 2,
  show-module-name: false,
  sort-functions: auto,
  show-outline: true,
)

#let _post-process-module(module-doc, module-args: (:), func-opts: (:), filter: func => true) = {
  let functions = module-doc.functions.filter(filter)

  for (i, func) in functions.enumerate() {
    for (key, value) in func-opts {
      functions.at(i).insert(key, value)
    }
  }

  module-doc.functions = functions
  return module-doc
}


#let tidy-module(name, data, scope: (:), module: none, filter: func => true, ..tidy-args) = {
  context {
    let doc = document.get()
    let scope = if doc.examples-scope != none {
      doc.examples-scope.scope
    } else {
      (:)
    } + scope

    let module-doc = deps.tidy.parse-module(
      data,
      name: name,
      scope: scope,
    )

    module-doc = _post-process-module(
      module-doc,
      func-opts: (
        module: module,
      ),
      filter: filter,
    )

    _show-module(module-doc, style: tidy-style, ..tidy-args.named())
  }
}

#let tidy-modules(modules, add-modules: false, name: auto, scope: (:), ..tidy-args) = {
  context {
    let doc = document.get()
    let scope = if doc.examples-scope != none {
      doc.examples-scope.scope
    } else {
      (:)
    } + scope

    let merged-data = none

    for (module, data) in modules {
      // TODO: extrude parsing in helper func
      let module-doc = deps.tidy.parse-module(
        name: module,
        scope: scope,
        data,
      )

      if add-modules {
        module-doc = _post-process-module(
          module-doc,
          func-opts: (
            module: module,
          ),
        )
      }

      if merged-data == none {
        merged-data = module-doc
      } else {
        merged-data.name += ";" + module-doc.name
        merged-data.functions += module-doc.functions
        merged-data.variables += module-doc.variables
        merged-data.label-prefix += "-" + module-doc.name
      }
    }

    if name != auto {
      merged-data.name = name
    }

    _show-module(merged-data, style: tidy-style, ..tidy-args.named())
  }
}
