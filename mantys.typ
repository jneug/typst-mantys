#import "./mty.typ"

#let colors = mty.colors

#let titlepage(
  name,        // string
  title,       // string|content
  subtitle,    // string|content
  info,        // string|content
  authors,     // string|array[string]|array[dict[string, string]]
  url,         // string
  version,     // string
  date,        // string|datetime
  abstract     // string|content
) = [
	#set align(center)
	#set block(spacing: 2em)

	#block(text(fill:colors.primary, size:2.5em,
		if title != none [ #title ] else [ #name ]
	))
	#if subtitle != none {
		block(subtitle)
	}

	#block(text(size:1.1em, [v#version #h(4em) #mty.date(date)]))

	#if info != none {
		block(info)
	}

	#block(if type(authors) == "array" {
		authors.map(a => mty.author(a)).join([\ ])
	} else {
		mty.name(authors)
	})
	#if url != none {
		block(link(url))
	}

	#if abstract != none {
		block(width:75%)[
			#set align(left)
			#set par(first-line-indent: .65em, hanging-indent: 0pt)
			#set block(spacing: 0.65em)
			#abstract
		]
	}

	#set align(left)
	#set block(spacing: 0.65em)
	#show outline.entry.where(level: 1): it => {
		v(0.85em, weak:true)
		strong(it.body)
	}
	#text(size:1.4em, [*Table of contents*])
	#columns(2, outline(
		title: none,
		indent: auto
	))

	#pagebreak()
]

#let mantys(
	name:	   none,
	title:     none,
	subtitle:  none,
	info:      none,
	authors:   (),
	url:       none,
	version:   none,
	date:      none,
	abstract:  [],

	titlepage: titlepage,

	example-imports: (:),

	..args,

	body
) = {
	if "name" == none {
		panic("You need to specifiy the package name.")
	}

	set document(
		title: if title != none { mty.txt(title) } else { mty.txt(name) },
		author: authors
	)

	set page(
		paper: "a4",
		margin: auto,
		header: locate(loc => {
			let elems = query(
				heading.where(level:2).before(loc),
				loc,
			)
			if elems != () {
				let elem = elems.last()
				h(1fr) + emph(counter(heading).at(loc).map(str).join(".") + h(.75em) + elem.body) + h(1fr)
			}
		}),
		footer: [
			#h(1fr)
			#counter(page).display("1")
			#h(1fr)
		]
	)
	set text(
		size: 12pt,
		lang:"en",
		region:"EN"
	)
	set par(
		justify:true,
		// first-line-indent: 1em,
		// hanging-indent: -1em
	)
	//show par: set block(spacing: 0.65em)
	set heading(numbering: "I.1.")
	show heading: it => block([
		#v(0.3em)
		#text(fill:colors.primary, counter(heading).display())
		#it.body
		#v(0.8em)
	])
	show heading.where(level: 1): it => {
		pagebreak(weak: true)
		block([
			#text(fill:colors.primary,
			[Part #counter(heading).display()])\
			#it.body
			#v(1em)
		])
	}
	show heading: it => {
		set text(font:("Liberation Sans"))
		it
	}

	// show raw.where(block:true, lang:"example"): it => mty.example(imports:example-imports, it)
	// show raw.where(block:true, lang:"side-by-side"): it => mty.example(side-by-side:true, imports:example-imports, it)
	state("@mty-example-imports").update(example-imports)

	titlepage(name, title, subtitle, info, authors, url, version, date, abstract)

	// Some common replacements
	show upper(name): mty.package(name)
	show "Mantys": mty.package
	show "Typst": it => smallcaps(strong(it))

	body

	[= Index]
	mty.make-index()
}

#let pkg = mty.package
#let module = mty.module
#let idx = mty.idx
#let make-index = mty.make-index

#let doc( target, name:none, fnote:false ) = {
	if name == none {
		name = target.split("/").last()
	}
	let url  = "https://typst.app/docs/reference/" + target

	link(url, mty.rawi(name))
	if fnote {
		footnote(link(url))
	}
}

#let value = mty.value

// Parse function spec into datatypes
#let func( spec ) = {

}

