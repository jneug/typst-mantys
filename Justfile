root := justfile_directory()

# install/uninstall specific variables
data :=  data_directory() / 'typst' / 'packages'
namespace := 'preview'
version := '0.1.0'
name := 'mantodea'
spec := '@' + namespace + '/' + name + ':' + version

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
	typst {{ cmd }} docs/manual.typ docs/manual.pdf

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

# install the package locally
install: uninstall
	mkdir -p {{ data / namespace / name }}
	ln -s {{ root }} {{ data / namespace / name / version }}

# uninstall the package locally
uninstall:
	rm -rf {{ data / namespace / name / version }}

# uninstall all versions of the package locally
purge:
	rm -rf {{ data / namespace / name }}

# run the ci test suite
ci: assets install
	typst-test run
	typst compile --root template template/main.typ template/main.pdf
	rm template/main.pdf
