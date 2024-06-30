#import "../util/utils.typ": rawi
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
#let value(value, repr: true) = if repr {
  themable(theme => text(theme.values.default, rawi(typst.repr(value))))
} else {
  themable(theme => text(theme.values.default, rawi(value)))
}

#let _v = value

/// Highlights the default value of a set of #cmd[choices].
/// - #shortex(`#default("default-value")`)
/// - #shortex(`#default(true)`)
/// - #shortex(`#choices(1, 2, 3, 4, default: 3)`)
///
/// - value (any): The value to highlight.
/// -> content
#let default(value, repr: true) = {
  themable(theme => underline(_v(value, repr: repr), offset: 0.2em, stroke: .8pt + theme.values.default))
}
