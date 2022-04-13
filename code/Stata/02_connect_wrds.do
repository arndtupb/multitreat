clear
version 17 
*
****************************************************
******           CONNECT TO WRDS            ********
****************************************************
/*
	You will need Stata 17 to access WRDS! Stata command: jdbc connect
	see: help jdbc
	>> https://blog.stata.com/2022/01/27/wharton-research-data-services-stata-17-and-jdbc/ for details
	In preparation of running the code below, you need to install a JDBC driver: 
	Step #1 
	Download JDBC driver (.jar file) from https://jdbc.postgresql.org/download.html#current (here postgresql-42.3.3.jar)
	Step #2 
	Copy .jar file to Stata's ado path. (By default, Stata for Windows uses the c:\ado directory for user-written ado files.) 
*/
*
	local jar "postgresql-42.3.3.jar"
	local classname "org.postgresql.Driver"
	local url "jdbc:postgresql://wrds-pgdata.wharton.upenn.edu:9737/wrds?ssl=require&sslfactory=org.postgresql.ssl.NonValidatingFactory"
	// DANGER ZONE
	confirm file "${path}\config.csv"
	import delimited "${path}\config.csv", varnames(nonames) rowrange(19)
	local wrds_user = v2[1]
	*display "`wrds_user'"
	local wrds_pwd = v2[2]
	*display "`wrds_pwd'"
	clear
*
	jdbc connect, 	jar("`jar'") ///
					driverclass("`classname'") ///
					url("`url'")   ///
					user("`wrds_user'") /// 
					password("`wrds_pwd'")
*
*	jdbc showtables // allows you to show all available tables (this depends on your institution's subscription)
*
*
****************************************************
******              PULL DATA               ********
****************************************************
*Compustat Data
*jdbc showtables comp_na% 
*jdbc describe comp_na_daily_all_funda_balancesheetitems
*
/*
jdbc load, exec("SqlStmtList") >> SqlStmtList may be one valid SQL statement or a list of SQL statements separated by semicolons: 
SELECT >> variables (e.g. gvkey & at)
FROM >> table at wrds (e.g. comp_na_daily_all.funda)
WHERE >> conditions (e.g. consol = 'C')
*/
*
*Dynamic Variables
	display "pulling dynamic Compustat data ... "
	jdbc load, exec("SELECT gvkey, conm, cik, fyear, datadate, indfmt, sich, consol, popsrc, datafmt, curcd, curuscn, fyr, act, ap, aqc, aqs, acqsc, at, ceq, che, cogs, csho, dlc, dp, dpc, dt, dvpd, exchg, gdwl, ib, ibc, intan, invt, lct, lt, ni, capx, oancf, ivncf, fincf, oiadp, pi, ppent, ppegt, rectr, sale, seq, txt, xint, xsga, costat, mkvalt, prcc_f,recch, invch, apalch, txach, aoloch, gdwlip, spi, wdp, rcp FROM comp_na_daily_all.funda WHERE consol='C' and (indfmt='INDL' or indfmt='FS') and datafmt='STD' and popsrc='D'")
*
	save "${path}\data\pulled\COMPUSTATdynamic.dta", replace
*
*Static Variables
	clear
	display "pulling static Compustat data ... "
	jdbc load, exec("SELECT gvkey, loc, sic, spcindcd, ipodate, fic FROM comp_na_daily_all.company")
*
	save "${path}\data\pulled\COMPUSTATstatic.dta", replace
*
*Merge Dynamic & Static Data
	merge 1:m gvkey using "${path}\data\pulled\COMPUSTATdynamic.dta"
	drop if _merge != 3 
	drop _merge
*
	save "${path}\data\pulled\cstat_us_sample.dta", replace
	erase "${path}\data\pulled\\COMPUSTATdynamic.dta"
	erase "${path}\data\pulled\COMPUSTATstatic.dta"
*
clear
exit
