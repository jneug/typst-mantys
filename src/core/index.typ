#import "../util/utils.typ"
#import "../_deps.typ" as deps

/// Removes special characters from #arg[term] to make it
/// a valid format for the index.
///
/// - term (string, content): The term to sanitize.
/// -> string
#let idx-term(term) = {
  utils.get-text(term).replace(regex("[#_()]"), "")
}


/// Adds #arg[term] to the index.
///
/// Each entry can be categorized by setting #arg[kind].
/// @@make-index can be used to generate the index for one kind only.
///
/// - term (string, content): An optional term to use, if it differs from #arg[body].
/// - hide (boolean): If #value(true), no content is shown on the page.
/// - kind (string): A category for ths term.
/// - body (content): The term or label for the entry.
/// -> (none, content)
#let idx(
  term: none,
  hide: false,
  kind: "term",
  main: false,
  body,
) = {
  let entry = (
    term: idx-term(if term != none {
      term
    } else {
      body
    }),
    body: body,
    main: main,
    kind: kind,
  )
  if not hide {
    body
  }
  [#metadata(entry)<mantys:index>]
}

/// #property(context: true)
#let index-len(kind: auto) = {
  let terms = (:)

  let index-entries = query(<mantys:index>)
  if kind != auto {
    let kinds = (kind,).flatten()
    index-entries = index-entries.filter(entry => entry.value.kind in kinds)
  }

  return index-entries.len()
}

/// Creates an index from previously set entries.
///
/// - kind (string): An optional kind of entries to show.
/// - cols (integer): Number of columns to show the entries in.
/// - headings (function): Function to generate headings in the index.
///   Gets the letter for the new section as an argument:
///   #lambda("string", ret:"content")
/// - entries (function): A function to format index entries.
///   Gets the index term, the label and the location for the entry:
///   #lambda("string", "content", "location", ret:"content")
/// -> content
#let make-index(
  kind: auto,
  headings: text => heading(depth: 2, numbering: none, outlined: false, bookmarked: false, text),
  entries: (term, body, locs) => [
    #link(locs.first(), body) #box(width: 1fr, repeat[.]) #{
      locs.map(loc => link(loc, strong(str(loc.page())))).join([, ])
    }\
  ],
) = context {
  // TODO: Improve index generation:
  //       - Add "main" index entry
  //       - Simplify (?)
  //       - Add "sort" option (by term, by (first) page)
  let index-entries = query(<mantys:index>)
  let terms = (:)
  let kinds = (kind,).flatten()

  for entry in index-entries {
    let idx = entry.value
    if kind != auto and idx.kind not in kinds {
      continue
    }

    let letter = upper(idx.term.first())
    let page = entry.location().page()

    if letter not in terms {
      terms.insert(letter, (:))
    }
    if idx.term in terms.at(letter) {
      // Update list of locations
      if page not in terms.at(letter).at(idx.term).pages {
        terms.at(letter).at(idx.term).pages.push(p)
        terms.at(letter).at(idx.term).locations.push(entry.location())
      }
    } else {
      // Insert term
      terms.at(letter).insert(
        idx.term,
        (
          term: idx.term,
          body: idx.body,
          pages: (page,), // TODO ?
          locations: (entry.location(),),
        ),
      )
    }
  }

  for letter in terms.keys().sorted() {
    headings(letter)

    for term-key in terms.at(letter).keys().sorted() {
      let term = terms.at(letter).at(term-key)
      entries(term.term, term.body, term.locations)
    }
  }
}
