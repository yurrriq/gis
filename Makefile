gap-srcs := \
	PackageInfo.g \
	init.g \
	lib/gis.gd \
	lib/gis.gi \
	makedoc.g \
	read.g

gap-check: ${srcs}
	gap --nointeract -l ";." -q tst/testall.g

gap-docs: makedoc.g ${srcs}
	gap --nointeract -b $<

idris-check: $(shell find {src,test} -name '*.idr')
	idris --execute -isrc -itest -p contrib -p specdris test/Data/GIS/Test.idr
	idris --execute -isrc -itest -p contrib -p specdris test/Data/Music/Test.idr

.PHONY: update
niv-update: package ?= nixpkgs
niv-update: sources := nix/sources.json
niv-update: rev = $(shell jq -r '.["${package}"].rev[:8]' ${sources})
niv-update: COMMIT_MSG_FILE = .git/COMMIT_EDITMSG
niv-update:
	@ niv update ${package}
	@ git add ${sources}
	@ jq '"${package}: ${rev} -> \(.["${package}"].rev[:8])"' \
	${sources} | xargs git commit -m
