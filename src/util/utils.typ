/// Extract text from content.
/// - it (content): A content item.
/// -> string
#let get-text(it) = {
  if type(it) == content and it.has("text") {
    return it.text
  } else if type(it) in (symbol, int, float, version, bytes, label, type, str) {
    return str(it)
  } else {
    return repr(it)
  }
}

/// Displays #arg[code] as inline #builtin[raw]
/// - #shortex(`#utils.rawi("my-code")`)
/// - code (string, content): The content to show as inline raw.
/// -> content
#let rawi(code, lang: none) = raw(block: false, lang: lang, get-text(code))

/// Shows #arg[code] as inline #builtin[raw] text (with #arg(block: false)) and with the given #arg[color]. This
/// supports no language argument, since #arg[code] will have a uniform color.
/// - #shortex(`#utils.rawc(purple, "some inline code")`)
///
/// - color (color): Color for the `raw` text.
/// - code (content): String content to be displayed as `raw`.
/// -> content
#let rawc(color, code) = text(fill: color, rawi(code))

/// Returns a light or dark color, depending on the provided #arg[clr].
/// #example[```
/// #utils.get-text-color(red)
/// ```]
/// - clr (color, gradient): Paint to get the text color for.
/// - light (color): Color to use, if #arg[clr] is a dark color.
/// - dark (color): Color to use, if #arg[clr] is a light color.
/// -> color
#let get-text-color(clr, light: white, dark: black) = {
  if type(clr) == gradient {
    clr = clr.sample(50%)
  }
  if color.hsl(clr).components(alpha: false).last() < 62% {
    light
  } else {
    dark
  }
}

/// Places a hidden #builtin[figure] in the document, that can be referenced via the
/// usual `@label-name` syntax.
/// - label (label): Label to reference.
/// - kind (str): Kind for the reference to properly step counters.
/// - supplement (str): Supplement to show when referencing.
/// - numbering (str): Numbering schema to use.
/// -> content
#let place-reference(
  label,
  kind,
  supplement,
  numbering: "1",
) = place()[#figure(
    kind: kind,
    supplement: supplement,
    numbering: numbering,
    [],
  )#label]

/// Creates a preamble
/// #property(since: "1.0.0", requires-context: true)
#let build-preamble(imports) = {
  if imports != (:) {
    return imports.pairs().map(((mod, imp)) => {
      "#import " + mod + ": " + imp
    }).join(";") + ";"
  } else {
    return ""
  }
}

// Adds a preamble for cutoms imports to #arg[code].
#let add-preamble(code, imports) = {
  if type(code) != str {
    code = code.text
  }
  return build-preamble(imports) + code
}
