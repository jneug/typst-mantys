#import "../util/utils.typ": rawc
#import "../util/typst.typ"
#import "../core/themes.typ": themable

/// Shows #arg[value] as content.
/// - #shortex(`#value("string")`)
/// - #shortex(`#value([string])`)
/// - #shortex(`#value(true)`)
/// - #shortex(`#value(1.0)`)
/// - #shortex(`#value(3em)`)
/// - #shortex(`#value(50%)`)
/// - #shortex(`#value(left)`)
/// - #shortex(`#value((a: 1, b: 2))`)
///
/// - value (any): Value to show.
/// -> content
#let value(value, parse-str: false) = {
  if parse-str and type(value) == str {
    themable(theme => rawc(theme.values.default, value))
  } else {
    themable(theme => rawc(theme.values.default, typst.repr(value)))
  }
}
#let _v = value


/// Highlights the default value of a set of #cmd[choices].
/// - #shortex(`#default("default-value")`)
/// - #shortex(`#default(true)`)
///
/// - value (any): The value to highlight.
/// -> content
#let default(value, parse-str: true) = {
  themable(theme => underline(_v(value, parse-str: parse-str), offset: 0.2em, stroke: .8pt + theme.values.default))
}
#let _d = default


/// Shows a list of choices possible for an argument.
///
/// If #arg[default] is set to something else than #value("__none__"), the value
/// is highlighted as the default choice. If #arg[default] is already present in
/// #arg[values] the value is highlighted at its current position. Otherwise
/// #arg[default] is added as the first choice in the list.
/// // - #shortex(`#choices(left, right, center)`)
/// // - #shortex(`#choices(left, right, center, default:center)`)
/// // - #shortex(`#choices(left, right, default:center)`)
/// // - #shortex(`#arg(align: choices(left, right, default:center))`)
/// -> content
#let choices(default: "__none__", sep: sym.bar.v, ..values) = {
  let list = values.pos().map(_v)
  if default != "__none__" {
    if default in values.pos() {
      let pos = values.pos().position(v => v == default)
      list.at(pos) = _d(default)
    } else {
      list.insert(0, _d(default))
    }
  }
  list.join(box(inset: (left: 1pt, right: 1pt), sep))
}
