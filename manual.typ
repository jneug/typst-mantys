#import "mantys.typ": *

// Some fancy logos
// credits go to discord user @adriandelgado
#let TeX = style(styles => {
  set text(font: "New Computer Modern")
  let e = measure("E", styles)
  let T = "T"
  let E = text(1em, baseline: e.height * 0.31, "E")
  let X = "X"
  box(T + h(-0.15em) + E + h(-0.125em) + X)
})

#let LaTeX = style(styles => {
  set text(font: "New Computer Modern")
  let a-size = 0.66em
  let l = measure("L", styles)
  let a = measure(text(a-size, "A"), styles)
  let L = "L"
  let A = box(scale(x: 110%, text(a-size, baseline: a.height - l.height, "A")))
  box(L + h(-a.width * 0.67) + A + h(-a.width * 0.25) + TeX)
})

#let cnltx = package("CNLTX")

#let shell( title:"shell", sourcecode ) = {
	mty.frame(
		stroke-color: black,
		bg-color: luma(42),
		radius: 0pt,
		{
			set text(fill:rgb(0,255,36))
			sourcecode
		}
	)
}

#show: mantys.with(
	..toml("typst.toml"),

  title: "The Mantys Package",
	subtitle: [#strong[MAN]uals for #strong[TY]p#strong[S]t],
	date: datetime.today(),
	abstract: 	[
		#package[Mantys] is a Typst template to help package and template authors to write manuals. It provides functionality for consistent formatting of commands, variables, options and source code examples. The template automatically creates a table of contents and a commanc index for easy reference and navigation.

    The main idea and design was inspired by the #LaTeX package #cnltx by #mty.name[Clemens Niederberger].
	],

	// example-imports: ("@local/mantys:0.0.3": "*"),
  examples-scope: (
    mty: mty,
    ..api.__all__
  )
)

= About

Mantys is a Typst package to help package and template authors to write consistently formatted manuals. The idea is that, as many Typst users are switching over from #TeX, they are used to the way packages provide a PDF manual for reference. Though in a modern ecosystem there are other ways to write documentation (like #mty.footlink("https://rust-lang.github.io/mdBook/")[mdBook] or #mty.footlink("https://asciidoc.org")[AsciiDoc]), having a manual in PDF format might still be beneficial, since many users of Typst will generate PDFs as their main output.

The design and functionality of Mantys was inspired by the fantastic #LaTeX package #mty.footlink("https://ctan.org/pkg/cnltx")[#cnltx] by #mty.name[Clemens Niederberger]#footnote[#link("mailto:clemens@cnltx.de", "clemens@cnltx.de")].

#ebox[
  Note that this manual is currently out of date with the newest version of Mantys and will be updated soon.
]

This manual is supposed to be a complete reference of Mantys, but might be out of date for the most recent additions and changes. On the other hand, the source file of this document is a great example of the things Mantys can do. Other than that, refer to the README file in the GitHub repository and the source code for Mantys.

#wbox[
	Mantys is in active development and its functionality is subject to change. Until version #mty.ver(0,1,0) is reached, the command signatures and manual layout may change and break previous versions. Keep that in mind while using Mantys.

  Contributions to the package are very welcome!
]

= Usage

== Using Mantys

=== Loading as a package

Currently the package needs to be installed into the local package repository.

Either download the current release from GitHub#footnote[#link("https://github.com/jneug/typst-typopts/releases/latest")] and unpack the archive into your system dependent local repository folder#footnote(link("https://github.com/typst/packages#local-packages")) or clone it directly:

