
#import "../_deps.typ" as deps
#import "../core/document.typ"
#import "../util/utils.typ"
#import "../core/themes.typ": themable
#import "../api/elements.typ": frame

/// Shows sourcecode in a frame.
/// #info-alert[Uses #universe[codelst] to render the code.]
/// See @sourcecode-examples for more information on sourcecode and examples.
///
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

  deps.codelst.sourcecode(
    frame: frame.with(title: if header == () {
      ""
    } else {
      header.join()
    }),
    ..args,
    code,
  )
}

#let codesnippet(body) = frame(body)

/// Show an example by evaluating the given raw code with Typst and showing the source and result in a frame.
///
/// See section II.2.3 for more information on sourcecode and examples.
///
/// - side-by-side (boolean): Shows the source and example in two columns instead of the result beneath the source.
/// - scope (dictionary): A scope to pass to #doc("foundations/eval").
/// - use-examples-scope (boolean): Set to #value(false) to not use the gloabl examples scope.
/// - mode (string): The evaulation mode: #choices("markup", "code", "math")
/// - breakable (boolean): If the frame may brake over multiple pages.
/// - example-code (content): A #doc("text/raw") block of Typst code.
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
    deps.codelst.sourcecode(
      frame: none,
      raw(
        lang: if mode == "code" {
          "typc"
        } else {
          "typ"
        },
        code.text,
      ),
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
    cont.push(
      eval(
        mode: mode,
        scope: doc.examples-scope.scope + scope,
        utils.add-preamble(
          code.text,
          doc.examples-scope.imports + imports,
        ),
      ),
    )
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

#let shortex(code, sep: [ #sym.arrow.r ], mode: "markup", scope: (:)) = context {
  let doc = document.get()
  raw(
    code.text,
    lang: "typ",
  )
  [#sep]
  eval(
    utils.build-preamble(doc.examples-scope.imports) + code.text,
    mode: "markup",
    scope: doc.examples-scope.scope + scope,
  )
}
