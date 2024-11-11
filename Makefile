all:

EMACS ?= emacs

build:
	keg build

lint:
	keg lint

test: build
	keg exec $(EMACS) --batch -l conao3-json-ts-mode-tests.el -f cort-test-run

clean:
	keg clean
