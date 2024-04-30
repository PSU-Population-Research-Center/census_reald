** project: census_reald
** purpose: adjust pums data for agreement with marginal totals by county from controls, and export tabulations
** author: sharygin@pdx.edu
/* notes:
	- prerequisites:
		- controldata_YYYY.dta = control totals by county from ACS tables for year YYYY (from 02_prep_control.do)
		- 5ACS`y'_ORWA_RELDPRI.dta = 5-year ACS pums for period ending YY (from 03_prep_pums.do)
		- Census API key stored in "censuskey.txt"
		- subdirectory "results" for saving tabulations
		- subdirectory "temp" for storing control totals
	- outputs:
		- 5ACS`y'_ORWA_RELDPRI_raceeth.dta = ACS pums with person weights consistent with county totals by age/sex and OMB race/eth
		- 5ACS`y'_ORWA_RELDPRI_disaby.dta = as above, but consistent by OHA-derived disability status and age/sex
		- 5ACS`y'_ORWA_RELDPRI_lang.dta = as above, but additionally consistent by language spoken at home for LEP population by age/sex
		- temp/control_***_tmp.dta = temporary files
		- results/results_***_`y'.dta = tabulations of REALD traits by county and age group
	- to run
		- run after 03_prep_pums.do
		- run after 04_langxwalk.dta has been updated
	- TBD: modify regions as needed to reflect change in 2020 pumas
	- TBD: add program to cleanup temporary files
	- TBD: incorporate code from language analysis as a separate dofile or module within this file
	- TBD: add error metric for tracking iterations in disability reweighting to aid decision on # of iterations
	- TBD: consider adding 06-10 PUMS for small counties only to inflate representation of rare conditions (especially languages)
changelog: ~ timestamp for deliverables from 2024-04-------
	v09: changing donor dataset to be broader time and geography PUMS 
	v08: adding dummy exposure from older ACS PUMS instead of synthetic obs 
	v07: adding empty persons to ensure successful language rake 
	v06: converted blocks to functions and updated filenames/paths; added place for language analysis (WIP)
	v05: fixed disability code ~ timestamp for deliverables from 2024-01-16
	v04: wip to add disability
	v03: wip to add disbaility
	v02: change to faster, consistent totals by county
	v01: first version, sequential totals 1/36
*/

// setup
if "$censuskey"=="" {
	import delim using "censuskey.txt", varn(nonames) clear
	qui levelsof v1, clean local(censuskey)
	global ckey "`censuskey'"
}
foreach p in "survwgt" "censusapi" {
	cap which `p'
	if _rc ssc install `p'
}

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
 	  + LEP speakers by selected languages: (appx ~19 columns) * 6 (age summaries only) = 114 cols.
		FYI, preferred language used by OHA is a different concept ~~ not akin to ACS
		FYI, bilingualism with languages other than English is not captured
		FYI, Chinese includes Mandarin/Cantonese and Persian includes Farsi/Dari; can be split by place of birth.
		which priority languages: ?? ~130 in PUMS. ?? ~11 in OHA list?? ~28/37/58 in SOS list (>500/>300/>100 speakers)
		>> use SOS counts as controls instead of table B16001 ~~ top 10 in at least one county AND >100 speakers; 
			language list (19): spanish, vietnamese, chinese, korean, russian, thai, arabic, tagalog, ukrainian, french
				japanese, romanian, italian, burmese, marshallese, somali, hindi, khmer, persian
*/

/*** part 1
 *                                                 __                                                                             _..._                               __                                               
 *                                                / /\                                                                         .-'_..._''.                           / /\                                              
 *                           __.....__           / /  '        __.....__                                                     .' .'      '.\     __.....__           / /  ' .        .--.       _________   _...._      
 *               .--./)  .-''         '.        / /  /     .-''         '.                                                  / .'            .-''         '.        / /  /.'|        |__|       \        |.'      '-.   
 *              /.''\\  /     .-''"'-.  `.     / /  /     /     .-''"'-.  `.                    .-.    .-,.--.             . '             /     .-''"'-.  `.     / /  /<  |        .--.        \        .'```'.    '. 
 *        __   | |  | |/     /________\   \   / /  /     /     /________\   \ ____     _____    | |    |  .-. |       __   | |            /     /________\   \   / /  /  | |        |  |         \      |       \     \
 *     .:--.'.  \`-' / |                  |  / /  /   _  |                  |`.   \  .'    /,---| |---.| |  | |    .:--.'. | |            |                  |  / /  /   | | .'''-. |  |     _    |     |        |    |
 *    / |   \ | /("'`  \    .-------------' / /  /  .' | \    .-------------'  `.  `'    .' `---| |---'| |  | |   / |   \ |. '            \    .-------------' / /  /    | |/.'''. \|  |   .' |   |      \      /    . 
 *    `" __ | | \ '---. \    '-.____...---./ /  /  .   | /\    '-.____...---.    '.    .'       | |    | |  '-    `" __ | | \ '.          .\    '-.____...---./ /  /     |  /    | ||  |  .   | / |     |\`'-.-'   .'  
 *     .'.''| |  /'""'.\ `.             .'/ /  / .'.'| |// `.             .'     .'     `.      `-'    | |         .'.''| |  '. `._____.-'/ `.             .'/ /  /      | |     | ||__|.'.'| |// |     | '-....-'`    
 *    / /   | |_||     ||  `''-...... -' /_/  /.'.'.-'  /    `''-...... -'     .'  .'`.   `.           | |        / /   | |_   `-.______ /    `''-...... -' /_/  /       | |     | |  .'.'.-'  / .'     '.             
 *    \ \._,\ '/\'. __//                 \ \ / .'   \_.'                     .'   /    `.   `.         |_|        \ \._,\ '/            `                   \ \ /        | '.    | '. .'   \_.''-----------'           
 *     `--'  `"  `'---'                   --'                               '----'       '----'                   _`--'  `"                                  --'         '---'   '---'                                 
 */

// generate raked file: age/sex and race-eth by age/sex
** TBD: rewrite such that no need to use the prep-control dofile.
** following disaby format: pull only tables b01001 and b01001a-i 
cap prog drop realdfile
prog def realdfile
	local year=`1'
	local y=substr("`year'",3,2)
	// LOAD pums data from prior step and ADD control totals
	use 5ACS`y'_ORWA_RELDPRI.dta, clear 
	merge m:1 year state county using temp/controldata_`year'.dta, assert(3) nogen
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
	version 13: table county if state=="41", contents(sum pwgtp sum pwt1 sum pwt2 mean totpop_e) format(%7.0fc) row // pwt2 matches ACS SF.
	// CLEAN and SAVE
	for any "fa*" "ft*" "fd*" "fl*": cap drop X // drop flags for eligible control populations
	for any "a*_*" "l*_*" "d*_*": cap drop X // drop control totals
	egen byte agecat=cut(agep),at(0,5,15,18,20,25,30,40,50,60,65,99)
	destring state, replace
	replace county=state*1000+county
	compress
	// define sample weights
	svyset [iw=pwt2], sdr(pwgtp1-pwgtp80) vce(sdr)
	gen byte one=1 
	save 5ACS`y'_ORWA_RELDPRI_raceeth.dta, replace
end
*realdfile 2020 

// check total population per county
cap prog drop chkTotal
prog def chkTotal
	local y=substr("`1'",3,2)
	use 5ACS`y'_ORWA_RELDPRI_raceeth.dta, clear
	svy: total one, over(county)
	mat table=r(table)
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
	pause on
	pause
	restore
end
*chkTotal 2020

// totals by detailed age/sex
capture prog drop tabSex
prog def tabSex
	cap use results/results_agesex_`1'.dta, clear
	if _rc {
		local y=substr("`1'",3,2)
		use county sex agecat pwt* pwgtp* one using 5ACS`y'_ORWA_RELDPRI_raceeth.dta, clear
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
		save results/results_agesex_`1'.dta, replace
	}
	** clean for excel export
	drop if county==.
	keep county sex agecat b
	reshape wide b, i(county agecat) j(sex)
	rename *1 *male
	rename *2 *female
	reshape wide bmale bfemale, i(county) j(agecat)
	order county bmale* bfemale*
end
*tabSex 2020

// totals by OMB rarest race/ethnicity and age/sex (don't need by sex, but retaining)
capture prog drop tabReldRR
prog def tabReldRR
	cap use results/results_agesex_ombrr_`1'.dta, clear
	if _rc {
		local y=substr("`1'",3,2)
		use county sex ombrrn agecat pwt* pwgtp* one using 5ACS`y'_ORWA_RELDPRI_raceeth.dta, clear
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
		save results/results_agesex_ombrr_`1'.dta, replace
	}
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
end
*tabReldRR 2020

