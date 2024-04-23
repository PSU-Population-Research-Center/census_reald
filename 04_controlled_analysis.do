** purpose: conduct analysis on pums
** apply external control totals 
** rake as appropriate for each table
** compile tables with MOEs (WIP)
** export dataset

** tbd.
** round results and check against county B01001 total by age/sex and fix discrepancies.

// generate raked file
cap prog drop realdfile
prog def realdfile
	// LOAD pums data from prior step and ADD control totals
	use 5ACS21_ORWA_RELDPRI.dta, clear 
	merge m:1 year state county using oha_reald_controldata.dta, assert(3) nogen
	destring county, replace
	gen coalpha=(county+1)/2
	sum coalpha, mean
	assert `r(min)'==1 & `r(max)'==36
	// FIRST, rake by appx age/sex/race-eth >> convert pwgtp to pwt1
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
	// SECOND, rake by disability status
	// THIRD, rake by language status
	// FINAL rake by detailed age/sex groups >> convert pwt1 to pwt2
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
	// reallocate OMB races using rarest race method
	// control totals have been adjusted using rarest race method to divide MR population
	// statewide frequency AOIC: nhpi (37787)<black (140010)<aian (163101)<asian (288867)<hispan ()<white()<sora
	gen ombrr=""
	replace ombrr="nhpi" if (racnh==1 | racpi==1)
	replace ombrr="black" if racblk==1 & ombrr==""
	replace ombrr="aian" if racaian==1 & ombrr==""
	replace ombrr="asian" if racasn==1 & ombrr==""
	replace ombrr="hisp" if hisp>1 & ombrr==""
	replace ombrr="white" if racwht==1 & ombrr==""
	replace ombrr="other" if racsor==1 & ombrr=="" // nh+sora
	version 13: table ombrr, contents(sum pwt2) format(%10.0fc) row
	encode ombrr, gen(ombrrn) // alpha order 1=n 2=a 3=b 4=h 5=p 6=o 7=w
	// CHECK
	*set seed 13371701 
	*survwgt poststratify pwt2, by(state county) totvar(totpop_e) replace
	version 13: table county if state=="41", contents(sum pwgtp sum pwt1 sum pwt2 mean totpop) format(%7.0fc) row // pwt2 matches ACS SF.
	** may need to be careful after; if ACS says nobody of that race, or if the ACS 5yr PUMS has nobody, it will break.
	// CLEAN and SAVE
	drop fa0004_male-fdisabn_a6599_h // drop flags for eligible control populations, no longer needed after rake
	drop a0514_male_e-a0004_female_m // drop control totals, no longer needed after rake
	egen byte agecat=cut(agep),at(0,5,15,18,20,25,30,40,50,60,65,99)
	destring state, replace
	replace county=state*1000+county
	compress
	// define sample weights
	svyset [iw=pwt2], sdr(pwgtp1-pwgtp80) vce(sdr)
	gen byte one=1 
	save 05_ipf_pums_v01.dta, replace
end
* realdfile

// check totals
/*
use 05_ipf_pums_v01.dta, clear
svy: total one, over(county)
mat table=table
preserve
drop _all
svmat table, names(dat) 
xpose, clear
ren v1 b
ren v2 se
ren v3 z
ren v4 pvalue
ren v5 ll
ren v6 ul
ren v7 df
ren v8 crit
ren v9 eform
gen coalpha=_n
* OK
restore
*/

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

