#import "/src/theme.typ" as _theme

#let _type = type

/// The type links supported by @@type.
///
/// Can be used to add new or alter exisiting type links.
///
/// The default contains the typst built in types, including the special types
/// which contain no page like `any`, linking to the types page instead.
#let typst = {
  let _docs(path) = "https://typst.app/docs/" + path
  let _reference(path) = _docs("reference/" + path)

  // the complete docs site map
  let site-map = (
    _self: _docs(""),
    tutorial: (
      _self:             _docs("tutorial"),
      writing-in-typst:  _docs("tutorial/writing-in-typst"),
      formatting:        _docs("tutorial/formatting"),
      advanced-styling:  _docs("tutorial/advanced-styling"),
      making-a-template: _docs("tutorial/making-a-template"),
    ),
    reference: (
      _self: _reference(""),
      foundations: (
        _self:      _reference("foundations"),
        arguments:  _reference("foundations/arguments"),
        array:      _reference("foundations/array"),
        bool:       _reference("foundations/bool"),
        bytes:      _reference("foundations/bytes"),
        content:    _reference("foundations/content"),
        datetime:   _reference("foundations/datetime"),
        dictionary: _reference("foundations/dictionary"),
        float:      _reference("foundations/float"),
        function:   _reference("foundations/function"),
        int:        _reference("foundations/int"),
        location:   _reference("foundations/location"),
        plugin:     _reference("foundations/plugin"),
        regex:      _reference("foundations/regex"),
        selector:   _reference("foundations/selector"),
        str:        _reference("foundations/str"),
        type:       _reference("foundations/type"),
        label:      _reference("foundations/label"),
      ),
      model: (
        _self:        _reference("model"),
        bibliography: _reference("model/bibliography"),
        cite:         _reference("model/cite"),
        document:     _reference("model/document"),
        emph:         _reference("model/emph"),
        enum:         _reference("model/enum"),
        figure:       _reference("model/figure"),
        footnote:     _reference("model/footnote"),
        heading:      _reference("model/heading"),
        link:         _reference("model/link"),
        list:         _reference("model/list"),
        numbering:    _reference("model/numbering"),
        outline:      _reference("model/outline"),
        par:          _reference("model/par"),
        parbreak:     _reference("model/parbreak"),
        quote:        _reference("model/quote"),
        ref:          _reference("model/ref"),
        strong:       _reference("model/strong"),
        table:        _reference("model/table"),
        terms:        _reference("model/terms"),
      ),
      text: (
        _self:      _reference("text"),
        highlight:  _reference("text/highlight"),
        linebreak:  _reference("text/linebreak"),
        lorem:      _reference("text/lorem"),
        lower:      _reference("text/lower"),
        overline:   _reference("text/overline"),
        raw:        _reference("text/raw"),
        smallcaps:  _reference("text/smallcaps"),
        smartquote: _reference("text/smartquote"),
        strike:     _reference("text/strike"),
        sub:        _reference("text/sub"),
        super:      _reference("text/super"),
        text:       _reference("text/text"),
        underline:  _reference("text/underline"),
        upper:      _reference("text/upper"),
      ),
      layout: (
        _self:     _reference("layout"),
        align:     _reference("layout/align"),
        alignment: _reference("layout/alignment"),
        angle:     _reference("layout/angle"),
        block:     _reference("layout/block"),
        box:       _reference("layout/box"),
        colbreak:  _reference("layout/colbreak"),
        columns:   _reference("layout/columns"),
        direction: _reference("layout/direction"),
        fraction:  _reference("layout/fraction"),
        grid:      _reference("layout/grid"),
        h:         _reference("layout/h"),
        hide:      _reference("layout/hide"),
        layout:    _reference("layout/layout"),
        measure:   _reference("layout/measure"),
        move:      _reference("layout/move"),
        pad:       _reference("layout/pad"),
        page:      _reference("layout/page"),
        pagebreak: _reference("layout/pagebreak"),
        place:     _reference("layout/place"),
        ratio:     _reference("layout/ratio"),
        relative:  _reference("layout/relative"),
        repeat:    _reference("layout/repeat"),
        rotate:    _reference("layout/rotate"),
        scale:     _reference("layout/scale"),
        stack:     _reference("layout/stack"),
        v:         _reference("layout/v"),
      ),
      visualize: (
        _self:    _reference("visualize"),
        circle:   _reference("visualize/circle"),
        color:    _reference("visualize/color"),
        ellipse:  _reference("visualize/ellipse"),
        gradient: _reference("visualize/gradient"),
        image:    _reference("visualize/image"),
        line:     _reference("visualize/line"),
        path:     _reference("visualize/path"),
        pattern:  _reference("visualize/pattern"),
        polygon:  _reference("visualize/polygon"),
        rect:     _reference("visualize/rect"),
        square:   _reference("visualize/square"),
        stroke:   _reference("visualize/stroke"),
      )
    ),
    guides: (
      _self:                 _docs("guides"),
      guide-for-latex-users: _docs("guides/guide-for-latex-users"),
      page-setup-guide:      _docs("guides/page-setup-guide"),
      table-guide:           _docs("guides/table-guide"),
    ),
    changelog: _docs("changelog"),
    roamap:    _docs("roamap"),
    community: _docs("community"),
  )

  let types = (
    // special
    any:    site-map.reference.foundations._self,
    "auto": site-map.reference.foundations._self,
    "none": site-map.reference.foundations._self,

    // foundations
    arguments:  site-map.reference.foundations.arguments,
    array:      site-map.reference.foundations.array,
    bool:       site-map.reference.foundations.bool,
    bytes:      site-map.reference.foundations.bytes,
    content:    site-map.reference.foundations.content,
    datetime:   site-map.reference.foundations.datetime,
    dictionary: site-map.reference.foundations.dictionary,
    float:      site-map.reference.foundations.float,
    function:   site-map.reference.foundations.function,
    int:        site-map.reference.foundations.int,
    location:   site-map.reference.foundations.location,
    plugin:     site-map.reference.foundations.plugin,
    regex:      site-map.reference.foundations.regex,
    selector:   site-map.reference.foundations.selector,
    str:        site-map.reference.foundations.str,
    type:       site-map.reference.foundations.type,
    label:      site-map.reference.foundations.label,

    // layout
    alignment: site-map.reference.layout.alignment,
    angle:     site-map.reference.layout.angle,
    direction: site-map.reference.layout.direction,
    fraction:  site-map.reference.layout.fraction,
    ratio:     site-map.reference.layout.ratio,
    relative:  site-map.reference.layout.relative,

    // visualize
    color:    site-map.reference.visualize.color,
    gradient: site-map.reference.visualize.gradient,
    pattern:  site-map.reference.visualize.pattern,
    stroke:   site-map.reference.visualize.stroke,
  )

  (
    docs: site-map,
    types: types,
  )
}

