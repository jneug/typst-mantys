

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
#let rawi(code) = raw(block: false, get-text(code))

/// Returns a light or dark color, depending on the provided #arg[clr].
/// #example[```
/// #utils.get-text-color(red)
/// ```]
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
