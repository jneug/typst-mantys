#import "../_deps.typ": typearea, hydra, codly

#import "styles.typ"

#import "../util/utils.typ"
#import "../util/typst.typ"
#import "../api/elements.typ": package
#import "../api/examples.typ": codesnippet
#import "../api/types.typ": link-custom-type, type-box, _type-map

#let page-header(doc, theme) = {
  context {
    set text(..theme.header)
    hydra.hydra(1) + h(1fr) + emph(hydra.hydra(2))
  }
}

#let page-footer(doc, theme) = context {
  let (n, ..) = counter(page).get()
  if n > 1 {
    set text(..theme.footer)
    show link: set text(..theme.footer)
    grid(
      columns: (5fr, 1fr),
      align: (left + bottom, right + bottom),
      {
        [compiled: #datetime.today().display()]
        if doc.git != none {
          if doc
            .package
            .repository != none [, git #link(doc.package.repository + "/tree/" + doc.git.hash, doc.git.hash.slice(0,8))] else [, git #doc.git.hash.slice(0,8)]
        }
      },
      [#n],
    )
  }
}

#let page-init(doc, theme) = (
  body => {
    // Configure main page
    // TODO: let user set paper?
    show: typearea.typearea.with(
      paper: "a4",
      div: 12,
      two-sided: false,
      header: page-header(doc, theme),
      footer: page-footer(doc, theme),
    )

    // Setup look & feel
    set par(justify: true)

    set text(..theme.text)
    set heading(numbering: "I.1.1.a")
    // show heading: it => {
    //   let level = it.at("level", default: it.at("depth", default: 2))
    //   let scale = (1.6, 1.4, 1.2).at(level - 1, default: 1.0)

    //   if it.at("level", default: it.at("depth", default: 2)) == 1 {
    //     pagebreak(weak: true)
    //   }
    //   set text(1em * scale, ..theme.heading)
    //   it
    // }
    // TODO: Style headings (crashes ?)
    // show heading: it => {
    //   let level = it.at("level", default: it.at("depth", default: 2))
    //   let scale = (1.6, 1.4, 1.2).at(level - 1, default: 1.0)
    //   set text(1em * scale, ..theme.heading)
    //   it
    // }

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
      std.link(dest, body)
      if show-urls {
        footnote(std.link(dest, dest))
      }
    }

    // TODO: let the user do this?
    show: codly.codly-init
    codly.codly(
      display-name: false,
      display-icon: false,
      // inset: 2pt,
      fill: none,
      zebra-fill: none,
      stroke: none,
    )
    // show raw.where(block: true): codesnippet

    // Allow theme overrides
    // TODO: Should theme call be in mantys.typ?
    show: theme.page-init(doc)

    // Setup show-rule for themeing support
    show <mantys:themable>: it => {
      let element = it.value
      (element.func)(theme, ..element.args)
    }

    show ref: it => {
      if it.element != none and it.element.func() == figure {
        if it.element.kind == "cmd" {
          let name = str(it.target).slice(4)
          let module = none
          if name.contains(".") {
            (name, module) = (name.split(".").slice(1).join("."), name.split(".").first())
          }
          return link(
            it.target,
            styles.cmd(name, module: module),
          )
        } else if it.element.kind == "type" {
          return link-custom-type(str(it.target).slice(5))
        }
      }
      it
    }

    show upper(doc.package.name): it => package(doc.package.name)

    body
  }
)
