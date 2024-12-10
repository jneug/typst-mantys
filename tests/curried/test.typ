#import "@local/tidy:0.3.0"

#{
  let inspect(n) = (
    (..args) => {
      let arg = args.pos().at(n)
      // [#arg]
      raw(lang: "typc", repr(arg))
    }
  )

  let doc = tidy.parse-module(read("curried.typ"))

  tidy.show-module(
    doc,
    style: (
      show-example: tidy.styles.default.show-example,
      show-reference: tidy.styles.default.show-reference,
      show-outline: (..) => [],
      show-parameter-list: tidy.styles.default.show-parameter-list,
      show-parameter-block: tidy.styles.default.show-parameter-block,
      show-variable: tidy.styles.default.show-variable,
      //
      show-function: inspect(0),
    ),
  )
}