// totals by REALD primary race and age/sex (don't need by sex, but retaining)
cap prog drop tabReldPri
prog def tabReldPri
	cap use results/results_agesex_reldpri_`1'.dta, clear
	if _rc {
		local y=substr("`1'",3,2)
		use county sex reldpri agecat pwt* pwgtp* one using 5ACS`y'_ORWA_RELDPRI_raceeth.dta, clear
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
					mata: st_matrix("county", range(1,37,1))
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
		save results/results_agesex_reldpri_`1'.dta, replace
	}
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
end
*tabReldPri 2020

/*** part 2
 *                                                                                     
 *    _______                                           .---.                          
 *    \  ___ `'.   .--.                   /|        .--.|   |.--.                      
 *     ' |--.\  \  |__|                   ||        |__||   ||__|      .-.          .- 
 *     | |    \  ' .--.                   ||        .--.|   |.--.     .|\ \        / / 
 *     | |     |  '|  |             __    ||  __    |  ||   ||  |   .' |_\ \      / /  
 *     | |     |  ||  |     _    .:--.'.  ||/'__ '. |  ||   ||  | .'     |\ \    / /   
 *     | |     ' .'|  |   .' |  / |   \ | |:/`  '. '|  ||   ||  |'--.  .-' \ \  / /    
 *     | |___.' /' |  |  .   | /`" __ | | ||     | ||  ||   ||  |   |  |    \ `  /     
 *    /_______.'/  |__|.'.'| |// .'.''| | ||\    / '|__||   ||__|   |  |     \  /      
 *    \_______|/     .'.'.-'  / / /   | |_|/\'..' /     '---'       |  '.'   / /       
 *                   .'   \_.'  \ \._,\ '/'  `'-'`                  |   /|`-' /        
 *                               `--'  `"                           `'-'  '..'         
 */
 
/* From Marjorie: For Disability:  
	Statewide and Regions: DA7compACSall DISDi; DA4cat 
	and the DAOICv2 vars where:  0 "Does not have this limitation" ; 1 "This limitation only" and  "2+ limitations".   
	At a county level – for very small counties… the same except likely DA7compACSall – please advise after you can run some tables…
*/ 

// obtain control totals by age/sex/disaby
cap prog drop disabyControls
prog def disabyControls
	local year=`1' // won't be persistent, because tokenizing within program
	local y=substr("`1'",3,2)
	foreach t in "dis 18101" "dear 18102" "deye 18103" "drem 18104" "dphy 18105" "ddrs 18106" "dout 18107" { 
		tokenize `t'
		tempfile tmp
		local T="B`2'"
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:*&in=state:41")
		save `tmp', replace
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:011&in=state:53")
		append using `tmp'
		rename b`2'_*e e*
		#delimit ;
		if "`1'"=="dout" { ; // 3 age groups;
			gen `1'1_1834_1=e004; gen `1'1_1834_2=e017; gen `1'1_3564_1=e007;
			gen `1'1_3564_2=e020; gen `1'1_6599_1=e010+e013; gen `1'1_6599_2=e023+e026;
			gen `1'2_1834_1=e005; gen `1'2_1834_2=e018; gen `1'2_3564_1=e008;
			gen `1'2_3564_2=e021; gen `1'2_6599_1=e011+e014; gen `1'2_6599_2=e024+e027;	};
		else if inlist("`1'","ddrs","dphy","drem") { ; // 4 age groups;
			gen `1'1_0517_1=e004; gen `1'1_1834_1=e007; gen `1'1_3564_1=e010; gen `1'1_6599_1=e013+e016;
			gen `1'2_0517_1=e005; gen `1'2_1834_1=e008;	gen `1'2_3564_1=e011; gen `1'2_6599_1=e014+e017;
			gen `1'1_0517_2=e020; gen `1'1_1834_2=e023; gen `1'1_3564_2=e026; gen `1'1_6599_2=e029+e032;
			gen `1'2_0517_2=e021; gen `1'2_1834_2=e024; gen `1'2_3564_2=e027; gen `1'2_6599_2=e030+e033; };
		else if inlist("`1'","deye","dear","dis") { ; // 5 age groups;
			gen `1'1_0004_1=e004; gen `1'1_0517_1=e007; gen `1'1_1834_1=e010; gen `1'1_3564_1=e013; gen `1'1_6599_1=e016+e019;
			gen `1'2_0004_1=e005; gen `1'2_0517_1=e008;	gen `1'2_1834_1=e011; gen `1'2_3564_1=e014;	gen `1'2_6599_1=e017+e020;
			gen `1'1_0004_2=e023; gen `1'1_0517_2=e026; gen `1'1_1834_2=e029; gen `1'1_3564_2=e032; gen `1'1_6599_2=e035+e038;
			gen `1'2_0004_2=e024; gen `1'2_0517_2=e027; gen `1'2_1834_2=e030; gen `1'2_3564_2=e033; gen `1'2_6599_2=e036+e039; };
		#delimit cr
		tostring state, replace format(%02.0f) 
		tostring county, replace format(%03.0f)
		gen stcofips=state+county
		keep stcofips `1'1_* `1'2_*
		reshape long `1'1_@_1 `1'1_@_2 `1'2_@_1 `1'2_@_2, i(stcofips) j(agecat) string
		reshape long `1'1__@ `1'2__@, i(stcofips agecat) j(sex)
		reshape long `1'@__, i(stcofips agecat sex) j(`1')
		ren `1'__ `1'_n // clearly label population count variable
		rename agecat agec5
		egen `1'1_tot=sum(`1'_n) if `1'==1, by(stcofips)
		gen int year=`year' 
		*collapse (sum) `1'_n, by(stcofips year agec5 `1') // don't need sex detail
		save temp/control_`1'_tmp.dta, replace // merge by state county year agec5 `i'(1=yes/2=no/.=na)
	}
	// obtain control totals by age/n_of_disaby
		tempfile tmp
		local T="C18108"
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:*&in=state:41")
		save `tmp', replace
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:011&in=state:53")
		append using `tmp'
		rename c18108_*e e*
		gen dnum1_0017=e003
		gen dnum2_0017=e004
		gen dnum0_0017=e005
		gen dnum1_1864=e007
		gen dnum2_1864=e008
		gen dnum0_1864=e009
		gen dnum1_6599=e011
		gen dnum2_6599=e012
		gen dnum0_6599=e013
		tostring state, replace format(%02.0f) 
		tostring county, replace format(%03.0f)
		gen stcofips=state+county
		keep stcofips dnum*
		reshape long dnum0_@ dnum1_@ dnum2_@, i(stcofips) j(agecat) string
		reshape long dnum@_, i(stcofips agecat) j(dnum)
		ren dnum_ dnum_n
		ren agecat agec3
		egen dnum2tot=sum(dnum_n) if dnum==2, by(stcofips)
		gen int year=`year'
		save temp/control_dnum_tmp.dta, replace
	// obtain control totals by detailed age/sex
		tempfile tmp
		local T="B01001"
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:*&in=state:41")
		save `tmp', replace
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:011&in=state:53")
		append using `tmp'
		gen a_0004_1=b01001_003e
		gen a_0514_1=b01001_004e+b01001_005e
		gen a_1517_1=b01001_006e
		gen a_1819_1=b01001_007e
		gen a_2024_1=b01001_008e+b01001_009e+b01001_010e
		gen a_2529_1=b01001_011e
		gen a_3039_1=b01001_012e+b01001_013e
		gen a_4049_1=b01001_014e+b01001_015e
		gen a_5059_1=b01001_016e+b01001_017e
		gen a_6064_1=b01001_018e+b01001_019e
		gen a_6599_1=b01001_020e+b01001_021e+b01001_022e+b01001_023e+b01001_024e+b01001_025e
		gen a_0004_2=b01001_027e
		gen a_0514_2=b01001_028e+b01001_029e
		gen a_1517_2=b01001_030e
		gen a_1819_2=b01001_031e
		gen a_2024_2=b01001_032e+b01001_033e+b01001_034e
		gen a_2529_2=b01001_035e
		gen a_3039_2=b01001_036e+b01001_037e
		gen a_4049_2=b01001_038e+b01001_039e
		gen a_5059_2=b01001_040e+b01001_041e
		gen a_6064_2=b01001_042e+b01001_043e
		gen a_6599_2=b01001_044e+b01001_045e+b01001_046e+b01001_047e+b01001_048e+b01001_049e
		tostring state, replace format(%02.0f) 
		tostring county, replace format(%03.0f)
		gen stcofips=state+county
		keep stcofips a_*
		reshape long a_0004_ a_0514_ a_1517_ a_1819_ a_2024_ a_2529_ a_3039_ a_4049_ a_5059_ a_6064_ a_6599_, i(stcofips) j(sex)
		reshape long a_@_, i(stcofips sex) j(agecat) string
		egen atot=sum(a__), by(stcofips)
		ren a__ a_n // N by age
		rename agecat agec11
		gen int year=`year'
		*collapse (sum) a_n, by(stcofips year agec11)
		save temp/control_age_tmp.dta, replace
