
#import "../_deps.typ" as deps
#import "../_api.typ" as api

#import "../core/tidy.typ" as tidy-style
#import "../core/document.typ"


#let tidy-module(name, data, scope: (:), ..tidy-args) = {
  context {
    let doc = document.get()
    let scope = if doc.examples-scope != none {
      doc.examples-scope
    } else {
      (:)
    } + scope // + (api: api) // TODO: Move to tidy-style

    let module-doc = deps.tidy.parse-module(
      data,
      name: name,
      scope: scope,
    )

    deps.tidy.show-module(
    module-doc,
    style: tidy-style,
    // first-heading-level: 2,
    // show-module-name: false,
    // sort-functions: false,
    // show-outline: true,
    // ..tidy-args.named(),
  )
  }
}
