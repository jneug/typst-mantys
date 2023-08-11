#import "./mty.typ"
#import "./theme.typ"

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

#let dtype( t, fnote:false, parse-type:false ) = {
  if mty.not-is-func(t) and mty.not-is-lambda(t) {
    if parse-type or type(t) != "string" {
      t = type(t)
    }
  }

	let d = none
  if mty.is-func(t) {
    d = doc("types/function", fnote:fnote)
		t = "function"
  } else if mty.is-lambda(t) or t.contains("=>") {
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

			box(fill:theme.colors.dtypes.color.at(i), radius:rad, inset:ins, outset:(y:2pt), "color".at(i))
		}
	} else if t in theme.colors.dtypes {
		box(fill: theme.colors.dtypes.at(t), radius:2pt, inset: (x: 4pt, y:0pt), outset:(y:2pt), d)
	} else {
		d
	}
}

// #let meta( name ) = mty.mty.rawc(theme.colors.argument, {sym.angle.l + name + sym.angle.r})
#let meta = mty.rawc.with(theme.colors.argument)

#let mty-show-values = false
#let arg(..args) = {
	let a = none
	if args.pos().len() == 1 {
		a = meta(mty.get.text(args.pos().first()))
	} else if args.named() != (:) {
		a = {
			meta(args.named().keys().first())
			mty.rawi(sym.colon + " ")
      mty.value(args.named().values().first())
		}
	} else if args.pos().len() == 2 {
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
		meta(mty.mty.get.text(name))
		mty.rawi(sym.bracket.r)
	}
	[#b<arg-body>]
}

#let sarg( name ) = {
	let s = meta(".." + mty.get.text(name))
	[#s<arg-sink>]
}

#let cmd(name, module:none, ret:none, index:true, unpack:false, ..args) = {
  if index {
    mty.idx(kind:"cmd", hide:true)[#mty.rawi(sym.hash)#mty.rawc(theme.colors.command, name)]
  }

  mty.rawi(sym.hash)
  if mty.is.not-none(module) {
    module(module)
  } else {
    // raw("", lang:"cmd-module")
    mty.place-marker("cmd-module")
  }
  mty.rawc(theme.colors.command, name)

  let fargs = args.pos().filter(mty.not-is-body)
  let bargs = args.pos().filter(mty.is-body)

	if unpack == true or (unpack == auto and fargs.len() >= 5) {
    mty.rawi(sym.paren.l) + [\ #h(1em)]
    fargs.join([`,`\ #h(1em)])
    [\ ] + mty.rawi(sym.paren.r)
	} else {
    mty.rawi(sym.paren.l)
    fargs.join(`, `)
    mty.rawi(sym.paren.r)
  }
	bargs.join()
	if ret != none {
		box(inset:(x:2pt), sym.arrow.r)//mty.rawi("->"))
		dtype(ret)
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

#let opt(name, index:true) = {
	if index {
		mty.idx(kind:"option")[#mty.rawc(theme.colors.option, name)]
	} else {
		mty.rawc(theme.colors.option, name)
	}
}
#let opt- = opt.with(index:false)

#let args( ..args ) = {
	let arguments = args.pos().filter(is.str).map(arg)
	arguments += args.pos().filter(is.content).map(barg)
	arguments += args.named().pairs().map(v => arg(v.at(0), v.at(1)))
	arguments
}

#let content( name ) = {
  mty.mark-lambda( "" + name )
}

#let symbol( name, module: none ) = {
  let full-name = if mty.is.not-none(module) {
    mty.module(module) + `.` + mty.rawi(name)
  } else {
    mty.rawc(theme.colors.command, name)
  }
  mty.mark-lambda(full-name)
}

#let func( name, module: none ) = {
  if type(name) == "function" {
    name = repr(name)
  }
  let full-name = if mty.is.not-none(module) {
    mty.module(module) + `.` + mty.rawc(theme.colors.command, name)
  } else {
    mty.rawc(theme.colors.command, name)
  }
  mty.mark-func(emph(mty.rawi(sym.hash) + full-name))
}

#let lambda( ..args, ret:none  ) = {
  args = args.pos().map(type)
  if is.arr(ret) and ret.len() > 0 {
    ret = sym.paren.l + ret.map(type).join(",") + if ret.len() == 1 {","} + sym.paren.r
  } else if is.dict(ret) and ret.len() > 0 {
    ret = sym.paren.l + ret.pairs().map(pair => {sym.quote + pair.first() + sym.quote + sym.colon + type(pair.last())}).join(",") + sym.paren.r
  } else {
    ret = type(ret)
  }
  mty.mark-lambda(sym.paren.l + args.join(",") + sym.paren.r + " => " + ret )
}


#let cmd- = cmd.with(index:false)

#let var( name ) = {
	mty.rawi(sym.hash)
	mty.rawc(theme.colors.command, name)
}
#let var-( name ) = {
	mty.rawi(sym.hash)
	mty.rawc(theme.colors.command, name)
}


#let __s_mty_command = state("@mty-command", none)

