# Let's give this a try
# Make's Structure: 
######################
# TARGET: DEPENDENCY
#	COMMAND
######################
# Use a Tab & not a Whitespace for COMMAND 

PAPER := output/paper_stata.pdf

TARGETS := $(PAPER) 

EXTERNAL_DATA := data/external/fama_french_12_industries.csv \
	data/external/fama_french_48_industries.csv

WRDS_DATA := data/pulled/cstat_us_sample.dta

GENERATED_DATA := data/pulled/cstat_us_tidy.dta 
#i should change this folder to generated 

#RESULTS := data/pulled/cstat_us_final.dta
#i should change this folder to generated  

DOFILE := "C:\Program Files\Stata17\Stata17SE-64" /e do
#"C:\Program Files\Stata17\Stata17SE-64.exe" is the .exe file!
#/opt/stata/stata-mp -b
#https://stackoverflow.com/questions/14928277/why-does-this-makefile-build-every-dependency-every-time

RSCRIPT := Rscript --encoding=UTF-8

.phony all clean very-clean dist-clean 

all: $(TARGETS)
#Making multiple targets and you want all of them to run? Make an all target! 

clean:
	rm -f $(TARGETS)
	rm -f $(RESULTS) 
	rm -f $(GENERATED_DATA)

very-clean: clean
	rm -f $(WRDS_DATA)

dist-clean: very-clean
	rm config.csv

config.csv:
	@echo "you need to copy _config.csv to config.csv and edit it"
	@false

$(WRDS_DATA): code/Stata/02_connect_wrds.do config.csv 
	$(DOFILE) code/Stata/02_connect_wrds.do 

$(GENERATED_DATA): $(WRDS_DATA) $(EXTERNAL_DATA) code/Stata/03_tidy_data.do
	$(DOFILE) code/Stata/03_tidy_data.do

$(RESULTS):	$(GENERATED_DATA) code/Stata/04_analyses.do
	$(DOFILE) code/Stata/04_analyses.do

$(PAPER): doc/paper_stata.qmd doc/references.bib $(RESULTS)
	$(RSCRIPT) -e 'library(rmarkdown); render("doc/paper.Rmd")'
	#$(call render_doc_fn,doc/paper_stata)
	mv doc/paper_stata.pdf output
	#rm -f doc/paper_stata.ttt doc/paper_stata.fff
