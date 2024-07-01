

/// Extract text from content.
/// - it (content): A content item.
/// -> string
#let get-text(it) = {
  if type(it) == content {
    return it.text
  } else {
    return it
  }
}

/// Displays #arg[code] as inline #builtin[raw]
/// - #shortex(`#utils.rawi("my-code")`)
/// - code (string, content): The content to show as inline raw.
/// -> content
#let rawi(code, lang: none) = raw(block: false, lang: lang, get-text(code))

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


/// Creates a preamble
/// #property(since: "1.0.0", requires-context: true)
#let build-preamble(imports) = {
  return imports.pairs().map(((mod, imp)) => {
    "#import " + mod + ": " + imp
  }).join(";") + ";"
}

#let add-pramble(code, imports) = {
  if type(code) != str {
    code = code.text
  }
  return build-preamble(imports) + code
}
