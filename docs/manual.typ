#import "util.typ": mantys, package, issues
#import "/src/lib.typ" as mantodea
#import mantodea.util.link: footlink

#show: mantys.mantys.with(
  ..package,
  title: [mantodea],
  subtitle: [/mɑntɔdɛɑ/],
  date: datetime.today().display(),
  abstract: [
    MANTODEA provides a template and tools for writing documents targeted at Typst developers, such as convenient bindings to Typst documentation pages, example rendering or source forge links.
    It is primarily used as a package and template for technical documents such as guidelines, documentation or specifcations.
  ],
)

#show raw.line: it => {
  show "{{VERSION}}": package.version
  it
}

= Manifest
MANTODEA aims to be the following:
- simple to use
  - the default template should provide an good user experience
- unsurprising
  - parameters should have sensible names and behave as one would expect
- general
  - provided features are not for specific use cases, but rather baseline utilities for more specific use cases

If you think its behvior is surprising, you believe you found a bug or you think its defaults or parameters are not sufficient for your use case, please open an issue at #issues.
Contributions are also welcome!

MANTODEA is a fork of #footlink("https://github.com/jneug/typst-mantys", mantys.package[Mantys]), a package for creating package documentation.

= Reference
== Stability
This package tries to adhere to #footlink("https://semver.org")[semantic versioning], please report unintended API breakage at #issues.

== Custom types
=== theme <type-theme>
Most functions take a `theme` argument, this type is a dictionary containign various style information to override, mainly colors and font configuration.
The default can be found at `mantodea.theme.default` and serves as the defacto schema.

#mantys.add-type("theme", target: <type-theme>, color: orange.lighten(75%))

== Modules
#let mods = (
  ("mantodea", "/src/lib.typ", [
    The package entry point, containing the top level sub modules and the template main function.
  ]),
  ("style", "/src/style.typ", [
    Styles for the template, namely the default style in use for the template body.
  ]),
  ("component", "/src/component/table-of-contents.typ", [
    Parts of the template's components, while usable independently, they assume certain styles found in the `style` module.
  ]),
  ("component/table-of-contents", "/src/component/table-of-contents.typ", [
    Contains an outline implementation with improved alignment.
  ]),
  ("component/title-page", "/src/component/table-of-contents.typ", [
    Contains the title page component.
  ]),
  ("theme", "/src/theme.typ", [
    Theming related values, namely the default style dictionary used when not style is given.
  ]),
  ("util", "/src/util.typ", [
    General utlities.
  ]),
  ("util/author", "/src/util/author.typ", [
    Utlities for handling author rendering.
  ]),
  ("util/exmaple", "/src/util/example.typ", [
    Utlities for rendering examples with and without evaluation of Typst code.
  ]),
  ("util/link", "/src/util/link.typ", [
    Utlities for linking to Typst resources or source forges.
  ]),
)

#let render-module(name, path, description) = [
  #heading(depth: 3, name)

  #description
  #mantys.tidy-module(read(path), name: name)
]

#mods.map(x => render-module(..x)).join(pagebreak(weak: true))
