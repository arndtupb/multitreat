clear
version 17 
*
****************************************************
******             TIDY DATA                ********
****************************************************
*
	*FFI Data
	*Convert .csv Industry Classification Files to .dta 
	import delimited "${path}\data\external\fama_french_12_industries.csv", delimiter(comma) varnames(1) stringcols(2) numericcols(1) 
	save "${path}\data\external\fama_french_12_industries.dta", replace
	clear
	import delimited "${path}\data\external\fama_french_48_industries.csv", delimiter(comma) varnames(1) stringcols(2) numericcols(1) 
	save "${path}\data\external\fama_french_48_industries.dta", replace
	clear
*
	*Import Raw Compustat Data
	use "${path}\data\pulled\cstat_us_sample.dta", clear 
*
{	//Tidy Raw Compustat Data
*
	*gvkey
	*Compustat via WRDS provides the numerical gvkey as string. When matching to other databases via gvkey as string, merging string-string delivers few hits. 
	gen string_gvkey = gvkey
	destring gvkey, replace 	//output should be: "gvkey: all characters numeric; replaced as long"
*
	*fyear
	*should never be missing
	drop if missing(fyear)	
*
	*Data format 
	drop if consol != "C"		//Consolidated Accounts Only
	drop if datafmt != "STD"	//Represents standardized annual data and standardized restated interim data.
	drop if indfmt != "INDL"
	drop if popsrc != "D" 		//D = Domestic Corporations. But: "Domestic includes Canadian Companies and ADRs!"
	drop if curcd != "USD"		//Analyzing domestic corporations 
	drop if fic != "USA"		//Analyzing domestic corporations
	drop if loc != "USA"		//Analyzing domestic corporations
*
	*Total Assets & Sales 
	drop if missing(at)
	drop if at <= 0
	drop if sale <= 0
*
	*Check for duplicates in gvkey and fyear
	isid gvkey fyear			//error would show: "variables gvkey and fyear do not uniquely identify the observations"
*
}
*
{	//Industry Classification
*	
	*current sic
	gen string_sic = sic
	destring sic, replace
	*historical sic: sich
	gen string_sich = sich
	destring sich, replace
	replace sic = sich if !missing(sich) & sich != sic 
*
	drop if missing(sic)
	drop if sic >= 6000 & sic <= 6999
*
	*merge FFI Data
	merge m:1 sic using "${path}\data\external\fama_french_12_industries.dta",  generate(_merge_ffi12)   
	merge m:1 sic using "${path}\data\external\fama_french_48_industries.dta",  generate(_merge_ffi48)   
	keep if _merge_ffi12 == 3 & _merge_ffi48 == 3
	drop _merge_ffi12 
	drop _merge_ffi48
*
}
*
*(...)
{	//Save Tidy Data
	save "${path}\data\pulled\cstat_us_tidy.dta", replace 
	erase "${path}\data\external\fama_french_12_industries.dta"
	erase "${path}\data\external\fama_french_48_industries.dta"
*
}
*
*clear
exit
