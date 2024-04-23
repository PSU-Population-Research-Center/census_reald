** purpose: download "authoritative" county controls, 
** as available from ACS detailed tables for each relevant oha-reald subsequent calculation from PUMS
** download, then run prep_pums, then merge these control data before analysis dofile

// 1. setup
global censuskey "2b92605774a71db73318e457339968929489b13c"
/*
foreach p in "shp2dta" "geoinpoly" "jsonio" "getcensus" "censusapi" "survwgt" "svr" {
	cap which `p'
	if _rc ssc install `p'
}
*/
global curl "I:\Research\Home\s\sharygin\curl.exe" 
global path "I:\Research\Home\s\sharygin\_OHA_REALD_ACS_v2"
cd $path

// prerequirsite
** 01_varstable_v02_api.xlsx // contains a list of varnames, and assocaited census tables and cells

// 4. download ACS SF tables for controls (age, sex, disab, LEP, lanp)
** optimize later by ~ loading all names into memory, checking against dataset for matches using ssc_isvar, sorting by table ID, etc.
cap prog drop oha_reald_controltotals
prog def oha_reald_controltotals
{
	if "`1'"=="replace" {
		getcensus b01001, year(2021) sample(5) geography(county) statefips(41) clear nolab
		keep year state county
		local n=_N+1
		set obs `n' // add clark county, WA 
		replace state="53" in `n'
		replace county="011" in `n'
		replace year=2021 in `n'
		save oha_reald_controldata.dta, replace // init empty dataset with county codes
	}
	import excel using 01_varstable_v02_api.xlsx, sheet(Sheet1) firstrow clear allstring
	drop if varname==""
	dropmiss, force
	tempfile tmp
	gen call=varname+" "+table+" "+cells
	levelsof call, local(calls)
	qui foreach v of local calls {
		tokenize "`v'"
		cap d `1'_e using oha_reald_controldata.dta // check if already exists in dataset
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
					gen int year=2021 
					tostring state, replace format(%02.0f) 
					tostring county, replace format(%03.0f)
				}
			}
			else if inlist(substr("`t'",1,1),"b","c") { /* ACS tables source */
				cap confirm var `t'_001e // check if this dataset is already loaded
				if _rc { 
					local T=upper("`t'") 
					censusapi, url("https://api.census.gov/data/2021/acs/acs5?get=group(`T')&for=county:*&in=state:41")
					save `tmp', replace
					censusapi, url("https://api.census.gov/data/2021/acs/acs5?get=group(`T')&for=county:011&in=state:53")
					append using `tmp'
					gen int year=2021 
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
			merge 1:1 year state county using oha_reald_controldata.dta, assert(3 4) nogen
			save oha_reald_controldata.dta, replace
			restore
		}
	}
}
end
oha_reald_controltotals // "replace" to reinitialize, blank to cumulate
