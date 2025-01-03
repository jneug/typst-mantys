#import "../core/document.typ"
#import "elements.typ": package

#let _type-map = (
  "auto": "foundations/auto",
  "none": "foundations/none",
  // foundation
  arguments: "foundations/arguments",
  array: "foundations/array",
  boolean: "foundations/bool",
  bytes: "foundations/bytes",
  content: "foundations/content",
  datetime: "foundations/datetime",
  dictionary: "foundations/dictionary",
  float: "foundations/float",
  function: "foundations/function",
  integer: "foundations/int",
  location: "foundations/location",
  module: "foundations/module",
  plugin: "foundations/plugin",
  regex: "foundations/regex",
  selector: "foundations/selector",
  string: "foundations/str",
  type: "foundations/type",
  label: "foundations/label",
  version: "foundations/version",
  // layout
  alignment: "layout/alignment",
  angle: "layout/angle",
  direction: "layout/direction",
  fraction: "layout/fraction",
  length: "layout/length",
  ratio: "layout/ratio",
  relative: "layout/relative",
  // visualize
  color: "visualize/color",
  gradient: "visualize/gradient",
  stroke: "visualize/stroke",
)

#let _builtin-map = (
  // tutorial
  "set": "../tutorial/formatting/#set-rules",
  "show": "../tutorial/formatting/#show-rules",
  // scripting
  "import": "scripting/#modules",
  // foundations
  "context": "context",
  arguments: "foundations/arguments",
  array: "foundations/array",
  assert: "foundations/assert",
  "auto": "foundations/auto",
  bool: "foundations/bool",
  bytes: "foundations/bytes",
  with: "foundations/function/#definitions-with",
  // Calc and its functions
  calc: "foundations/calc",
  abs: "foundations/calc#function-abs",
  pow: "foundations/calc#function-pow",
  exp: "foundations/calc#function-exp",
  sqrt: "foundations/calc#function-sqrt",
  root: "foundations/calc#function-root",
  sin: "foundations/calc#function-sin",
  cos: "foundations/calc#function-cos",
  tan: "foundations/calc#function-tan",
  asin: "foundations/calc#function-asin",
  acos: "foundations/calc#function-acos",
  atan: "foundations/calc#function-atan",
  atan2: "foundations/calc#function-atan2",
  sinh: "foundations/calc#function-sinh",
  cosh: "foundations/calc#function-cosh",
  tanh: "foundations/calc#function-tanh",
  log: "foundations/calc#function-log",
  ln: "foundations/calc#function-ln",
  fact: "foundations/calc#function-fact",
  perm: "foundations/calc#function-perm",
  binom: "foundations/calc#function-binom",
  gcd: "foundations/calc#function-gcd",
  lcm: "foundations/calc#function-lcm",
  floor: "foundations/calc#function-floor",
  ceil: "foundations/calc#function-ceil",
  trunc: "foundations/calc#function-trunc",
  fract: "foundations/calc#function-fract",
  round: "foundations/calc#function-round",
  clamp: "foundations/calc#function-clamp",
  min: "foundations/calc#function-min",
  max: "foundations/calc#function-max",
  even: "foundations/calc#function-even",
  odd: "foundations/calc#function-odd",
  rem: "foundations/calc#function-rem",
  quo: "foundations/calc#function-quo",
  //
  content: "foundations/content",
  datetime: "foundations/datetime",
  dictionary: "foundations/dictionary",
  duration: "foundations/duration",
  eval: "foundations/eval",
  float: "foundations/float",
  function: "foundations/function",
  int: "foundations/int",
  label: "foundations/label",
  module: "foundations/module",
  "none": "foundations/none",
  panic: "foundations/panic",
  plugin: "foundations/plugin",
  regex: "foundations/regex",
  repr: "foundations/repr",
  selector: "foundations/selector",
  str: "foundations/str",
  style: "foundations/style",
  sys: "foundations/sys",
  type: "foundations/type",
  version: "foundations/version",
  // model
  bibliography: "model/bibliography",
  cite: "model/cite",
  document: "model/document",
  figure: "model/figure",
  emph: "model/emph",
  enum: "model/enum",
  list: "model/list",
  numbering: "model/numbering",
  outline: "model/outline",
  par: "model/par",
  parbreak: "model/parbreak",
  quote: "model/quote",
  strong: "model/strong",
  ref: "model/ref",
  table: "model/table",
  terms: "model/terms",
  link: "model/link",
  // text
  raw: "text/raw",
  text: "text/text",
  highlight: "text/highlight",
  linebreak: "text/linebreak",
  lorem: "text/lorem",
  lower: "text/lower",
  upper: "text/upper",
  overline: "text/overline",
  underline: "text/underline",
  smallcaps: "text/smallcaps",
  smartquote: "text/smartquote",
  strike: "text/strike",
  sub: "text/sub",
  super: "text/super",
  // layout
  align: "layout/align",
  alignment: "layout/alignment",
  angle: "layout/angle",
  block: "layout/block",
  box: "layout/box",
  colbreak: "layout/colbreak",
  columns: "layout/columns",
  direction: "layout/direction",
  fraction: "layout/fraction",
  grid: "layout/grid",
  h: "layout/h",
  hide: "layout/hide",
  layout: "layout/layout",
  length: "layout/length",
  measure: "layout/measure",
  move: "layout/move",
  pad: "layout/pad",
  page: "layout/page",
  pagebreak: "layout/pagebreak",
  place: "layout/place",
  ratio: "layout/ratio",
  relative: "layout/relative",
  repeat: "layout/repeat",
  rotate: "layout/rotate",
  scale: "layout/scale",
  stack: "layout/stack",
  v: "layout/v",
  // math
  accent: "math/accent",
  attach: "math/attach",
  cancel: "math/cancel",
  cases: "math/cases",
  class: "math/class",
  equation: "math/equation",
  frac: "math/frac",
  lr: "math/lr",
  mat: "math/mat",
  op: "math/op",
  primes: "math/primes",
  roots: "math/roots",
  sizes: "math/sizes",
  styles: "math/styles",
  underover: "math/underover",
  variants: "math/variants",
  vec: "math/vec",
  // visualize
  circle: "visualize/circle",
  color: "visualize/color",
  ellipse: "visualize/ellipse",
  gradient: "visualize/gradient",
  image: "visualize/image",
  line: "visualize/line",
  path: "visualize/path",
  pattern: "visualize/pattern",
  polygon: "visualize/polygon",
  rect: "visualize/rect",
  square: "visualize/square",
  stroke: "visualize/stroke",
  // instrospection
  counter: "introspection/counter",
  here: "introspection/here",
  locate: "introspection/locate",
  location: "introspection/location",
  metadata: "introspection/metadata",
  query: "introspection/query",
  state: "introspection/state",
  // data-loading
  cbor: "data-loading/cbor",
  csv: "data-loading/csv",
  json: "data-loading/json",
  read: "data-loading/read",
  toml: "data-loading/toml",
  xml: "data-loading/xml",
  yaml: "data-loading/yaml",
)


