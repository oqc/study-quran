# Study Quran

Some Ruby scripts that parse 3 translations and the original Arabic
Quran texts into a well formatted document.

Currently it is set up for a Dutch version (includes a Dutch
introduction and title page), but it is easily adjusted
for other languages.

[Download the Study Quran](https://github.com/oqc/study-quran/raw/master/study-quran.pdf)

This link should give you the latest version.


## Building the PDF from these files

To generate a `.pdf` from these files you need to install some software,
it's called XeLaTeX, and some fonts. In Ubuntu linux this is simple,
on the command line do:

   sudo aptitude install texlive-xetex texlive-latex-recommended \
                         texlive-lang-dutch tex-gyre ttf-sil-scheherazade
                         # `texlive-lang-dutch` is needed for the dutch version

You only have to do that once.

Generating the `.pdf` is accomplished by:

   cd study-quran        # the directory of your local copy/clone
   ./combinetexts.rb     # combines the texts (add argument 'q' for quick)
   xelatex study-quran   # generates a `pdf` from `study-quran.tex`


I don't use `pdflatex` but `XeTeX` since it allows me to use gyre's
lowercase numbers, and should give better results with Arabic and/or RTL
languages.
