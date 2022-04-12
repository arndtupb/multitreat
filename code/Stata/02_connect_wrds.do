*https://ftp.postgresql.org/pub/odbc/versions/msi/psqlodbc_09_06_0100.zip



*https://blog.stata.com/2022/01/27/wharton-research-data-services-stata-17-and-jdbc/
version = 17 

local jar "postgresql-42.3.0.jar"
local classname "org.postgresql.Driver"
local url "jdbc:postgresql://wrds-pgdata.wharton.upenn.edu:9737/wrds?ssl=require&sslfactory=org.postgresql.ssl.NonValidatingFactory"
*local user "stata"
*local pass "secret"


jdbc connect, 	jar("`jar'") ///
				driverclass("`classname'") ///
				url("`url'")   ///
				user($wrds_user) /// 
				password($wrds_pwd)
				
				
				
*
