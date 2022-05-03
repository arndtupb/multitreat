clear
version 17 
*
****************************************************
******             TREATMENT                ********
****************************************************
*
	*Import Tidy Compustat Data
	use "${path}\data\pulled\cstat_us_tidy.dta", clear 
*
{	//Simulation of Treatment
	set seed 1234
*
	*TREATED
	*whether or not a firm will receive a treatment
	*treated and never-treated firms: median split of are normally distributed variable 
	generate vhelp = .
	bysort gvkey: replace vhelp = cond(_n==1,rnormal(),vhelp[1])
	qui sum vhelp, detail 
	gen treated = 0 
	replace treated = 1 if vhelp >= `r(p50)' 
	drop vhelp*	
*
	*TREATMENT
	*point of time a firm is initially treated
	*treatment status remains constant
	*simulation: observation that is the closest to passing p50 of a uniformly distributed random variable within the interval (0,1)
	bysort gvkey: gen id = _n
	gen random =  cond(treated == 1, runiform(),.)
	gen vhelp = .
	qui sum random, detail 
	sort gvkey random 
	bysort gvkey (random): gen treatment = sum(random >= `r(p50)' & random < .) == 1
	drop id random vhelp
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
	gen y = sale/LAG_!_at
	
*
}
*
{	//Analyses

}
*
clear
exit
