//#import "@local/typopts:0.0.3": options
#import "../typopts-0.0.3/options.typ"

#import "./mty.typ"

#let colors = (
	primary:   rgb(166, 9, 18),
	secondary: rgb(5, 10, 122),
	argument:  rgb(220, 53, 69),
	option:    rgb(214, 182, 93),
	value:     rgb(11, 113, 20),
	command:   rgb(153, 64, 39),
	comment:   rgb(128, 128, 128),

	info: rgb(23, 162, 184),
	warning: rgb(255, 193, 7),
	error: rgb(220, 53, 69),
	success: rgb(40, 167, 69),
)

#let titlepage(
  name,            // string
  title:    none,  // string|content
  subtitle: none,  // string|content
  info:     none,  // string|content
  authors:  none,  // string|array[string]|array[dict[string, string]]
  url:      none,  // string
  version:  none,  // string
  date:     none,  // string|datetime
  abstract: none   // string|content
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

#let mantys( ..args, body ) = {
	if not "name" in args.named() {
		panic("You need to specifiy the package name.")
	}

	let name = args.named().name
	options.update("name", name, ns:"mty")

	set text(size: 12pt, lang:"en", region:"EN")
	set par(justify:true, /*first-line-indent: 1em, hanging-indent: -1em*/)
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

	titlepage(args.named().at("name"), ..options.extract(args, title:none, subtitle:none, info:none, authors:none, url:none, version:none, date:none, abstract:[]))

	// Some common replacements
	show mty.ufirst(name): mty.package(name)
	show "Mantys": it => mty.package(it)
	show "Typst": it => smallcaps(strong(it))

	body
}

#let __value( value ) = {
	let t = type(value)
	// if t in ("boolean","angle","length") {
	// 	return [#value]
	// } else if t == "string" {
	// 	return mty.rawi(sym.quote.double) + mty.rawc(colors.value, value) + mty.rawi(sym.quote.double)
	// } else {
	// 	return mty.rawc(colors.value, repr(value))
	// }
	if t == "string" {
		return mty.rawi(sym.quote.double) + mty.rawc(colors.value, value) + mty.rawi(sym.quote.double)
	} else {
		return mty.rawc(colors.value, repr(value))
	}
	// return [#value]
}

#let name = mty.package(options.display("name", ns:"mty"))
#let pkg = mty.package
#let module = mty.module

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

#let value = __value

#let dtype( t, fnote:false, parse-type:false ) = {
	if parse-type or type(t) != "string" {
		t = type(t)
	}

	if t.contains("=>") {
		doc("types/function", name:t, fnote:fnote)
	} else if t == "location" {
		doc("meta/locate", name:"location", fnote:fnote)
	} else if t == "dict" {
		doc("types/dictionary", name:"dict", fnote:fnote)
	} else if t == "arr" {
		doc("types/array", name:"arr", fnote:fnote)
	} else {
		doc("types/" + t, fnote:fnote)
	}
}

#let def( val ) = underline(value(val), offset:0.2em, stroke:1pt+colors.value)

#let dtypes( ..types ) = {
	types.pos().map(dtype.with(fnote:false)).join("|")
}

#let choices( default: "__none__", ..values ) = {
	let list = values.pos().map(__value)
	if default != "__none__" {
		if default in values.pos() {
			let pos = values.pos().position(v => v == default)
			list.at(pos) = def(default)
		} else {
			list.insert(0, def(default))
		}
	}
	list.join("|")
}

// #let arg(..args) = {
// 	text(fill:colors.argument, mty.rawi(args.pos().at(0)))
// 	if args.pos().len() > 1 {
// 		mty.rawi(sym.colon + " ")
// 		__value(args.pos().at(1))
// 	}
// }

//#let meta( name ) = emph({sym.angle.l + name + sym.angle.r})
#let meta( name ) = mty.rawc(colors.argument, name)

#let opt( name ) = mty.rawc(colors.option, name)

#let arg(..args) = {
	if args.pos().len() > 0 {
		let name = args.pos().first()
		if type(name) == "content" {
			if type(name) != "string" {
				if name.has("text") {
					name = name.text
				} else {
					name = repr(name)
				}
			}
			mty.rawi(sym.bracket.l)
			meta(name)
			mty.rawi(sym.bracket.r)
		} else {
			meta(args.pos().first())
		}
	} else {
		meta(args.named().keys().first())
		mty.rawi(sym.colon + " ")
		__value(args.named().values().first())
	}
}

