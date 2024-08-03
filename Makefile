gap-srcs := \
	PackageInfo.g \
	init.g \
	lib/gis.gd \
	lib/gis.gi \
	makedoc.g \
	read.g

.PHONY: all
all: gap-check haskell-check idris-check

.PHONY: gap-install
gap-install:
	@ mkdir -p ~/.gap/pkg
	@ ln -fs $PWD ~/.gap/pkg/

gap-check: ${gap-srcs} gap-install
	@ gap --nointeract -l ";." -q tst/testall.g

gap-docs: makedoc.g ${gap-srcs}
	@ gap --nointeract -b $<

haskell-check:
	@ cabal test

idris-check:
	@ elba test