#let dtype( t, fnote:false, parse-type:false ) = {
	if parse-type or type(t) != "string" {
		t = type(t)
	}

	let d = none
	if t.contains("=>") {
		d = doc("types/function", name:t, fnote:fnote)
		t = "function"
	} else if t == "location" {
		d = doc("meta/locate", name:"location", fnote:fnote)
	} else if t == "any" {
		d = doc("types", name:"any", fnote:fnote)
	} else if t == "dict" {
		t = "dictionary"
		d = doc("types/dictionary", name:"dictionary", fnote:fnote)
	} else if t == "arr" {
		t = "array"
		d = doc("types/array", name:"array", fnote:fnote)
	} else if t == "regular experssion" {
		d = doc("construct/regex", name:"regular expression", fnote:fnote)
	} else if t.ends-with("alignment") {
		d = doc("layout/align/#parameters-alignment", name:t, fnote:fnote)
	} else {
		d = doc("types/" + t, fnote:fnote)
	}

	if t == "color" {
		for i in range(5) {
			let ins = (x:2pt, y:0pt)
			let rad = 0pt
			if i == 0 {
				ins = (left:3pt, right:2pt, y:0pt)
				rad = (left:2pt)
			} else if i == 4 {
				ins = (right:3pt, left:2pt, y:0pt)
				rad = (right:2pt)
			}

			box(fill:colors.dtypes.color.at(i), radius:rad, inset:ins, outset:(y:2pt), "color".at(i))
		}
	} else if t in colors.dtypes {
		box(fill: colors.dtypes.at(t), radius:2pt, inset: (x: 4pt, y:0pt), outset:(y:2pt), d)
	} else {
		d
	}
}

#let dtypes( ..types, sep: box(inset:(left:1pt,right:1pt), sym.bar.v)) = {
	types.pos().map(dtype.with(fnote:false)).join(sep)
}

#let choices( default: "__none__", ..values ) = {
	let list = values.pos().map(mty.value)
	if default != "__none__" {
		if default in values.pos() {
			let pos = values.pos().position(v => v == default)
			list.at(pos) = mty.default(default)
		} else {
			list.insert(0, mty.default(default))
		}
	}
	[#list.join(box(inset:(left:1pt,right:1pt), sym.bar.v))<arg-choices>]
}

// #let meta( name ) = mty.rawc(colors.argument, {sym.angle.l + name + sym.angle.r})
#let meta = mty.rawc.with(colors.argument)

#let opt(name, index:true) = {
	if index {
		idx(kind:"option")[#mty.rawc(colors.option, name)]
	} else {
		mty.rawc(colors.option, name)
	}
}
#let opt- = opt.with(index:false)

#let arg(..args) = {
	let a = none
	if args.pos().len() == 1 {
		a = meta(mty.txt(args.pos().first()))
	} else if args.named() != (:) {
		a = {
			meta(args.named().keys().first())
			mty.rawi(sym.colon + " ")
			mty.value(args.named().values().first())
		}
	} else  if args.pos().len() == 2 {
		a = {
			meta(args.pos().first())
			mty.rawi(sym.colon + " ")
			mty.value(args.pos().at(1))
		}
	} else {
		panic()
		return
	}
	[#a<arg>]
}

#let barg( name ) = {
	let b = {
		mty.rawi(sym.bracket.l)
		meta(mty.txt(name))
		mty.rawi(sym.bracket.r)
	}
	[#b<arg-body>]
}

#let sarg( name ) = {
	let s = meta(".." + mty.txt(name))
	[#s<arg-sink>]

}

#let args( ..args ) = {
	let arguments = args.pos().filter(mty.is-string).map(arg)
	arguments += args.pos().filter(mty.is-content).map(barg)
	arguments += args.named().pairs().map(v => arg(v.at(0), v.at(1)))
	arguments
}

