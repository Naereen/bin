# Makefile
build:
	gcc -o main.exe main.c
run:	build
	./main.exe
.PHONY: build run clean

nccgen:
	nccgen -ncgcc -ncld -ncfabs -o main.exe main.c
	nccnav main.nccout