#let link-docs(..path) = std.link("https://typst.app/docs/reference/" + path.pos().first(), ..path.pos().slice(1))

#let link-dtype(..name) = link-docs(_type-map.at(name.pos().first(), default: ""), ..name.pos().slice(1))

#let link-builtin(..name) = link-docs(_builtin-map.at(name.pos().first(), default: ""), ..name.pos().slice(1))

#let link(..args) = {
  let dest = args.pos().first()
  let body = if args.pos().len() > 1 {
    args.pos().at(1)
  } else {
    dest
  }
  if not args.named().at("footnote", default: true) {
    [#std.link(dest, body)]
  } else {
    [#std.link(dest, body)<mantys:link>]
  }
}

/// Displays a link to a #link("https://github.com", "github.com", footnote:false) user page.
/// If #arg[name] is empty or #typ.v.auto, the package
/// author is linked (if a github username was provided).
/// ```example
/// - #github-user()
/// - #github-user("typst")
/// ```
/// -> content
#let github-user(
  /// Name of the user on GitHub, like `jneug` or #typ.v.auto.
  /// -> str | auto
  ..name,
) = {
  let name = name.pos().at(0, default: auto)
  if name != auto {
    link("https://github.com/" + name, sym.at + name)
  } else {
    context {
      let author = document.get-value("package.authors").first()
      if "github" in author {
        link("https://github.com/" + author.github, sym.at + author.github)
      } else {
        let repo = document.get-value("package.repository")
        if repo != none {
          let name = repo.split("/").first()
          link("https://github.com/" + name, sym.at + name)
        } else {
          panic("#github-user either needs a gihub name for the author or a repository URL set during initialization.")
        }
      }
    }
  }
}

