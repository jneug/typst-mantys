#import "../src/mantys.typ": *

#let TeX = style(styles => {
  set text(font: "New Computer Modern")
  let e = measure("E", styles)
  let T = "T"
  let E = text(1em, baseline: e.height * 0.31, "E")
  let X = "X"
  box(T + h(-0.15em) + E + h(-0.125em) + X)
})

#let LaTeX = style(styles => {
  set text(font: "New Computer Modern")
  let a-size = 0.66em
  let l = measure("L", styles)
  let a = measure(text(a-size, "A"), styles)
  let L = "L"
  let A = box(scale(x: 110%, text(a-size, baseline: a.height - l.height, "A")))
  box(L + h(-a.width * 0.67) + A + h(-a.width * 0.25) + TeX)
})

#let cnltx = package("CNLTX")
#let TIDY = package("Tidy")

#show: mantys(
  ..toml(toml-file),

  subtitle: [#strong[MAN]uals for #strong[TY]p#strong[S]t],
  date: datetime.today(),
  abstract: [
    MANTYS is a Typst template to help package and template authors to write manuals. It provides functionality for consistent formatting of commands, variables, options and source code examples. The template automatically creates a table of contents and a command index for easy reference and navigation.

    For even easier manual creation, MANTYS works well with #TIDY, the Typst docstring parser.

    The main idea and design was inspired by the #LaTeX package #cnltx by #smallcaps[Clemens Niederberger].
  ],

  git: read(git-head-file(read(git-file))),

  examples-scope: (
    scope: (utils: utils, api: api),
    imports: (utils: "get-text", api: "*"),
  ),
  assets: (
    "pages": (
      src: "examples/pages.typ",
      dest: "examples/pages/{n}.png",
    ),
    "examples/ab.png": "examples/ab.typ",
  ),
)

#pagebreak(weak: true)
= About <about>

#image("examples/ab.png")
#image("examples/pages/2.png")

Mantys is a Typst package to help package and template authors to write consistently formatted manuals. The idea is that, as many Typst users are switching over from #TeX, they are used to the way packages provide a PDF manual for reference. Though in a modern ecosystem there are other ways to write documentation (like #link("https://rust-lang.github.io/mdBook/")[mdBook] or #link("https://asciidoc.org")[AsciiDoc]), having a manual in PDF format might still be beneficial, since many users of Typst will generate PDFs as their main output.

The design and functionality of Mantys was inspired by the fantastic #LaTeX package #link("https://ctan.org/pkg/cnltx")[#cnltx] by #name[Clemens Niederberger]#footnote[#link("*mailto:clemens@cnltx.de", "clemens@cnltx.de")].

This manual is supposed to be a complete reference of Mantys, but might be out of date for the most recent additions and changes. On the other hand, the source file of this document is a great example of the things Mantys can do. Other than that, refer to the README file in the GitHub repository and the source code for Mantys.

#warning-alert[
  Mantys is in active development and its functionality is subject to change. Until version 1.0.0 is reached, the command signatures and layout may change and break previous versions. Keep that in mind while using Mantys.

  Contributions to the package are very welcome!
]


= Tutorial

== Example pages

= My second Part
#lorem(100)

== Subsection
#sourcecode[```
  Some example for sourecode.
  ```]
#codesnippet[```
  Some example for sourecode.
  ```]
#lorem(100)

== Utilities module
#tidy-module("utils", read("../src/util/utils.typ"))

== Subsection
#lorem(500)

#pagebreak(weak: true)
= My third Part
#lorem(200)

== Subsection
#lorem(100)

== Subsection
#lorem(100)

== Schemas and custom types <custom-types>

=== Coordinates <type-coordinates>
#custom-type("coordinate")

#lorem(30)

=== Author
#schema("author", document.schema.author)

#lorem(120)

=== Template
#schema("template", (name: str, entrypoint: int))

#lorem(120)

= Appendix
#lorem(500)