#codesnippet[```shell-unix-generic
git clone https://github.com/jneug/typst-mantys.git mantys-0.0.3
```]

After installing the package just import it inside your `typ` file:

#codesnippet[```typ
#import "@local/mantys:0.0.3": *
```]

=== Loading as a module

To load Mantys into a single project as a module download the necessary files and place them inside the project directory. The required files are `mantys.typ` and `mty.typ`.

Import the module into your manual file:

#codesnippet[```typ
#import "mantys.typ": *
```]

=== Initialising the template

After importing Mantys the template is initialized by applying a show rule with the #cmd[mantys] command passing the necessary options using `with`:
#codesnippet[```typ
#show: mantys.with(
	...
)
```]

#cmd-[mantys] takes a bunch of arguments to describe the documented package. These can also be loaded directly from the `typst.toml` file in the packages' root directory:
#codesnippet[```typ
#show: mantys.with(
	..toml("typst.toml"),
  ...
)
```]

#command("mantys", ..args(name:	none, title: none,
	subtitle: none,
	info: none,
	authors: (),
	url: none,
	repository: none,
	license: none,
	version: none,
	date: none,
	abstract: content("[]"),
	titlepage: func(titlepage),
	examples-scope: (:),
	[body]), sarg[args])[
		#argument("titlepage", default:func(titlepage))[
			A function that renders a titlepage for the manual. Refer to #cmdref("titlepage") for details.
		]
		#argument("examples-scope", default:(:))[
			Default scope for code examples.

			```typc
			examples-scope: (
			  cmd: mantys.cmd
			)
			```

			For further details refer to #cmdref("example").
		]

		All other arguments will be passed to #cmd-[titlepage].

		All uppercase occurences of #arg[name] will be highlighted as a packagename. For example #text(hyphenate:false, "MAN\u{2060}TYS") will appear as Mantys.
]

== Available commands

=== Describing arguments and values

#command("meta", arg[name], ret:"content")[
	Used to highlight argument names.
	#shortex(`#meta[variable]`)
]
#command("value", arg[variable], ret:"content")[
	Used to display the value of a variable. The command will highlight the value depending on the type.

	- #shortex(`#value[name]`)
	- #shortex(`#value("name")`)
	- #shortex(`#value((name: "value"))`)
	- #shortex(`#value(range(4))`)
]
#command("arg", arg[name], ret:"content")[
	Renders an argument, either positional or named. The argument name is highlighted with #cmd-[meta] and the value with #cmd-[value].

	- #shortex(`#arg[name]`)
	- #shortex(`#arg("name")`)
	- #shortex(`#arg(name: "value")`)
]
#command("sarg", arg[name], ret:"array")[
	Renders an argument sink.
	#shortex(`#sarg[args]`)
]
#command("barg", arg[name], ret:"content")[
	Renders a body argument.
	#shortex(`#barg[body]`)

	#ibox(width:100%)[Body arguments are positional arguments that can be given as a separat content block at the end of a command.]
]
#command("args", sarg[args], ret:"content")[
	Creates an array of all its arguments rendered either by #cmd-[arg] or #cmd-[barg]. All values of type #dtype("content") will be passed to #cmd-[barg] and everything else to #cmd-[arg].

	This command is intendend to be unpacked as the arguments to one of #cmd-[cmd] or #cmd-[command].

	#example[```
	#cmd("my-command", ..args("arg1", arg2: false, [body]))
	```]
]
#command("dtype", arg[t], arg(fnote: false), arg(parse-types: false), ret:"string")[
	Shows the (data-)type of #arg[t] and a link to the Typst documentation of that type.

	#arg(fnote: true) will show the reference link in a footnote (useful for print versions of the manual).

	The type is determined by passing #arg[t] to #doc("foundations/type").
	If #arg[t] is a string however, it is assumed to already be a type name. For example #value("fraction") will give the type #dtype("fraction"). Setting #arg(parse-types: true) will prevent this and always call `type` on #arg[t].

	- #shortex(`#dtype(false)`)
	- #shortex(`#dtype(1%)`)
	- #shortex(`#dtype(left)`)
	- #shortex(`#dtype([some content], fnote:true)`)
	- #shortex(`#dtype("dictionary")`)
	//- #shortex(`#dtype("dictionary", parse-types:true)`)
]
#command("dtypes", sarg[types], arg(sep:box(inset:(left:1pt,right:1pt), sym.bar.v)), ret:"content")[
	Will produce a list of types from the provided arguments. Each value is passed to #cmd-[dtype] and the results joined by #arg[sep].

	- #shortex(`#dtypes(false, 1cm, "array", [world])`)
	- #shortex(`#dtypes(false, 1cm, "array", [world], sep: " or ")`)
]
#command("choices", arg(default:"__none__"), sarg[values])[
	Creates a list of possible values for an argument.

	If #arg[default] is set to something else than #value("__none__"), the value is highlighted as the default choice. If #arg[default] is already given in #arg[values], the value is highlighted at its current position. Otherwise #arg[default] is added as the first choice in the list.

	- #shortex(`#choices(..range(5))`)
	- #shortex(`#choices(..range(5), default:3)`)
	- #shortex(`#choices(..range(5), default:5)`)
]
#command("func", arg[name])[
  Can be used as value for an argument to display a function (command) like `emph`. The name can be given as a name or as the function itself.

  - #shortex(`#arg(default: func(strong))`)
  - #shortex(`#arg(highlight: func("emph"))`)
  - #shortex(`#arg(titlepage: func("titlepage"))`)
]
#command("symbol", arg[name])[
  Can be used as value for an argument to display a Typst syntax symbol like `sym.arrow.r`.

  - #shortex(`#arg(default: symbol("sym.arrow.r"))`)
]
#command("lambda", sarg[args])[

]
#command("opt", arg[name], sarg[args], barg[body])[
	Renders the option #arg[name] and adds an entry to the index.

	- #shortex(`#opt[example-imports]`)
]
#command("opt-", arg[name], sarg[args], barg[body])[
	Same as #cmd[opt] but does not create an index entry.
]

