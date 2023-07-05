//#import "@local/mantys:0.0.1": *
#import "mantys.typ": *

#show: mantys.with(
	name:		"Mantys",
	title: 		"The Mantys Package",
	subtitle: 	[Template for documenting Typst Packages and Templates],
	info:		[A Typst template to create consistens and readable manuals for pakcages and templates.],
	authors:	"Jonas Neugebauer",
	url:		"https://github.com/jneug/typst-mantys",
	version:	"0.0.1",
	date:		datetime.today(),
	abstract: 	[
		Weit hinten, hinter den Wortbergen, fern der Länder Vokalien und Konsonantien leben die Blindtexte. Abgeschieden wohnen sie in Buchstabhausen an der Küste des Semantik, eines großen Sprachozeans. Ein kleines Bächlein namens Duden fließt durch ihren Ort und versorgt sie mit den nötigen Regelialien. Es ist ein paradiesmatisches Land, in dem einem gebratene Satzteile in den Mund fliegen. Nicht einmal von der allmächtigen Interpunktion werden die Blindtexte beherrscht – ein geradezu unorthographisches Leben.
	]
)

#let cnltx = mty.primary("CNLTX")

= About

Mantys is a Typst package

#wbox[
	Mantys is in active development and its functionality is subject to change.
]
#ibox[
	Contributions are welcome.
]

= Usage


== Loading the package

Currently the package needs to be installed into the local package repository.

Either download the current release from GitHub#footnote[#link("https://github.com/jneug/typst-typopts/releases/latest")] and unpack the archive into yout system dependent local repository folder or clone it directly:

#shell[
```shell-unix-generic
git clone https://github.com/jneug/typst-typopts.git typopts-0.0.3
```
]

After installing the package just import it inside your `typ` file:

#sourcecode[
```typc
#import "@local/typopts:0.0.3": options
```
]


== Available functions

=== Describing commands

#command("argument", "name", "type", default:"__none__")[
	Sets a command with arguments.

	#argument("name", type:dtype("string"))[
		Name of the command
	]
	#argument("func", type:"v => v")[
		Function to pass the value to.
	]

	Retrieves the value for the option by the given #arg("name") and passes it to #arg("func"), which is a function of on argument.

	If no option #arg("name") exists, the given #arg("default") is passed on.

	If #arg(final: true), the final value for the option is retrieved, otherwise the current value. If #arg("loc") is given, the call is not wrapped inside a #doc("meta/locate") call and the given #dtype("location") is used.
]

=== Source code and examples

Mantys provides several commands to handle source code snippets and show examples of functionality. The usual #cmd("raw") command still works, but theses command allow you to highlight code in different ways or add line numbers.

#command("sourcecode", title:none, file:none, [code])[
	If provided, the #arg("title") and #arg("file") argument are set as a titlebar above the content.

	#argument("code", type:dtype("content"))[
		A #cmd[raw] block, that will be set inside a bordered block. The `raw` content is not modified and keeps its #arg("lang") attribute, if set.
	]
	#argument("title", type:dtype("string"), default:none)[
		A title to show above the code in a titlebar.
	]
	#argument("file", type:dtype("string"), default:none)[
		A filename to show above the code in a titlebar.
	]

	If provided, the #arg("title") and #arg("file") argument are set as a titlebar above the content.

	#example[
	```
	#sourcecode(title:"Some Rust code")[
	`ㅤ``rust
	fn main() {
	  println!("Hello World!");
	}
	`ㅤ``
	]
	```
	][
	#sourcecode(title:"Some Rust code")[
	```rust
	fn main() {
		println!("Hello World!");
	}
	```
	]
	]
]

#ebox[
	The ultimate goal is to provide an #cmd("example") command simmilar to the `example` environment in #cnltx, that is able to typeset the example code and the result in one go. As of now #cmd("example") requires you to give it both the source and result as separate arguments.
]

=== Utilities

#command("mty.box", [body], header:none, footer:none, invert-headers:true, stroke-color:colors.primary, bg-color:white, width:100%, padding: 8pt, radius:4pt)[
	#lorem(100)
]
