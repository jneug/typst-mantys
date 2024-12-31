#import "../_deps.typ" as deps
#import "../core/themes.typ": themable
#import "../util/utils.typ"

/// Create a frame around some content.
/// #info-alert[Uses #package("showybox") and can take any arguments the
/// #cmd-[showybox] command can take.]
/// #example[```
/// #frame(title:"Some lorem text")[#lorem(10)]
/// ```]
///
/// ..args (any): Arguments for #package[Showybox].
/// -> content
#let frame(..args) = themable(theme => deps.showybox.showybox(
  frame: (
    border-color: theme.primary,
    title-color: theme.primary,
    thickness: .75pt,
    radius: 4pt,
    inset: 8pt,
  ),
  ..args,
))

/// An alert box to highlight some content.
/// #example[```
/// #alert(color:purple, width:4cm)[#lorem(10)]
/// ```]
/// - color (color): Color of the alert.
/// - width (length, ratio): Width of the alert box.
/// - size (length): Size of the text.
/// - body (content): Content of the alert.
/// - ..style (any): Style arguments to be passed to #builtin[block].
/// -> content
#let alert(
  color: blue,
  width: 100%,
  size: .88em,
  ..style,
  body,
) = block(
  stroke: (left: 2pt + color, rest: 0pt),
  fill: color.lighten(88%),
  inset: 8pt,
  width: width,
  ..style,
  text(size: size, fill: color.darken(60%), body),
)


#let info-alert = alert.with(color: rgb(23, 162, 184))
#let warning-alert = alert.with(color: rgb(255, 193, 7))
#let error-alert = alert.with(color: rgb(220, 53, 69))
#let success-alert = alert.with(color: rgb(40, 167, 69))

/// Show a package name.
/// - #shortex(`#package("codelst")`)
///
/// - name (string): Name of the package.
#let package(name) = themable(theme => text(theme.emph.package, smallcaps(name)))

/// Show a module name.
/// - #shortex(`#module("util")`)
///
/// - name (string): Name of the module.
#let module(name) = themable(theme => text(theme.emph.module, utils.rawi(name)))

/// Highlight human names (with first- and lastnames).
/// - #shortex(`#name("Jonas Neugebauer")`)
/// - #shortex(`#name("J.", last:"Neugebauer")`)
///
/// - name (string): First or full name.
/// - last (string): Optional last name.
/// -> content
#let name(name, last: none) = {
  if last == none {
    let parts = utils.get-text(name).split(" ")
    last = parts.pop()
    name = parts.join(" ")
  }
  [#name #smallcaps(last)]
}
/// Creates a #typ.version from #sarg[args]. If the first argument is a version, it is returned as given.
/// - #ex(`#ver(1, 4, 2)`)
/// - #ex(`#ver(version(1, 4, 3))`)
/// -> version
#let ver(
  /// Components of the version.
  /// -> version | int
  ..args,
) = {
  if type(args.pos().first()) != version {
    version(..args.pos())
  } else {
    args.pos().first()
  }
}


/// Show a margin note in the left margin.
/// See @cmd:since and @cmd:until for examples.
/// -> content
#let note(
  /// Arguments to pass to #cmd(module: "drafting", "margin-note").
  /// -> any
  ..args,
  /// Body of the note.
  /// -> content
  body,
) = {
  // deps.drafting.margin-note(..args)[
  //   // #set align(right)
  //   #set text(.7em)
  //   #body
  // ]
  deps.marginalia.note(
    reverse: true,
    numbered: false,
    ..args,
  )[
    // #set align(right)
    #set text(.7em, style: "normal")
    #body
  ]
}


/// #is-themable()
/// Show a margin-note with a minimal package version.
/// - #ex(`#since(1,2,3)`)
/// #property(see: (<cmd:note>, <cmd:ver>))
/// -> content
#let since(
  /// Components of the version number.
  /// -> int | version
  ..args,
) = {
  note(
    styles.pill(
      "emph.since",
      (
        icon("arrow-up") + sym.space.nobreak + "Introduced in " + str(ver(..args))
      ),
    ),
  )
}

/// #is-themable()
/// Show a margin-note with a maximum package version.
/// - #ex(`#until(1,2,3)`)
/// #property(see: (<cmd:note>, <cmd:ver>))
/// -> content
#let until(
  /// Components of the version number.
  /// -> int | version
  ..args,
) = note(
  styles.pill(
    "emph.until",
    (
      icon("arrow-down") + sym.space.nobreak + "Available until " + str(ver(..args))
    ),
  ),
)


/// #is-themable()
/// Show a margin-note with a version number.
/// - #ex(`#changed(1,2,3)`)
/// #property(see: (<cmd:note>, <cmd:ver>))
/// -> content
#let changed(
  /// Components of the version number.
  /// -> int | version
  ..args,
) = note(
  styles.pill(
    "emph.changed",
    (
      icon("arrow-switch") + sym.space.nobreak + "Changed in " + str(ver(..args))
    ),
  ),
)


/// #is-themable()
/// Show a margin-note with a deprecated warning.
/// - #ex(`#deprecated()`)
/// #property(see: (<cmd:note>, <cmd:ver>))
/// -> content
#let deprecated() = note(
  styles.pill(
    "emph.deprecated",
    (
      icon("circle-slash") + sym.space.nobreak + "deprecated"
    ),
  ),
)


/// #is-themable()
/// Show a margin-note with a minimal Typst compiler version.
/// - #ex(`#compiler(1,2,3)`)
/// #property(see: (<cmd:note>, <cmd:ver>))
/// -> content
#let compiler(
  /// Components of the version number.
  /// -> int | version
  ..args,
) = note(
  styles.pill(
    "emph.compiler",
    (
      deps.codly.typst-icon.typ.icon + sym.space.nobreak + str(ver(..args))
    ),
  ),
)


/// #is-themable()
/// Show a margin-note with a context warning.
/// - #ex(`#requires-context()`)
/// #property(see: (<cmd:note>, <cmd:ver>))
/// -> content
#let requires-context() = note(
  styles.pill(
    "emph.context",
    (
      icon("pulse") + sym.space.nobreak + "context"
    ),
  ),
)
