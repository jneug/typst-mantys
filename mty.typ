#import "@local/codelst:0.0.3": sourcecode, sourcefile, lineref, code-frame, numbers-style

#let colors = (
	primary:   rgb(35, 157, 172),
	secondary: rgb(18, 120, 133),
	argument:  rgb(0, 29, 87),
	option:    rgb(214, 182, 93),
	value:     rgb(181, 2, 86),
	command:   rgb(75, 105, 197),
	comment:   rgb(128, 128, 128),

	info: rgb(23, 162, 184),
	warning: rgb(255, 193, 7),
	error: rgb(220, 53, 69),
	success: rgb(40, 167, 69),

	dtypes: (
		length: rgb(230, 218, 255),
		integer: rgb(230, 218, 255),
		float: rgb(230, 218, 255),
		fraction: rgb(230, 218, 255),
		ratio: rgb(230, 218, 255),
		"relative length": rgb(230, 218, 255),
		"none": rgb(255, 203, 195),
		"auto": rgb(255, 203, 195),
		"any": rgb(255, 203, 195),
		"regular expression": rgb(239, 240, 243),
		dictionary: rgb(239, 240, 243),
		array: rgb(239, 240, 243),
		stroke: rgb(239, 240, 243),
		location: rgb(239, 240, 243),
		alignment: rgb(239, 240, 243),
		"2d alignment": rgb(239, 240, 243),
		boolean: rgb(255, 236, 193),
		content: rgb(166, 235, 229),
		string: rgb(209, 255, 226),
		function: rgb(249, 223, 255),
		color: (
			rgb(133, 221, 244),
			rgb(170, 251, 198),
			rgb(214, 247, 160),
			rgb(255, 243, 124),
			rgb(255, 187, 147)
		)
	)
)

// #################################
// # Some common utility functions #
// #################################

// Backup type function to use "type" as an argument.
#let type = type

#let extract(
	args,
	_prefix:"",
	_positional:false,
	..keys
) = {
	let vars = (:)
	for key in keys.named() {
		let k = _prefix + key.first()

		if k in args.named() {
			vars.insert(key.first(), args.named().at(k))
		} else {
			vars.insert(key.first(), key.last())
		}
	}
	if _positional { return vars.values() }
	else { return vars }
}

// Create a dict from a key / value pair.
#let kv( key, val ) = {
	let x = (:)
	x.insert(key, val)
	return x
}

// Extract text from any elemten
#let txt( v ) = {
	if type(v) == "content" {
		if v.has("text") {
			v.text
		} else if v.has("children") {
			let s = ""
			for c in v.children {
				s += txt(c)
			}
			s
		} else if v.has("child") {
			txt(v.child)
		} else if v.has("body") {
			txt(v.body)
		} else {
			// repr(v)
			""
		}
	} else {
		str(v)
	}
}

// Convert text or content to titlecase
#let ufirst( text ) = {
	let s = str(text)
	upper(s.slice(0,1))
	lower(s.slice(1))
}
#let title( body ) = {
	body.split(" ").map(upfirst).join(" ")
}

// Inline raw text
#let rawi(code, lang:none) = raw(block: false, txt(code), lang:lang)
// Colored inline raw text
#let rawc(color, code) = text(fill:color, rawi(code))

// A centered block
#let cblock(width:90%, ..args, body) = block(
	width: 100%,
	inset: (left:(100%-width)/2, right:(100%-width)/2),
	block(width:100%, ..args, body)
)

// A box to highlight content
#let frame(
	header: none,
	invert-header: true,
	stroke-color: colors.primary,
	bg-color: white,
	width: 100%,
	radius: 4pt,
	padding: 8pt,

	body
) = {
	let rad = radius
	let pad = padding

	let head = block()
	if header != none {
		head = block(
			stroke: .75pt+stroke-color,
			radius: (
				top: rad
			),
			width: 100%,
			inset: pad / 2,
			fill: if invert-header {stroke-color} else {bg-color},
			text(
				fill: if invert-header {bg-color} else {stroke-color},
				header
			)
		)
	}

	grid(
		columns: 1,
		gutter: 0pt,
		head,
		block(
			stroke: .75pt+stroke-color,
			radius: (
				top: if header != none {0pt} else {rad},
				bottom: rad
			),
			inset: pad,
			width: width,
			fill: bg-color,
			body
		)
	)
}

