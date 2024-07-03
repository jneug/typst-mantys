#import "../src/mantys.typ": *
#import "../src/_api.typ" as mantys-api
#import "../src/core/schema.typ" as s

#let show-module(name, scope: (:), ..tidy-args) = tidy-module(
  name,
  read("../src/" + name + ".typ"),
  show-module-name: false,
  ..tidy-args,
)

// Some fancy logos
// credits go to discord user @adriandelgado
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
    MANTYS is a Typst template to help package and template authors to write manuals. It provides functionality for consistent formatting of commands, variables and source code examples. The template automatically creates a table of contents and a command index for easy reference and navigation.

    For even easier manual creation, MANTYS works well with #TIDY, the Typst docstring parser.

    The main idea and design was inspired by the #LaTeX package #cnltx by #smallcaps[Clemens Niederberger].
  ],

  git: git-info(read),

  examples-scope: (
    scope: (mantys: mantys-api),
    imports: (mantys: "*"),
  ),
  assets: (
    "assets/examples/headline.png": "assets/examples/headline.typ",
    "assets/thumbnail.png": "assets/thumbnail.typ",
  ),
)

#show raw.where(block: true, lang: "typ"): it => {
  show "{{VERSION}}": "0.1.4"
  it
}

#pagebreak(weak: true)
= About <about>

Mantys is a Typst package to help package and template authors to write consistently formatted manuals. The idea is that, as many Typst users are switching over from #TeX, they are used to the way packages provide a PDF manual for reference. Though in a modern ecosystem there are other ways to write documentation (like #link("https://rust-lang.github.io/mdBook/")[mdBook] or #link("https://asciidoc.org")[AsciiDoc]), having a manual in PDF format might still be beneficial, since many users of Typst will generate PDFs as their main output.

The design and functionality of Mantys was inspired by the fantastic #LaTeX package #link("https://ctan.org/pkg/cnltx")[#cnltx] by #name[Clemens Niederberger]#footnote[#link("*mailto:clemens@cnltx.de", "clemens@cnltx.de")].

This manual is supposed to be a complete reference of Mantys, but might be out of date for the most recent additions and changes. On the other hand, the source file of this document is a great example of the things Mantys can do. Other than that, refer to the README file in the GitHub repository and the source code for Mantys.

#warning-alert[
  Mantys is in active development and its functionality is subject to change. Until version 1.0.0 is reached, the command signatures and layout may change and break previous versions. Keep that in mind while using Mantys.

  Contributions to the package are very welcome!
]

= Usage

Initialize MANTYS using `typst init`:
```bash
typst init "@preview/mantys" docs
```

#info-alert[We suggest to initialize the template inside a `docs` subdirectory to keep your manual separated from your packages source files.]

If you prefer to manually setup you manual, create a `.typ` file and import MANTYS at the top:

```typ
#import "@preview/{{VERSION}}": *
```

=== Initializing the template

After importing MANTYS the template is initialized by applying a show rule with the #cmd[mantys] command.

#cmd-[mantys] requires some information to setup the template with an initial title page. Most of the information can be read directly from the `typst.toml` of your package:
```typ
#show: mantys.with(
	..toml("typst.toml"),
  ...
)
```

#command(
  "mantys",

  arg(theme: "themes.default"),
)[
  #argument("title-page", default: "title-page")[
    A function that renders a titlepage for the manual. Refer to #cmd-[titlepage] for details.
  ]
  #argument("examples-scope", default: (:))[
    Default scope for code examples.

    ```typc
    examples-scope: (
      scope: (
        pkg: my-pkg
      ),
      imports: (
        pkg: "*"
      )
    )
    ```

    For further details refer to #cmd-[example].
  ]

  All other arguments will be passed to #cmd-[titlepage].

  All uppercase occurrences of #arg[name] will be highlighted as a packagename. For example #text(hyphenate:false, "MAN\u{2060}TYS") will appear as MANTYS.
]

#schema("author", s.author)

#schema("package", s.package)

== Initializing the template

== Outline and index pages

== Themes

= Available commands

== Utilities
#show-module("util/utils", show-outline: false)

== API
#let apis = (
  Commands: "api/commands",
  Types: "api/types",
  Values: "api/values",
  Elements: "api/elements",
  Examples: "api/examples",
)
#for (name, file) in apis {
  [=== #name]
  show-module(file, omit-private-parameters: true)
}