=== Describing commands
#command("cmd", arg[name], sarg[args], barg[body])[
	Renders the command #arg[name] with arguments and creates an entry in the command index.

	#arg[args] is a collection of positional arguments created with #cmd[arg], #cmd[barg] and #cmd[sarg].

	All positional arguments will be rendered first, then named arguemnts and all body arguments will be added after the closing paranthesis.

	- #shortex(`#cmd("cmd", arg[name], sarg[args], barg[body])`)
	- #shortex(`#cmd("cmd", ..args("name", [body]), sarg[args])`)
]
#command("cmd-", arg[name], sarg[args], barg[body])[
	Same as #cmd[cmd] but does not create an index entry.
]
#command("var", arg[name], arg(default:none))[

]
#command("var-", arg[name], arg(default:none))[

]


#command("command", arg[name], sarg[args], barg[body])[
	Shows
]
#command("argument", "name", "type", default:"__none__")[

]
#command("variable", arg[name], sarg[args], barg[body])[

]

=== Source code and examples

Mantys provides several commands to handle source code snippets and show examples of functionality. The usual #doc("text/raw") command still works, but theses commands allow you to highlight code in different ways or add line numbers.

Typst code examples can be set with the #cmd[example] command. Simply give it a fenced code block with the example code and Mantys will render the code as highlighted Typst code and show the result underneath.

#example(raw("#example[
```
This will render as *content*.

Use any #emph[Typst] code here.
```
]"))

The result will be generated using #doc("foundations/eval") and thus is subject to its limitations. Each `eval` call is run in a local scope and does not have access to previously imported commands. To use your packages commands, you have to import it as a package:

#example(raw("#example[```
#import \"@local/mantys:0.0.3\": dtype