#let sink( name ) = arg(".." + mty.txt(name))

#let cmd(name, ..args) = {
	mty.rawi(sym.hash)
	mty.rawc(colors.command, mty.txt(name))
	mty.rawi(sym.paren.l)
	args.pos().filter(v => type(v)=="string").map(arg).join(`, `)
	if args.named().len() > 0 {
		if args.pos().filter(v => type(v)=="string").len() > 0 {
			mty.rawi(", ")
		}
		args.named().pairs().map(v => {
			let x = (:)
			x.insert(v.at(0), v.at(1))
			return arg(..x)
		}).join(`, `)
	}
	mty.rawi(sym.paren.r)
	args.pos().filter(v => type(v)=="content").map(arg).join()
}

#let var( name ) = {
	mty.rawi(sym.hash)
	mty.rawc(colors.command, name)
}


#let command(name, ..args, body ) = [
	#set terms(hanging-indent: 0pt)
	#set par(first-line-indent:0.65pt, hanging-indent: 0pt)
	/ #cmd(name, ..args.pos(), ..args.named() ): #block(inset:(left:2em), body)
	// #set terms(hanging-indent: 1.2em, separator: [\ ])
	// #set par(first-line-indent: 1.2em, hanging-indent: 1.2em)
	// / #cmd(name, ..args.pos(), ..args.named() ): #body
]

#let argument(
	argument,
	is-sink:false,
	type:none,
	choices:none,
	default:"__none__",
	body
) = block(width:100%, inset:(left:1em), grid(
	columns: (auto, 1fr, auto),
	gutter: 10pt,
	if is-sink { sink(argument) } else { if default != "__none__" {arg(..mty.kv(argument, default))}  else {arg(argument)}},
	par(hanging-indent: 0pt, body),
	if mty.type(type) == "array" { dtypes(..type) } else { dtype(type) }
))
// [
	// / #arg(..args.pos(), ..args.named()): #body
	// #place(right, type)#if default != "__none__" {
	// 	let x = (:)
	// 	x.insert(argument, default)
	// 	arg(..x)
	// } else {arg(argument)}: #body \
// ]

#let example(side-by-side: false, code1, code2) = {
	let code = code1.children.filter(i=>i.func() == raw).first()
	let cont = (raw(lang:"typc", code.text),)
	if not side-by-side {
		cont.push(line(length:100%, stroke:.5pt+black))
	}
	cont.push(code2)


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

#let sourcecode( title: none, file: none, sourcecode ) = {
	let head = block()
	if title != none {
		head = block(
			stroke: .75pt+colors.primary,
			radius: (top:4pt),
			width: 100% + 6mm,
			inset: 2mm,
			fill: colors.primary,
			text(fill:white, title)
		)
	}

	style(styles => {
		let m = (height:0pt)
		if title != none {
			m = measure([title], styles)
			m.height += 4mm
		}

		block(
			stroke: .75pt+colors.primary,
			radius: 4pt,
			inset: (top:m.height + 3mm, left: 3mm, bottom: 3mm, right: 3mm),
			width: 100%,
			place(top+left, dy:-m.height - 3mm, dx:-3mm, head) + sourcecode
		)
	})
}

#let shell( title:"shell", sourcecode ) = {
	let header = block(
		width: 100% + 6mm,
		inset: 2mm,
		fill: colors.comment,
		text(fill:white, weight:600, mty.rawi(title))
	)

	style(styles => {
		let m = measure(header, styles)

		block(
			stroke: .75pt+black,
			fill: luma(42),
			inset: (top:m.height + 3mm, left: 3mm, bottom: 3mm, right: 3mm),
			width: 100%,
			{
				place(top+left, dy:-m.height - 3mm, dx:-3mm, header)
				set text(fill:rgb(0,255,36))
				sourcecode
			}
		)
	})
}

#let ibox = mty.alert.with(color:colors.info)
#let wbox = mty.alert.with(color:colors.warning)
#let ebox = mty.alert.with(color:colors.error)
#let sbox = mty.alert.with(color:colors.success)
