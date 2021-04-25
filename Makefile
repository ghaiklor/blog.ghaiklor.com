all: clean build test lint

clean:
	bundle exec jekyll clean

build:
	bundle exec jekyll build

test: build
	bundle exec htmlproofer ./_site

lint: clean
	find . -name '*.md' ! -path './vendor/*' | xargs bundle exec mdl

serve:
	bundle exec jekyll serve
