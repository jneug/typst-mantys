#import "/src/packages.typ" as _pkg
#import "/src/theme.typ" as _theme

#let _columns = columns

#let fill(arr, len, new) = if arr.len() >= len {
  arr
} else {
  arr + ((new,) * (len - arr.len()))
}

/// Generate the default table of contents.
///
/// - title (str, content, none): The title to use, if this is a `heading`
///   itself it will not be passed to `outline`.
/// - target (selector, function): The target to show, this is primarily used
///   to restrict the search space of the default selector. If something other
///   than a heading selector is passed, then this may not work.
/// - columns (int): The amount of columns to use for the outline.
/// - theme (theme): The theme to use for this table of contents.
/// -> content
#let make-table-of-contents(
  title: heading(outlined: false, numbering: none)[Table of Contents],
  target: heading.where(outlined: true),
  columns: 1,
  theme: _theme.default,
) = {
  _pkg.t4t.assert.any-type(str, content, title)
  _pkg.t4t.assert.any-type(selector, function, target)
  _pkg.t4t.assert.any-type(int, columns)
  _pkg.t4t.assert.any-type(dictionary, theme)

  // NOTE: unsure if this looks good, this also doens't work in CI for now
  // set text(font: theme.fonts.headings)
  set block(spacing: 0.65em)
  set _columns(columns)

  if title != none {
    title
  }

  let _numbering(part) = {
    let nums = counter(heading).at(part.location())
    if part.level == 1 {
      strong(numbering("I", nums.first()))
    } else {
      numbering("1.1", ..nums.slice(1))
    }
  }

  let _page(part) = {
    let loc = part.location()
    let num = _pkg.t4t.def.if-none("1", loc.page-numbering())
    numbering(num, counter(page).at(loc).first())
  }

  context {
    let indent-stack = ()
    let parts = query(target)
    let page-max = 1em

    for part in parts {
      if part.level >= indent-stack.len() {
        indent-stack = fill(indent-stack, part.level, 0em)
      }

      let level-max = indent-stack.at(part.level - 1)
      let new = measure(_numbering(part)).width
      if level-max.to-absolute() <= new {
        indent-stack.at(part.level - 1) = new
      }

      let new = measure(_page(part)).width
      if page-max.to-absolute() <= new {
        page-max = new
      }
    }

    let front(part) = {
      let loc = part.location()

      let body = link(loc, {
        let max = indent-stack.at(part.level - 1)
        box(width: max, align(right, _numbering(part)))
        h(0.6em)
        part.body
      })

      if part.level == 1 {
        strong(body)
      } else {
        let indent = indent-stack.slice(0, part.level - 1)
        h(0.6em)
        indent.map(h).join(h(0.6em))
        body
      }
    }

    for part in parts {
      if part.level == 1 {
        v(0.85em, weak: true)
        front(part)
      } else {
        let loc = part.location()

        linebreak()
        front(part)
        [ ]
        box(width: 1fr, repeat(" . "))
        [ ]
        link(loc, box(width: page-max, align(right, _page(part))))
      }
    }
  }
}