#let command(name, ..args, body) = [
  #__s_mty_command.update(name)
  #block(
    below: 0.65em,
    above: 1.3em,
    text(weight:600)[#cmd(name, unpack:auto, ..args.pos(), ..args.named() )<cmd>]
  )
  #block(inset:(left:1em), spacing: 0pt, breakable:true, body)#label("cmd-"+name+"()")
  #__s_mty_command.update(none)
  // #v(.65em, weak:true)
]

#let variable( name, types:none, value:none, body ) = [
	#set terms(hanging-indent: 0pt)
	#set par(first-line-indent:0.65pt, hanging-indent: 0pt)
	/ #var(name)#{if value != none {" " + sym.colon + " " + mty.value(value)}}#{if types != none {h(1fr) + dtypes(..types)}}<var>: #block(inset:(left:2em), body)#label("var-"+name)
]

#let argument(
	name,
	is-sink: false,
  // {deprecated}
  type: none,
	types: none,
	choices: none,
	default: "__none__",
	body
) = {
  types = mty.def.if-none(type, types)

  v(.65em)
  block(
    above: .65em,
    stroke:.75pt + theme.colors.muted,
    inset: (top:10pt, left: -1em + 8pt, rest:8pt),
    outset: (left: 1em),
    radius: 2pt, {
    place(top+left, dy: -15.5pt, dx: 5.75pt,
      box(inset:2pt, fill:white,
        text(size:.75em, font:theme.fonts.sans, theme.colors.muted, "Argument")
      )
    )
    if is-sink {
      sarg(name)
    } else if default != "__none__" {
      arg(..mty.get.dict(name, default))
    }  else {
      arg(name)
    }
    h(1fr)
    dtype(if mty.is.not-none(types) { type } else if default != "__none__" { default })
    block(width:100%, below: .65em, inset:(x:.75em), body)
  })
}

#let module-commands(module, body) = [
	// #let add-module = (c) => {
	// 	mty.marginnote[
	// 		#mty.module(module)
	// 		#sym.quote.angle.r.double
	// 	]
	// 	c
	// }
	// #show <cmd>: add-module
	// #show <var>: add-module
  // #show raw.where(lang:"cmd-module"): (it) => mty.module(module) + mty.rawi(sym.dot.basic)
  #show <cmd>: (it) => {
    show mty.marker("cmd-module"): (it) => {
      mty.module(module) + mty.rawi(sym.dot.basic)
    }
    it
  }
	#body
]

#let cmd-selector(name) = selector(<cmd>).before(label("cmd-"+name))

#let cmdref(name, format: (name, loc) => [command #cmd(name) on #link(loc)[page #loc.page()]]) = locate(loc => {
	let res = query(cmd-selector(name), loc)
	if res == () {
		panic("No label <cmd-" + name + "> found.")
	} else {
		let e = res.last()
		format(name, e.location())
	}
})

#let relref( label ) = locate(loc => {
  let q = query(selector(label).before(loc), loc)
	if q != () {
		return link(q.last().location(), "above")
	} else {
    q = query(selector(label).after(loc), loc)
  }
  if q != () {
		return link(q.first().location(), "below")
	} else {
		panic("No label " + str(label) + " found.")
	}
})

#let update-example-imports( imports ) = {
  state("@mty-example-imports").update(example-imports)
}

#let example(..args) = state("@mty-example-imports").display(
  (imports) => mty.example(imports: imports, ..args)
)

#let side-by-side = example.with(side-by-side:true)

#let shortex( code, sep: sym.arrow.r ) = state("@mty-example-imports").display(
  (imports) => [#raw(code.text, lang:"typ") #sep #eval("[" + mty.build-imports(imports) + code.text + "]")]
)

#let sourcecode( title: none, file: none, ..args, code ) = {
	let header = ()
	if is.not-none(title) {
		header.push(text(fill:white, title))
	}
	if is.not-none(file) {
		header.push(h(1fr))
		header.push(text(fill:white, emoji.folder) + " ")
		header.push(text(fill:white, emph(file)))
	}

	mty.sourcecode(
    frame: mty.frame.with(title: if header == () { "" } else { header.join() }),
    ..args,
    code,
  )
}

#let codesnippet = mty.sourcecode.with(frame: mty.frame, numbering: none)

#let ibox = mty.alert.with(color:theme.colors.info, icon:emoji.bell)
#let wbox = mty.alert.with(color:theme.colors.warning, icon:emoji.warning)
#let ebox = mty.alert.with(color:theme.colors.error, icon:emoji.siren)
#let sbox = mty.alert.with(color:theme.colors.success, icon:"✓")

#let version( since:(), until:() ) = {
  if is.not-empty(since) or is.not-empty(until) {
    mty.marginnote(gutter: 1em, dy: 0pt, {
      set text(size:.8em)
      if is.not-empty(since) { [_since_ #text(theme.colors.secondary, mty.ver(..since))] }
      if is.not-empty(since) and is.not-empty(until) { linebreak() }
      if is.not-empty(until) { [until #text(theme.colors.secondary, mty.ver(..until))] }
    })
  }
}
