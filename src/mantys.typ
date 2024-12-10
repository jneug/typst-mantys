
#import "core/document.typ"
#import "core/themes.typ"
#import "core/index.typ": *
#import "core/layout.typ"
#import "api/tidy.typ": *

#import "_api.typ": *

#let mantys-init(
  theme: themes.default,
  ..args,
) = {
  let doc = document.create(..args)

  let mantys-func = body => {
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
    if doc.show-index {
      pagebreak(weak: true)
      [= Index]
      columns(3, make-index())
    }
  }

  return (doc, mantys-func)
}

/// Main MANTYS template function.
/// Use it to initialize the template:
/// ```typ
/// #show: mantys(
///   // initialization
/// )
/// ```
#let mantys(..args) = {
  let (_, mantys) = mantys-init(..args)
  return mantys
}

/// Reads the package information from the `typst.toml` file in the base package directory.
/// The result can be unpacked in the #cmd[mantys] to initialize the template.
///
/// ```typ
/// #show: mantys(
///   ..toml-info(read)
/// )
/// ```
///
/// Since MANTYS can't read files from outside its package directory,
/// #cmd-[toml-info] needs the #builtin[read] function to be
/// passed in.
/// - read (function): The builtin #builtin[read] function.
/// - toml-file (string): relative path to the `typst.toml` file.
/// -> dictionary
#let toml-info(read, toml-file: "../typst.toml") = {
  return toml.decode(read(toml-file))
}

/// Reads some information about the current commit from the
/// local `.git` directory. The result can be passed to #cmd[mantys] with the #arg[git] key.
///
/// Since MANTYS can't read files from outside its package directory,
/// #cmd-[git-info] needs the #builtin[read] function to be
/// passed in.
/// - read (function): The builtin #builtin[read] function.
/// - git-root (string): relative path to the `.git` directory.
/// -> dictionary
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