// A box to highlight content
#let alert(
	color:blue,
	icon:none,
	title:none,
	width: 90%,
	size:.9em,
	body
) = {
	cblock(width:width,
		stroke: .75pt+color,
		fill: color.lighten(80%),
		radius: 2pt,
		inset: 2mm,
		{
			set text(size:size, fill:color.darken(50%))
			if icon != none { text(weight:600, icon) }
			if title != none { text(weight:600, title) + [\ ] }
			body
		}
	)
}

#let marginnote(
	pos:    left,
	gutter: .5em,
	dy:     -1pt,
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

#let idx-term(term) = {
	txt(term).replace(regex("[#_()]"), "")
}

#let idx(body, term:none, hide:false, kind:"term") = locate(loc => {
	__s_mty_index.update(arr => {
		arr.push((
			term: idx-term(if term == none { body } else { term }),
			body: if term == none { body } else { term },
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
	kind:none,
	cols:3,
	headings:(h) => heading(level:2, numbering:none, outlined:false, h),
	entry: (term, body, locs) => [
		#link(locs.first(), body) #box(width: 1fr, repeat[.]) #{locs.map(loc => link(loc, strong(str(loc.page())))).join([, ])}\
	]
) = locate(loc => {
	let index = __s_mty_index.final(loc)
	let terms = (:)

	let kinds = kind
	if type(kind) != "array" {
		kinds = (kind,)
	}

	for idx in index {
		if kind != none and idx.kind not in kinds {
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
		#block(spacing:0.3em, text(font:("Liberation Sans"), fill:colors.secondary, it.body))
	])
	columns(cols,
		for l in terms.keys().sorted() {
			headings(l)

			// for (_, term) in terms.at(l) {
			for term-key in terms.at(l).keys().sorted() {
				let term = terms.at(l).at(term-key)
				entry(term.term, term.body, term.locs)
			}
		}
	)
})

// Version numbers
#let ver( major, minor, patch ) = [#major.#minor.#patch]

// Typset human names (with first- and lastnames)
#let name( name, last:none ) = {
	if last == none {
		let parts = name.split(" ")
		last = parts.pop()
		name = parts.join(" ")
	}
	[#name #smallcaps(last)]
}

#let author( info ) = {
	if type(info) == "string" {
		return name(info)
	} else if "email" in info {
		return [#name(info.name) <#link("mailto:" + info.email, rawi(info.email))>]
		// return [#info.name#footnote[#info.email]]
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

#let primary = text.with(fill:colors.primary)
#let secondary = text.with(fill:colors.secondary)

#let package( name ) = primary(smallcaps(name))
#let module( name ) = secondary(rawi(name))

#let is-a(value, label) = {
	return type(value) == "content" and value.has("label") and value.label == label
}

#let is-string( value ) = {return type(value) == "string"}
#let is-content( value ) = {return type(value) == "content"}
#let is-body( value ) = is-a(value, <arg-body>)
#let not-is-body( value ) = {return not is-body(value)}
#let is-choices( value ) = is-a(value, <arg-choices>)
#let not-is-choices( value ) = {return not is-choices(value)}

#let value( value ) = {
	let t = type(value)
	if t == "string" {
		if value.contains("=>") {
			return rawc(colors.value, value)
		} else {
			return rawi(sym.quote.double) + rawc(colors.value, value) + rawi(sym.quote.double)
		}
	} else if is-choices(value) {
		return value
	} else {
		return rawc(colors.value, repr(value))
	}
	// return [#value]
}

#let default( val ) = [#underline(value(val), offset:0.2em, stroke:1pt+colors.value)<default>]


#let count_tabs(line, default:0) = {
	if line.len() == 0 {
		return default
	}

	let m = line.match(regex("^\t+"))
	if m != none {
		return m.end
	} else {
		return 0
	}
}
#let tabs(line, spaces:4, gobble:0) = {
	if gobble in (none, false) { gobble = 0 }

	if spaces != none and spaces > 0 {
		let m = line.match(regex("^\t+"))
		if m != none {
			line = line.replace(regex("^\t+"), " " * (m.end - gobble) * spaces)
		}
	}
	return line
}
// #let sourcecode(
// 	fill: white,
// 	border: none,
// 	lines-color: luma(200),
// 	lines-style: (i) => text(
// 		fill: luma(200),
// 		size: .8em,
// 		rawi(str(i))
// 	),

// 	tab-indent: 4,
// 	gobble: auto,

// 	linenos: true,
// 	gutter: 10pt,

// 	body
// ) = {
// 	let lines = 0
// 	let lang = none
// 	let code-lines = ()

// 	let code = body
// 	if code.func() != raw {
// 		for item in body.children {
// 			if item.func() == raw {
// 				code = item
// 				break
// 			}
// 		}
// 	}

// 	code-lines = code.text.split("\n")
// 	lines = code-lines.len()
// 	lang = code.lang

// 	if gobble == auto {
// 		gobble = code-lines.fold(100, (v, line) => {
// 			return calc.min(v, count_tabs(line, default:v))
// 		})
// 	}

// 	for i in range(lines) {
// 		code-lines.at(i) = tabs(code-lines.at(i), spaces:tab-indent, gobble:gobble)
// 	}

// 	let grid-cont = ()
// 	for i in range(lines) {
// 		grid-cont.push(lines-style(i + 1))
// 		// grid-cont.push(hide(raw(lang:lang, block:true,code-lines.at(i))))
// 		grid-cont.push(raw(lang:lang, block:true,code-lines.at(i)))
// 	}

// 	style(styles => {
// 		block(
// 			fill:fill,
// 			stroke: border,
// 			inset: (x: 5pt, y: 10pt),
// 			radius: 4pt,
// 			breakable: true,
// 			// breakable: false,
// 			width: 100%,
// 		)[
// 			#set align(left)
// 			#set par(justify:false)
// 			#if linenos {
// 				let lines-content = raw(range(lines).map(i => str(i + 1)).join("\n"))
// 				let lines-width = measure(lines-content, styles).width

// 				// place(top+left, dx:lines-width+gutter, dy:-2pt,
// 				// 	block(width: 100% - lines-width - gutter, breakable:true,
// 				// 		raw(lang:lang, block:true,
// 				// 			code-lines.join("\n")
// 				// 		)
// 				// 	)
// 				// )
// 				grid(
// 					columns: (lines-width, 100% - lines-width - gutter),
// 					column-gutter: gutter,
// 					row-gutter: 0.51em,
// 					// align(right, text(fill:lines-color,
// 					// 	lines-content
// 					// )),
// 					// raw(lang:lang, block:true,
// 					// 	code-lines.join("\n")
// 					// )
// 					..grid-cont
// 				)
// 			} else {
// 				raw(lang:lang, block:true,
// 					code-lines.join("\n")
// 				)
// 			}
// 		]
// 	})
// }


#let build-imports( imports ) = {
	let import-code = ""
	for (pkg, scope) in imports {
		if scope != "" {
			import-code += "#import \"" + pkg + "\": " + scope + "\n"
		} else {
			import-code += "#import \"" + pkg + "\"\n"
		}
	}
	return import-code
}
#let example(
	side-by-side: false,
	imports:(:),
	example-code,
	..args
) = {
	if args.named() != (:) {
		panic("unexpected argument: " + args.named().keys().first())
	}
	if args.pos().len() > 1 {
		panic("unexpected argument")
	}

	let code = example-code
	if code.func() != raw {
		code = example-code.children.filter(i=>i.func() == raw).first()
	}
	// let cont = (raw(lang:"typc", code.text),)
	let cont = (
		sourcecode(raw(lang:"typc", code.text)),
	)
	if not side-by-side {
		cont.push(line(length:100%, stroke:.5pt+black))
	}

	if args.pos() != () {
		cont.push(args.pos().first())
	} else {
		cont.push(eval("[" + build-imports(imports) + code.text + "]"))
	}

	block(
		stroke: .75pt+colors.primary,
		radius: 4pt,
		inset: 3mm,
		width: 100%,
		grid(
			columns: if side-by-side {(1fr,1fr)} else {(1fr,)},
			gutter: 5mm,
			..cont
		)
	)
}
