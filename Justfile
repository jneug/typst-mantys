root := justfile_directory()
export TYPST_ROOT := root

[private]
default:
	@just --list --unsorted

build FILE: (assets FILE)
	typst compile "{{FILE}}"

assets FILE:
	#!/usr/bin/env bash
	FILE_ROOT=`dirname "{{FILE}}"`

	# Query for asset data
	if ! typst query "{{FILE}}" "<mantys:asset>" &>/dev/null; then
		ERRORS=`typst query "{{FILE}}" "<mantys:asset>" --diagnostic-format short 2>&1`
		RE='(.*)searched at ([^)]+)(.*)'

		while [[ $ERRORS =~ $RE ]]; do
			# Create fake asset
			echo "" | typst c - "${BASH_REMATCH[2]}"
			ERRORS=${BASH_REMATCH[1]}${BASH_REMATCH[3]}
		done
	fi

	ASSETS=`typst query "{{FILE}}" "<mantys:asset>"`
	echo $ASSETS | jq -c '.[].value' | while read ASSET;
	do
		ID=$(echo $ASSET | jq -r '.["id"]')
		SRC=$FILE_ROOT"/"$(echo $ASSET | jq -r '.["src"]')
		DEST=$FILE_ROOT"/"$(echo $ASSET | jq -r '.["dest"]')

		if test -f "$SRC"; then
			mkdir -p `dirname "$DEST"`
			typst compile "$SRC" "$DEST" --ppi 250
			echo "Created asset $ID"
		else
			echo "Asset $SRC not found!"
		fi
	done

