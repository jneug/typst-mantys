
#import "../util/utils.typ": rawi, get-text-color
#import "../util/is.typ"
#import "../core/themes.typ": themable
#import "../core/index.typ"
#import "links.typ"

#let _type-map = (
  "auto": auto,
  "none": none,

  // foundations
  arguments: arguments,
  array: array,
  boolean: bool,
  bytes: bytes,
  content: content,
  datetime: datetime,
  dictionary: dictionary,
  float: float,
  function: function,
  integer: int,
  location: location,
  plugin: plugin,
  regex: regex,
  selector: selector,
  string: str,
  type: type,
  label: label,
  version: version,

  // layout
  alignment: alignment,
  angle: angle,
  direction: direction,
  fraction: fraction,
  length: length,
  ratio: ratio,
  relative: relative,

  // visualize
  color: color,
  gradient: gradient,
  stroke: stroke,
)
#let _type-aliases = (
  bool: "boolean",
  str: "string",
  arr: "array",
  dict: "dictionary",
  int: "integer",
)

#let type-box(name, color) = box(
  fill: color,
  radius: 2pt,
  inset: (x: 4pt, y: 0pt),
  outset: (y: 2pt),
  text(
    .88em,
    get-text-color(color),
    rawi(name),
  ),
)

#let custom-type(name, color: auto) = [
  #metadata((name: name, color: color))
  #label("mantys:custom-type-" + name)
  #index.idx(
    term: name,
    kind: "type",
    themable(theme => type-box(name, theme.types.custom)),
  )
]

#let is-custom-type(name) = query(label("mantys:custom-type-" + name)) != ()

#let link-custom-type(name) = context {
  let _q = query(label("mantys:custom-type-" + name))
  if _q != () {
    let custom-type = _q.first()
    if custom-type.value.color == auto {
      return themable(theme => link(custom-type.location(), type-box(name, theme.types.custom)))
    } else {
      return themable(theme => link(custom-type.location(), type-box(name, custom-type.value.color)))
    }
  } else {
    panic("custom type " + name + " not found. use #custom-type in your manual to add the type first.")
  }
}

#let dtype(name, link: true) = context {
  let _type
  if is.type(name) {
    _type = name
  } else if not is.str(name) {
    _type = type(name)
  } else {
    let name = _type-aliases.at(name, default: name)
    if name in _type-map {
      _type = _type-map.at(name)
    } else if is-custom-type(name) {
      return link-custom-type(name)
    } else {
      return themable(theme => links.link-dtype(name, type-box(name, theme.types.default)))
    }
  }

  _type = repr(_type)
  return themable((theme => links.link-dtype(_type, type-box(_type, theme.types.at(_type)))))
}

#let dtypes(..types, link: true, sep: box(inset: (left: 1pt, right: 1pt), sym.bar.v)) = {
  types.pos().map(dtype.with(link: link)).join(sep)
}


// TODO Adding schemas as cutsom types
#let _parse-dict-schema(schema) = {
  for (key, el) in schema [
    *#rawi(key)*: #dtype(el)\
  ]
}

#let _parse-valkyie-schema(schema, expand-schemas: false, expand-choices: 2) = {
  // [#schema]

  let el = schema
  if "dictionary-schema" in el {
    if el.dictionary-schema != (:) {

      block(
        fill: luma(88%),
        radius: 4pt,
        pad(
          left: 1em,
          grid(columns: (auto, 1fr),
          // row-gutter: .5em,
          // column-gutter: 20pt,
          inset: .33em,
          fill: (c, r) => if calc.odd(r) {
            rgb(95%,95%,95%,66%)
          } else {
            rgb(100%,100%,100%,80%)
          },
          grid.cell(colspan:2, fill: none, `(`),
          ..for (key, el) in el.dictionary-schema {
            (
              strong(rawi(key)) + ": ",
              _parse-valkyie-schema(el, expand-schemas: expand-schemas, expand-choices: expand-choices)
              // if "dictionary-schema" in el {
              //   _parse-valkyie-schema(el)
              // } else if el.name.starts-with("array") {
              //   dtype(array) + " of " + _parse-valkyie-schema(el.descendents-schema, expand-schemas: expand-schemas, expand-choices: expand-choices)
              // } else {
              //   _parse-valkyie-schema(el, expand-schemas: expand-schemas, expand-choices: expand-choices)
              // },
            )
          },
          grid.cell(colspan:2, fill: none, `)`),
        ),
        ),
      )
    } else {
      dtype(dictionary)
      // `(:)`
    }
  } else if "descendents-schema" in el {
    dtype(array) + " of " + _parse-valkyie-schema(
      el.descendents-schema,
      expand-schemas: expand-schemas,
      expand-choices: expand-choices,
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

#let schema(name, definition, color: auto) = {
  assert(is.dict(definition))

  custom-type(name, color: color)
  if "valkyrie-type" in definition {
    _parse-valkyie-schema(definition)
  } else {
    _parse-dict-schema(definition)
  }
}
