
#import "../util/is.typ"
#import "../util/utils.typ"
#import "../util/valkyrie.typ"
#import "../core/themes.typ": themable
#import "../core/index.typ"
#import "../core/styles.typ"

#import "links.typ"
#import "values.typ"

/// Dictionary of builtin types, mapping the types name to its actual type.
#let _type-map = (
  "auto": auto,
  "none": none,
  // foundations
  arguments: arguments,
  array: array,
  bool: bool,
  bytes: bytes,
  content: content,
  datetime: datetime,
  decimal: decimal,
  duration: datetime,
  dictionary: dictionary,
  float: float,
  function: function,
  int: int,
  label: label,
  module: module,
  plugin: plugin,
  regex: regex,
  selector: selector,
  str: str,
  symbol: symbol,
  type: type,
  version: version,
  // instrospection
  counter: counter,
  location: location,
  state: state,
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
  tiling: tiling,
)
/// Dictionary of allowed type aliases, like `dict` for `dictionary`.
#let _type-aliases = (
  boolean: "bool",
  string: "str",
  arr: "array",
  dict: "dictionary",
  integer: "int",
  func: "function",
)
/// Dictionary of colors to use for builtin types.
#let _type-colors = {
  let red = rgb(255, 203, 195)
  let gray = rgb(239, 240, 243)
  let purple = rgb(230, 218, 255)
  let yellow = rgb(255, 236, 193)
  let green = rgb(209, 255, 226)
  let pink = rgb(252, 223, 255)
  let bluish = rgb(198, 215, 236)
  let blue = rgb(167, 234, 255)

  let gradient-color = gradient.linear(
    (rgb("#7cd5ff"), 0%),
    (rgb("#a6fbca"), 33%),
    (rgb("#fff37c"), 66%),
    (rgb("#ffa49d"), 100%),
  )
  let gradient-date = gradient.conic(
    angle: 150deg,
    (rgb("#0205133F"), 0%),
    (rgb("#0415293F"), 7%),
    (rgb("#a07aaa3F"), 18%),
    (rgb("#a6aff63F"), 28%),
    (rgb("#89c8e53F"), 35%),
    (rgb("#b7daec3F"), 66%),
    (rgb("#dcac683F"), 73%),
    (rgb("#47232d3F"), 79%),
    (rgb("#0415293F"), 89%),
    (rgb("#0205133F"), 100%),
  )

  (
    // fallback
    default: rgb(239, 240, 243),
    custom: rgb("#fcfdb7"),
    // special
    any: gray,
    "auto": red,
    "none": red,
    // foundations
    arguments: pink,
    array: pink,
    bool: yellow,
    bytes: pink,
    content: rgb(166, 235, 229),
    datetime: gradient-date,
    duration: gradient-date,
    decimal: yellow,
    dictionary: pink,
    float: yellow,
    function: purple,
    int: yellow,
    label: bluish,
    module: purple,
    plugin: gray,
    regex: green,
    selector: bluish,
    string: green,
    str: green,
    symbol: green,
    type: purple,
    version: pink,
    // instrospection
    counter: gray,
    location: bluish,
    state: gray,
    // layout
    alignment: blue,
    angle: yellow,
    direction: blue,
    fraction: yellow,
    length: yellow,
    "relative length": purple,
    ratio: yellow,
    relative: yellow,
    // visualize
    color: gradient-color,
    gradient: gradient-color,
    stroke: gradient-color,
    tiling: gradient.linear(
      angle: 150deg,
      ..range(20).map(i => {
        let p = calc.quo(i + 1, 2)
        (
          (rgb("#ffd2ec"), rgb("#c7ffff")).at(calc.rem(p + i, 2)),
          p * 10%,
        )
      }),
    ),
  )
}


