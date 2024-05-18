root := justfile_directory()

export TYPST_ROOT := root
# export TYPST_FONT_PATHS := root / 'assets' / 'fonts'

alias tt := typst-test

alias d := doc
alias t := test
alias u := update

# list recipes
[private]
@default:
	just --list --unsorted --no-aliases

# run typst with the correct environment variables
typst *args:
	typst {{ args }}

# run typst-test with the correct environment variables
typst-test *args:
	typst-test {{ args }}

# generate the manual
doc cmd='compile':
	typst {{ cmd }} doc/manual.typ doc/manual.pdf

# generate the examples
assets:
	typst compile assets/examples/thumbnail.typ assets/thumbnail.png
	oxipng --opt max assets/thumbnail.png

# run the test suite
test filter='':
	typst-test run {{ filter }}

# update the tests
update filter='':
	typst-test update {{ filter }}

# run the ci test suite
ci: assets
	typst-test run