/// The forges supported by @@forge.
///
/// Can be used to add new, or alter existing matchers, matchers come in the
/// form of a function which takes a url and either returns a `str` or `none`
/// directly, or a boolean. `false` or `none` means the matcher did not match,
/// `true` means use the matcher key, a `str` means use this string directly.
///
/// The default matchers include GitHub, GitLab and Codeberg as well as a crude
/// git-subdomain matcher which returns the top and second level domain.
#let forges = state("__mantodea:util:link:forges", (
  GitHub: s => s.contains("github.com"),
  GitLab: s => s.contains("gitlab.com"),
  Codeberg: s => s.contains("codeberg.org"),
  GenericGitSubdomain: s => {
    let re = regex("(https?://)?git\.")
    if s.starts-with(re) {
      s.trim(re, at: start, repeat: false)
    }
  },
))

/// Creates a link with a footnote.
///
/// - url (str): The url for the link and the footnote.
/// - label (str): The label for the link.
/// -> content
#let footlink(url, label) = [#link(url, label)#footnote(link(url))]

/// Creates a link with footnote to a source forge and optional repo.
///
/// - base (str): The forge base url.
/// - label (str, auto): The label to use for the forge, uses @@forges if
///   `auto`.
/// - ..relative (str): An optional author or repository path.
/// -> content
#let forge(
  base,
  ..relative,
  label: auto,
) = {
  let relative = relative.pos().at(0, default: none)

  if base.ends-with("/") {
    base = base.silce(0, -1)
  }

  if label == auto {
    label = context {
      for (label, matcher) in forges.final().pairs() {
        let m = matcher(base)
        if m == true {
          return label
        } else if type(m) == str {
          return m
        }
      }

      base
    }
  }

  if relative != none {
    label = label + ":" + relative
  }

  let url = if relative != none {
    (base, relative).join("/")
  } else {
    base
  }

  footlink(url, label)
}

/// Creates a link with a footnote to a GitHub repository.
///
/// - repo (str): The repository path.
/// -> content
#let github(repo) = forge("https://github.com", repo)

/// Creates a link with a footnote to a GitLab repository.
///
/// - repo (str): The repository path.
/// -> content
#let gitlab(repo) = forge("https://gitlab.com", repo)

/// Creates a link with a footnote to a Codeberg repository.
///
/// - repo (str): The repository path.
/// -> content
#let codeberg(repo) = forge("https://codeberg.org", repo)

/// Creates a link with a footnote to the Typst Universe page of a package.
///
/// - name (str): The name of the package.
/// - version (version, none): The version of the package, this has no effect
///   on the link itself.
/// -> content
#let package(name, version: none) = {
  let base = "https://typst.app/universe/package"
  // NOTE: lowering the name is always valid here
  footlink((base, lower(name)).join("/"), smallcaps(name))
}

/// Creates a link with a footnote to the Typst package repository.
///
/// - name (str): Name of the package.
/// - version (version): The version of the package.
/// - namespace (str): The package namespace to use.
/// -> content
#let package-repo(name, version, namespace: "preview") = {
  let base = "https://github.com/typst/packages/tree/main/packages"
  let version = str(version)

  footlink(
    // NOTE: I'm not sure if always lowering the package name is valid, but I the ecosystem seems to
    // largely use kebab-case package names so this will be fine
    (base, namespace, lower(name), version).join("/"),
    smallcaps(name + ":" + version),
  )
}

/// Creates a link with a footnote to the documentation of a built-in Typst type.
///
/// - value (str, any): The type or value to which to link to:
///   - if this is a `str`, it is inferred to be the type representation
///   - if this is a type, it is inferred to be the expected type
///   - if this is a value, it is inferred to be a value of the expected type
/// - theme (theme): The theme to use for this type.
/// -> content
#let type(
  value,
  with-footnote: false,
  theme: _theme.default,
) = {
  let type = if _type(value) == str {
    value
  } else if _type(value) == _type {
    repr(value)
  } else {
    repr(_type(value))
  }

  let color = theme.colors.types.at(type, default: theme.colors.types.at("any"))

  let type = {
    let aliases = (
      string: "str",
      boolean: "bool",
    )

    aliases.at(type, default: type)
  }

  footlink(typst.types.at(type), box(
    inset: (x: 0.25em),
    outset: (y: 0.25em),
    radius: 0.25em,
    fill: color,
    raw(type),
  ))
}
