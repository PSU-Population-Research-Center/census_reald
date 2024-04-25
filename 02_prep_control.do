** project: census_reald
** purpose: download "authoritative" county controls from ACS
** author: sharygin@pdx.edu
/* notes:
	- prerequisite:
		- 01_varstable_api.xlsx = list of equivalencies between ACS tables and PUMS, for API calls
		- curl executable
		- Census API key stored in "censuskey.txt"
		- subdirectory "temp"
	- outputs:
		- temp/temp/controldata_`y'.dta = list of county control totals for various characteristics
	- to run:
		- modify setup block to specify location of census API key in plain text file.
		- modify setup block to specify location of curl executable
		- modify setup block to specify working directory
		- update '01_varstable_api.xlsx' with the following columns:
			- varname: what you wish to call the control variable
			- year: the last year of the 5-year ACS for this control
			- table: the acs table that contains the data of interest to calculate the control variable
			- cells: the cells that should be summed to generate the control variable
			- universe: the total population for which data is available
			- filter: stata code to be run on the PUMS such that it generates an equivalent population
	- TBD: optimize by loading names into memory, checking against dataset for matches using ssc_isvar, sorting by table ID, etc.
*/

// setup
global curl "I:/Research/Home/s/sharygin/curl.exe" 
global path "I:/Research/Home/s/sharygin/_OHA_REALD_ACS_v2"
cd $path
if "$censuskey"=="" {
	import delim using "censuskey.txt", varn(nonames)
	qui levelsof v1, clean local(censuskey)
	global censuskey "`censuskey'"
}
foreach p in "jsonio" "getcensus" "censusapi" {
	cap which `p'
	if _rc ssc install `p'
}

// prerequisite
** 01_varstable_api.xlsx // contains a list of varnames, and assocaited census tables and cells

// download ACS SF tables for controls (age, sex, disab, LEP, lanp)
cap prog drop oha_reald_controltotals
prog def oha_reald_controltotals
{
	local y="`1'"
	if "`2'"=="replace" {
		getcensus b01001, year(`y') sample(5) geography(county) statefips(41) clear nolab
		keep year state county
		local n=_N+1
		set obs `n' // add clark county, WA 
		replace state="53" in `n'
		replace county="011" in `n'
		replace year=`y' in `n'
		save temp/controldata_`y'.dta, replace // init empty dataset with county codes
	}
	import excel using 01_varstable_api.xlsx, sheet(Sheet1) firstrow clear allstring
	drop if varname==""
	dropmiss, force
	tempfile tmp
	gen call=varname+" "+table+" "+cells
	levelsof call, local(calls)
	qui foreach v of local calls {
		tokenize "`v'"
		cap d `1'_e using temp/controldata_`y'.dta // check if already exists in dataset
		cap assert `r(N)'>0
		if _rc {
			local v="`1'"
			local t="`2'"
			local f="`3'"
			nois di ". retrieving data for `v' <= table `t'"
			if inlist(substr("`t'",1,1),"p","P") { /* decennial tables source */
				local t=lower("`t'") 
				cap confirm var `t'_001n // check if this dataset is already loaded
				if _rc {
					local T=upper("`t'") 
					censusapi, url("https://api.census.gov/data/2020/dec/dhc?get=group(`T')&for=county:*&in=state:41")
					save `tmp', replace
					censusapi, url("https://api.census.gov/data/2020/dec/dhc?get=group(`T')&for=county:011&in=state:53")
					append using `tmp'
					confirm var geo_id 
					drop *na 
					rename *n *e
					gen int year=`y' 
					tostring state, replace format(%02.0f) 
					tostring county, replace format(%03.0f)
				}
			}
			else if inlist(substr("`t'",1,1),"b","c") { /* ACS tables source */
				cap confirm var `t'_001e // check if this dataset is already loaded
				if _rc { 
					local T=upper("`t'") 
					censusapi, url("https://api.census.gov/data/`y'/acs/acs5?get=group(`T')&for=county:*&in=state:41")
					save `tmp', replace
					censusapi, url("https://api.census.gov/data/`y'/acs/acs5?get=group(`T')&for=county:011&in=state:53")
					append using `tmp'
					gen int year=`y' 
					tostring state, replace format(%02.0f) 
					tostring county, replace format(%03.0f)
				}
			}
			gen `v'_e=0
			gen `v'_m=0
			local 3: di subinstr("`3'","+"," ",.)
			local n: word count `3'
			tokenize `3'
			forvalues i=1/`n' {
				local j: di %03.0f ``i'' 
				replace `v'_e=`v'_e+`t'_`j'e
				cap replace `v'_m=`v'_m+`t'_`j'm^2
			}
			replace `v'_m=sqrt(`v'_m)
			preserve 
			keep `v'* year state county
			unique state
			assert `r(unique)'==2
			qui for var `v'_e `v'_m: label var X "`t': `f'"
			merge 1:1 year state county using temp/controldata_`y'.dta, assert(3 4) nogen
			save temp/controldata_`y'.dta, replace
			restore
		}
	}
}
end
oha_reald_controltotals 2020 // arg1=5-year ACS to run; arg2="replace" to reinitialize, blank to cumulate 
