#import "../_deps.typ" as deps
#import "../core/document.typ"
#import "../util/utils.typ"
#import "../core/themes.typ": themable
#import "../api/elements.typ": frame


/// Shows sourcecode in a @@frame.
/// #info-alert[Uses #universe("codelst") to render the code.]
/// See @sec:examples for more information on sourcecode and examples.
///
/// #example[````
/// #sourcecode(title:"Example", file:"sourcecode-example.typ")[```
/// #let module-name = "sourcecode-example"
/// ```]
/// ````]
///
/// - title (str): A title to show on top of the frame.
/// - file (str): A filename to show in the title of the frame.
/// - code (content): A #builtin[raw] block of Typst code.
/// - ..args (any): Argumente für #cmd-(module:"codelst")[sourcecode]
/// -> content
#let sourcecode(title: none, file: none, ..args, code) = {
  let header = ()
  if title != none {
    header.push(text(fill: white, title))
  }
  if file != none {
    header.push(h(1fr))
    header.push(text(fill: white, emoji.folder) + " ")
    header.push(text(fill: white, emph(file)))
  }

  // deps.codelst.sourcecode(
  //   frame: frame.with(title: if header == () {
  //     ""
  //   } else {
  //     header.join()
  //   }),
  //   ..args,
  //   code,
  // )
  frame(
    title: if header == () {
      ""
    } else {
      header.join()
    },
    deps.codly.local(..args, code),
  )
}


/// Shows some #builtin[raw] code in a @@frame, but
/// without line numbers or other enhancements.
/// #info-alert[
///   By default MANTYS wrapps any #builtin[raw] code in the manual in this command.
/// ]
///
/// #example[````
/// ```typc
/// let a = "some content"
/// [Content: #a]
/// ```
/// ````]
///
/// -> content
#let codesnippet = frame
// TODO: codesnippet double wraps code because of the show rule


/// Show an example by evaluating the given #builtin[raw] code with Typst and showing the source and result in a @@frame.
///
/// See @sec:examples for more information on sourcecode and examples.
///
/// - side-by-side (boolean): Shows the source and example in two columns instead of the result beneath the source.
/// - scope (dictionary): A scope to pass to #builtin[eval].
/// - use-examples-scope (boolean): Set to #value(false) to not use the gloabl examples scope.
/// - mode (string): The evaulation mode: #choices("markup", "code", "math")
/// - breakable (boolean): If the frame may brake over multiple pages.
/// - example-code (content): A #builtin[raw] block of Typst code.
/// - ..args (content): An optional second positional argument that overwrites the evaluation result. This can be used to show the result of a sourcecode, that can not evaulated directly.
#let example(
  side-by-side: false,
  scope: (:),
  imports: (:),
  use-examples-scope: true,
  mode: "markup",
  breakable: false,
  example-code,
  ..args,
) = context {
  if args.named() != (:) {
    panic("unexpected arguments", args.named().keys().join(", "))
  }
  if args.pos().len() > 1 {
    panic("unexpected argument")
  }

  let code = example-code
  if not code.func() == raw {
    code = example-code.children.find(it => it.func() == raw)
  }
  let cont = (
    // deps.codelst.sourcecode(
    //   frame: none,
    //   raw(
    //     lang: if mode == "code" {
    //       "typc"
    //     } else {
    //       "typ"
    //     },
    //     code.text,
    //   ),
    // ),
    raw(
      lang: if mode == "code" {
        "typc"
      } else {
        "typ"
      },
      code.text,
    ),
  )
  if not side-by-side {
    cont.push(themable(theme => line(length: 100%, stroke: .75pt + theme.text.fill)))
  }

  // If the result was provided as an argument, use that,
  // otherwise eval the given example as code or content.
  if args.pos() != () {
    cont.push(args.pos().first())
  } else if not use-examples-scope {
    cont.push(
      eval(
        mode: mode,
        scope: scope,
        utils.add-preamble(
          code.text,
          imports,
        ),
      ),
    )
  } else {
    let doc = document.get()
    // cont.push(
    //   eval(
    //     mode: mode,
    //     scope: doc.examples-scope.scope + scope,
    //     utils.add-preamble(
    //       code.text,
    //       doc.examples-scope.imports + imports,
    //     ),
    //   ),
    // )

    cont.push(if "import" in code.text {
      block(
        fill: red.lighten(80%),
        stroke: 4pt + red,
        radius: 4pt,
        inset: 8pt,
        width: 100%,
        code.text,
      )
    } else {
      eval(
        mode: mode,
        scope: doc.examples-scope.scope + scope,
        utils.add-preamble(
          code.text,
          doc.examples-scope.imports + imports,
        ),
      )
    })
  }

  frame(
    breakable: breakable,
    grid(
      columns: if side-by-side {
        (1fr, 1fr)
      } else {
        (1fr,)
      },
      gutter: 12pt,
      ..cont
    ),
  )
}


