srcs := \
	PackageInfo.g \
	init.g \
	lib/gis.gd \
	lib/gis.gi \
	makedoc.g \
	read.g

check: ${srcs}
	gap --nointeract -l ";." -q tst/testall.g

docs: makedoc.g ${srcs}
	gap --nointeract -b $<
