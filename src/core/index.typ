// persistent state for index entries
#let __s_mty_index = state("@mty-index", ())


/// Removes special characters from #arg[term] to make it
/// a valid format for the index.
///
/// - term (string, content): The term to sanitize.
/// -> string
#let idx-term(term) = {
  get.text(term).replace(regex("[#_()]"), "")
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
  body,
) = locate(loc => {
  __s_mty_index.update(arr => {
    arr.push((
      term: idx-term(def.if-none(term, body)),
      body: def.if-none(term, body),
      kind: kind,
      loc: loc,
    ))
    arr
  })
  if not hide {
    body
  }
})


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
  kind: none,
  cols: 3,
  headings: h => heading(level: 2, numbering: none, outlined: false, h),
  entries: (term, body, locs) => [
    #link(locs.first(), body) #box(width: 1fr, repeat[.]) #{
      locs.map(loc => link(loc, strong(str(loc.page())))).join([, ])
    }\
  ],
) = locate(loc => {
  let index = __s_mty_index.final(loc)
  let terms = (:)

  let kinds = (kind,).flatten()
  for idx in index {
    if is.not-none(kind) and idx.kind not in kinds {
      continue
    }
    let term = idx.term
    let l = upper(term.first())
    let p = idx.loc.page()

    if l not in terms {
      terms.insert(l, (:))
    }
    if term in terms.at(l) {
      if p not in terms.at(l).at(term).pages {
        terms.at(l).at(term).pages.push(p)
        terms.at(l).at(term).locs.push(idx.loc)
      }
    } else {
      terms.at(l).insert(term, (term: term, body: idx.body, pages: (p,), locs: (idx.loc,)))
    }
  }

  show heading: it => block([
    #block(spacing: 0.3em, text(font: ("Liberation Sans"), fill: theme.colors.secondary, it.body))
  ])
  columns(
    cols,
    for l in terms.keys().sorted() {
      headings(l)

      // for (_, term) in terms.at(l) {
      for term-key in terms.at(l).keys().sorted() {
        let term = terms.at(l).at(term-key)
        entries(term.term, term.body, term.locs)
      }
    },
  )
})
