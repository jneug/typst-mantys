#import "@preview/t4t:0.1.0": *
#import "@preview/codelst:1.0.0"
#import "@preview/showybox:0.2.1": showybox

#import "theme.typ"

// #################################
// # Some common utility functions #
// #################################

// Inline raw text
#let rawi( code, lang:none ) = raw(block: false, get.text(code), lang:lang)
// Colored inline raw text
#let rawc( color, code ) = text(fill:color, rawi(code))

// A centered block
#let cblock( width:90%, breakable:false, ..args, body ) = block(
	width: 100%,
  breakable: breakable,
	inset: (left:(100%-width)/2, right:(100%-width)/2),
	block(width:100%, spacing: 0pt, ..args, body)
)

// Some boxes / blocks to highlight content
#let frame = showybox.with(
  frame: (
    border-color: theme.colors.primary,
    upper-color: theme.colors.primary,
    width: .75pt,
    radius: 4pt,
    inset: 8pt
  )
)

// inspired by typst-boxes
#let alert(
	color: blue,
	icon: none,
	width: 100%,
	size: .9em,
	body
) = {
  let (stroke, radius, inset) = (2pt, 2pt, 8pt)
  return cblock(
    fill: color.lighten(88%),
    stroke: stroke + color,
    radius: radius,
    width: width,
    grid(
      columns: if is.not-none(icon) { (100% - 1em - 2*inset, auto) } else { 1 },
      block(
        width: 100%,
        spacing: 0pt,
        inset: inset,
        text(size:.88em, body)
      ),
      if is.not-none(icon) {
        h(1fr)
        box(
          fill: color,
          // width: 1em + 2*inset,
          inset: inset,
          radius: (top-right: radius, bottom-left: radius),
          text(fill: white, weight: 600, icon)
        )
      }
    )
  )
}

#let marginnote(
	pos: left,
	gutter: .5em,
	dy: -1pt,
	body
) = {
	style(styles => {
		let _m = measure(body, styles)
		if pos == left {
			place(pos, dx: -1*gutter - _m.width, dy:dy, body)
		} else {
			place(pos, dx: gutter + _m.width, dy:dy, body)
		}
	})
}

// Index
#let __s_mty_index = state("@mty-index", ())

#let idx-term( term ) = {
	get.text(term).replace(regex("[#_()]"), "")
}

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

// Version numbers
#let ver( major, minor, patch ) = [*#major.#minor.#patch*]

// Typset human names (with first- and lastnames)
#let name( name, last:none ) = {
	if last == none {
		let parts = get.text(name).split(" ")
		last = parts.pop()
		name = parts.join(" ")
	}
	[#name #smallcaps(last)]
}

#let author( info ) = {
	if type(info) == "string" {
		return name(info)
	} else if "email" in info {
		return [#name(info.name) #link("mailto:" + info.email, rawi("<" + info.email + ">"))]
	} else {
		return name(info.name)
	}
}

#let date( d, format:"[year]-[month]-[day]" ) = {
	if type(d) == "datetime" {
		d.display(format)
	} else {
		d
	}
}

#let footlink( url, label ) = [#link(url, label)#footnote(link(url))]
#let gitlink( repo ) = footlink("https://github.com/" + repo, repo)
#let pkglink( name, version, namespace:"preview" ) = footlink("https://github.com/typst/packages/tree/main/packages/" + namespace + "/" + name + "-" + version.join("."), repo + sym.colon + version.join("."))

#let primary = text.with(fill:theme.colors.primary)
#let secondary = text.with(fill:theme.colors.secondary)

#let package( name ) = primary(smallcaps(name))
#let module( name ) = secondary(rawi(name))

#let is-a(value, label) = {
	return type(value) == "content" and value.has("label") and value.label == label
}

#let is-body( value ) = is-a(value, <arg-body>)
#let not-is-body( value ) = {return not is-body(value)}
#let is-choices( value ) = is-a(value, <arg-choices>)
#let not-is-choices( value ) = {return not is-choices(value)}
#let is-func( value ) = is-a(value, <mty-func>)
#let not-is-func( value ) = not is-a(value, <mty-func>)
#let is-lambda( value ) = is-a(value, <mty-lambda>)
#let not-is-lambda( value ) = not is-a(value, <mty-lambda>)

#let as-arr( ..values ) = (..values.pos(),).flatten()

#let mark-as( mark, elem ) = {
  if not is.label(mark) {
    mark = alias.label(mark)
  }
  [#elem#mark]
}
#let mark-body( elem ) = [#elem<arg-body>]
#let mark-choices( elem ) = [#elem<arg-choices>]
#let mark-func( elem ) = [#elem<mty-func>]
// #let mark-func = mark-as.with(<mty-func>)
#let mark-lambda( elem ) = [#elem<mty-lambda>]

#let has-mark( mark, elem ) = {
  if type(mark) != "label" {
    mark = label(mark)
  }
  return type(elem) == "content" and elem.has("label") and elem.label == mark
}
#let is-func = has-mark.with(<mty-func>)

#let place-marker( name ) = {
  raw("", lang:"--meta-" + name + "--")
}

#let marker( name ) = selector(raw.where(lang: "--meta-" + name + "--"))

#let value( value ) = {
	if is.str(value) {
		if value.contains("=>") {
			return rawc(theme.colors.value, value)
		} else {
			return rawi(sym.quote.double) + rawc(theme.colors.value, value) + rawi(sym.quote.double)
		}
	} else if is-choices(value) or is-func(value) {
    return value
  } else if is-lambda(value) {
		return rawc(theme.colors.value, value)
	} else {
		return rawc(theme.colors.value, repr(value))
	}
	// return [#value]
}

#let default( val ) = [#underline(value(val), offset:0.2em, stroke:1pt+theme.colors.value)<default>]

#let sourcecode = codelst.sourcecode.with(frame:none, label-regex: none)
#let lineref = codelst.lineref

#let example(
	side-by-side: false,
	scope: (:),
	mode:"markup",
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
    grid(
			columns: if side-by-side {(1fr,1fr)} else {(1fr,)},
			gutter: 12pt,
			..cont
		)
  )
}
