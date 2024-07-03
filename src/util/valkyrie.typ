#import "../core/styles.typ"

#let parse-schema(schema, expand-schemas: false, expand-choices: 2, dtype: none) = {
  // [#schema]

  let el = schema
  if "dictionary-schema" in el {
    if el.dictionary-schema != (:) {
      block(
        fill: rgb(95%, 95%, 95%, 40%),
        radius: 4pt,
        grid(columns: (1em, auto, 1fr),
          align: (left, left+top, right+horizon),
          // row-gutter: .5em,
          // column-gutter: 20pt,
          inset: .33em,
          fill: (c, r) => if calc.odd(r) {
            rgb(95%,95%,95%,80%)
          } else {
            rgb(100%,100%,100%,90%)
          },
          grid.cell(colspan:3, fill: none, `(`),
          ..for (key, el) in el.dictionary-schema {
            (
              [],
              // strong(utils.rawi(key)) + ": ",
              styles.arg(key) + if el.optional { ": " + raw(lang: "typc", "none") } else if el.default != none { ": " + raw(lang: "typc", repr(el.default)) },
              parse-schema(el, expand-schemas: expand-schemas, expand-choices: expand-choices, dtype: dtype)
              // if "dictionary-schema" in el {
              //   parse-schema(el)
              // } else if el.name.starts-with("array") {
              //   dtype(array) + " of " + parse-schema(el.descendents-schema, expand-schemas: expand-schemas, expand-choices: expand-choices)
              // } else {
              //   parse-schema(el, expand-schemas: expand-schemas, expand-choices: expand-choices)
              // },
            )
          },
          grid.cell(colspan:3, fill: none, `)`),
        ),
      )
    } else {
      dtype(dictionary)
      // `(:)`
    }
  } else if "descendents-schema" in el {
    dtype(array) + " of " + parse-schema(
      el.descendents-schema,
      expand-schemas: expand-schemas,
      expand-choices: expand-choices,
      dtype: dtype,
    )
  } else if el.name == "enum" {
    [one of ]
    `(`
    if expand-choices not in (false, 0) {
      if type(expand-choices) == int and el.choices.len() > expand-choices {
        el.choices.slice(0, expand-choices).map(c => ["#c"]).join(", ") + [ ... ]
      } else {
        el.choices.map(c => ["#c"]).join(", ")
      }
    } else [
      ...
    ]
    `)`
  } else {
    dtype(el.name)
  }
}
