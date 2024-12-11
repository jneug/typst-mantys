#import "../src/mantys.typ": *
#import "../src/_api.typ" as mantys-api
#import "../src/core/schema.typ" as s

#let show-module(name, scope: (:), ..tidy-args) = tidy-module(
  name,
  read("../src/" + name + ".typ"),
  show-module-name: false,
  ..tidy-args.named(),
)
#let show-modules(scope: (:), ..tidy-args) = tidy-modules(
  tidy-args.pos().fold(
    (:),
    (d, m) => {
      d.insert(
        m.split("/").last(),
        read("../src/" + m + ".typ"),
      )
      d
    },
  ),
  show-module-name: false,
  ..tidy-args.named(),
)

#import "@preview/swank-tex:0.1.0": TeX, LaTeX

#let CNLTX = package("CNLTX")
#let TIDY = package("Tidy")

#show: mantys(
  ..toml-info(read),
  name: "Mantys",

  subtitle: [#text(eastern, weight:600)[MAN]uals for #text(eastern, weight:600)[TY]p#text(eastern, weight:600)[S]t],
  date: datetime.today(),
  abstract: [
    MANTYS is a Typst template to help package and template authors write beautiful and useful manuals. It provides functionality for consistent formatting of commands, variables and source code examples. The template automatically creates a table of contents and a command index for easy reference and navigation.

    For even easier manual creation, MANTYS works well with #TIDY, the Typst docstring parser.

    The main idea and design were inspired by the #LaTeX package #CNLTX by #name[Clemens Niederberger].
  ],

  git: git-info(read),

  examples-scope: (
    scope: (mantys: mantys-api),
    imports: (mantys: "*"),
  ),
  assets: (
    "theme-cnltx-pages": (
      src: "assets/examples/theme-cnltx-pages.typ",
      dest: "assets/examples/theme-cnltx-pages/{n}.png",
    ),
    "assets/examples/theme-cnltx.png": "assets/examples/theme-cnltx.typ",
    "theme-modern-pages": (
      src: "assets/examples/theme-modern-pages.typ",
      dest: "assets/examples/theme-modern-pages/{n}.png",
    ),
    "assets/examples/theme-modern.png": "assets/examples/theme-modern.typ",
    "theme-typst-pages": (
      src: "assets/examples/theme-typst-pages.typ",
      dest: "assets/examples/theme-typst-pages/{n}.png",
    ),
    "assets/examples/theme-typst.png": "assets/examples/theme-typst.typ",
    "theme-orly-pages": (
      src: "assets/examples/theme-orly-pages.typ",
      dest: "assets/examples/theme-orly-pages/{n}.png",
    ),
    "assets/examples/theme-orly.png": "assets/examples/theme-orly.typ",
    "assets/examples/headline.png": "assets/examples/headline.typ",
    "assets/thumbnail.png": "assets/thumbnail.typ",
  ),
)

#pagebreak(weak: true)
= About <sec:about>

Mantys is a Typst package to help package and template authors write manuals. The idea is that, as many Typst users are switching over from #TeX, they are used to the way packages provide a PDF manual for reference. Though in a modern ecosystem there are other ways to write documentation (like #link("https://rust-lang.github.io/mdBook/")[mdBook] or #link("https://asciidoc.org")[AsciiDoc]), having a manual in PDF format might still be beneficial since many users of Typst will generate PDFs as their main output.

This manual is a complete reference of all of MANTYS features. The source file of this document is a great example of the things MANTYS can do. Other than that, refer to the README file in the GitHub repository and the source code for MANTYS.

== Acknowledgements

Mantys was inspired by the fantastic #LaTeX package #link("https://ctan.org/pkg/cnltx")[#CNLTX] by #name[Clemens Niederberger]#footnote[#link("*mailto:clemens@cnltx.de", "clemens@cnltx.de")].

Thanks to #github-user("tingerrr") and ... for contributing to this package and giving feedback.

Thanks to #github-user("Mc-Zen") for developing #github("Mc-Zen/tidy").

= Usage <sec:usage>

Initialize a new manual using `typst init`:
```bash
typst init "@preview/mantys" docs
```

#info-alert[We suggest to initialize the template inside a `docs` subdirectory to keep your manual separated from your packages source files.]