end
*disabyControls 2020

// LOAD pums data; ADD disability control totals
capture prog drop disabyFile
prog def disabyFile
	local year=`1'
	local y=substr("`1'",3,2)
	use state county sex agep dis deye dear ddrs dphy drem dout disdi da4cat da7compacsall d*oicv2 pwgtp* using 5ACS`y'_ORWA_RELDPRI.dta, clear 
	gen stcofips=state+county
	drop state county
	gen int year=`year'
	gen agec5=""
	replace agec5="0004" if inrange(agep,0,4)
	replace agec5="0517" if inrange(agep,5,17)
	replace agec5="1834" if inrange(agep,18,34)
	replace agec5="3564" if inrange(agep,35,64)
	replace agec5="6599" if inrange(agep,65,99)
	// fillin possible demographics that don't exist in the PUMS, so that avoid merge fail with controls.
	foreach d in  "dis" "dear" "deye" "dphy" "drem" "ddrs" "dout"  { //  
		fillin stcofips year sex agec5 `d'
		drop if _fillin==1 & `d'==.
		drop if _fillin==1 & inlist("`d'","drem","dphy","ddrs") & agec5=="0004" // drop <5 value of agec5 for these (uses 4/5)
		drop if _fillin==1 & "`d'"=="dout" & agep<18 & inlist(agec5,"0004","0517") // drop <18 value of agec5 for these (uses 3/5)
		qui for var pwgtp pwgtp1-pwgtp80: replace X=0 if _fillin
		sum _fillin, mean
		if `r(max)'==1 {
			levelsof agec5 if _fillin, local(ages) clean
			** impute missing ages
			foreach a of local ages {
				sum agep if agec5=="`a'" & `d'==1 [fw=pwgtp] 
				cap replace agep=round(`r(mean)') if _fillin==1 & agec5=="`a'"
				if _rc drop if _fillin==1 & agec5=="`a'" 
			}
			** update agec5
			replace agec5="0004" if _fillin==1 & inrange(agep,0,4) 
			replace agec5="0517" if _fillin==1 & inrange(agep,5,17)
			replace agec5="1834" if _fillin==1 & inrange(agep,18,34)
			replace agec5="3564" if _fillin==1 & inrange(agep,35,64)
			replace agec5="6599" if _fillin==1 & inrange(agep,65,99)
			** update dis/disdi
			replace dis=`d' if _fillin==1 
			replace disdi=(`d'-2)*-1 if _fillin==1 
			** update da4/da7/d*oic
			if "`d'"=="dis" {
				replace da4cat=1 if _fillin==1 & `d'==1 
				replace da4cat=0 if _fillin==1 & `d'==2
				replace da7compacsall=1 if (_fillin==1 & `d'==1) 
				replace da7compacsall=0 if (_fillin==1 & `d'==2) 
				for any "deye" "dear": replace X=2 if _fillin \\ replace Xoicv2=0 if _fillin
				for any "dphy" "drem" "ddrs": replace X=2 if _fillin & agep>=5 \\ replace Xoicv2=0 if _fillin & agep>=5
				for any "dout": replace X=2 if _fillin & agep>=18 \\ replace Xoicv2=0 if _fillin & agep>=18
			}
			if "`d'"=="dear" {
				replace `d'oicv2=(`d'-2)*-1 if _fillin==1 
				replace da4cat=1 if _fillin==1 & `d'==1 
				replace da4cat=0 if _fillin==1 & `d'==2
				replace da7compacsall=1 if (_fillin==1 & `d'==1) 
				replace da7compacsall=0 if (_fillin==1 & `d'==2) 
				for any "deye": replace X=2 if _fillin \\ replace Xoicv2=0 if _fillin
				for any "dphy" "drem" "ddrs": replace X=2 if _fillin & agep>=5 \\ replace Xoicv2=0 if _fillin & agep>=5
				for any "dout": replace X=2 if _fillin & agep>=18 \\ replace Xoicv2=0 if _fillin & agep>=18
			}
			if "`d'"=="deye" {
				replace `d'oicv2=(`d'-2)*-1 if _fillin==1
				replace da4cat=1 if _fillin==1 & `d'==1 
				replace da4cat=0 if _fillin==1 & `d'==2
				replace da7compacsall=2 if (_fillin==1 & `d'==1) 
				replace da7compacsall=0 if (_fillin==1 & `d'==2) 
				for any "dear": replace X=2 if _fillin \\ replace Xoicv2=0 if _fillin
				for any "dphy" "drem" "ddrs": replace X=2 if _fillin & agep>=5
				for any "dout": replace X=2 if _fillin & agep>=18
			}
			if "`d'"=="dphy" {
				replace `d'oicv2=(`d'-2)*-1 if _fillin==1
				replace da4cat=1 if _fillin==1 & `d'==1 
				replace da4cat=0 if _fillin==1 & `d'==2
				replace da7compacsall=3 if (_fillin==1 & `d'==1) 
				replace da7compacsall=0 if (_fillin==1 & `d'==2) 
				for any "deye" "dear": replace X=2 if _fillin \\ replace Xoicv2=0 if _fillin
				for any "drem" "ddrs": replace X=2 if _fillin \\ replace Xoicv2=0 if _fillin
				for any "dout": replace X=2 if _fillin & agep>=18 \\ replace Xoicv2=0 if _fillin & agep>=18
			}
			if "`d'"=="drem" {
				replace `d'oicv2=(`d'-2)*-1 if _fillin==1
				replace da4cat=1 if _fillin==1 & `d'==1 
				replace da4cat=0 if _fillin==1 & `d'==2
				replace da7compacsall=4 if (_fillin==1 & `d'==1) 
				replace da7compacsall=0 if (_fillin==1 & `d'==2) 
				for any "deye" "dear": replace X=2 if _fillin \\ replace Xoicv2=0 if _fillin
				for any "dphy" "ddrs": replace X=2 if _fillin \\ replace Xoicv2=0 if _fillin
				for any "dout": replace X=2 if _fillin & agep>=18 \\ replace Xoicv2=0 if _fillin & agep>=18
			}
			if "`d'"=="ddrs" {
				replace `d'oicv2=(`d'-2)*-1 if _fillin==1
				replace da4cat=3 if _fillin==1 & `d'==1 
				replace da4cat=0 if _fillin==1 & `d'==2
				replace da7compacsall=6 if (_fillin==1 & `d'==1) 
				replace da7compacsall=0 if (_fillin==1 & `d'==2) 
				for any "deye" "dear": replace X=2 if _fillin \\ replace Xoicv2=0 if _fillin
				for any "drem" "dphy": replace X=2 if _fillin \\ replace Xoicv2=0 if _fillin
				for any "dout": replace X=2 if _fillin & agep>=18 \\ \\ replace Xoicv2=0 if _fillin & agep>=18
			}
			if "`d'"=="dout" {
				replace `d'oicv2=(`d'-2)*-1 if _fillin==1
				replace da4cat=3 if _fillin==1 & `d'==1 
				replace da4cat=0 if _fillin==1 & `d'==2
				replace da7compacsall=6 if (_fillin==1 & `d'==1) 
				replace da7compacsall=0 if (_fillin==1 & `d'==2) 
				for any "deye" "dear": replace X=2 if _fillin \\ replace Xoicv2=0 if _fillin
				for any "drem" "dphy" "ddrs": replace X=2 if _fillin \\ replace Xoicv2=0 if _fillin
			}
			** update year
			replace year=`year' if _fillin==1
		}
		drop _fillin
	}
	** detailed agecat
	gen agec11=""
	replace agec11="0004" if inrange(agep,0,4)
	replace agec11="0514" if inrange(agep,5,14)
	replace agec11="1517" if inrange(agep,15,17)
	replace agec11="1819" if inrange(agep,18,19)
	replace agec11="2024" if inrange(agep,20,24)
	replace agec11="2529" if inrange(agep,25,29)
	replace agec11="3039" if inrange(agep,30,39)
	replace agec11="4049" if inrange(agep,40,49)
	replace agec11="5059" if inrange(agep,50,59)
	replace agec11="6064" if inrange(agep,60,64)
	replace agec11="6599" if inrange(agep,65,99)
	** count num of disabilities (0-1-2+ by agec3)
	for var ddrs dear deye dout dphy drem: gen Xd=X*-1+2 // convert 1=y,2=n into 0=n,1=y
	egen dnum=rowtotal(ddrsd deard deyed doutd dphyd dremd)
	replace dnum=1 if dis==1 & dnum==0
	tab dnum dis
	replace dnum=2 if dnum>2 & dnum<. 
	drop ddrsd deard deyed doutd dphyd dremd
	gen agec3="0017" if inrange(agep,0,17)
	replace agec3="1864" if inrange(agep,18,64)
	replace agec3="6599" if inrange(agep,65,99)
	fillin stcofips agec3 dnum 
	drop if agec3=="" & _fillin==1
	assert _fillin==0
	drop _fillin
	** add control totals by disability
	foreach d in  "dis" "dear" "deye" "dphy" "drem" "ddrs" "dout" { 
		merge m:1 stcofips year sex agec5 `d' using temp/control_`d'_tmp.dta, assert(1 3) nogen
	}
	** add control totals by dnum
	merge m:1 stcofips year agec3 dnum using temp/control_dnum_tmp.dta, assert(3) nogen 
	** add control totals by age/sex
	merge m:1 stcofips year sex agec11 using temp/control_age_tmp.dta, assert(3) nogen
	// RAKE by detailed age/sex (gen pwt1) THEN by age/numdis THEN by age/sex/dis (gen pwt2)
	set seed 1337170
	survwgt poststratify pwgtp, by(stcofips agec11 sex) totvar(a_n) gen(pwt1)
	set seed 1337170
	survwgt poststratify pwt1, by(stcofips agec3 dnum) totvar(dnum_n) gen(pwt2)
	set seed 1337170
	survwgt poststratify pwt2, by(stcofips agec5 sex dis) totvar(dis_n) gen(pwt3)
	replace pwt3=0 if pwt3==.
	// RAKE by specific conditions ~ starting with n=4th iteration, minimum 6 further iterations.
	local i=4 // starting number
	qui while `i'<=30 { // ending number (end-start = N iterations)
		local h=`i'-1
		clonevar pwt`i'=pwt`h'
		set seed 1337170
		survwgt poststratify pwt`i' if deye<., by(stcofips agec5 sex deye) totvar(deye_n) gen(tmp)
		replace pwt`i'=tmp if deye<.
		drop tmp
		set seed 1337170
		survwgt poststratify pwt`i' if dear<., by(stcofips agec5 sex dear) totvar(dear_n) gen(tmp)
		replace pwt`i'=tmp if dear<. 
		drop tmp
		set seed 1337170
		survwgt poststratify pwt`i' if dphy<. & agep>=5, by(stcofips agec5 sex dphy) totvar(dphy_n) gen(tmp)
		replace pwt`i'=tmp if dphy<. & agep>=5
		drop tmp
		set seed 1337170
		survwgt poststratify pwt`i' if drem<. & agep>=5, by(stcofips agec5 sex drem) totvar(drem_n) gen(tmp)
		replace pwt`i'=tmp if drem<. & agep>=5
		drop tmp
		set seed 1337170
		survwgt poststratify pwt`i' if ddrs<. & agep>=5, by(stcofips agec5 sex ddrs) totvar(ddrs_n) gen(tmp)
		replace pwt`i'=tmp if ddrs<. & agep>=5
		drop tmp
		set seed 1337170
		survwgt poststratify pwt`i' if dout<. & agep>=18, by(stcofips agec5 sex dout) totvar(dout_n) gen(tmp)
		replace pwt`i'=tmp if dout<. & agep>=18
		drop tmp
		set seed 1337170
		survwgt poststratify pwt`i', by(stcofips agec11 sex) totvar(a_n) replace
		set seed 1337170
		survwgt poststratify pwt`i', by(stcofips agec3 dnum) totvar(dnum_n) replace
		set seed 1337170
		survwgt poststratify pwt`i', by(stcofips agec5 sex dis) totvar(dis_n) replace
		replace pwt`i'=0 if pwt`i'==.
		nois di "iteration: `i' (MAE=X)" 
		version 13: nois table stcofips if deye==1, contents(sum pwgtp sum pwt3 sum pwt`h' sum pwt`i' mean deye1_tot) 
		local ++i
	}
	// CHECK totals (and also check whether any improvement from more iterations)
	**	pwt1=original pwt3=after age/sex/dis rake pwt4=after first condition specific rake pwt30=after 30 rounds of condition specific rake
		version 13: table stcofips, contents(sum pwt1 sum pwt3 sum pwt4 sum pwt30 mean atot) 
		version 13: table stcofips if dis==1, contents(sum pwgtp sum pwt3 sum pwt4 sum pwt30 mean dis1_tot) 
	// repeat RAKE by detailed age/sex to ensure consistent totals
		*set seed 1337170
		*survwgt poststratify pwt2, by(state county agec11 sex) totvar(a_n) gen(pwt1)
	// CLEAN and SAVE
		keep stcofips sex d* agep atot a_n dis_n pwt1 pwt2 pwt3 pwt30 pwgtp* agec5 agec3
		egen byte agecat=cut(agep),at(0,5,15,18,20,25,30,40,50,60,65,99)
		destring stcofips, replace // svy total, over(X) requires num.
		svyset [iw=pwt30], sdr(pwgtp1-pwgtp80) vce(sdr) // pwt3: agesex->dnum->disdi pwt4: +conditions.
		compress
		save 5ACS`y'_ORWA_RELDPRI_disaby.dta, replace
end
disabyFile 2020

// tables by disdi
cap prog drop tabdisdi
prog def tabdisdi
	cap use results/results_disdi_`1'.dta, clear
	if _rc {
		local y=substr("`1'",3,2)
		use 5ACS`y'_ORWA_RELDPRI_disaby.dta, clear
		mat master=J(1,13,.)
		mat colnames master="stcofips" "sex" "disdi" "agecat" "b" "se" "z" "p" "ll" "ul" "df" "crit" "eform"
		sort stcofips agecat disdi
		fillin stcofips agecat disdi // rectangularize (to ensure 37 rows for each svy total results matrix)
		qui for var pwt3 pwgtp1-pwgtp80: replace X=0 if X==. 
		drop _fillin
		gen byte one=1 
		levelsof agecat, local(ages)
		qui forvalues d=0/1 {
			nois di _newline ". Disab: disdi:`d' | Age: " _cont
			foreach a of local ages {
				nois di "`a'." _cont
				ereturn clear
				svy sdr: total one if agecat==`a' & disdi==`d', over(stcofips) 
				mat table=r(table)
				mat table=table'
				mata: st_matrix("stcofips", range(1,37,1))
				mat sex=J(37,1,0)
				mat disdi=J(37,1,`d')
				mat agecat=J(37,1,`a')
				mat result=stcofips,sex,disdi,agecat,table
				mat master=master\result
			}
		}
		drop _all
		svmat master, names(col)
		save results/results_disdi_`1'.dta, replace
	}
	** clean for excel export
	drop if stcofips==.
	collapse (sum) b, by(stcofips disdi agecat)
	reshape wide b, i(stcofips agecat) j(disdi )
	rename b* disdi*_
	reshape wide disdi0_ disdi1_, i(stcofips) j(agecat) 
	order *, seq
	order stcofips
end
tabdisdi 2020

// tables by da4cat (none/one/two+/severe) 
cap prog drop tabda4
prog def tabda4
	cap use results/results_da4cat_`1'.dta, clear
	if _rc {
		local y=substr("`1'",3,2)
		use 5ACS`y'_ORWA_RELDPRI_disaby.dta, clear
		mat master=J(1,13,.)
		mat colnames master="stcofips" "sex" "da4cat" "agecat" "b" "se" "z" "p" "ll" "ul" "df" "crit" "eform"
		sort stcofips agecat da4cat
		fillin stcofips agecat da4cat // rectangularize (to ensure 37 rows for each svy total results matrix)
		qui for var pwt30 pwgtp1-pwgtp80: replace X=0 if X==. 
		drop _fillin
		gen byte one=1 
		levelsof agecat, local(ages)
		levelsof da4cat, local(ds)
		qui foreach d of local ds {
			nois di _newline ". Disab: da4cat:`d' | Age: " _cont
			foreach a of local ages {
				nois di "`a'." _cont
				if `d'==3 & `a'==0 { // no iadl/severe for age 0-4
					mat table=J(37,9,0)
				}
				else {
					svy sdr: total one if agecat==`a' & da4cat==`d', over(stcofips) 
					mat table=r(table)'
				}
				mata: st_matrix("stcofips", range(1,37,1))
				mat sex=J(37,1,0)
				mat da4cat=J(37,1,`d')
				mat agecat=J(37,1,`a')
				mat result=stcofips,sex,da4cat,agecat,table
				mat master=master\result
			}
		}
		drop _all
		svmat master, names(col)
		save results/results_da4cat_`1'.dta, replace
	}
	** clean for excel export
	drop if stcofips==.
	collapse (sum) b, by(stcofips da4cat agecat)
	reshape wide b, i(stcofips agecat) j(da4cat )
	rename b* da4cat*_
	reshape wide da4cat0_ da4cat1_ da4cat2_ da4cat3_, i(stcofips) j(agecat) 
	order *, seq
	order stcofips
end
tabda4 2020

// tables by da7compacsall 
capture prog drop tabda7
prog def tabda7
	cap use results/results_da7compacsall_`1'.dta, clear
	if _rc {
		local y=substr("`1'",3,2)
		use 5ACS`y'_ORWA_RELDPRI_disaby.dta, clear
		mat master=J(1,13,.)
		mat colnames master="stcofips" "sex" "da7compacsall" "agecat" "b" "se" "z" "p" "ll" "ul" "df" "crit" "eform"
		sort stcofips agecat da7compacsall
		fillin stcofips agecat da7compacsall // rectangularize (to ensure 37 rows for each svy total results matrix)
		qui for var pwt30 pwgtp1-pwgtp80: replace X=0 if X==. 
		drop _fillin
		gen byte one=1 
		levelsof agecat, local(ages)
		levelsof da7compacsall, local(ds)
		qui foreach d of local ds {
			nois di _newline ". Disab: da7compacsall:`d' | Age: " _cont
			foreach a of local ages {
				nois di "`a'." _cont
				if `a'==0 & inlist(`d',3,4,6) {
					mat table=J(37,9,0) // all zeros
				}
				else {
					svy sdr: total one if agecat==`a' & da7compacsall==`d', over(stcofips) 
					mat table=r(table)'
				}
				mata: st_matrix("stcofips", range(1,37,1))
				mat sex=J(37,1,0)
				mat da7compacsall=J(37,1,`d')
				mat agecat=J(37,1,`a')
				mat result=stcofips,sex,da7compacsall,agecat,table
				mat master=master\result
			}
		}
		drop _all
		svmat master, names(col)
		save results/results_da7compacsall_`1'.dta, replace
	}
	** clean for excel export
	drop if stcofips==.
	collapse (sum) b, by(stcofips da7compacsall agecat)
	reshape wide b, i(stcofips agecat) j(da7compacsall )
	rename b* da7compacsall*_
	reshape wide da7compacsall0_ da7compacsall1_ da7compacsall2_ da7compacsall3_ ///
				 da7compacsall4_ da7compacsall5_ da7compacsall6_, i(stcofips) j(agecat) 
	order *, seq
	order stcofips
end
tabda7 2020

// tables by d*oicv2 
capture prog drop tabdaoic
prog def tabdaoic
	local y=substr("`1'",3,2)
	use 5ACS`y'_ORWA_RELDPRI_disaby.dta, clear
	foreach v in "dear" "deye"  "dphy" "drem" "ddrs" "dout" {  
		cap confirm file results/results_`v'oicv2_`1'.dta
		if _rc {
			preserve
			mat master=J(1,13,.)
			mat colnames master="stcofips" "sex" "`v'oicv2" "agecat" "b" "se" "z" "p" "ll" "ul" "df" "crit" "eform"
			sort stcofips agecat `v'oicv2
			fillin stcofips agecat `v'oicv2 // rectangularize (to ensure 37 rows for each svy total results matrix)
			qui for var pwt30 pwgtp1-pwgtp80: replace X=0 if X==. 
			drop _fillin
			gen byte one=1 
			levelsof agecat, local(ages)
			forvalues d=0/2 {
				nois di _newline ". Disab: `v'oicv2:`d' | Age: " _cont
				qui foreach a of local ages {
					nois di "`a'." _cont
					if (`a'==0 & inlist("`v'","dphy","drem","ddrs","dout")) | ///
					   (`a'==5 & inlist("`v'","dout")) {
						mat table=J(37,9,0)
					}
					else {
						svy sdr: total one if agecat==`a' & `v'oicv2==`d', over(stcofips) 
						mat table=r(table)'
					}
					mata: st_matrix("stcofips", range(1,37,1))
					mat sex=J(37,1,0)
					mat `v'oicv2=J(37,1,`d')
					mat agecat=J(37,1,`a')
					mat result=stcofips,sex,`v'oicv2,agecat,table
					mat master=master\result
				}
			}
			drop one
			drop _all
			svmat master, names(col)
			save results/results_`v'oicv2_`1'.dta, replace
			restore
		}
	}
	** clean for excel export
	pause on
	foreach v in "dear" "deye" "dphy" "drem" "ddrs" "dout" {
		use if stcofips<. using results/results_`v'oicv2_`1'.dta, clear
		collapse (sum) b, by(stcofips `v'oicv2 agecat)
		reshape wide b, i(stcofips agecat) j(`v'oicv2 )
		rename b* `v'oicv2*_
		reshape wide `v'oicv20_ `v'oicv21_ `v'oicv22_, i(stcofips) j(agecat) 
		order *, seq
		order stcofips
		browse
		pause
	}
end
*tabdaoic 2020

	
	
/***
 *                                                                                         
 *    .---.                                                                                
 *    |   |             _..._                                               __.....__      
 *    |   |           .'     '.   .--./)                        .--./)  .-''         '.    
 *    |   |          .   .-.   . /.''\\                        /.''\\  /     .-''"'-.  `.  
 *    |   |    __    |  '   '  || |  | |                 __   | |  | |/     /________\   \ 
 *    |   | .:--.'.  |  |   |  | \`-' /      _    _   .:--.'.  \`-' / |                  | 
 *    |   |/ |   \ | |  |   |  | /("'`      | '  / | / |   \ | /("'`  \    .-------------' 
 *    |   |`" __ | | |  |   |  | \ '---.   .' | .' | `" __ | | \ '---. \    '-.____...---. 
 *    |   | .'.''| | |  |   |  |  /'""'.\  /  | /  |  .'.''| |  /'""'.\ `.             .'  
 *    '---'/ /   | |_|  |   |  | ||     |||   `'.  | / /   | |_||     ||  `''-...... -'    
 *         \ \._,\ '/|  |   |  | \'. __// '   .'|  '/\ \._,\ '/\'. __//                    
 *          `--'  `" '--'   '--'  `'---'   `-'  `--'  `--'  `"  `'---'                     
 */

// obtain control totals for languages
// -- old lang32 (2010,2015 all counties + 2010,2015 state)
// -- new lang42 (2019,2021,2022 multco + 2018,2021,2022 washco + 2019,2020,2021,2022 state)
// -- new lang12 (2019,2020,2021,2022 all counties + 2019,2020,2021,2022 state)
// data prep
// -- attach agec3, agec5, agec11, lep, langc5, langc32, langc42, langfnl (langs for report)
// -- rectangularize to avoid zeros
// raking sequence 
// -- rake to agec11/sex
// -- rake to pobp/ancestry (county level ~ help with e.g. NHPI)
// -- rake to 2015 version lang32 (for counties that were part of a multi-county PUMA)
// -- rake to langc5/agec3/lep 
// -- rake to agec11/sex 
// -- simultaneous rake to lang12 (all counties) + lang42 (state)
// summary
// -- special adjustments/overrides, e.g. Spanish>0 for Gilliam in 2021 etc


// obtain control totals by age/sex/lang
cap prog drop langControls
prog def langControls
	local year=`1' // won't be persistent, because tokenizing within program
	local y=substr("`1'",3,2)
	// obtain control totals by age3/lep by lang5 (eng/spa/oie/api/oth)
	** consider: include 5ACS10, 5ACS15 for small populations
		tempfile tmp
		local T="B16004"
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:*&in=state:41")
		save `tmp', replace
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:011&in=state:53")
		append using `tmp'
		rename b16004_*e e*
		gen lc5eng_0517_lep0=e003
		gen lc5spa_0517_lep0=e005
		gen lc5spa_0517_lep1=e006+e007+e008
		gen lc5oie_0517_lep0=e010
		gen lc5oie_0517_lep1=e011+e012+e013
		gen lc5api_0517_lep0=e015
		gen lc5api_0517_lep1=e016+e017+e018
		gen lc5oth_0517_lep0=e020
		gen lc5oth_0517_lep1=e021+e022+e023
		gen lc5eng_1864_lep0=e025
		gen lc5spa_1864_lep0=e027
		gen lc5spa_1864_lep1=e028+e029+e030
		gen lc5oie_1864_lep0=e032
		gen lc5oie_1864_lep1=e033+e034+e035
		gen lc5api_1864_lep0=e037
		gen lc5api_1864_lep1=e038+e039+e040
		gen lc5oth_1864_lep0=e042
		gen lc5oth_1864_lep1=e043+e044+e045
		gen lc5eng_6599_lep0=e047
		gen lc5spa_6599_lep0=e049
		gen lc5spa_6599_lep1=e050+e051+e052
		gen lc5oie_6599_lep0=e054
		gen lc5oie_6599_lep1=e055+e056+e057
		gen lc5api_6599_lep0=e059
		gen lc5api_6599_lep1=e060+e061+e062
		gen lc5oth_6599_lep0=e064
		gen lc5oth_6599_lep1=e065+e066+e067
		tostring state, replace format(%02.0f) 
		tostring county, replace format(%03.0f)
		gen stcofips=state+county
		keep stcofips lc*
		reshape long lc5eng_@_lep0 lc5eng_@_lep1 lc5spa_@_lep0 lc5spa_@_lep1 lc5oie_@_lep0 lc5oie_@_lep1 ///
			lc5api_@_lep0 lc5api_@_lep1 lc5oth_@_lep0 lc5oth_@_lep1, i(stcofips) j(agec3) string
		reshape long lc5@__lep0 lc5@__lep1, i(stcofips agec3) j(langc5) string
		reshape long lc5__lep@, i(stcofips agec3 langc5) j(lep)
		ren lc5__lep lc5ac3lep_n
		drop if langc5=="eng" & lep==1
		assert lc5ac3lep_n<.
		*egen lc5ac3lep_tot=sum(lc5ac3lep_n), by(stcofips)
		gen int year=`year'
		save temp/control_lc5ac3lep_tmp.dta, replace
	// obtain control totals by lang32 (2015)
	** consider: include 5ACS10, 5ACS15 for small populations
		tempfile tmp
		local T="B16001"
		censusapi, url("https://api.census.gov/data/2015/acs/acs5?get=group(`T')&for=county:*&in=state:41")
		save `tmp', replace
		censusapi, url("https://api.census.gov/data/2015/acs/acs5?get=group(`T')&for=county:011&in=state:53")
		append using `tmp'
		rename b16001_*e e*
		#delimit ;
		gen lc39eng0=e002;
		gen lc39spa0=e004; gen lc39spa1=e005;
		gen lc39fre0=e007; gen lc39fre1=e008;
		gen lc39hai0=e010; gen lc39hai1=e011;
		gen lc39ita0=e013; gen lc39ita1=e014;
		gen lc39por0=e016; gen lc39por1=e017;
		gen lc39ger0=e019; gen lc39ger1=e020;
		gen lc39yid0=e022; gen lc39yid1=e023;
		gen lc39owg0=e025; gen lc39owg1=e026;
		gen lc39sca0=e028; gen lc39sca1=e029;
		gen lc39grk0=e031; gen lc39grk1=e039;
		gen lc39rus0=e034; gen lc39rus1=e035;
		gen lc39pol0=e037; gen lc39pol1=e038;
		gen lc39sco0=e040; gen lc39sco1=e041;
		gen lc39osl0=e043; gen lc39osl1=e044;
		gen lc39arm0=e046; gen lc39arm1=e047;
		gen lc39per0=e049; gen lc39per1=e050;
		gen lc39guj0=e052; gen lc39guj1=e053;
		gen lc39hin0=e055; gen lc39hin1=e056;
		gen lc39urd0=e058; gen lc39urd1=e059;
		gen lc39oin0=e061; gen lc39oin1=e062;
		gen lc39oie0=e064; gen lc39oie1=e065;
		gen lc39chn0=e067; gen lc39chn1=e068;
		gen lc39jap0=e070; gen lc39jap1=e071;
		gen lc39kor0=e073; gen lc39kor1=e074;
		gen lc39khm0=e076; gen lc39khm1=e077;
		gen lc39hmo0=e079; gen lc39hmo1=e080;
		gen lc39tha0=e082; gen lc39tha1=e083;
		gen lc39lao0=e085; gen lc39lao1=e086;
		gen lc39vie0=e088; gen lc39vie1=e089;
		gen lc39oas0=e091; gen lc39oas1=e092;
		gen lc39tgl0=e094; gen lc39tgl1=e095;
		gen lc39opi0=e097; gen lc39opi1=e098;
		gen lc39nav0=e100; gen lc39nav1=e101;
		gen lc39ona0=e103; gen lc39ona1=e104;
		gen lc39hun0=e106; gen lc39hun1=e107;
		gen lc39ara0=e109; gen lc39ara1=e110;
		gen lc39heb0=e112; gen lc39heb1=e113;
		gen lc39afr0=e115; gen lc39afr1=e116;
		gen lc39oth0=e118; gen lc39oth1=e119;
		#delimit cr
		tostring state, replace format(%02.0f) 
		tostring county, replace format(%03.0f)
		gen stcofips=state+county
		keep stcofips lc39*
		reshape long lc39@0 lc39@1, i(stcofips) j(langc39) string
		reshape long lc39@, i(stcofips langc39) j(lep)
		ren lc39 lc39_n
		drop if langc39=="eng" & lep==1
		assert lc39_n<.
		*egen lc39_tot=sum(lc39_n), by(stcofips)
		gen int year=2015
		save temp/control_langc39_tmp.dta, replace
	// obtain recent control totals by lang42 (county level = multco, washco only; state level = OR)
	** consider: combining 1ACS18/1ACS19, 1ACS20, 1ACS21 for small populations
	** consider ignoring county level because have already the 5-year PUMS, which is more reliable
		tempfile tmp
		local T="B16001"
		if `year'<2019 {
			di as error "year must be >=2019"
			exit
		}
		if `year'<=2020 {
			tempfile tmp
			censusapi, url("https://api.census.gov/data/2019/acs/acs1?get=group(`T')&for=county:051&in=state:41")
			save `tmp', replace
			censusapi, url("https://api.census.gov/data/2018/acs/acs1?get=group(`T')&for=county:067&in=state:41")
			append using `tmp'
			save `tmp', replace
		}
		if `year'>2020 {
			tempfile tmp
			censusapi, url("https://api.census.gov/data/`year'/acs/acs1?get=group(`T')&for=county:051&in=state:41")
			save `tmp', replace
			censusapi, url("https://api.census.gov/data/`year'/acs/acs1?get=group(`T')&for=county:067&in=state:41")
			append using `tmp'
			save `tmp', replace
		}
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=state:41")
		append using `tmp'
		rename b16001_*e e*
		#delimit ;
		gen lc42eng0=e002; 
		gen lc42spa0=e004; gen lc42spa1=e005;
		gen lc42fre0=e007; gen lc42fre1=e008;
		gen lc42hai0=e010; gen lc42hai1=e011;
		gen lc42ita0=e013; gen lc42ita1=e014;
		gen lc42por0=e016; gen lc42por1=e017;
		gen lc42ger0=e019; gen lc42ger1=e020;
		gen lc42ywg0=e022; gen lc42ywg1=e023;
		gen lc42grk0=e025; gen lc42grk1=e026;
		gen lc42rus0=e028; gen lc42rus1=e029;
		gen lc42pol0=e031; gen lc42pol1=e032;
		gen lc42sco0=e034; gen lc42sco1=e035;
		gen lc42osl0=e037; gen lc42osl1=e038;
		gen lc42arm0=e040; gen lc42arm1=e041;
		gen lc42per0=e043; gen lc42per1=e044;
		gen lc42guj0=e046; gen lc42guj1=e047;
		gen lc42hin0=e049; gen lc42hin1=e050;
		gen lc42urd0=e052; gen lc42urd1=e053;
		gen lc42pan0=e055; gen lc42pan1=e056;
		gen lc42ben0=e058; gen lc42ben1=e059;
		gen lc42oin0=e061; gen lc42oin1=e062;
		gen lc42oie0=e064; gen lc42oie1=e065;
		gen lc42tel0=e067; gen lc42tel1=e068;
		gen lc42tam0=e070; gen lc42tam1=e071;
		gen lc42mal0=e073; gen lc42mal1=e074;
		gen lc42chn0=e076; gen lc42chn1=e077;
		gen lc42jap0=e079; gen lc42jap1=e080;
		gen lc42kor0=e082; gen lc42kor1=e083;
		gen lc42hmo0=e085; gen lc42hmo1=e086;
		gen lc42vie0=e088; gen lc42vie1=e089;
		gen lc42khm0=e091; gen lc42khm1=e092;
		gen lc42tlk0=e094; gen lc42tlk1=e095;
		gen lc42oas0=e097; gen lc42oas1=e098;
		gen lc42tgl0=e100; gen lc42tgl1=e101;
		gen lc42opi0=e103; gen lc42opi1=e104;
		gen lc42ara0=e106; gen lc42ara1=e107;
		gen lc42heb0=e109; gen lc42heb1=e110;
		gen lc42afa0=e112; gen lc42afa1=e113;
		gen lc42waf0=e115; gen lc42waf1=e116;
		gen lc42cea0=e118; gen lc42cea1=e119;
		gen lc42nav0=e121; gen lc42nav1=e122;
		gen lc42ona0=e124; gen lc42ona1=e125;
		gen lc42oth0=e127; gen lc42oth1=e128;
		#delimit cr
		tostring state, replace format(%02.0f) 
		tostring county, replace format(%03.0f)
		gen stcofips=state+county 
		replace stcofips="41" if stcofips=="41." // "41" for Oregon statewide
		keep stcofips lc42*
		reshape long lc42@0 lc42@1, i(stcofips) j(langc42) string
		reshape long lc42@, i(stcofips langc42) j(lep)
		ren lc42 lc42_n
		drop if langc42=="eng" & lep==1
		assert lc42_n<.
		*egen lc42_tot=sum(lc42_n), by(stcofips)
		gen int year=`year'
		subsave if stcofips!="41" using temp/control_langc42_tmp.dta, replace // county totals (where available)
		keep if stcofips=="41"
		ren stcofips stfips
		ren lc42_n lc42st_n
		save temp/control_langc42st_tmp.dta, replace // state totals
	// obtain control totals by lang12 (latest, state + county)
	** consider: 
		local T="C16001"
		tempfile tmp
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:*&in=state:41")
		save `tmp', replace
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:067&in=state:53")
		append using `tmp'
		rename c16001_*e e*
		#delimit ;
		gen lc12eng0=e002;
		gen lc12spa0=e004; gen lc12spa1=e005;
		gen lc12fre0=e007; gen lc12fre1=e008;
		gen lc12ger0=e010; gen lc12ger1=e011;
		gen lc12sla0=e013; gen lc12sla1=e014;
		gen lc12oie0=e016; gen lc12oie1=e017;
		gen lc12kor0=e019; gen lc12kor1=e020;
		gen lc12chn0=e022; gen lc12chn1=e023;
		gen lc12vie0=e025; gen lc12vie1=e026;
		gen lc12tgl0=e028; gen lc12tgl1=e029;
		gen lc12oap0=e031; gen lc12oap1=e032;
		gen lc12ara0=e034; gen lc12ara1=e035;
		gen lc12oth0=e037; gen lc12oth1=e038;
		#delimit cr
		tostring state, replace format(%02.0f) 
		tostring county, replace format(%03.0f)
		gen stcofips=state+county
		keep stcofips lc12*
		reshape long lc12@0 lc12@1, i(stcofips) j(langc12) string
		reshape long lc12@, i(stcofips langc12) j(lep)
		ren lc12 lc12_n
		drop if langc12=="eng" & lep==1
		assert lc12_n<.
		*egen lc12_tot=sum(lc12_n), by(stcofips)
		gen int year=`year'
		save temp/control_langc12_tmp.dta, replace
	// obtain latest counts by birthplace in hong kong/taiwan, mainland china, iran/tajikistan, and afghanistan
	** include data from 2015 EXCEPT for Wash, Mult, Clack, Clark; others get weighted average of 2010-15 and last
		tempfile tmp
		local T="B05006"
		censusapi, url("https://api.census.gov/data/2015/acs/acs5?get=group(`T')&for=county:*&in=state:41")
		gen int year=2015
		save `tmp', replace
		censusapi, url("https://api.census.gov/data/2015/acs/acs5?get=group(`T')&for=county:011&in=state:53")
		gen int year=2015
		append using `tmp'
		save `tmp', replace
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:*&in=state:41")
		gen int year=`year'
		append using `tmp'
		save `tmp', replace
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:011&in=state:53")
		gen int year=`year'
		append using `tmp'
		drop if state==53 & county==11 & year==2015
		drop if state==41 & inlist(county,53,67,5) & year==2015
		rename b05006_*e e*
		collapse (sum) e*, by(state county)
		gen chn_trad=(e051+e052)/e049
		gen chn_simp=e050/e049
		assert inrange(chn_trad+chn_simp,.99,1.01) | (chn_trad==.&chn_simp==.)
		gen per_farsi=(e061)/(e061+e057)
		gen per_dari=(e057)/(e061+e057)
		assert inrange(per_farsi+per_dari,.99,1.01) | (per_farsi==.&per_dari==.)
		list state county per* chn*, clean noobs
		keep state county per* chn*
		save temp/parse_farsi_chinese.dta, replace
	// obtain control totals by detailed age/sex
		tempfile tmp
		local T="B01001"
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:*&in=state:41")
		save `tmp', replace
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:011&in=state:53")
		append using `tmp'
		gen a_0004_1=b01001_003e
		gen a_0514_1=b01001_004e+b01001_005e
		gen a_1517_1=b01001_006e
		gen a_1819_1=b01001_007e
		gen a_2024_1=b01001_008e+b01001_009e+b01001_010e
		gen a_2529_1=b01001_011e
		gen a_3039_1=b01001_012e+b01001_013e
		gen a_4049_1=b01001_014e+b01001_015e
		gen a_5059_1=b01001_016e+b01001_017e
		gen a_6064_1=b01001_018e+b01001_019e
		gen a_6599_1=b01001_020e+b01001_021e+b01001_022e+b01001_023e+b01001_024e+b01001_025e
		gen a_0004_2=b01001_027e
		gen a_0514_2=b01001_028e+b01001_029e
		gen a_1517_2=b01001_030e
		gen a_1819_2=b01001_031e
		gen a_2024_2=b01001_032e+b01001_033e+b01001_034e
		gen a_2529_2=b01001_035e
		gen a_3039_2=b01001_036e+b01001_037e
		gen a_4049_2=b01001_038e+b01001_039e
		gen a_5059_2=b01001_040e+b01001_041e
		gen a_6064_2=b01001_042e+b01001_043e
		gen a_6599_2=b01001_044e+b01001_045e+b01001_046e+b01001_047e+b01001_048e+b01001_049e
		tostring state, replace format(%02.0f) 
		tostring county, replace format(%03.0f)
		gen stcofips=state+county
		keep stcofips a_*
		reshape long a_0004_ a_0514_ a_1517_ a_1819_ a_2024_ a_2529_ a_3039_ a_4049_ a_5059_ a_6064_ a_6599_, i(stcofips) j(sex)
		reshape long a_@_, i(stcofips sex) j(agecat) string
		egen atot=sum(a__), by(stcofips)
		ren a__ a_n // N by age
		rename agecat agec11
		gen int year=`year'
		*collapse (sum) a_n, by(stcofips year agec11)
		save temp/control_age_tmp.dta, replace
	// obtain control totals by place of birth for foreign born
		/*
		tempfile tmp
		local T="B05006"
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:*&in=state:41")
		save `tmp', replace
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:011&in=state:53")
		append using `tmp'
		rename b05006_*e e*
		gen fbbpld_eur=e002
		gen fbbpld_asi=e047
		gen fbbpld_afr=e095
		gen fbbpld_oce=e130
		gen fbbpld_lac=e139
		gen fbbpld_nam=e176
		... more detailed, to help with languages
		tostring state, replace format(%02.0f) 
		tostring county, replace format(%03.0f)
		gen stcofips=state+county
		keep stcofips a_*
		reshape long a_0004_ a_0514_ a_1517_ a_1819_ a_2024_ a_2529_ a_3039_ a_4049_ a_5059_ a_6064_ a_6599_, i(stcofips) j(sex)
		reshape long a_@_, i(stcofips sex) j(agecat) string
		egen atot=sum(a__), by(stcofips)
		ren a__ a_n // N by age
		rename agecat agec11
		gen int year=`year'
		*collapse (sum) a_n, by(stcofips year agec11)
		save temp/control_forborn_bpld.dta, replace
		*/
end
*langControls 2020

// generate donor samples from previous ACS PUMS (for more representation of rare languages)
**	limited to 2012-2016 sample and later to ensure comparability of PUMA and LANP codes.
** 	used only to get traits (age/sex/lep) for language speakers not in PUMS, but in ACS tables
cap prog drop donorLang
prog def donorLang
	local year=`1'
	local y=substr("`year'",3,2)
	local i=1
	tempfile tmp
	foreach g in "for=state:41" "for=public%20use%20microdata%20area:11101,11102,11103,11104&in=state:53" {
		local vars="AGEP,SEX,LANX,ENG,LANP"
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5/pums?get=`vars'&`g'&key=$ckey") 
		if `i'==1 save `tmp'
		if `i'==2 append using `tmp'
		local ++i
	}
	cap drop publicusemicroda
	cap drop state
	keep if inrange(lanp,1000,9999) // keep persons with a language other than english
	ren lanp lanp16
	merge m:1 lanp16 using 04_langxwalk.dta, keep(1 3) nogen keepus(langfnl)
	save "acs/donor_lanp_5acs`y'.dta", replace 
end
*donorLang 2016 // pums api is flaky; may require repeated runs.
*donorLang 2020

// attach merge/rake points in PUMS
cap prog drop langFile
prog def langFile
	local 1=2020
	local year=`1'
	local y=substr("`year'",3,2)
	** load PUMS
	use year state county sex agep lanx lanp eng pw* using 5ACS20_ORWA_RELDPRI.dta, clear
	gen stfips=state
	gen stcofips=state+county
	drop state county
	** language categories
	ren lanp lanp16 // only works for PUMS samples from 2016+
	merge m:1 lanp16 using 04_langxwalk.dta, keep(1 3) nogen keepus(langfnl)
	** fillin such that every lang*lep status is represented and has nonmissing age/sex
	** this is necessary because sometimes control totals require adjustment of weights where no matching speakers exist in PUMS
	** method for doing so -- create dummy obs with minimal pwgtp; merge traits from donor datasets of speakers from other time/areas
	preserve
	tempfile tmp2
	fillin year stcofips langfnl eng
	keep if _fillin==1
	keep year stcofips langfnl eng 
	merge m:m langfnl eng using acs/donor_lanp_5acs`y'.dta, keepus(lanx lanp agep sex) keep(1 3)
	drop _merge
	merge m:m langfnl eng using acs/donor_lanp_5acs16.dta, keepus(lanx lanp agep sex) keep(1 3 4) update
	drop _merge
	keep if sex<. & agep<. & lanp<. & lanx<. & langfnl<. & eng<.
	gen pwgtp=1e-3 
	save `tmp2'
	restore
	append using `tmp2'
	** lep
	gen lep=.
	replace lep=0 if eng==1 | lanx==2
	replace lep=1 if inlist(eng,2,3,4)
	assert lep<. if agep>=5
	** summarized language categories
	merge m:m langfnl using 04_langxwalk.dta, keep(1 3) nogen keepus(lf_label langc39 langc42 langc12 langc5)
	tab1 langc39 langc42 langc12 langc5 if lanp16<., mis // ensure no missings for non-english languages
	** fix english only speakers
	for var langc*: replace X="eng" if lanx==2 // ensure speaks english only is given lang="eng"
	assert lep==0 if lanx==2
	** detailed agecat
	gen agec11=""
	replace agec11="0004" if inrange(agep,0,4)
	replace agec11="0514" if inrange(agep,5,14)
	replace agec11="1517" if inrange(agep,15,17)
	replace agec11="1819" if inrange(agep,18,19)
	replace agec11="2024" if inrange(agep,20,24)
	replace agec11="2529" if inrange(agep,25,29)
	replace agec11="3039" if inrange(agep,30,39)
	replace agec11="4049" if inrange(agep,40,49)
	replace agec11="5059" if inrange(agep,50,59)
	replace agec11="6064" if inrange(agep,60,64)
	replace agec11="6599" if inrange(agep,65,99)
	assert agec11!=""
	** broad agecat 5+
	gen agec3="0517" if inrange(agep,5,17)
	replace agec3="1864" if inrange(agep,18,64)
	replace agec3="6599" if inrange(agep,65,99)
	assert agec3!="" | agec11=="0004"

save 5ACS20_ORWA_RELDPRI_raceeth_wip.dta, replace
DONE TO HERe
END
	use 5ACS20_ORWA_RELDPRI_raceeth_wip.dta, clear
	>> all kinds of problems merging the control totals for "eng" and lep:0
	
	** add control totals by age/sex/language/lep
	assert stcofips!="" & year<. & sex<. & agec11!=""
	merge m:1 stcofips sex agec11 using temp/control_age_tmp.dta, assert(3) nogen
	* merge m:1 stcofips agec3 langc5 lep using temp/control_lc5ac3lep_tmp.dta, assert(1 3) // _m==1 for age0-4 ~ skipping
	assert stcofips!="" & year<. & (lep<.|agec11=="0004") & (langc39!=""|agec11=="0004")
	merge m:1 stcofips langc39 lep using temp/control_langc39_tmp.dta, assert(1 3) // old county lang39
	assert _merge==3 if agec11!="0004"
	assert stcofips!="" & year<. & (lep<.|agec11=="0004") & (langc42!=""|agec11=="0004")
	merge m:1 stcofips year langc42 lep using temp/control_langc42_tmp.dta, assert(1 3) // state lang42 (and multco/washco)
	assert _merge==3 if agec11!="0004"
	assert stcofips!="" & year<. & (lep<.|agec11=="0004") & (langc12!=""|agec11=="0004")
	merge m:1 stcofips year langc12 lep using temp/control_langc12_tmp.dta, assert(1 3) // latest county lang12
	assert _merge==3 if agec11!="0004"
	assert stfips!="" & year<. & (lep<.|agec11=="0004") & (langc42!=""|agec11=="0004")
	merge m:1 stfips year langc42 lep using temp/control_langc42st_tmp.dta, assert(1 3) // state total (OR only)
	assert _merge==3 if agec11!="0004"
	
	// RAKE by detailed age/sex (gen pwt1) THEN by ... 
	set seed 1337170
	survwgt poststratify pwgtp, by(stcofips agec11 sex) totvar(a_n) gen(pwt1)
	gen toskip=inlist(stcofips,"MARION","MULTNOMAH","CLACKAMAS","WASHINGTON")
	set seed 1337170
	survwgt poststratify pwt1 if toskip==0, by(stcofips langc39 lep) totvar(lc39_n) gen(pwt2) // control to 2015 detailed languages
	replace pwt2=pwt1 if toskip==1
	set seed 1337170
	survwgt poststratify pwt2, by(stcofips agec3 lep langc5) totvar(ac3_lc5_lep_n) gen(pwt3) // control to broad age*broad language
	set seed 1337170
	survwgt poststratify pwt3, by(stcofips state langc42 lep) totvar(lc12_n lc42_n) gen(pwt4) <<-- fix this for simultaneous control
	replace pwt4=0 if pwt4==.

	// simultaneous rake to latest state lang42 + county lang12
	** n.b. sometimes wash/mult have a recent b16001 with lang42, but 1-yr ACS with terrible MOEs.
	egen id1=group(lang42 lep)
	egen id2=group(cname lang12 lep)
	survwgt rake perwt1, by(id1 id2) totvars(pop_lep_state pop_lep_county) gen(perwt_lep_sr) maxrep(255) // final raked counts 

end
langFile 2020

	//
	// tabulate by langfnl, plus checks
	collapse (sum) lep_2021=perwt_lep_sr, by(cname langfnl)
	replace lep_2021=round(lep_2021)
	merge 1:1 cname langfnl using auxiliary/lang_table.dta
	drop _merge
	save auxiliary/lang_table.dta, replace


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

