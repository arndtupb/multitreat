clear
version 17 
*
****************************************************
******            CONFIG DO-FILE            ********
****************************************************
*
{ 	// PACKAGES
	*Some User Written Packages are required/suggested. Install/update first!
	*ssc install estout
	*ssc install reghdfe
	*reghdfe, compile
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
	***************************************************************************************************************************************
		global path "C:\Users\weinrich\sciebo\0_Forschung\98_Other\trr266multitreat\multitreat"		//to be blinded for review 
	***************************************************************************************************************************************
	***************************************************************************************************************************************					
		cd "${path}" 
		sysdir set PERSONAL "C:\ado\personal" 
		*
		}
	if("${path" != ""){
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
{	// LISTS OF VARIABLES
	global COMPUSTATvarlist gvkey fyear txp txr
}
*
clear
exit