#dtype(false)
```]"))

#wbox[
	You can only import packages and not local files.
]

To automatically add imports to every example code, you can set the option #opt[example-imports] at the initial call to #cmd[mantys]. For example this manual was compiled with #arg(example-imports: ("@local/mantys:0.0.3": "*")). This imports the Mantys commands into all example code, without explicitly importing it in the code.

#example(raw("#example[```
#mty.value(false)
```]"))

See #relref(cmd-label("example")) for how to use the #cmd-[example] command.

#ibox[
	To use fenced code blocks in your example, add an extra backtick to the example code:

	#example(scope:("@local/mantys:0.0.3": "example"))[`````
    #example[````
      ```rust
      fn main() {
        println!(\"Hello World!\");
      }
      ```
    ````]
  `````]
]

#command("example", ..args(side-by-side: false, imports:(:), mode:"code", [example-code], [result]))[
	#argument("example-code", types:"content")[
		A block of #doc("text/raw") code representing the example Typst code.
	]
	#argument("side-by-side", default:false)[
		Usually, the #arg[example-code] is set above the #arg[result] separated by a line. Setting this to #value(true) will set the code on the left side and the result on the right.
	]
	#argument("scope", default:(:))[
		The scope to pass to #doc("foundations/eval").

    Examples will always import the #opt[examples-scope] set in the initial #cmd-[mantys] call. Passing this argument to an #cmd-[example] call will override those imports. If an example should explicitly run without imports, pass #arg(imports: (:)):
    #sourcecode[````typ
    #example[`I use #opt[examples-scope].`]

    #example(scope:(:))[```
    // This will fail: #opt[examples-scope]
    I can't use `#opt()`, because i don't use `examples-scope`.
    ```]
    ````]
	]
	#argument("mode", default:"code", choices:("code","markup", "math"))[
		The mode to evaluate the example in.
	]
	#argument("result", types:"content")[
		The result of the example code. Usually the same code as #arg[example-code] but without the `raw` markup. See #relref(<example-result-example>) for an example of using #barg[result].

		#wbox(width:100%)[#arg[result] is optional and will be omitted in most cases!]
	]

	Sets #barg[example-code] as a #doc("text/raw") block with #arg(lang: "typ") and the result of the code beneath. #barg[example-code] need to be `raw` code itself.

	#example[````
    #example[```
      *Some lorem ipsum:*\
      #lorem(40)
    ```]
	````]

	Setting #arg(side-by-side: true) will set the example on the left side and the result on the right and is useful for short code examples. The command #cmd-[side-by-side] exists as a shortcut.

	#example[````
    #example(side-by-side: true)[```
      *Some lorem ipsum:*\
      #lorem(20)
    ```]
	````]

	#barg[example-code] is passed to #cmd-[mty.sourcecode] for processing.

	If the example-code needs to be different than the code generating the result (for example, because automatic imports do not work or access to the global scope is required), #cmd-[example] accepts an optional second positional argument #barg[result]. If provided, #barg[example-code] is not evaluated and #barg[result] ist used instead.

	#example[````
    #example[```
      #value(range(4))
    ```][
      The value is: #mty.value(range(4))
    ]
	````]<example-result-example>
]

#command("side-by-side", ..args(scope: (:), mode: "code", [example-code], [result]) )[
	Shortcut for #cmd("example", arg(side-by-side: true)).
]

#command("sourcecode", ..args(title:none, file:none, [code]))[
	If provided, the #arg("title") and #arg("file") argument are set as a titlebar above the content.

	#argument("code", types:dtype("content"))[
		A #cmd[raw] block, that will be set inside a bordered block. The `raw` content is not modified and keeps its #arg("lang") attribute, if set.
	]
	#argument("title", types:dtype("string"), default:none)[
		A title to show above the code in a titlebar.
	]
	#argument("file", types:dtype("string"), default:none)[
		A filename to show above the code in a titlebar.
	]

	#cmd-[sourcecode] will render a #doc("text/raw") block with linenumbers and proper tab indentions using #package[codelst] and put it inside a #cmd-[mty.frame].

	If provided, the #arg("title") and #arg("file") argument are set as a titlebar above the content.

	#example(raw("#sourcecode(title:\"Some Rust code\", file:\"world.r\")[```rust
	fn main() {
		println!(\"Hello World!\");
	}
```]"))
]

#command("codesnippet", barg[code])[
	A short code snippet, that is shown without line numbers or title.

	#example[````
  #codesnippet[```shell-unix-generic
  git clone https://github.com/jneug/typst-mantys.git mantys-0.0.3
  ```]
  ````]
]

#command("shortex", ..args(sep: symbol("sym.arrow.r"), [code]))[
  Display a very short example to highlight the result of a single command. #arg[sep] changes the separator between code and result.

  #example[```
  - #shortex(`#emph[emphasis]`)
  - #shortex(`#strong[strong emphasis]`, sep:"::")
  - #shortex(`#smallcaps[Small Capitals]`, sep:sym.arrow.r.double.long)
  ```][
  - #shortex(`#emph[emphasis]`)
  - #shortex(`#strong[strong emphasis]`, sep:"::")
  - #shortex(`#smallcaps[Small Capitals]`, sep:sym.arrow.double.r)
  ]
]

