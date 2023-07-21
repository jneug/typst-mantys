# Mantys (0.0.2)

> **MAN**uals for **TY**p**S**t

Template for documenting [typst](https://github.com/typst/typst) packages and templates.

## Usage

For Typst 0.6.0 or later download the [latest version](https://github.com/jneug/typst-mantys/releases/tag/v0.0.2) and unpack it into the [system dependent local package repository](https://github.com/typst/packages#local-packages).

In your local repository type:
```shell
wget https://github.com/jneug/typst-mantys/archive/refs/tags/v0.0.2.tar.gz
mkdir mantys-0.0.2
tar -xzf v0.0.2.tar.gz -C mantys-0.0.2
```

Now import the package at the beginning of your document:
```typst
#import "@local/mantys:0.0.2": *
```

For Typst before 0.6.0 or to use **Mantys** as a local module, download the package and unpack into a folder inside your project (e.g. `/mantys`). Then import `mantys/mantys.typ`:

```typst
#import "mantys/mantys.typ": *
```

## Writing basics

A basic template for a manual should look like this:

```typst
#import "@local/mantys:0.0.2": *

#show: mantys.with(
	name:		"your-package-name",
	title: 		[A title for the manual],
	subtitle: 	[A subtitle for the manual],
	info:		[A short descriptive text for the package.],
	authors:	"Your Name",
	url:		"https://github.com/repository/url",
	version:	"0.0.1",
	date:		"date.of.release",
	abstract: 	[
		A few paragraphs of text to describe the package.
	],

	example-imports: ("@local/your-package-name:0.0.1": "*")
)

// end of preamble

# About
#lorem(50)

# Usage
#lorem(50)

# Available commands
#lorem(50)

```

Use `#command(name, ..args)[description]` to describe commands and arguments. 

For a full reference of available commands read [the manual](manual.pdf).