// totals by detailed age/sex
use county sex agecat pwt* pwgtp* one using 05_ipf_pums_v01.dta, clear
fillin county sex agecat
qui for var pwt2 pwgtp1-pwgtp80: replace X=0 if X==.
drop _fillin
mat master=J(1,12,.)
matrix colnames master="county" "sex" "agecat" "b" "se" "z" "p" "ll" "ul" "df" "crit" "eform"
levelsof agecat, local(ages)
forvalues s=1/2 {
	foreach a of local ages {
		svy: total one if agecat==`a' & sex==`s', over(county)
		mat table=r(table)
		mat table=table'
		mata: st_matrix("county", range(1,37,1))
		mat sex=J(37,1,`s')
		mat agecat=J(37,1,`a')
		mat result=county,sex,agecat,table
		mat master=master\result
	}
}
drop _all
svmat master, names(col)
save results_agesex.dta, replace
** clean for excel export
drop if county==.
keep county sex agecat b
reshape wide b, i(county agecat) j(sex)
rename *1 *male
rename *2 *female
reshape wide bmale bfemale, i(county) j(agecat)
order county bmale* bfemale*

// totals by OMB rarest race/ethnicity and age/sex
use county sex ombrrn agecat pwt* pwgtp* one using 05_ipf_pums_v01.dta, clear
fillin county sex ombrrn agecat
qui for var pwt2 pwgtp1-pwgtp80: replace X=0 if X==.
drop _fillin
mat master=J(1,13,.)
mat colnames master="county" "sex" "ombrrn" "agecat" "b" "se" "z" "p" "ll" "ul" "df" "crit" "eform"
levelsof agecat, local(ages)
forvalues s=1/2 {
	forvalues r=1/7 {
		foreach a of local ages {
			ereturn clear
			svy sdr: total one if agecat==`a' & sex==`s' & ombrrn==`r', over(county) 
			mat table=r(table)
			mat table=table'
			mata: st_matrix("county", range(1,37,1))
			mat sex=J(37,1,`s')
			mat ombrrn=J(37,1,`r')
			mat agecat=J(37,1,`a')
			mat result=county,sex,ombrrn,agecat,table
			mat master=master\result
		}
	}
}
drop _all
svmat master, names(col)
lab def ombrr 1 "aian" 2 "asian" 3 "black" 4 "hispanic" 5 "nhpi" 6 "other" 7 "white", replace
label values ombrr ombrr
decode ombrrn, gen(ombrr)
drop ombrrn
save results_agesex_ombrr.dta, replace
** clean for excel export
drop if county==.
keep county sex ombrr agecat b
reshape wide b, i(county agecat ombrr) j(sex)
rename *1 *male
rename *2 *female
reshape wide bmale bfemale, i(county agecat) j(ombrr) string
reshape wide bmale* bfemale*, i(county) j(agecat) 
order county bmaleaian* bmaleasian* bmaleblack* bmalehispanic* bmalenhpi* bmaleother* bmalewhite* ///
	bfemaleaian* bfemaleasian* bfemaleblack* bfemalehispanic* bfemalenhpi* bfemaleother* bfemalewhite* 

// totals by REALD primary race and age/sex
use county sex reldpri agecat pwt* pwgtp* one using 05_ipf_pums_v01.dta, clear
fillin county sex reldpri agecat
qui for var pwt2 pwgtp1-pwgtp80: replace X=0 if X==. 
drop _fillin
encode reldpri, gen(reldprin)
mat master=J(1,13,.)
mat colnames master="county" "sex" "reldprin" "agecat" "b" "se" "z" "p" "ll" "ul" "df" "crit" "eform"
levelsof agecat, local(ages)
forvalues s=1/2 {
	if `s'==1 local slbl="male"
	if `s'==2 local slbl="female"
	forvalues r=1/37 {
		local rlbl: label reldprin `r'
		nois di _newline ". Now running: Sex: `slbl' REALD: `rlbl' Age: " _cont
		foreach a of local ages {
			nois di "`a'." _cont
			ereturn clear
			nois cap svy sdr: total one if agecat==`a' & sex==`s' & reldprin==`r', over(county) 
			if _rc mat table=J(9,37,0)
			else mat table=r(table)
			mat table=table'
			mata: st_matrix("county", range(1,37,2))
			mat sex=J(37,1,`s')
			mat reldprin=J(37,1,`r')
			mat agecat=J(37,1,`a')
			mat result=county,sex,reldprin,agecat,table
			mat master=master\result
		}
	}
}
drop _all
svmat master, names(col)
label values reldprin reldprin
decode reldprin, gen(reldpri)
drop reldprin
save results_agesex_reldpri.dta, replace
** clean for excel export
drop if county==.
keep county sex reldpri agecat b
reshape wide b, i(county agecat reldpri) j(sex)
rename *1 *male
rename *2 *female
levelsof reldpri, local(levels)
reshape wide bmale bfemale, i(county agecat) j(reldpri) string
reshape wide bmale* bfemale*, i(county) j(agecat) 
order *, seq
order county
foreach l of local levels {
	egen b`l'=rowtotal(bfemale`l'* bmale`l'*)
}
browse county bAfrAm-bWhiteOth

// totals by disability
// totals by LEP/language


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


