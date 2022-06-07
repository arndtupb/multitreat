clear
version 17 
*
****************************************************
******             START DO-FILE            ********
****************************************************
*
{ 	// PACKAGES
	*Some User Written Packages are required/suggested. Install/update first!
	*ssc install estout
	*ssc install reghdfe
	*reghdfe, compile
	*ssc install drdid
	*ssc install csdid
	*ssc install addplot
	*Update packages
	*adoupdate corsp estout reghdfe, update
}
*
{	// OS, WORKING DIRECTORY, TIMESTAMP
*
{	//WD
	if "`c(os)'"=="MacOSX" | "`c(os)'"=="UNIX" {
		display as error "please run dofiles & scripts using Windows (developing environment)"
		exit 999
	}
	else {
	***************************************************************************************************************************************
	***************************************************************************************************************************************
		global path "C:\Users\weinrich\sciebo\0_Forschung\98_Other\trr266multitreat\multitreat"		 
		global pathStata "C:\Program Files\Stata17\StataSE-64\StataSE-64"	
	***************************************************************************************************************************************
	***************************************************************************************************************************************					
		cd "${path}" 
		*
		}
	if("${path}" != ""){
		sysdir set PERSONAL "C:\ado\personal" 
*
		confirm file "${path}\config.csv"
*
		global username "`c(username)'"
		global desktop "C:\Users\\${username}\Desktop"
		file open mynotes using "C:\Users\\${username}\Desktop\pathStata.txt", text write replace
		file write mynotes "${pathStata}"
		file close mynotes
*
		display "good to go!"
	}
	else{
		display as error "not all relevant paths have been set!"
		exit 999
	}		
*	
}
*
{	//TIMESTAMP
	local c_date = c(current_date)
	local c_time = c(current_time)
	local c_time_date = "`c_date'"+"_" +"`c_time'"
	display "`c_time_date'"
	global time_string = subinstr("`c_time_date'", ":", "_", .)
	global time_string = subinstr("$time_string", " ", "_", .)
	display "$time_string"
}
*
}
*
clear
exit
