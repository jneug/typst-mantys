#import "../_deps.typ": octique

/// Shows an icon from the #github("0x6b/typst-octique") package.
///
/// - name (str): A name from the Octique icon set.
/// - fill (color, auto): The fill color for the icon. #value(auto) will use the fill of the surrounding text.
/// - ..args (any): Further args for the #cmd[octique] command.
/// -> content
#let icon(name, fill: auto, ..args) = context {
  octique.octique-inline(
    name,
    color: if fill == auto { text.fill } else { fill },
    ..args,
  )
}

/// The default info icon: #icons.info
#let info = icon("info")

/// The default info icon: #icons.warning
#let warning = icon("alert-fill")
