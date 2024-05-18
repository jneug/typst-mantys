#import "packages.typ" as _pkg
#import "theme.typ" as _theme

/// The default style applied over the whole document.
///
/// - theme (theme): The theme to use for the document styling.
/// -> function
#let default(
  theme: _theme.default,
) = body => {
  set page(
    numbering: "1",
    header: context {
      let section = _pkg.hydra.hydra(2, display: (_, it) => {
        numbering("1.1", ..counter(heading).at(it.location()).slice(1))
        [ ]
        it.body
      })
      align(center, emph(section))
    },
  )

  set text(12pt, font: theme.fonts.text, lang: "en")
  set par(justify: true)

  set heading(numbering: "I.1.")
  show heading: it => {
    let scale = if it.level == 1 {
      1.8
    } else if it.level == 2 {
      1.4
    } else if it.level == 3 {
      1.2
    } else {
      1.0
    }

    let size = 1em * scale;
    let above = if it.level == 1 { 1.8em } else { 1.44em } / scale;
    let below = 0.75em / scale;

    set text(size, font: theme.fonts.headings)
    set block(above: above, below: below)

    if it.level == 1 {
      pagebreak(weak: true)
      block({
        if it.numbering != none {
          text(fill: theme.colors.primary, {
            [Part ]
            counter(heading).display()
          })
          linebreak()
        }
        it.body
      })
    } else {
      block({
        if it.numbering != none {
          text(fill: theme.colors.primary, counter(heading).display())
        }
        it.body
      })
    }
  }

  show raw: set text(9pt, font: theme.fonts.code)
  show figure.where(kind: raw): set block(breakable: true)

  body
}