#let cmd(name, module:none, ret:none, index:true, unpack:false, ..args) = {
	if module != none {
		// mty.module(module)
		// mty.rawi(".")
		mty.marginnote[
			#mty.module(module)
			#sym.quote.angle.r.double
		]
	}
	if index {
		idx(kind:"cmd")[#mty.rawi(sym.hash)#mty.rawc(colors.command, name)]
	} else {
		mty.rawi(sym.hash)
		mty.rawc(colors.command, name)
	}

	let sep = `, `
	if unpack and args.pos().len() + args.named().len() > 5 {
		sep = [`,`\ #h(1em)]
	}

	mty.rawi(sym.paren.l)
	args.pos().filter(mty.not-is-body).join(sep)
	mty.rawi(sym.paren.r)
	args.pos().filter(mty.is-body).join()
	if ret != none {
		box(inset:(x:2pt), mty.rawi("->"))
		dtype(ret)
	}
}
#let cmd- = cmd.with(index:false)

#let var( name ) = {
	mty.rawi(sym.hash)
	mty.rawc(colors.command, name)
}
#let var-( name ) = {
	mty.rawi(sym.hash)
	mty.rawc(colors.command, name)
}


#let command(name, ..args, body) = [
	#set terms(hanging-indent: 0pt)
	#set par(first-line-indent:0.65pt, hanging-indent: 0pt)
	/ #cmd(name, unpack:false, ..args.pos(), ..args.named() )<cmd>: #block(inset:(left:2em), body)#label("cmd-"+name)
	// #set terms(hanging-indent: 1.2em, separator: [\ ])
	// #set par(first-line-indent: 1.2em, hanging-indent: 1.2em)
	// / #cmd(name, ..args.pos(), ..args.named() ): #body
]

#let variable( name, types:none, value:none, body ) = [
	#set terms(hanging-indent: 0pt)
	#set par(first-line-indent:0.65pt, hanging-indent: 0pt)
	/ #var(name)#{if value != none {" " + sym.colon + " " + mty.value(value)}}#{if types != none {h(1fr) + dtypes(..types)}}<var>: #block(inset:(left:2em), body)#label("var-"+name)
]

#let argument(
	argument,
	is-sink:false,
	type:none,
	choices:none,
	default:"__none__",
	body
) = block(width:100%, inset:(left:-1em), grid(
	columns: (auto, 1fr, auto),
	gutter: 10pt,
	if is-sink { sarg(argument) } else { if default != "__none__" {arg(..mty.kv(argument, default))}  else {arg(argument)}},
	par(hanging-indent: 0pt, body),
	if type == none and default != "__none__" {
		dtype(default)
	} else if mty.type(type) == "array" {
		dtypes(..type)
	} else {
		dtype(type)
	}
))

#let module-commands(module, body) = [
	#let add-module = (c) => {
		mty.marginnote[
			#mty.module(module)
			#sym.quote.angle.r.double
		]
		c
	}
	#show <cmd>: add-module
	#show <var>: add-module
	#body
]

#let cmd-selector(name) = selector(<cmd>).before(label("cmd-"+name))

#let refcmd(name, format: (name, loc) => [command #cmd(name) on #link(loc)[page #loc.page()]]) = locate(loc => {
	let res = query(cmd-selector(name), loc)
	if res == () {
		panic("No label <cmd-" + name + "> found.")
	} else {
		let e = res.last()
		format(name, e.location())
	}
})
#let refrel( label ) = locate(loc => {
	if query(selector(label).before(loc), loc) != () {
		[above]
	} else if query(selector(label).after(loc), loc) != () {
		[below]
	} else {
		panic("No label " + str(label) + " found.")
	}
})


#let example(..args) = locate(loc => {
	let imports = state("@mty-example-imports").at(loc)
	mty.example(imports: imports, ..args)
})
#let side-by-side = example.with(side-by-side:true)
#let quickex( code ) = locate(loc => {
	let imports = state("@mty-example-imports").at(loc)
	[#raw(code.text, lang:"typc") #sym.arrow.r #eval("[" + mty.build-imports(imports) + code.text + "]")]
})

#let sourcecode( title: none, file: none, ..args, code ) = {
	let header = ()
	if title != none {
		header.push(text(fill:white, title))
	}
	if file != none {
		header.push(h(1fr))
		header.push(text(fill:white, emoji.folder) + " ")
		header.push(text(fill:white, emph(file)))
	}

	mty.frame(
		header: header.join(),
		mty.sourcecode(..args, code)
	)
}

#let ibox = mty.alert.with(color:colors.info)
#let wbox = mty.alert.with(color:colors.warning)
#let ebox = mty.alert.with(color:colors.error)
#let sbox = mty.alert.with(color:colors.success)
