#import "../_deps.typ": typearea, hydra
#import "../util/utils.typ"
#import "../util/typst.typ"
#import "../api/elements.typ": package
#import "../api/types.typ": type-box, _type-map

#let page-header(doc, theme) = {
  grid(
    columns: (auto, 1fr, auto),
    align: (left + top, center + top, right + top),
    context hydra.hydra(1), [], context emph(hydra.hydra(2)),
  )
}

#let page-footer(doc, theme) = {
  counter(page).display((n, ..) => if n > 1 {
    set text(.88em, theme.muted.fill)
    grid(
      columns: (5fr, 1fr),
      align: (left + bottom, right + bottom),
      {
        [compiled: #datetime.today().display()]
        if doc.git != none [, git #doc.git.slice(0,8)]
      },
      [#n],
    )
  })
}

#let page-init(doc, theme) = body => {
  // Configure main page
  // TODO let user set paper?
  show: typearea.typearea.with(
    paper: "a4",
    div: 12,
    two-sided: false,
    header: page-header(doc, theme),
    footer: page-footer(doc, theme),
  )

  // Setup look&feel
  set par(justify: true)

  set text(..theme.text)
  set heading(numbering: "I.1.1.a")
  show heading: set text(..theme.heading)
  show heading.where(level: 1): it => [
    #pagebreak(weak: true)
    #it
  ]
  show link: set text(theme.emph.link)
  // Show (some) urls in footnotes
  show <mantys:link>: it => {
    let (dest, body) = (it.dest, it.body)

    let show-urls = doc.show-urls-in-footnotes
    if type(dest) == str and dest.starts-with("*") {
      show-urls = not show-urls
      dest = dest.slice(1)
    } else if type(dest) != str {
      show-urls = false
    }
    typst.link(dest, body)
    if show-urls {
      footnote(typst.link(dest, dest))
    }
  }

  // Allow theme overrides
  // TODO: Should theme call be in mantys.typ?
  show: theme.page-init(doc)

  // Setup show-rule for theming support
  show <mantys:themable>: it => {
    let element = it.value
    (element.func)(theme, ..element.args)
  }

  show upper(doc.package.name): it => package(doc.package.name)

  body
}
