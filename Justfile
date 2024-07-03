root := justfile_directory()
export TYPST_ROOT := root

[private]
default:
	@just --list --unsorted

compile FILE *ARGS:
	typst compile "{{ FILE }}" {{ ARGS }}

watch FILE *ARGS:
	typst watch "{{ FILE }}" {{ ARGS }}

test FILTER="":
	typst-test run {{ FILTER }}

update FILTER="":
	typst-test update {{ FILTER }}



build FILE: (assets FILE)
	typst compile "{{ FILE }}"

assets FILE:
	bash scripts/assets "{{ FILE }}"

