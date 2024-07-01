
#import "core/document.typ"
#import "core/themes.typ"
#import "core/index.typ": *
#import "core/layout.typ"
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

#let git-info(read, git-root: "../.git") = {
  if git-root.at(-1) != "/" {
    git-root += "/"
  }
  let head-data = read(git-root + "HEAD")
  let m = head-data.match(regex("^ref: (\S+)"))
  if m == none {
    return none
  }

  let ref = m.captures.at(0)

  let branch = ref.split("/").last()
  let hash = read(git-root + ref).trim()

  return (
    branch: branch,
    hash: hash,
  )
}