/// Creates a colored box for a type, similar to those on the Typst website.
/// - #ex(`#type-box("color", red)`)
/// -> content
#let type-box(
  /// Name of the type.
  /// -> str
  name,
  /// Color for the type box.
  /// -> color
  color,
) = box(
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

/// Test if #arg[name] was registered as a custom type.
/// #property(requires-context: true)
/// -> bool
#let is-custom-type(
  /// Name to check.
  /// -> str
  name,
) = query(label("mantys:custom-type-" + name)) != ()


/// Displays a type link to the custom type #arg[name], if that
/// name is registered as a @cmd:custom-type in the manual.
/// - #ex(`#link-custom-type("document")`)
/// - #ex(`#link-custom-type("theme")`)
/// -> content
#let link-custom-type(
  /// Name of the custom type.
  /// -> str
  name,
) = context {
  let _q = query(label("mantys:custom-type-" + name))
  if _q != () {
    let custom-type = _q.first()
    if custom-type.value.color == auto {
      return link(custom-type.location(), type-box(name, _type-colors.custom))
    } else {
      return link(custom-type.location(), type-box(name, custom-type.value.color))
    }
  } else {
    panic("custom type " + name + " not found. use #custom-type in your manual to add the type first.")
  }
}


/// Displays a type link to the type #arg[name]. #arg[name] can
/// either be a #link(<subsec:shortcuts-types>, "builtin type") or a registered @type:custom-type.
///
/// Builtin types are linked to the official Typst reference documentation. Custom types to their location in the manual.
/// Some builtin types can be referenced by aliases like `dict` for `dictionary`.
///
/// If #arg[name] is given as a #typ.t.str it is taken as the name of the type. If #arg[name] is a #typ.type or any other value, the type of the value is displayed.
///
/// - #ex(`#dtype("string")`)
/// - #ex(`#dtype("dict")`)
/// - #ex(`#dtype(1.0)`)
/// - #ex(`#dtype(true)`)
/// - #ex(`#dtype("document")`)
/// -> content
#let dtype(
  /// Name of the type.
  /// -> any
  name,
  /// If the type should be linked to the Typst documentation or the location of the custom type.
  /// Set to #typ.v.false to disable linking.
  /// -> bool
  link: true,
) = context {
  // TODO: (jneug) parse types like "array[str]"
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
      return links.link-dtype(name, type-box(name, _type-colors.default))
    }
  }

  _type = repr(_type)
  return links.link-dtype(_type, type-box(_type, _type-colors.at(_type)))
}

/// Creates a list of datatypes. Each value in
/// #sarg[types] is passed to @cmd:dtype.
/// - #ex(`#dtypes(int, str, "theme", "dict")`)
/// - #ex(`#dtypes(int, float, sep: ", ")`)
/// -> content
#let dtypes(
  ..types,
  link: true,
  sep: box(inset: (left: 1pt, right: 1pt), sym.bar.v),
) = {
  types.pos().map(dtype.with(link: link)).join(sep)
}

/// Registers a custom type.
#let custom-type(name, color: auto) = [
  #metadata((name: name, color: color))
  #label("mantys:custom-type-" + name)
  #utils.place-reference(label("type:" + name), "type", "type")
  #index.idx(
    name,
    kind: "type",
    main: true,
    display: if color == auto {
      type-box(name, _type-colors.custom)
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
              _parse-dict-schema(el, ..options, _dtype: _dtype, _value: _value)
            }
          } else {
            if _dtype != none {
              _dtype(el)
            }
          },
        ),
      )
    },
  )
  `)`
}

// TODO: Merge with #custom-type ?
/// Registeres a schema as a @type:custom-type.
#let schema(name, definition, color: auto, ..args) = {
  assert(is.dict(definition))

  custom-type(name, color: color)
  if "valkyrie-type" in definition {
    valkyrie.parse-schema(definition, ..args, _dtype: dtype, _value: values.value)
  } else {
    _parse-dict-schema(definition, ..args, _dtype: dtype, _value: values.value)
  }
}

