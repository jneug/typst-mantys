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
      for (label, matcher) in forges.get().pairs() {
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
