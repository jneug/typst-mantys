
#import "../util/is.typ"
#import "../util/utils.typ"
#import "../util/valkyrie.typ"
#import "../core/themes.typ": themable
#import "../core/index.typ"
#import "../core/styles.typ"

#import "links.typ"
#import "values.typ"

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
    utils.get-text-color(color),
    utils.rawi(name),
  ),
)

/// #property(requires-context: true)
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
  if is.type(name) or is._auto(name) or is._none(name) {
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

/// Creates a list of datatypes.
#let dtypes(..types, link: true, sep: box(inset: (left: 1pt, right: 1pt), sym.bar.v)) = {
  types.pos().map(dtype.with(link: link)).join(sep)
}

#let custom-type(name, color: auto) = [
  #metadata((name: name, color: color))
  #label("mantys:custom-type-" + name)
  #utils.place-reference(label("type:" + name), "type", "type")
  #index.idx(
    name,
    kind: "type",
    main: true,
    display: if color == auto {
      themable(theme => type-box(name, theme.types.custom))
    } else {
      type-box(name, color)
    },
  )
]

// TODO Adding schemas as custom types
// TODO: move into sub-module (like valkyrie)?
#let _parse-dict-schema(schema, ..options, _dtype: none, _value: none) = {
  `(`
  terms(
    hanging-indent: 1.28em,
    indent: .64em,
    ..for (key, el) in schema {
      (
        terms.item(
          styles.arg(key),
          if type(el) == dictionary {
            if el == (:) {
              _dtype(dictionary)
            } else {
              _parse-dict-schema(el, ..options, _dtype: none, _value: none)
            }
          } else {
            _dtype(el)
          },
        ),
      )
    },
  )
  `)`
}

// TODO: Merge with #custom-type ?
#let schema(name, definition, color: auto, ..args) = {
  assert(is.dict(definition))

  custom-type(name, color: color)
  if "valkyrie-type" in definition {
    valkyrie.parse-schema(definition, ..args, _dtype: dtype, _value: values.value)
  } else {
    _parse-dict-schema(definition, ..args, _dtype: dtype, _value: values.value)
  }
}
