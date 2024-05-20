#import "/src/packages.typ" as _pkg
#import "/src/theme.typ" as _theme

/// An alert box to highlight some content.
/// #ibox[Uses #package("showybox") and can take any arguments the #cmd-[showybox] command can take.]
/// #example[```
/// #mty.alert(color:purple, width:4cm)[#lorem(10)]
/// ```]
#let alert(
	color: blue,
	width: 100%,
	size: .88em,
  ..style,
	body
) = _pkg.showybox.showybox(
  frame: (
    border-color: color,
    title-color: color,
    body-color: color.lighten(88%),
    thickness: (left:2pt, rest:0pt),
    radius: 0pt,
    inset: 8pt
  ),
  width: width,
  ..style,
  text(size:size, fill:color.darken(60%), body)
)


/// Places a note in the margin of the page.
///
/// - pos (alignment): Either #value(left) or #value(right).
/// - gutter (length): Spacing between note and textarea.
/// - dy (length): How much to shift the note up or down.
/// - body (content): Content of the note.
/// -> content
#let marginnote(
	pos: left,
	gutter: .5em,
	dy: -1pt,
	body
) = {
	style(styles => {
		let _m = measure(body, styles)
		if pos.x == left {
			place(pos, dx: -1*gutter - _m.width, dy:dy, body)
		} else {
			place(pos, dx: gutter + _m.width, dy:dy, body)
		}
	})
}