If you prefer to manually setup your manual, create a `.typ` file and import MANTYS at the top:

#show-import()

== Initializing the template <sec:init>

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

  arg(theme: "default", _value: var-.with(module: "themes")),
)[
  #argument("title-page", default: auto, types: (auto, function))[
    A function that renders a titlepage for the manual. Refer to #cmd-[titlepage] for details.
  ]
  #argument("examples-scope", default: (:))[
    Default scope for code examples. The examples scope is a #dtype(dictionary) with two keys: `scope` and `imports`. The `scope` is passed to #builtin[eval] for evaluation. `imports` maps module names to a set of imports that should be prepended to example code as a preamble.

    *Schema*:
    #schema(
      "examples-scope",
      (
        scope: (:),
        imports: (:),
      ),
    )

    For example, if your package is named `my-pkg` and you want to import everything from your package into every examples scope, you can add the following #arg[examples-scope]:

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

    For further details refer to @cmd:example.
  ]

  #argument("theme", types: ("theme",))[]

  All other arguments will be passed to #cmd-[titlepage].

  All uppercase occurrences of #arg[name] will be highlighted as a packagename. For example #text(hyphenate:false, "MAN\u{2060}TYS") will appear as MANTYS.
]


== The MANTYS document
#frame[
  #set text(.88em)
  #schema(
    "document",
    s.document,
    child-schemas: (
      package: "package",
      template: "template",
      examples-scope: "examples-scope",
    ),
  )
]

==== Schema for package information
#frame(
  schema(
    "package",
    s.package,
    child-schemas: (
      authors: "author",
    ),
    expand-schemas: true,
  ),
)

==== Schema for template information
#frame(
  schema(
    "template",
    s.template,
  ),
)

==== Schema for author information
#frame(schema("author", s.author))

=== Accessing document data

There are two methods to access information from the MANTYS #dtype("document"):

1. Using commands from the #module[document] module or
2. using @cmd:mantys-init instead of @cmd:mantys.

==== Using the `document` module

==== Custom initialization

Instead of using @cmd:mantys in a #builtin[show] rule, you can initialize MANTYS using @cmd:mantys-init directly (#cmd-[mantys] essentially is a shortcut for using #cmd-[mantys-init]).

#command("mantys-init", ret: array)[
  Calling this function will return a tuple with two elements:

  / [0]: The MANTYS #dtype("document").
  / [1]: The MANTYS function to be used in a #builtin[show] rule.
]

```typ
#let (doc, mantys) = mantys-init(..toml("../typst.toml"))

#show: mantys

This is the manual for #doc.package.name version #str(doc.package.version).
```

= Documenting commands <sec:docs>

= Customizing the template <sec:customize>

== Themes <sec:themes>

MANTYS provides support for color themes and can be styled within certain boundries. The template comes with a few bundled themes but you can easily create a custom theme.

#warning-alert[
  #icons.warning Theme support is considered *experimental* and might be removed in future versions if it proves to be not stable enough.
]

=== Using themes <sec:using-themes>

To set the theme for your manual, simply provide a #arg[theme] argument to @cmd:mantys and set it to one of the bundled themes (see @sec:bundled-themes), a #dtype("dictionary") or a #dtype("module") with the required color, font and style information.

Some themes can be further customized by options that get passed to @cmd:mantys in the #arg[theme-options] key.

