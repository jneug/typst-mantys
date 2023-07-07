#let colors = (
	primary:   rgb(35, 157, 172),
	secondary: rgb(18, 120, 133),
	argument:  rgb(0, 24, 69),
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
		fraction: rgb(230, 218, 255),
		"relative length": rgb(230, 218, 255),
		"none": rgb(255, 203, 195),
		"auto": rgb(255, 203, 195),
		"any": rgb(255, 203, 195),
		dictionary: rgb(239, 240, 243),
		array: rgb(239, 240, 243),
		stroke: rgb(239, 240, 243),
		location: rgb(239, 240, 243),
		alignement: rgb(239, 240, 243),
		"2d alignement": rgb(239, 240, 243),
		boolean: rgb(255, 236, 193),
		content: rgb(166, 235, 229),
		string: rgb(209, 255, 226),
		function: rgb(249, 223, 255)
	)
)

// #################################
// # Some common utility functions #
// #################################

// Backup type function to use "type" as an argument.
#let type = type

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
#let rawi(code) = raw(block: false, txt(code))
// Colored inline raw text
#let rawc(color, code) = text(fill:color, rawi(code))

// A centered block
#let cblock(width:90%, ..args, body) = block(
	width: 100%,
	inset: (left:(100%-width)/2, right:(100%-width)/2),
	block(width:100%, ..args, body)
)

// A box to highlight content
#let box(
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

// Version numebers
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
		return [#name(info.name) <#link("mailto:" + info.email)>]
		// return [#info.name#footnote[#info.email]]
	} else {
		return name(info.name)
	}
}

#let date( d ) = {
	if type(d) == "datetime" {
		d.display()
	} else {
		d
	}
}

#let primary = text.with(fill:colors.primary)
#let secondary = text.with(fill:colors.secondary)

#let package( name ) = primary(smallcaps(name))
#let module( name ) = secondary(rawi(name))


#let value( value ) = {
	let t = type(value)
	// if t in ("boolean","angle","length") {
	// 	return [#value]
	// } else if t == "string" {
	// 	return mty.rawi(sym.quote.double) + mty.rawc(colors.value, value) + mty.rawi(sym.quote.double)
	// } else {
	// 	return mty.rawc(colors.value, repr(value))
	// }
	if t == "string" {
		if value.contains("=>") {
			return rawc(colors.value, value)
		} else {
			return rawi(sym.quote.double) + rawc(colors.value, value) + rawi(sym.quote.double)
		}
	} else {
		return rawc(colors.value, repr(value))
	}
	// return [#value]
}


#let code(
	fill: white,
	border: none,

	tab-indent: 4,
	gobble: auto,

	linenos: true,
	gutter: 10pt,

	body
) = {
	let lines = 0
	let lang = none
	let code-lines = ()

	for item in body.children {
		if item.func() == raw {
			code-lines = item.text.split("\n")
			lines = code-lines.len()
			lang = item.lang


			if gobble == auto {
				gobble = code-lines.fold(100, (v, line) => {
					return calc.min(v, __count_tabs(line, default:v))
				})
			}

			for i in range(lines) {
				code-lines.at(i) = __tabs(code-lines.at(i), spaces:tab-indent, gobble:gobble)
			}
		}
	}

	style(styles => {
		block(
			fill:fill,
			stroke: border,
			inset: (x: 5pt, y: 10pt),
			radius: 4pt,
			breakable: true,
			width: 100%,
		)[
			#set align(left)
			#set par(justify:false)
			#if linenos {
				let lines-content = raw(range(lines).map(i => str(i + 1)).join("\n"))
				let lines-width = measure(lines-content, styles).width

				grid(
					columns: (lines-width, 100% - lines-width - gutter),
					column-gutter: gutter,
					align(right, text(fill:theme.muted,
						lines-content
					)),
					raw(lang:lang, block:true,
						code-lines.join("\n")
					)
				)
			} else {
				raw(lang:lang, block:true,
					code-lines.join("\n")
				)
			}
		]
	})
}
