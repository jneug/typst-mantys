#import "packages.typ": *
#import t4t: *
#import codelst
#import showybox: showybox

#import "theme.typ"

// #################################
// # Some common utility functions #
// #################################

/// Create a frame around some content.
/// #ibox[Uses #package("showybox") and can take any arguments the
/// #cmd-[showybox] command can take.]
/// #example[```
/// #mty.frame(title:"Some lorem text")[#lorem(10)]
/// ```]
///
/// ..args (any): Arguments for #package[Showybox].
/// -> content
#let frame( ..args ) = showybox(
  frame: (
    border-color: theme.colors.primary,
    title-color: theme.colors.primary,
    thickness: .75pt,
    radius: 4pt,
    inset: 8pt
  ),
  ..args
)


/// An alert box to highlight some content.
/// #ibox[Uses #package("showybox") and can take any arguments the #cmd-[showybox] command can take.]
/// #example[```
/// #mty.alert(color:purple, width:4cm)[#lorem(10)]
/// ```]
#let alert(
	color: blue,
	width: 100%,
	size: .88em,
  ..style,
	body
) = showybox(
  frame: (
    border-color: color,
    title-color: color,
    body-color: color.lighten(88%),
    thickness: (left:2pt, rest:0pt),
    radius: 0pt,
    inset: 8pt
  ),
  width: width,
  ..style,
  text(size:size, fill:color.darken(60%), body)
)


/// Places a note in the margin of the page.
///
/// - pos (alignment): Either #value(left) or #value(right).
/// - gutter (length): Spacing between note and textarea.
/// - dy (length): How much to shift the note up or down.
/// - body (content): Content of the note.
/// -> content
#let marginnote(
	pos: left,
	gutter: .5em,
	dy: -1pt,
	body
) = {
	style(styles => {
		let _m = measure(body, styles)
		if pos.x == left {
			place(pos, dx: -1*gutter - _m.width, dy:dy, body)
		} else {
			place(pos, dx: gutter + _m.width, dy:dy, body)
		}
	})
}


// persistent state for index entries
#let __s_mty_index = state("@mty-index", ())


/// Removes special characters from #arg[term] to make it
/// a valid format for the index.
///
/// - term (string, content): The term to sanitize.
/// -> string
#let idx-term( term ) = {
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
  body
) = locate(loc => {
	__s_mty_index.update(arr => {
		arr.push((
			term: idx-term(def.if-none(term, body)),
			body: def.if-none(term, body),
			kind: kind,
			loc: loc
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
	headings: (h) => heading(level:2, numbering:none, outlined:false, h),
	entries: (term, body, locs) => [
		#link(locs.first(), body) #box(width: 1fr, repeat[.]) #{locs.map(loc => link(loc, strong(str(loc.page())))).join([, ])}\
	]
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
			terms.at(l).insert(term, (term:term, body:idx.body, pages: (p,), locs: (idx.loc,)))
		}
	}

	show heading: it => block([
		#block(spacing:0.3em, text(font:("Liberation Sans"), fill:theme.colors.secondary, it.body))
	])
	columns(cols,
		for l in terms.keys().sorted() {
			headings(l)

			// for (_, term) in terms.at(l) {
			for term-key in terms.at(l).keys().sorted() {
				let term = terms.at(l).at(term-key)
				entries(term.term, term.body, term.locs)
			}
		}
	)
})

/// Shows sourcecode in a frame.
/// #ibox[Uses #package[codelst] to render the code.]
/// See @sourcecode-examples for more information on sourcecode and examples.
///
/// - ..args (any): Argumente für #cmd-(module:"codelst")[sourcecode]
/// -> content
#let sourcecode( ..args ) = codelst.sourcecode(
  frame:none,
  ..args
)


/// Show an example by evaluating the given raw code with Typst and showing the source and result in a frame.
///
/// See section II.2.3 for more information on sourcecode and examples.
///
/// - side-by-side (boolean): Shows the source and example in two columns instead of the result beneath the source.
/// - scope (dictionary): A scope to pass to #doc("foundations/eval").
/// - mode (string): The evaulation mode: #choices("markup", "code", "math")
/// - breakable (boolean): If the frame may brake over multiple pages.
/// - example-code (content): A #doc("text/raw") block of Typst code.
/// - ..args (content): An optional second positional argument that overwrites the evaluation result. This can be used to show the result of a sourcecode, that can not evaulated directly.
#let code-example(
	side-by-side: false,
	scope: (:),
	mode:"markup",
  breakable: false,
	example-code,
	..args
) = {
	if is.not-empty(args.named()) {
		panic("unexpected arguments", args.named().keys().join(", "))
	}
	if args.pos().len() > 1 {
		panic("unexpected argument")
	}

	let code = example-code
	if not is.raw(code) {
		code = example-code.children.find(is.raw)
	}
	let cont = (
		sourcecode(raw(lang:if mode == "code" {"typc"} else {"typ"}, code.text)),
	)
	if not side-by-side {
		cont.push(line(length: 100%, stroke: .75pt + theme.colors.text))
	}

  // If the result was provided as an argument, use that,
  // otherwise eval the given example as code or content.
	if args.pos() != () {
		cont.push(args.pos().first())
	} else {
    cont.push(eval(mode:mode, scope: scope, code.text))
	}

  frame(
    breakable: breakable,
    grid(
			columns: if side-by-side {(1fr,1fr)} else {(1fr,)},
			gutter: 12pt,
			..cont
		)
  )
}
