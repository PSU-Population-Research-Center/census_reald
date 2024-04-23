** purpose: conduct analysis on pums
** apply external control totals 
** rake as appropriate for each table
** compile tables with MOEs (WIP)
** export dataset

//
// data
use 5ACS21_ORWA_RELDPRI.dta, clear 
merge m:1 year state county using oha_reald_controldata.dta, assert(3) 
destring county, replace
gen coalpha=(county+1)/2
sum coalpha, mean
assert `r(min)'==1 & `r(max)'==36
mata: st_matrix("master", range(1,36,1)) // empty matrix with county alphabetically sorted order

//
// FIRST Rake by appx age/sex/race-eth >> convert pwgtp to pwt1
cap drop pwt1
clonevar pwt1=pwgtp
local i=0
_dots 0, title(first rake: age/sex/race-eth) reps(180)
set seed 13371701 
qui foreach a in "0004" "0514" "1517" "1819" "2024" "2529" "3034" "3544" "4554" "5564" "6599" {
	foreach s in "male" "female" {
		foreach r in "wa" "ba" "na" "aa" "pa" "oa" "mr" "wanh" "h" {
			survwgt poststratify pwgtp if fa`a'_`s'_`r'==1, by(state county) totvar(a`a'_`s'_`r'_e) gen(tmpwt) // reweight to match county total by age*sex 
			replace pwt1=tmpwt if fa`a'_`s'_`r'==1 
			drop tmpwt
			local ++i
			nois _dots `i' 0
		}
	}
}
// 
// SECOND rake by detailed age/sex groups >> convert pwt1 to pwt2
cap drop pwt2
clonevar pwt2=pwt1 // base the age rake off the prior pov*age rake
local i=0
_dots 0, title(First rake: age/sex) reps(20)
set seed 13371701 
qui foreach a in "0004" "0514" "1517" "1819" "2024" "2529" "3039" "4049" "5059" "6064" "6599" { 
	foreach s in "male" "female" {
		survwgt poststratify pwt1 if fa`a'_`s'==1, by(state county) totvar(a`a'_`s'_e) gen(tmpwt) 
		replace pwt2=tmpwt if fa`a'_`s'==1 
		drop tmpwt
		local ++i
		nois _dots `i' 0
	}
} 
// LAST control to totalpop 
*set seed 13371701 
*survwgt poststratify pwt2, by(state county) totvar(totpop_e) replace
version 13: table county if state=="41", contents(sum pwgtp sum pwt1 sum pwt2 mean totpop) format(%7.0fc) row // pwt2 matches ACS SF.
** may need to be careful after; if ACS says nobody of that race, or if the ACS 5yr PUMS has nobody, it will break.

// TABLES
/* rows: counties (37)
   columns:
	by ages:
		age detailed	 =	0-4,5-14,15-17,18-19,20-24,25-29,30-39,40-49,50-59,60-64,65+ (11)
		age summaries	 =	0-17,18-64,0-64,60+,65+,0-99 (6) -- derivative of above
	  = 10 columns for each trait of:
		part 1.
 	  + sex: female, male = (2 cols) * 11 = 22 cols
 	  + race/eth (full detail): (30 columns) * 11 = 330 cols
	  + race/eth (rarest/OMB): (8 columns, nhwa nhba nhna nhaa nhpa nhoa nhmr h ) * 11 = 88 cols
		part 2.
	  + disab: yes, no = (2 cols) * 11 = 22 cols.
	  + detailed disab: yes, no (2 cols) * eye, phys, self, walk, memory, hear (6 traits) = (12 cols) * 11 = 132 cols
		part 3.
 	  + LEP speakers by selected languages: (appx ~13 columns) * 11 = 141 cols
		preferred langauge used by OHA is a different concept ~~ not akin to ACS
		priority languages: ?? ~ 130 or so in PUMS. ?? 11 or so in OHA list??
*/

// generate additional flags for age w/o sex.
foreach a in "0004" "0514" "1517" "1819" "2024" "2529" "3039" "4049" "5059" "6064" "6599" {
	local x=real(substr("`a'",1,2))
	local y=real(substr("`a'",3,2))
	cap confirm var fa`a'
	if _rc gen byte fa`a'=inrange(age,`x',`y')
	cap confirm var fa`a'_male
	if _rc gen byte fa`a'_male=inrange(age,`x',`y') & sex==1
	cap confirm var fa`a'_female 
	if _rc gen byte fa`a'_female=inrange(age,`x',`y') & sex==2
}

//
// age * [sex + reald + ombrr] = 11 * [2 + 330 + 88] = 4,631 columns.
mat results=J(36,4620,.) 
mat stderr=results
svyset [iw=pwt2], sdr(pwgtp1-pwgtp80) vce(sdr) // use previously adjusted weights.
local i=1 // count the rows as we proceed
set seed 13371701 
qui foreach a in "a0004" "a0514" "a1517" "a1819" "a2024" "a2529" "a3039" "a4049" "a5059" "a6064" "a6599" { 
	// binary sex
	foreach s in "" "_male" "_female" { // 3 sexes * 16 ages = 48 columns
		forvalues c=1/36 {
			*cap assert el(results,`c',`i')<. // check if matrix cell is empty (skip if already calculated) ~ although, will break the replicability with the seed.
			*if _rc {
				sum pwt1 if f`a'`s'==1 & coalpha==`c', mean // simple weighted sum
				if `r(sum)'>0 {
					if inlist(`c',3,10,15,20,24,26,34) { // counties with repwgts
						svy: total f`a'`s' if coalpha==`c' // recalculate using repwgts
						mat results [`c',`i']=el(r(table),1,1) // total
						mat stderr [`c',`i']=el(r(table),2,1) // SE
					}
					else {
						mat results [`c',`i']=`r(sum)' // store earlier result in county vector spot
					}
				}
				else {
					mat results [`c',`i']=0
				}
			*}
		}
		matrcrename results col `i' sex`s'_`a'_e // name the results vector
		matrcrename stderr col `i' sex`s'_`a'_se // name the results vector
		nois di "`: word `i' of `: colnames results''" // check the name
		local ++i // move to the next column
	}
	// reldpri (REALD primary)
	levelsof reldpri, local(races)
	set seed 13371701 
	foreach r of local races {
		forvalues c=1/36 {
			*cap assert el(results,`c',`i')<. 
			*if _rc {
				sum pwt2 if reldpri=="`r'" & f`a'==1 & coalpha==`c', mean
				if `r(sum)'>0 {
					if inlist(`c',3,10,15,20,24,26,34) { 
						svy: total f`a' if reldpri=="`r'" & coalpha==`c'
						mat results [`c',`i']=el(r(table),1,1) 
						mat stderr [`c',`i']=el(r(table),2,1) 
					}
					else {
						mat results [`c',`i']=`r(sum)'
					}
				}
				else {
					mat results [`c',`i']=0
				}
			*}
		}
		matrcrename results col `i' re_reald_`r'_`a'_e
		matrcrename stderr col `i' re_reald_`r'_`a'_se
		nois di "`: word `i' of `: colnames results''"
		local ++i
	}
	// omb (OMB rarest)
	levelsof omb, local(races)
	set seed 13371701 
	foreach r of local races {
		forvalues c=1/36 {
			*cap assert el(results,`c',`i')<. 
			*if _rc {
				sum pwt2 if omb=="`r'" & f`a'==1 & coalpha==`c', mean
				if `r(sum)'>0 {
					if inlist(`c',3,10,15,20,24,26,34) { // counties with repwgts
						svy: total f`a' if omb=="`r'" & coalpha==`c'
						mat results [`c',`i']=el(r(table),1,1) // total
						mat stderr [`c',`i']=el(r(table),2,1) // SE
					}
					else {
						mat results [`c',`i']=`r(sum)'
					}
				}
				else {
					mat results [`c',`i']=0
				}
			*}
		}
		matrcrename results col `i' re_omb_`r'_`a'_e
		matrcrename stderr col `i' re_omb_`r'_`a'_se
		nois di "`: word `i' of `: colnames results''"
		local ++i
	}
	// disab
	// LEP + language
}
mata: st_matrix("c", range(1,36,1))
mat results=c,results
mat stderr=c,stderr
xsvmat results, saving(results_asre_e.dta, replace) names(col) 
xsvmat stderr, saving(results_asre_se.dta, replace) names(col) 
dropmiss
compress
BREAK
END



* Notes:
* The data source is the 2016-20 5-year ACS PUMS and detailed tables. The reweighting process results in non-integer counts, and these have been left as is. They can be displayed as or rounded to whole counts (in which case, rounding errors will mean that totals may not sum exactly).
* Not all households have income or know poverty status; therefore, sum by income quintiles or income to poverty ratio will not sum to total population.
* Language is assessed for the population age 5+ only; therefore, sums across languages will not sum to the total population.
* Disability status is assessed only for the civilian noninstitutionalized population; therefore, sums across disability status will not sum to total population.
* Total population includes households and group quarters; therefore, totals by households with/without children will not sum to total population.
* Totals by REALD race/ethnicity are assigned using pre-production code and then adjusted for consistency at the county level by OMB race/ethnicity only. Subgroups for White, Asian, or Black are implicitly treated as distributed proportional to population across each county of a multi-county PUMA. Approaches are under ongoing development and results may not match totals published elsewhere.
* County level totals by REALD race/ethnicity are pegged to the population of each OMB race/ethnicity; OMB race/ethnicity and same sex cohabiting couples are from the 2020 Census Demographic and Housing Characteristics (DHC) file, not the ACS, due to low representation in the latter. However, the DHC totals by race/ethnicity are proportionally adjusted up/down for consistency with the ACS total population counts for each county.
* Totals and subgroups by income quintile and income to poverty ratio are implicitly treated as distributed proportional to population across each county of a multi-county PUMA. Totals by income quintile and poverty to income ratio may not match totals published elsewhere.
* Totals across subgroups and of all counties may not be equal to independently calculated overall totals due to rounding. For example, the state total from counties may not exactly equal a state total published elsewhere.
* Tabulations made from ACS PUMS have been made consistent with published tables by age by post-stratification weights. Therefore, totals may differ from data in published ACS tables or from ACS PUMS calculations with unadjusted person or household weights.
* RUCA codes for 2020 census tracts have not been determined. Therefore, RUCA codes for the purpose of urban (codes 1--3) or rural (codes 4--10) status determination are assigned to 2020 tracts on the basis of the 2010 tracts that best approximate the boundaries of the 2020 tracts.


