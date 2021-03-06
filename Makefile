.PHONY: book images

ABSTRACTS=vonLaszewski-cloud-vol-7
PAPERS=vonLaszewski-cloud-vol-8
PROJECTS=vonLaszewski-cloud-vol-9
TUTORIAL=vonLaszewski-cloud-vol-10
#FLAGS=-interaction nonstopmode -halt-on-error -file-line-error
#FLAGS=-interaction nonstopmode  -file-line-error
FLAGS=-shell-escape
CLOUD=cloud
FLAGS=-shell-escape -output-directory=dest -aux-directory=dest


DEFAULT=$(CLOUD)

LATEX=pdflatex

all: abstracts compile papers projects
	echo done

compile:
	./compile-papers.py
	./compile-project.py

bio: abstracts
	echo done

tutorial:
	latexmk -jobname=$(TUTORIAL) $(FLAGS) -view=pdf $(TUTORIAL) 

b:
	latexmk -jobname=$(ABSTRACTS) $(FLAGS) -view=pdf $(ABSTRACTS) 

bb:
	latexmk -jobname=$(ABSTRACTS) $(FLAGS) -pvc -view=pdf $(ABSTRACTS) 

abstracts: clean dest biolist
	latexmk -jobname=$(ABSTRACTS) $(FLAGS) -view=pdf $(ABSTRACTS) 

papers:
	./papers.py > $(PAPERS).tex
	latexmk -jobname=$(PAPERS) $(FLAGS) -view=pdf $(PAPERS)

projects:
	./projects.py > $(PROJECTS).tex
	latexmk -jobname=$(PROJECTS) $(FLAGS) -view=pdf $(PROJECTS)

pdflatex: clean dest biolist
	pdflatex $(FILE)

biolist: $(wildcard ../hid-sp*/bio-*.tex)
	python bios.py >  bio-list.tex

#ls ../hid-sp*/bio-*.tex | awk '{printf "\\input{%s}\n", $$1}' > bio-list.tex
#	cat bio-list.tex


check:
	grep "&" ../hid-sp18-*/bio-*.tex 
	grep '\$$' ../hid-sp18-*/bio-*.tex 
	grep "_" ../hid-sp18-*/bio-*.tex


clean:
	rm -f	*.pdf *.bbl *.log *.blg *.aux *.out *.idx *.run.xml *.bcf *.toc *.ptc
	rm -rf dest

dest:
	mkdir dest

view:
	open dest/$(FILE).pdf

# google:
# 	gdrive update 1h6_ZRmlCRIFMHG861wSyriPzn9rXxgKT dest/$(FILE).pdf

publish:
	make -f Makefile.publish
	echo done

pull:
	cd ..; cms community pull
