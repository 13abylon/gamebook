all: book

COMMITDATE = `date +'%d.%m.%Y %H:%M %Z'`

book: #summary-check
	cd gh-pages/ && find . -not -name '.git' -depth 1 | xargs rm -rf
	cd gamebook/ && gitbook build ./ ./../_books
	cd _books && cp -r * ../gh-pages/
	rm -rf _books/
	cp gamebook/assets/favicon.ico gh-pages/gitbook/images/favicon.ico
	make copy-pdf

commit:
	cd gh-pages/ && git add -A
	cd gh-pages/ && git commit -m "gamebook updated on $(COMMITDATE)"
	cd gh-pages/ && git push origin gh-pages

summary-check:
	@find . -name \*.md |grep -v gh-pages/ |sed -e "s;./gamebook/;;" |grep -vf not_in_summary.txt |sort > /tmp/md_files_gamebook.txt
	@cat gamebook/SUMMARY.md |sed -e "s;.*(;;" -e "s;).*;;" |sort |grep -v '#Summary' > /tmp/md_files_gamebook_in_summary.txt
	@if test "`comm -3 /tmp/md_files_gamebook.txt /tmp/md_files_gamebook_in_summary.txt|wc -l`" -ne 0; then \
		echo "Warning: Something in the Summary isn't correct"; \
		echo "--------------\nMarkdown files that are NOT in the summary:\n--------------"; \
		comm -23 /tmp/md_files_gamebook.txt /tmp/md_files_gamebook_in_summary.txt; \
		echo "--------------\nMarkdown files that are mentioned in the summary but do not exist:\n--------------"; \
		comm -13 /tmp/md_files_gamebook.txt /tmp/md_files_gamebook_in_summary.txt; \
		exit 1; \
	fi

copy-pdf:
	cp gamebook/assets/arkham_horror/regeln.pdf gh-pages/assets/arkham_horror/
	cp gamebook/assets/arkham_horror/erweiterungen.pdf gh-pages/assets/arkham_horror/
