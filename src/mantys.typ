
#import "core/document.typ"
#import "core/themes.typ"
#import "core/index.typ": *
#import "layout/main.typ" as layout
#import "api/tidy.typ": *

#import "_api.typ": *

#let mantys(
  theme: themes.default,
  ..args,
) = body => {
  let doc = document.create(..args)
  document.save(doc)

  // Add assets metadata to document
  for asset in doc.assets [#metadata(asset)<mantys:asset>]

  // Asset mode skips rendering the body
  if sys.inputs.at("mode", default: "full") == "assets" {
    return []
  }

  // theme.page-init(doc)
  // set page(paper: "a4")
  show: layout.page-init(doc, theme)

  theme.title-page(doc)
  pagebreak()

  if sys.inputs.at("debug", default: "false") in ("true", "1") {
    page(flipped: true, columns: 2)[
      #set text(10pt)
      #doc
    ]
  }
  pagebreak(weak: true)

  body

  // Show index if enabled and at least one entry
  context {
    if doc.show-index and index-len() > 0 {
      pagebreak(weak: true)
      [= Index]
      columns(3, make-index())
    }
  }
}

// TODO: (re)move?
#let toml-file = "../typst.toml"
#let git-file = "../.git/HEAD"
#let git-head-file(head-data) = {
  let m = head-data.match(regex("^ref: (\S+)"))
  return "../.git/" + m.captures.at(0)
}
