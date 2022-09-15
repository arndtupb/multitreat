clear
version 17 
*
	***************************************************************************************************************************************
	*****************************************					SET UP DOFILE 					*******************************************
	***************************************************************************************************************************************	
/*
{ 	// PACKAGES
	*Some user-written packages are required/suggested. Install/update first!
	ssc install estout
	ssc install reghdfe
	reghdfe, compile
	ssc install drdid
	ssc install csdid
	ssc install addplot
	ssc install rsource
	*Update packages
	adoupdate corsp estout reghdfe, update
}
*/
	***************************************************************************************************************************************
	***************************************************************************************************************************************
{	//Working Directory
	if "`c(os)'"=="MacOSX" | "`c(os)'"=="UNIX" {
		display as error "please run .do-files & scripts using Windows (developing environment)"
		exit 999
	}
	else {
	pwd		//in case you opened the .dofile by double-clicking on it
	global currentwd `c(pwd)' 
	display "${currentwd}"
		 if regexm("${currentwd}", "\\multitreat\\code\\Stata$") == 0{
			display as error "WARNING >> fork the repository & keep the folder-structure. enter your local path to [...]\multitreat in setup-dofile (line 34) << "
			global path "...\multitreat"  		
			cd "${path}"
			display "${path}"
			display as error "INFO WD set!"
			}
			else{
				cd "${currentwd}"  	 
				cd .. 
				cd ..
				pwd
				global path `c(pwd)'
				display "${path}"
				display as error "INFO WD set!"
			}	
		}
	}
	***************************************************************************************************************************************
	***************************************************************************************************************************************						
{	//File Paths
	if regexm("${path}",  "\\multitreat$") == 1{
	*config.csv contains access information to WRDS
		confirm file "${path}\config.csv"
	*Path to ado\personal (assumed, you may need to change this)
	/*
	You will need Stata 17 to access WRDS! Stata command: jdbc connect
	see: 
	>> help jdbc & 
	>> https://blog.stata.com/2022/01/27/wharton-research-data-services-stata-17-and-jdbc/ for details
	In preparation of pulling WRDS-data, you need to install a JDBC driver: 
	Step #1 
	Download JDBC driver (.jar file) from https://jdbc.postgresql.org/download.html#current (here postgresql-42.3.3.jar)
	Step #2 
	Copy .jar file to Stata's ado path. (By default, Stata for Windows uses the c:\ado directory for user-written ado files.) 
	*/
		sysdir set PERSONAL "C:\ado\personal" 	
	*Path to Stata (assumed, you may need to change this)
		global pathStata "C:\Program Files\Stata17\StataSE-64\StataSE-64"	
		global username "`c(username)'"
		global desktop "C:\Users\\${username}\Desktop"
		file open mynotes using "C:\Users\\${username}\Desktop\pathStata.txt", text write replace
		file write mynotes "${pathStata}"
		file close mynotes
	*Path to R (assumed, you may need to change this)
		global pathR "C:\Program Files\R\R-4.1.1\bin"
*
		display as error "INFO file paths set!"
	}
	else{
		display as error "not all relevant paths have been set! check setup-dofile for details!"
		exit 999
	}		
*	
}
	***************************************************************************************************************************************
	***************************************************************************************************************************************	
{	//TIMESTAMP
	local c_date = c(current_date)
	local c_time = c(current_time)
	local c_time_date = "`c_date'"+"_" +"`c_time'"
	display "`c_time_date'"
	global time_string = subinstr("`c_time_date'", ":", "_", .)
	global time_string = subinstr("$time_string", " ", "_", .)
	display "$time_string"
}
	***************************************************************************************************************************************
	***************************************************************************************************************************************	
{	//BUILD 
	timer on 1
	do "${path}\code\Stata\02_connect_wrds.do"
	do "${path}\code\Stata\03_tidy_data.do"
	do "${path}\code\Stata\04_analyses.do"
	timer off 1
	timer list
	*25 Minutes
}
*
clear
exit
