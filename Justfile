root := justfile_directory()
package-fork := "$TYPST_PKG_FORK"

export TYPST_ROOT := root

[private]
default:
	@just --list --unsorted

# build assets for docs
assets FILE:
  bash scripts/assets "{{ FILE }}"

preview: install-preview && uninstall-preview
  typst compile --root . -f png --ppi 250 template/manual.typ docs/assets/thumbnail-{n}.png
  mv docs/assets/thumbnail-1.png docs/assets/thumbnail.png
  rm -f docs/assets/thumbnail-2.png

# generate manual
doc:
  typst compile docs/manual.typ docs/manual.pdf

# run test suite
test *args:
	tt run {{ args }}

# update test cases
update *args:
	tt update {{ args }}

# package the library into the specified destination folder
package target:
	./scripts/package "{{target}}"

# install the library with the "@local" prefix
install: (package "@local")

# install the library with the "@preview" prefix (for pre-release testing)
install-preview: (package "@preview")

# prepare the package for a pull-request
prepare: (package package-fork)

# create a symbolic link to this library in the target repository
link target="@local":
	./scripts/link "{{target}}"

link-preview: (link "@preview")

[private]
remove target:
	./scripts/uninstall "{{target}}"

# uninstalls the library from the "@local" prefix
uninstall: (remove "@local")

# uninstalls the library from the "@preview" prefix (for pre-release testing)
uninstall-preview: (remove "@preview")

# unlinks the library from the "@local" prefix
unlink: (remove "@local")

# unlinks the library from the "@preview" prefix
unlink-preview: (remove "@preview")

# run ci suite
ci: test doc

# run tbump
bump VERSION:
  tbump {{VERSION}}
