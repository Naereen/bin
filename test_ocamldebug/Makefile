# Makefile for tiny examples of OCaml files

build:
	ocamlbuild -cflags -g -use-ocamlfind main.d.byte
run:	build
	./main.d.byte
clean:
	-mv -vfi ./a.out ./*.o ./*.cm* perf.data* ocamlprof.dump /tmp/
	-ocamlbuild -clean

.PHONY: build clean run

test-profiling:
	-mv -vf graphtest_annotated.ml ocamlprof.dump /tmp/
	cp -vf graphtest.ml graphtest_annotated.ml
	ocamlcp -P a graphics.cma graphtest.ml -o graphtest
	./graphtest
	ocamlprof graphtest.ml > graphtest_annotated.ml
	#diff --color=auto --side-by-side graphtest.ml graphtest_annotated.ml
	git wdiff graphtest_annotated.ml

show-produced-c-code:
	git wdiff testCompile.ml
	-mv -vf testCompile.c /tmp/
	ocamlc -output-obj -o testCompile.c testCompile.ml
	git wdiff testCompile.c testCompile.ml

keep-assembly:
	ocamlopt -S testCompile.ml
	cat testCompile.s
	git wdiff testCompile.s

gprof:
	ocamloptp -p testCompile.ml
	gprof ./a.out
	# not supported in recent OCaml versions

time:
	ocamlc   -o ./graphtest.byte graphics.cma graphtest.ml
	ocamlopt -o ./graphtest.opt  graphics.cmxa graphtest.ml
	@echo "Bytecode version:"
	time ./graphtest.byte
	@echo "Native version:"
	time ./graphtest.opt

perf:
	ocamlopt -g -o ./graphtest.opt graphics.cmxa graphtest.ml
	sudo perf record --call-graph=dwarf -- ./graphtest.opt
	sudo chown lilian perf.data
	sudo chgrp lilian perf.data
	perf report

keep-dsource:
	ocamlc -dsource testCompile.ml

keep-dparsetree:
	ocamlc -dparsetree testCompile.ml

keep-dtypedtree:
	ocamlc -dtypedtree testCompile.ml

keep-drawlambda:
	ocamlc -drawlambda testCompile.ml

keep-dlambda:
	ocamlc -dlambda testCompile.ml

keep-dinstr:
	ocamlc -dinstr testCompile.ml
