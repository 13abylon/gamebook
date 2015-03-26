all: book

COMMITDATE = `date +'%d.%m.%Y %H:%M %Z'`

book:
	cd gh-pages/ && find . -not -name '.git' -depth 1 | xargs rm -rf
	cd gamebook/ && gitbook build ./ ./../_books
	cd _books && cp -r * ../gh-pages/
	rm -rf _books/

commit:
	cd gh-pages/ && git add -A
	cd gh-pages/ && git commit -m "gamebook updated on $(COMMITDATE)"
	cd gh-pages/ && git push origin gh-pages