=== Other commands

#command("package")[
	Shows a package name:

  - #shortex(`#package[tablex]`)
  - #shortex(`#mty.package[tablex]`)
]

#command("module")[
	Shows a module name:

  - #shortex(`#module[mty]`)
  - #shortex(`#mty.module[mty]`)
]

#command("doc", ..args("target", name:none, fnote:false))[
  Displays a link to the Typst reference documentation at #link("https://typst.app/docs"). The #arg[target] need to be a relative path to the reference url, like #value("text/raw"). #cmd-[doc] will create an appropriate link URL and cut everything before the last `/` from the link text.

  The text can be explicitly set with #arg[name]. For #(fnote: true) the documentation URL is displayed in an additional footnote.

  #example[```
  Remember that #doc("meta/query") requires a #doc("meta/locate", name:"location") obtained by #doc("meta/locate", fnote:true) to work.
  ```]

  #wbox[
    Footnote links are not yet reused if multiple links to the same reference URL are placed on the same page.
  ]
]

#command("command-selector", arg[name])[
  Creates a #doc("types/selector") for the specified command.

  #example[```
  // Find the page of a command.
  #let cmd-page( name ) = locate(loc => {
    let res = query(cmd-selector(name), loc)
    if res == () {
      panic("No command " + name + " found.")
    } else {
      return res.last().location().page()
    }
  })

  The #cmd-[mantys] command is documented on page #cmd-page("mantys").
  ```]
]

// #let pkg = mty.package
// #let module = mty.module
// #let idx = mty.idx
// #let make-index = mty.make-index

// #let doc( target, name:none, fnote:false ) = {

=== Templating and styling

#command("titlepage", ..args("name", "title", "subtitle", "info", "authors", "urls", "version", "date", "abstract", "license"))[
  The #cmd-[titlepage] command sets the default titlepage of a Mantys document.

  To implement a custom title page, create a function that takes the arguments shown above and pass it to #cmd[mantys] as #arg[titlepage]:
  #sourcecode[```typ
  #let my-custom-titlepage( ..args ) = [*My empty title*]

  #show: mantys.with(
    ..toml("typst.toml"),
    titlepage: my-custom-titlepage
  )
  ```]

  A #arg[titlepage] function gets passed the package information supplied to #cmd-[mantys] with minimal preprocessing. THe function has to check for #value(none) values for itself. The only argument with a guaranteed value is #arg[name].
]

=== Utilities

Most of MANTYS functionality is located in a module named #module[mty]. Only the main commands are exposed at a top level to keep the namespace polution as minimal as possible to prevent name collisons with commands belonging to the package / module to be documented.

The commands provide some helpful low-level functionality, that might be useful in some cases.
#variable("colors", types:("dictionary",))[
	#lorem(30)
]

#module-commands("mty")[
#command("type", arg[variable], ret:"string")[
	Alias for the buildin #doc("foundations/type") command.
]

#command("kv", ..args("key", "value"), ret:"dictionary")[
	#argument("key")[
		#lorem(10)
	]
	Creates a #dtype("dictionary") containing the given #arg[key]/#arg[value]-pair. Useful for using `map` on the pairs of a dictionary:
	```typc
	#let dict = (a: 1, b: 2, c: 3)
	dict.pairs().map(p => kv(..p)).map( ... )
	```
]
#command("txt", arg[variable], ret:"string")[
	Extracts the text content of #arg[variable] as a #dtype("string"). The command attempts to extract as much text as possible by looking at possible children of a content element.


]
#command("rawi", barg[code], arg(lang:none), ret:"content")[
	Inline #doc("text/raw") content with an optional language fpr highlighting.
]
#command("rawc", arg[color], barg[code], ret:"content")[
	Colored inline #doc("text/raw") content. This supports no language argument, since #arg[code] will have a uniform #arg[color].
]

#command("primary")[]
#command("secondary")[]

#command("cblock", arg(width:90%), barg[body], sarg[block-args], ret: "content")[
	Sets #arg[body] inside a centered #doc("layout/block") with the given #arg[width]. Any further arguments will be passed to the `block` command.
]
#command("box", barg[body], ..args(header:none, footer:none, invert-headers:true, stroke-color:theme.colors.primary, bg-color:white, width:100%, padding: 8pt, radius:4pt), ret: "content")[
	#lorem(100)
]
#command("alert", barg[body], ..args(color:blue, icon:none, title:none, width:90%, size:.9em), ret: "content")[
	#lorem(50)
]
#command("marginnote", ..args(pos: left, margin: .5em, dy: 0pt), barg[body], ret: "content")[
	#lorem(30)
]
#command("sourcecode", ..args(fill: white, border: none, tab-indent: 4, gobble: auto, linenos: true, gutter: 10pt,), barg[body], ret: "content")[
	#lorem(30)
]


#command("ver", ..args("major", "minor", "patch"), ret: "content")[
	#side-by-side[
		```
		#mty.ver(0, 0, 1)
		```
	][
		#mty.ver(0, 0, 1)
	]
]
#command("name", arg[name], arg(last:none), ret: "content")[

	```example
	- #mty.name("Jonas Neugebauer")
	- #mty.name("Jonas van Neugebauer")
	- #mty.name("Jonas van", last:"Neugebauer")
	- #mty.name("Jonas", last:"van Neugebauer")
	```
]
#command("author", arg[info], ret: "content")[
	```example
	- #mty.author("Jonas Neugebauer")
	- #mty.author(
		(name: "Jonas van Neugebauer")
	)
	- #mty.author((
		name: "Jonas van Neugebauer",
		email: "jonas@neugebauer.cc"
	))
	```
]
#command("date", arg[d], ret: "content")[
	#side-by-side(scope:("@local/mantys:0.0.3":"mty"))[
		```
		- #mty.date("2023-07-15")
		- #mty.date(datetime(year:2023, month:7, day:15))
		- #mty.date(datetime.today())
		- #mty.date(datetime.today(), format:"[day].[month].[year]")
		```
	]
]
#command("package", arg[name], ret:"content")[
	```side-by-side
	- #mty.package("Mantys")
	- #mty.package("typopts")
	```
]
#command("module", arg[name], ret:"content")[
	#side-by-side[
		```
		- #mty.module("mty")
		- #mty.module("emoji")
		```
	][
		- #mty.module("mty")
		- #mty.module("emoji")
	]
]


#command("value", arg[variable], ret:"content")[
	Returns the value of #arg[variable] as content.

	#side-by-side[
		```
		- #mty.value("string")
		- #mty.value([string])
		- #mty.value(true)
		- #mty.value(1.0)
		- #mty.value(3em)
		- #mty.value(50%)
		- #mty.value(left)
		- #mty.value((a: 1, b: 2))
		```
	][
		- #mty.value("string")
		- #mty.value([string])
		- #mty.value(true)
		- #mty.value(1.0)
		- #mty.value(3em)
		- #mty.value(50%)
		- #mty.value(left)
		- #mty.value((a: 1, b: 2))
	]
]
#command("default", arg[value], ret:"content")[
	Highlights the default value of a set of #cmd[choices]. By default the value is underlined.

	#side-by-side[
		```
		- #mty.default("default-value")
		- #mty.default(true)
		- #choices(1, 2, 3, 4, default: 3)
		```
	][
		- #mty.default("default-value")
		- #mty.default(true)
		- #choices(1, 2, 3, 4, default: 3)
	]
]

  ==== Argument filters

  These utility functions can be used to filter an array of content elements for those created with #cmd-[barg] or #cmd-[choices].

  #command("is-choices", arg[value])[
    Checks if #arg[value] is a choices value created with #cmd[choices].
  ]
  #command("is-body", arg[value])[
    Checks if #arg[value] is a body argument created with #cmd[barg].
  ]
  #command("not-is-body", arg[value])[
    Negation of #cmd[is-body].
  ]
  #command("not-is-choices", arg[value])[
    Negation of #cmd[is-choices].
  ]
] // end module mty
