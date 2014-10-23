coffee_files := $(wildcard *.coffee)
js_files     := $(coffee_files:%.coffee=%.js)

all: js
js: $(js_files)

%.js: %.coffee
	coffee -sc < $< > $@
