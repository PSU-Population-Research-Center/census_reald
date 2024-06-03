* v14: output stcofips in rows instead of county 1--37; removed mata:st_matrix in favor of tab, matrow
* v13: bugfixes
* v12: fork out of controlled_analysis.do

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

// download necessary controls (age/sex) (age/sex/race) (age/sex/hisp)
cap prog drop reControls
prog def reControls
	args year
	tempfile tmp
	// obtain control totals by detailed age/sex
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
		egen atot=sum(a__), by(stcofips) // total pop by county -- unnecessary though b/c totals by age sum to overall total
		ren a__ as_n // N by agesex
		rename agecat agec11
		tostring sex, replace
		replace sex="male" if sex=="1"
		replace sex="female" if sex=="2"
		gen int year=`year'
		save temp/control_age_tmp.dta, replace
	// repeat, but generate totals for agec11 (as used in race-eth tables A-I)
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
		gen a_3034_1=b01001_012e
		gen a_3544_1=b01001_013e+b01001_014e
		gen a_4554_1=b01001_015e+b01001_016e
		gen a_5564_1=b01001_017e+b01001_018e+b01001_019e
		gen a_6599_1=b01001_020e+b01001_021e+b01001_022e+b01001_023e+b01001_024e+b01001_025e
		gen a_0004_2=b01001_027e
		gen a_0514_2=b01001_028e+b01001_029e
		gen a_1517_2=b01001_030e
		gen a_1819_2=b01001_031e
		gen a_2024_2=b01001_032e+b01001_033e+b01001_034e
		gen a_2529_2=b01001_035e
		gen a_3034_2=b01001_036e
		gen a_3544_2=b01001_037e+b01001_038e
		gen a_4554_2=b01001_039e+b01001_040e
		gen a_5564_2=b01001_041e+b01001_042e+b01001_043e
		gen a_6599_2=b01001_044e+b01001_045e+b01001_046e+b01001_047e+b01001_048e+b01001_049e
		tostring state, replace format(%02.0f) 
		tostring county, replace format(%03.0f)
		gen stcofips=state+county
		keep stcofips a_*
		reshape long a_0004_ a_0514_ a_1517_ a_1819_ a_2024_ a_2529_ a_3034_ a_3544_ a_4554_ a_5564_ a_6599_, i(stcofips) j(sex)
		reshape long a_@_, i(stcofips sex) j(agecat) string
		ren a__ as_n // N by agesex
		rename agecat agec11b
		tostring sex, replace
		replace sex="male" if sex=="1"
		replace sex="female" if sex=="2"
		gen int year=`year'
		save temp/control_ageb_tmp.dta, replace
	// obtain controls by age/sex + OMB race-eth (A-I)
		** agec11 sex ombrace (wa ba na aa pa oa mr) ombhisp (wanh h)
		local t="`c(alpha)'"
		tokenize `t'
		forvalues r=1/9 {
			local T="B01001"+upper("``r''")
			censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:*&in=state:41")
			save `tmp', replace
			censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:011&in=state:53")
			append using `tmp'
			ren b01001``r''_*e e*
			gen a_0004_1_`r'=e003
			gen a_0514_1_`r'=e004+e005
			gen a_1517_1_`r'=e006
			gen a_1819_1_`r'=e007
			gen a_2024_1_`r'=e008
			gen a_2529_1_`r'=e009
			gen a_3034_1_`r'=e010
			gen a_3544_1_`r'=e011
			gen a_4554_1_`r'=e012
			gen a_5564_1_`r'=e013
			gen a_6599_1_`r'=e014+e015+e016
			gen a_0004_2_`r'=e018
			gen a_0514_2_`r'=e019+e020
			gen a_1517_2_`r'=e021
			gen a_1819_2_`r'=e022
			gen a_2024_2_`r'=e023
			gen a_2529_2_`r'=e024
			gen a_3034_2_`r'=e025
			gen a_3544_2_`r'=e026
			gen a_4554_2_`r'=e027
			gen a_5564_2_`r'=e028
			gen a_6599_2_`r'=e029+e030+e031
			tostring state, replace format(%02.0f) 
			tostring county, replace format(%03.0f)
			gen stcofips=state+county
			keep stcofips a_*
			if inrange(`r',1,7) local race="ombrace" // 1=w 2=b 3=n 4=a 5=p 6=o 7=m
			if inrange(`r',8,9) local race="ombhisp" // 8=nhw 9=h
			reshape long a_0004_1_ a_0514_1_ a_1517_1_ a_1819_1_ a_2024_1_ a_2529_1_ a_3034_1_ a_3544_1_ a_4554_1_ a_5564_1_ a_6599_1_ ///
				a_0004_2_ a_0514_2_ a_1517_2_ a_1819_2_ a_2024_2_ a_2529_2_ a_3034_2_ a_3544_2_ a_4554_2_ a_5564_2_ a_6599_2_, i(stcofips) j(`race')
			reshape long a_0004_@_ a_0514_@_ a_1517_@_ a_1819_@_ a_2024_@_ a_2529_@_ a_3034_@_ a_3544_@_ a_4554_@_ a_5564_@_ a_6599_@_, i(stcofips `race') j(sex)
			reshape long a_@__, i(stcofips `race' sex) j(agecat) string
			gen int year=`year'
			if inrange(`r',2,7) append using temp/control_age_ombrace_tmp.dta
			if `r'==7 { // after last race
				egen atot=sum(a__), by(stcofips)
				rename agecat agec11b // also 11 categories, but different
				tostring ombrace, replace
				replace ombrace="wa" if ombrace=="1"
				replace ombrace="ba" if ombrace=="2"
				replace ombrace="na" if ombrace=="3"
				replace ombrace="aa" if ombrace=="4"
				replace ombrace="pa" if ombrace=="5"
				replace ombrace="oa" if ombrace=="6"
				replace ombrace="mr" if ombrace=="7"
				tostring sex, replace
				replace sex="male" if sex=="1"
				replace sex="female" if sex=="2"
				ren a___ asr_n
			}
			if inrange(`r',1,7) save temp/control_age_ombrace_tmp.dta, replace
			if `r'==9 {
				append using temp/control_age_ombhisp_tmp.dta
				rename agecat agec11b
				tostring ombhisp, replace
				replace ombhisp="wanh" if ombhisp=="8"
				replace ombhisp="h" if ombhisp=="9"
				tostring sex, replace
				replace sex="male" if sex=="1"
				replace sex="female" if sex=="2"
				ren a___ ash_n
			}
			if inrange(`r',8,9) save temp/control_age_ombhisp_tmp.dta, replace
			if `r'==9 { // generate "omnh" or residual, all non-hispanic races other than NHWA
				collapse (sum) ash_n, by(stcofips year sex agec11b)
				merge 1:1 stcofips year sex agec11b using temp/control_ageb_tmp.dta, assert(3)
				replace ash_n=as_n-ash_n
				assert ash_n>=0 & ash_n<.
				drop as_n _merge
				gen ombhisp="omnh"
				append using temp/control_age_ombhisp_tmp.dta
				save temp/control_age_ombhisp_tmp.dta, replace 
			}
		}
end
*reControls 2021 
** three datasets: control_age, control_age_ombrace, control_age_ombhisp
 
// generate raked file: age/sex and race-eth by age/sex
** TBD: rewrite such that no need to use the prep-control dofile.
** following disaby format: pull only tables b01001 and b01001a-i 
cap prog drop reFile
prog def reFile
	local year=`1'
	local y=substr("`year'",3,2)
	// LOAD pums data from prior step and generate flags for control pops
	use 5ACS`y'_ORWA_RELDPRI.dta, clear 
	cap drop flag
	gen stcofips=state+county
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
	gen agec11b=""
	replace agec11b="0004" if inrange(agep,0,4)
	replace agec11b="0514" if inrange(agep,5,14)
	replace agec11b="1517" if inrange(agep,15,17)
	replace agec11b="1819" if inrange(agep,18,19)
	replace agec11b="2024" if inrange(agep,20,24)
	replace agec11b="2529" if inrange(agep,25,29)
	replace agec11b="3034" if inrange(agep,30,34)
	replace agec11b="3544" if inrange(agep,35,44)
	replace agec11b="4554" if inrange(agep,45,54)
	replace agec11b="5564" if inrange(agep,55,64)
	replace agec11b="6599" if inrange(agep,65,99)	
	cap drop ombrace
	gen ombrace=""
	replace ombrace="wa" if racwht==1 & racnum==1
	replace ombrace="ba" if racblk==1 & racnum==1
	replace ombrace="na" if racaian==1 & racnum==1
	replace ombrace="aa" if racasn==1 & racnum==1
	replace ombrace="pa" if racnhpi==1 & racnum==1
	replace ombrace="oa" if racsor==1 & racnum==1
	replace ombrace="mr" if racnum>1
	assert ombrace!=""
	gen ombhisp=""
	replace ombhisp="wanh" if racwht==1 & racnum==1 & hisp==1
	replace ombhisp="h" if inrange(hisp,2,24)
	replace ombhisp="omnh" if ombrace!="wa" & hisp==1
	assert ombhisp!=""
	tostring sex, replace
	replace sex="male" if sex=="1"
	replace sex="female" if sex=="2"
	// attach controls and fix microdata
	merge m:1 year stcofips sex agec11 using temp/control_age_tmp.dta, assert(3) nogen // adds as_n and atot
	merge m:1 year stcofips sex agec11b ombrace using temp/control_age_ombrace_tmp.dta, assert(2 3) // _merge==2 means no matching microdata present
	levelsof stcofips if _merge==2 & asr_n>0, local(levels) // non-zero population counts w/o matching microdata
	foreach l of local levels {
		levelsof agec11b if _merge==2 & stcofips=="`l'" & asr_n>0, local(ages)
		foreach a of local ages {
			levelsof sex if _merge==2 & stcofips=="`l'" & agec11b=="`a'" & asr_n>0, local(sexes)
			foreach s of local sexes {
				levelsof ombrace if _merge==2 & stcofips=="`l'" & agec11b=="`a'" & sex=="`s'" & asr_n>0, local(races)
				foreach r of local races {
					count if _merge==2 & stcofips=="`l'" & agec11b=="`a'" & sex=="`s'" & ombrace=="`r'"
					assert `r(N)'==1
					randomtag if agec11b=="`a'" & stcofips=="`l'" & sex=="`s'", count(1) gen(tag) // use this donor obs to impute missing chars besides race
					expand 2 if tag==1, gen(flag)
					sum asr_n if _merge==2 & stcofips=="`l'" & agec11b=="`a'" & sex=="`s'" & ombrace=="`r'" // copy age-sex-race total
					replace asr_n=`r(mean)' if flag==1 
					replace ombrace="`r'" if flag==1 // copy race var (others already present)
					drop flag tag
					drop if _merge==2 & stcofips=="`l'" & agec11b=="`a'" & sex=="`s'" & ombrace=="`r'" // drop merged obs, now that weight copied to donor obs
				}
			}
		}	
	}
	drop if _merge==2 & asr_n==0
	drop _merge
	merge m:1 year stcofips sex agec11b ombhisp using temp/control_age_ombhisp_tmp.dta, assert(2 3) // 2=missing microdata
	levelsof stcofips if _merge==2, local(levels)
	foreach l of local levels {
		levelsof agec11b if _merge==2 & stcofips=="`l'" & ash_n>0, local(ages)
		foreach a of local ages {
			levelsof sex if _merge==2 & stcofips=="`l'" & agec11b=="`a'" & ash_n>0, local(sexes)
			foreach s of local sexes {
				levelsof ombhisp if _merge==2 & stcofips=="`l'" & agec11b=="`a'" & sex=="`s'" & ash_n>0, local(races)
				foreach r of local races {
					count if _merge==2 & stcofips=="`l'" & agec11b=="`a'" & sex=="`s'" & ombhisp=="`r'"
					assert `r(N)'==1
					randomtag if agec11b=="`a'" & stcofips=="`l'" & sex=="`s'", count(1) gen(tag) // use this donor obs to impute missing chars besides race
					expand 2 if tag==1, gen(flag)
					sum ash_n if _merge==2 & stcofips=="`l'" & agec11b=="`a'" & sex=="`s'" & ombhisp=="`r'" // copy age-sex-eth total
					replace ash_n=`r(mean)' if flag==1
					replace ombhisp="`r'" if flag==1
					drop flag tag
					drop if _merge==2 & stcofips=="`l'" & agec11b=="`a'" & sex=="`s'" & ombhisp=="`r'" // drop merged obs, now that weight copied to donor obs
				}
			}
		}	
	}
	drop if _merge==2 & ash_n==0
	drop _merge
	// FIRST, rake by appx age/sex/race >> convert pwgtp to pwt1; THEN age/sex/hisp >> convert pwt1 to pwt2; THEN, rake by age/sex >> convert pwt2 to pwt3.
	cap drop pwt1
	set seed 13371701
	survwgt poststratify pwgtp, by(stcofips sex agec11b ombrace) totvar(asr_n) gen(pwt1) // ombrace w b n a p o m
	survwgt poststratify pwt1, by(stcofips sex agec11b ombhisp) totvar(ash_n) gen(pwt2) // ombhisp omnh wanh h
	survwgt poststratify pwt2, by(stcofips sex agec11) totvar(as_n) gen(pwt3) // agecat
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
	assert ombrrn<.
	// CHECK
	version 13: table stcofips, contents(sum pwgtp sum pwt1 sum pwt2 sum pwt3 mean atot) format(%7.0fc) row // pwt3 should match ACS SF.
	// CLEAN and SAVE
	drop as_n asr_n ash_n // drop control totals
	egen byte agecat=cut(agep),at(0,5,15,18,20,25,30,40,50,60,65,99)
	destring stcofips, replace // svy total, over(X) requires num.
	replace sex="1" if sex=="male"
	replace sex="2" if sex=="female"
	destring sex, replace
	compress
	// define sample weights
	svyset [iw=pwt3], sdr(pwgtp1-pwgtp80) vce(sdr)
	gen byte one=1 
	save 5ACS`y'_ORWA_RELDPRI_raceeth.dta, replace
end
*reFile 2020 

// check total population per county
cap prog drop chkTotal
prog def chkTotal
	local y=substr("`1'",3,2)
	use 5ACS`y'_ORWA_RELDPRI_raceeth.dta, clear
	svy: total one, over(stcofips)
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
		use stcofips sex agecat pwt* pwgtp* one using 5ACS`y'_ORWA_RELDPRI_raceeth.dta, clear
		fillin stcofips sex agecat
		qui for var pwt3 pwgtp1-pwgtp80: replace X=0 if X==.
		drop _fillin
		mat master=J(1,12,.)
		matrix colnames master="stcofips" "sex" "agecat" "b" "se" "z" "p" "ll" "ul" "df" "crit" "eform"
		levelsof agecat, local(ages)
		forvalues s=1/2 {
			foreach a of local ages {
				svy: total one if agecat==`a' & sex==`s', over(stcofips)
				mat table=r(table)
				mat table=table'
				qui tab stcofips, matrow(stcofips)
				mat sex=J(37,1,`s')
				mat agecat=J(37,1,`a')
				mat result=stcofips,sex,agecat,table
				mat master=master\result
			}
		}
		drop _all
		svmat master, names(col)
		save results/results_agesex_`1'.dta, replace
	}
	** clean for excel export
	drop if stcofips==.
	keep stcofips sex agecat b
	reshape wide b, i(stcofips agecat) j(sex)
	rename *1 *male
	rename *2 *female
	reshape wide bmale bfemale, i(stcofips) j(agecat)
	order stcofips bmale* bfemale*
end
*tabSex 2020

// totals by OMB rarest race/ethnicity and age/sex (don't need by sex, but retaining)
capture prog drop tabReldRR
prog def tabReldRR
	cap use results/results_agesex_ombrr_`1'.dta, clear
	if _rc {
		local y=substr("`1'",3,2)
		use stcofips sex ombrrn agecat pwt* pwgtp* one using 5ACS`y'_ORWA_RELDPRI_raceeth.dta, clear
		fillin stcofips sex ombrrn agecat
		qui for var pwt3 pwgtp1-pwgtp80: replace X=0 if X==.
		drop _fillin
		mat master=J(1,13,.)
		mat colnames master="stcofips" "sex" "ombrrn" "agecat" "b" "se" "z" "p" "ll" "ul" "df" "crit" "eform"
		levelsof agecat, local(ages)
		forvalues s=1/2 {
			forvalues r=1/7 {
				foreach a of local ages {
					ereturn clear
					svy sdr: total one if agecat==`a' & sex==`s' & ombrrn==`r', over(stcofips) 
					mat table=r(table)
					mat table=table'
					qui tab stcofips, matrow(stcofips)
					mat sex=J(37,1,`s')
					mat ombrrn=J(37,1,`r')
					mat agecat=J(37,1,`a')
					mat result=stcofips,sex,ombrrn,agecat,table
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
		drop if stcofips==.
		save results/results_agesex_ombrr_`1'.dta, replace
	}
	** clean for excel export
	keep stcofips sex ombrr agecat b
	reshape wide b, i(stcofips agecat ombrr) j(sex)
	rename *1 *male
	rename *2 *female
	reshape wide bmale bfemale, i(stcofips agecat) j(ombrr) string
	reshape wide bmale* bfemale*, i(stcofips) j(agecat) 
	order stcofips bmaleaian* bmaleasian* bmaleblack* bmalehispanic* bmalenhpi* bmaleother* bmalewhite* ///
		bfemaleaian* bfemaleasian* bfemaleblack* bfemalehispanic* bfemalenhpi* bfemaleother* bfemalewhite* 
end
*tabReldRR 2020

// totals by REALD primary race and age/sex (don't need by sex, but retaining)
cap prog drop tabReldPri
prog def tabReldPri
	cap use results/results_agesex_reldpri_`1'.dta, clear
	if _rc {
		local y=substr("`1'",3,2)
		use stcofips sex reldpri agecat pwt* pwgtp* one using 5ACS`y'_ORWA_RELDPRI_raceeth.dta, clear
		fillin stcofips sex reldpri agecat
		qui for var pwt3 pwgtp1-pwgtp80: replace X=0 if X==. 
		drop _fillin
		encode reldpri, gen(reldprin)
		mat master=J(1,13,.)
		mat colnames master="stcofips" "sex" "reldprin" "agecat" "b" "se" "z" "p" "ll" "ul" "df" "crit" "eform"
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
					nois cap svy sdr: total one if agecat==`a' & sex==`s' & reldprin==`r', over(stcofips) 
					if _rc mat table=J(9,37,0)
					else mat table=r(table)
					mat table=table'
					qui tab stcofips, matrow(stcofips)
					mat sex=J(37,1,`s')
					mat reldprin=J(37,1,`r')
					mat agecat=J(37,1,`a')
					mat result=stcofips,sex,reldprin,agecat,table
					mat master=master\result
				}
			}
		}
		drop _all
		svmat master, names(col)
		label values reldprin reldprin
		decode reldprin, gen(reldpri)
		drop reldprin
		drop if stcofips==.
		save results/results_agesex_reldpri_`1'.dta, replace
	}
	** clean for excel export
	keep stcofips sex reldpri agecat b
	reshape wide b, i(stcofips agecat reldpri) j(sex)
	rename *1 *male
	rename *2 *female
	levelsof reldpri, local(levels)
	reshape wide bmale bfemale, i(stcofips agecat) j(reldpri) string
	reshape wide bmale* bfemale*, i(stcofips) j(agecat) 
	order *, seq
	order stcofips
	foreach l of local levels {
		egen b`l'=rowtotal(bfemale`l'* bmale`l'*)
	}
	*browse stcofips bAfrAm-bWhiteOth
end
*tabReldPri 2020
