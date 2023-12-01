clear
version 18 
*
****************************************************
******             TREATMENT                ********
****************************************************
*
	*Import Tidy Compustat Data
	use ".\data\generated\cstat_us_tidy.dta", clear 
*
{	//Limit Sample to 25 Years of Observations (done for ease of computation)
	drop if fyear < 1996 
	drop if fyear > 2020
*
}
*
{	//Simulation of Treatment
	set seed 1234
*
	*TREATED
	*whether or not a firm will receive a treatment
	*treated and never-treated firms: p25-split of a normally distributed variable 
	generate vhelp = .
	bysort gvkey: replace vhelp = cond(_n==1,rnormal(),vhelp[1])
	qui sum vhelp, detail 
	gen treated = 0 
	replace treated = 1 if vhelp >= `r(p25)' 
	drop vhelp*	
*
	*TREATMENT
	*point of time a firm is initially treated
	*treatment status remains constant
	*simulation: observation that is the closest to passing p50 of a uniformly distributed random variable within the interval (0,1) (or max of random var if it does not passt overall p50 per treated gvkey)
	gen random =  cond(treated == 1, runiform(),.)
	qui sum random, detail
	sort gvkey random 
	bysort gvkey (random): gen treatment = sum(random >= `r(p50)' & random < .) == 1
	bysort gvkey: egen vhelp = max(treatment)
	bysort gvkey: egen reverserandomrank = rank(-random)
	bysort gvkey (reverserandomrank): replace treatment = 1 if _n==1 &  treated == 1 & treatment == 0 & vhelp == 0
	drop random vhelp* reverserandomrank
	sort gvkey fyear
	*initial treatment year per firm
	bysort gvkey: gen first_treatment = fyear if treatment == 1
	bysort gvkey: egen vhelp = max(first_treatment)
	replace first_treatment = vhelp
	replace first_treatment = 0 if treated == 0
	drop vhelp 
	sort gvkey fyear
*
	*POST
	generate post = treatment
	bysort gvkey (fyear): replace post = post[_n-1] if _n>1 & post==0
*
	*TREATEDxPOST
	*i.treated##i.post or: 
	gen treatedxpost = treated*post
*
	*EFFECT
	sort gvkey fyear
	gen y = sale/LAG_1_at
	replace y = sale/at if missing(y)
	*winsorize
	qui sum y, d
	replace y = `r(p1)' if y <= `r(p1)'
	replace y = `r(p99)' if y >= `r(p99)'
	*simulate effect
	*stable without variation: 
	qui sum y, d 
	replace y = y + `r(sd)' if post == 1 & treated == 1 & !missing(y)
*
}
*
	save ".\data\generated\cstat_us_final.dta", replace 
*
{	//Desc. Statistics
	estpost summarize y treated post, d
	*
	esttab using "./output/stata_descstats.tex", replace ///
	cells("mean sd min p50 max")	///
	  title("Descriptive Statistics") ///
	  nonumbers nogaps ///
	  coeflabels(y "\$\frac{sales}{lagged\,total\,assets}\$") 	  ///
	  addnotes("\label{tab:tbl-descstats}")
	 * alternative: .csv file
	 esttab using "./output/stata_descstats.csv", replace ///
		cells("mean sd min p50 max")	///
		title("Descriptive Statistics") ///
		nonumbers nogaps ///
		coeflabels(y "\$\frac{sales}{lagged\,total\,assets}\$") 	  ///
		addnotes("\label{tab:tbl-descstats}")
	 
*
}
*
{	//Analyses
	timer on 1
	csdid y, ivar(gvkey) time(fyear) gvar(first_treatment) method(dripw)
	estat all
	*5 year window around treatment: ATT by Periods
	estat event, window(-5 5) estore(event)
	esttab event using ".\output\stata_tbl_twfe.tex", replace /// 
		se(3) nostar noobs nogaps /// 
		coeflabels(Pre_avg "Pretreatment Average" ///
					Post_avg "Posttreatment Average" ///
					Tm5 "Pretreatment \$t-5\$" ///
					Tm4 "Pretreatment \$t-4\$" ///
					Tm3 "Pretreatment \$t-3\$" ///
					Tm2 "Pretreatment \$t-2\$" ///
					Tm1 "Pretreatment \$t-1\$" ///
					Tp0 "Treatment" ///
					Tp1 "Posttreatment \$t1\$" ///
					Tp2 "Posttreatment \$t2\$" ///
					Tp3 "Posttreatment \$t3\$" ///
					Tp4 "Posttreatment \$t4\$" ///
					Tp5 "Posttreatment \$t5\$") ///
		title("ATT by Periods Before and After Treatment") mtitles("\$\frac{sales}{lagged\,total\,assets}\$") nonumbers ///
		addnotes("Presentation limited to a window of 5 periods around treament." "\label{tab:tbl-twfe}")
	*Visualization: example with 2008-cohort 
	graph drop _all
	csdid_plot, group(2008) style(rspike) name(twfe)
	addplot twfe: , plotregion(fcolor(white)) graphregion(color(white)) legend(off) 
	graph export  ".\output\stata_fig_twfe.svg", replace
	timer off 1
	timer list
*	
}
*
