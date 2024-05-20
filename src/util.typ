#import "/src/packages.typ" as _pkg

#import "util/author.typ"
#import "util/example.typ"
#import "util/link.typ"

/// Draw an alert box.
#let alert(
  color: purple,
  size: 0.8em,
  ..args,
  body,
) = _pkg.showybox.showybox(
  width: 100%,
  frame: (
    border-color: color,
    title-color: color,
    body-color: color.lighten(88%),
    thickness: (left: 2pt, rest: 0pt),
    radius: 0pt,
    inset: 8pt,
  ),
  ..args,
  text(size: size, fill: color.darken(60%), body),
)

/// Draw a blue alert box.
#let hint = alert.with(color: blue)

/// Draw a green alert box.
#let info = alert.with(color: green)

/// Draw a yellow alert box.
#let warn = alert.with(color: yellow)

/// Draw a red alert box.
#let error = alert.with(color: red)
