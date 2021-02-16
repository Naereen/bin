# Makefile
build:
	ocamlbuild -cflags -g -use-ocamlfind main.d.byte
run:	build
	./main.d.byte
clean:
	ocamlbuild -clean
.PHONY: build clean
