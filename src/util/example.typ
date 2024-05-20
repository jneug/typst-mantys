#import "/src/packages.typ" as _pkg
#import "/src/theme.typ" as _theme

/// Show a source code frame.
///
/// - theme (theme): The theme to use for this code frame.
/// - ..args (any): The args to pass to `showybox`.
/// -> content
#let frame(
  theme: _theme.default,
  ..args,
) = _pkg.showybox.showybox(
  frame: (
    border-color: theme.colors.primary,
    title-color: theme.colors.primary,
    thickness: .75pt,
    radius: 4pt,
    inset: 8pt
  ),
  ..args
)

/// Shows example code and its corresponding output in a frame.
///
/// - side-by-side (bool): Whether or not the example source and output should
///   be shown side by side.
/// - scope (dictionary): The scope to pass to `eval`.
/// - breakable (bool): If the frame can brake over multiple pages.
/// - theme (theme): The theme to use for this code example.
/// - result (content): The content to render as the example result. Evaluated
///  `eval`.
/// - source (content): A raw element containing the source code to evaluate.
/// -> content
#let code-result(
  side-by-side: false,
  scope: (:),
  breakable: false,
  theme: _theme.default,
  result: auto,
  source,
) = {
  let mode = if source.lang == "typc" {
    "code"
  } else if source.lang in ("typ", "typst") {
    "markup"
  } else if result == auto {
    panic("cannot evaluate " + source.lang + " code")
  }

  if result == auto {
    result = eval(mode: mode, scope: scope, source.text)
  }

  frame(
    breakable: breakable,
    theme: theme,
    grid(
      columns: if side-by-side { (1fr, 1fr) } else { (1fr,) },
      gutter: 12pt,
      source,
      if not side-by-side {
        grid.hline(stroke: 0.75pt + theme.colors.primary)
      },
      result,
    )
  )
}
