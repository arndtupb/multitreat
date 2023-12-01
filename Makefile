######################
# TARGET: DEPENDENCY
#	COMMAND
######################
# Use a tab & not whitespaces for COMMAND 
#
#Set L to "python", "Stata" or "R" 
L?=Stata
#
PAPER := output/paper_stata.pdf
#
TARGETS := $(PAPER) 
#
EXTERNAL_DATA := data/external/fama_french_12_industries.csv \
	data/external/fama_french_48_industries.csv
#
WRDS_DATA := data/pulled/cstat_us_sample.dta
#
GENERATED_DATA := data/generated/cstat_us_tidy.dta 
#
RESULTS := data/generated/cstat_us_final.dta
#
#
ifeq ($L,R)
	CLI:=Rscript --encoding=UTF-8
	SCRIPT_EXT:=R
	DATA_EXT:=rds
	RESULT_EXT:=rda
	DOC_EXT:=Rmd
	render_doc_fn = $(CLI) -e 'library(rmarkdown); render("${1}.$(DOC_EXT)")'
else ifeq ($L,python)
	CLI:=python
	SCRIPT_EXT:=py
	DATA_EXT:=csv
	RESULT_EXT:=json
	DOC_EXT:=qmd
	render_doc_fn = quarto render $(1).$(DOC_EXT) --quiet
else ifeq ($L,Stata)
	CLI:="C:\Program Files\Stata18\Stata18SE-64" -e do
	SCRIPT_EXT:=do
	render_doc_fn = quarto.cmd render $(1).qmd --to pdf
else
$(error Langauge(L) has to be python, Stata or R; also please make sure that there are no trailing white space.)
endif
#
#
.phony: all, clean very-clean dist-clean 
#
all: $(TARGETS)
#Making multiple targets and you want all of them to run? Make an all target! 
#
clean:
	rm -f $(TARGETS)
	rm -f $(RESULTS) 
	rm -f $(GENERATED_DATA)
#
very-clean: clean
	rm -f $(WRDS_DATA)
#
dist-clean: very-clean
	rm config.csv
#
config.csv:
	@echo "you need to copy _config.csv to config.csv and edit it"
	@false
#
$(WRDS_DATA): code/Stata/connect_wrds.$(SCRIPT_EXT) config.csv
	$(CLI) code/Stata/connect_wrds.$(SCRIPT_EXT) 
#
$(GENERATED_DATA): $(WRDS_DATA) $(EXTERNAL_DATA) code/Stata/tidy_data.$(SCRIPT_EXT) 
	$(CLI) code/Stata/tidy_data.$(SCRIPT_EXT) 
#
$(RESULTS): $(GENERATED_DATA) code/Stata/analyses.$(SCRIPT_EXT) 
	$(CLI) code/Stata/analyses.$(SCRIPT_EXT) 
#
$(PAPER): doc/paper_stata.qmd doc/references.bib $(RESULTS)
	$(call render_doc_fn,doc/paper_stata)
	mv doc/paper_stata.pdf output
	rm -f doc/paper_stata.ttt doc/paper_stata.fff