/// Displays a link to a #link("https://github.com", "github.com", footnote:false) repository.
/// If #arg[repo] is empty or #typ.v.auto, the package
/// repository is linked (if a repository URL was provided).
/// ```example
/// - #github()
/// - #github("typst/packages")
/// - #github(path: "/issues")
/// - #github("typst/packages", path: "/issues")
/// ```
/// -> content
#let github(
  /// Name of the repository on GitHub, like `jneug/typst-mantys` or #typ.v.auto.
  /// -> str | auto
  ..repo,
  /// Optional path to append to the URL. This
  /// is appended to the repository URL as is and
  /// can include anchors.
  /// -> str
  path: none,
  /// Custom label for the link.
  /// -> content | auto
  label: auto,
) = {
  let make-link(r) = {
    if r.starts-with("https://github.com/") {
      r = r.slice(19)
    }
    let path = if path == none {
      ""
    } else {
      "/" + path.trim("/", at: start)
    }
    let label = if label == auto {
      r
    } else {
      label
    }
    link("https://github.com/" + r + path, label)
  }

  let repo = repo.pos().at(0, default: auto)

  if repo != auto {
    make-link(repo)
  } else {
    document.use-value(
      "package.repository",
      repo => {
        if repo != none {
          make-link(repo)
        } else {
          panic("#github requires a <repo> to be provided or the <repository> option set during initialization.")
        }
      },
    )
  }
}

/// Displays a link to a #link("https://github.com", "github.com", footnote:false) repository.
/// If #arg[repo] is empty or #typ.v.auto, the package
/// repository is linked (if a repository URL was provided).
/// ```example
/// - #github-file("README.md")
/// - #github-file("typst/packages", "README.md")
/// ```
/// -> content
#let github-file(
  /// Either a file path or a repository name and a filepath.
  /// -> str
  ..repo-filepath,
  /// The branch to link to.
  /// -> str
  branch: "main",
) = {
  if repo-filepath.pos() == () {
    panic("#github-file requires a filepath to link to.")
  }

  let filepath = repo-filepath.pos().last()

  if repo-filepath.pos().len() > 1 {
    github(repo-filepath.pos().first(), path: "/tree/" + branch + "/" + filepath, label: filepath)
  } else {
    github(path: "/tree/" + branch + "/" + filepath, label: filepath)
  }
}

/// ```example
/// - #universe()
/// - #universe("tidy")
/// ```
/// -> content
#let universe(
  ..pkg,
  version: none,
) = {
  let make-link(pkg) = {
    let url = "https://typst.app/universe/package/" + pkg
    if version != none {
      url += "/" + str(version)
    }
    link(url, package(pkg))
  }

  let pkg = pkg.pos().at(0, default: auto)
  if pkg != auto {
    make-link(pkg)
  } else {
    document.use-value(
      "package.name",
      pkg => {
        make-link(pkg)
      },
    )
  }
}

/// Creates a link to the #github("typst/package") repository
/// in the `@preview` namespace.
/// ```example
/// - #preview()
/// - #preview(ver: version(0,4,1))
/// - #preview("tidy")
/// - #preview("tidy:0.3.1", namespace:"local")
/// ```
/// -> content
#let preview(
  ..pkg,
  ver: auto,
  namespace: "preview",
) = {
  let pkg = pkg.pos().at(0, default: auto)

  if ver == auto and pkg != auto {
    let m = pkg.match(regex(":(\d+\.\d+\.\d+)$"))
    if m != none {
      ver = m.captures.at(0)
      pkg = pkg.slice(0, -ver.len() - 1)
    } else {
      ver = none
    }
  } else if ver == auto {
    ver = none
  }

  if type(ver) == str {
    ver = version(..ver.split(".").map(int))
  }

  let make-link(pkg) = {
    link(
      "https://github.com/typst/packages/tree/main/packages/"
        + namespace
        + "/"
        + pkg
        + if ver != none {
          "/" + str(ver)
        } else {
          ""
        },
      package(
        "@"
          + namespace
          + "/"
          + pkg
          + if ver != none {
            ":" + str(ver)
          } else {
            ""
          },
      ),
    )
  }

  if pkg != auto {
    make-link(pkg)
  } else {
    document.use-value(
      "package.name",
      pkg => {
        make-link(pkg)
      },
    )
  }
}