/// Same as @@example, but with #arg(side-by-side: true) set.
/// -> content
#let side-by-side = example.with(side-by-side: true)


/// Show a "short example" by showing #arg[code] and the evaluation of #arg[code] separated
/// by #arg[sep]. This can be used for quick one-line examples as seen in @@name and other command docs in this manual.
///
/// #example[```
///
/// - #shortex(`#name("Jonas Neugebauer")`)
/// - #shortex(`#meta("arg-name")`, sep: ": ")
/// ```]
///
/// - code (content): The #builtin[raw] code example to show.
/// - sep (content): The separator between #arg[code] and its evaluated result.
/// - mode (str): One of #choices("markup", "code", "math")
/// - scope (dictionary): A scope argument similar to @type:examples-scope.
/// -> content
#let shortex(code, sep: [ #sym.arrow.r ], mode: "markup", scope: (:)) = context {
  let doc = document.get()
  raw(
    code.text,
    lang: "typ",
  )
  sep
  eval(
    utils.build-preamble(doc.examples-scope.imports) + code.text,
    mode: "markup",
    scope: doc.examples-scope.scope + scope,
  )
}


/// Shows an import statement for this package. The name and version from the document are used.
/// #example[```
/// #show-import()
/// #show-import(repository: "@local", imports: "mantys", mode:"code")
/// ```]
/// - repository (str): Custom package repository to show.
/// - imports (str, none): What to import from the package. Use #value(none) to just import the package into the global scope.
/// - mode (str): One of #choices("markup", "code"). Will show the import in markup or code mode.
#let show-import(repository: "@preview", imports: "*", mode: "markup") = {
  document.use(doc => {
    codesnippet(
      raw(
        lang: if mode == "markup" {
          "typ"
        } else {
          "typc"
        },
        if mode == "markup" {
          "#"
        } else {
          ""
        } + "import \"" + repository + "/" + doc.package.name + ":" + str(doc
          .package
          .version) + "\"" + if imports != none {
          ": " + imports
        },
      ),
    )
  })
}


/// Shows an import statement for this package. The name and version from the document are used.
/// #example[```
/// #show-import()
/// #show-import(repository: "@local", imports: "mantys", mode:"code")
/// ```]
/// - repository (str): Custom package repository to show.
/// - imports (str, none): What to import from the package. Use #value(none) to just import the package into the global scope.
/// - mode (str): One of #choices("markup", "code"). Will show the import in markup or code mode.
#let show-git-clone(repository: auto, out: auto) = {
  document.use(doc => {
    let repo = if repository == auto {
      doc.package.repository
    } else {
      repository
    }
    let url = if not repo.starts-with(regex("https?://")) {
      "https://github.com/" + repository
    } else {
      repository
    }

    codesnippet(
      raw(
        lang: "shell",
        "git clone " + url + " " + doc.package.name + "/" + str(doc.package.version),
      ),
    )
  })
}
