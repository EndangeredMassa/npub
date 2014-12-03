default: build

BINDIR = bin
SRCDIR = src
LIBDIR = lib
TESTDIR = test
DISTDIR = dist

SRC = $(shell find "$(SRCDIR)" -name "*.coffee" -type f | sort)
LIB = $(SRC:$(SRCDIR)/%.coffee=$(LIBDIR)/%.js)
TEST = $(shell find "$(TESTDIR)" -name "*.coffee" -type f | sort)

COFFEE=node_modules/.bin/coffee --js
MOCHA=node_modules/.bin/mocha --compilers coffee:coffee-script-redux/register -r coffee-script-redux/register -r test-setup.coffee -u tdd -R dot
CJSIFY=node_modules/.bin/cjsify --minify

all: build test
build: $(LIB)
bundle: $(DISTDIR)/bundle.js

$(LIBDIR)/%.js: $(SRCDIR)/%.coffee
	@mkdir -p "$(@D)"
	$(COFFEE) <"$<" >"$@"

$(DISTDIR)/bundle.js: $(LIB)
	@mkdir -p "$(@D)"
	$(CJSIFY) -x ProjectName $(shell node -pe 'require("./package.json").main') >"$@"

.PHONY: test loc clean

test:
	$(MOCHA) $(TEST)
$(TESTDIR)/%.coffee: phony-dep
	$(MOCHA) "$@"

loc:
	@wc -l "$(SRCDIR)"/*

clean:
	@rm -rf "$(LIBDIR)" "$(DISTDIR)"