#codesnippet(```typ
#mantys(
  ..toml-info(read),

  theme: themes.orly,
  theme-options: (
    pic: image("assets/logo.png", width: 100%, )
  )
)
```)

#{ }

=== Bundled themes <sec:bundled-themes>

==== Typst theme <subsec:theme-default>
#grid(
  columns: 2,
  column-gutter: 5%,
  [The default theme for MANTYS. Based on the Typst documentation and website.],
  frame(arg(theme: "default", _value: var-.with(module: "themes"))),
)
#align(center, image("assets/examples/theme-typst.png", height: 30%))

==== Modern theme
#grid(
  columns: 2,
  column-gutter: 5%,
  [A slightly more modern theme for the digital age. Based on the #link("https://creativecommons.org/2019/10/30/cc-style-guide/", [Creative Commons Style Guide]).],
  frame(arg(theme: "modern", _value: var-.with(module: "themes"))),
)
#align(center, image("assets/examples/theme-modern.png", height: 30%))

==== CNLTX theme
#grid(
  columns: 2,
  column-gutter: 5%,
  [This theme is based on the original #CNLTX template.],
  frame(arg(theme: "cnltx", _value: var-.with(module: "themes"))),
)
#align(center, image("assets/examples/theme-cnltx.png", height: 30%))

==== O'Rly#super[?] theme
#grid(
  columns: 2,
  column-gutter: 5%,
  [This theme uses the #universe("fauxreilly") package to create a style similar to an O'Reilly book.],
  frame(arg(theme: "orly", _value: var-.with(module: "themes"))),
)
#align(center, image("assets/examples/theme-orly.png", height: 30%))

===== Theme Options
#argument("pic", types: content)[
  #dtype(content) to be passed to the #arg[pic] argument of #cmd-("orly", module:"fauxreilly").
]

=== Creating a custom theme <sec:creating-themes>

A theme is a #dtype("dictionary") ot #dtype("module") with a set of predefined keys for color and font information. See the #link(<subsec:theme-default>, "default theme") for a full list of keys and their meaning.

// #block(
//   height: 8em,
//   columns(3)[
//     // #list(..themes.default.keys().map(utils.rawi))
//     #list(..themes.default.pairs().map(((k, v)) => [#arg(k): #dtype(v)]))
//   ],
// )
#let summator(sum, dict) = {
  dict.pairs().fold(
    sum,
    (s, (k, v)) => {
      s + if type(v) == dictionary {
        1 + summator(sum, v)
      } else {
        1
      }
    },
  )
}
#let max-lines = summator(0, themes.default)
#block(
  height: calc.ceil(max-lines / 3) * 1.64em,
  columns(3)[
    #schema("theme", themes.default, color: _type-colors.color)
  ],
)

#arg[primary] and #arg[secondary] define are the main color scheme of the theme. #arg[fonts] is a dict of the main fontsets used in the theme.

#arg[page-init] is a #dtype("function") called during template initialization to add custom #builtin("set") rules and other global settings to the document. #arg[title-page] and #arg[last-page] are called once at the beginning and end of the document to add a title and final page to the manual respectively. All three are functions of #lambda(ret:"content", "document", "theme").

#info-alert[When writing a custom theme, remember to add #builtin("pagebreak") at the end, if your title page is supposed to be on its own page. Same goes for the last page.]

=== Theme helpers


== The index <sec:index>

MANTYS adds an index of all commands and custom types to the end of the manual. You can modify this index in several ways.

=== Adding entries to the index

Using #cmd[idx] you can add new entries to the index. Entries may be categorized by #arg[kind]. Commands have #arg(kind: "cmd") set and custom types #arg(kind: "type"). You may add arbitrary new types. If your package handles colors, you may want to add a "color" category like this:
```typc
idx("red", kind: "color")
```

=== Showing index entries by category

The default index can be disabled by passing #arg(show-index: false) to @cmd:mantys.

To manually show an index in the manual, use @cmd:make-index // #cmd[make-index].

#command("make-index", arg(kind: auto))[
  Shows an index of the specified #arg[kind].
]

#example[```
  #for c in (red, green, yellow, blue) {
    idx(c.to-hex(), kind:"color", display:box(inset:2pt,baseline:3pt,fill:c, text(white, c.to-hex())))
  }

  #block(height:8em, columns(2)[
    #make-index(
      kind:"color",
      entry-format: (term, pages) => [#term (#pages.join(", "))\ ],
      grouping: it => it.term.at(1)
    )
  ])
  ```]

#schema(
  "index-entry",
  (
    term: str,
    kind: str,
    main: bool,
    display: content,
  ),
)

== Examples <sec:examples>

= Available commands <sec:commands>

// #show-module("mantys")

== Utilities
#show-module("util/utils", module: "utils")

== API
#let apis = (
  Commands: "api/commands",
  Types: "api/types",
  Values: "api/values",
  Elements: "api/elements",
  Examples: "api/examples",
)
// #for (name, file) in apis {
//   [=== #name]
//   show-module(file, omit-private-parameters: true)
// }
#show-modules(
  ..apis.values(),
)
