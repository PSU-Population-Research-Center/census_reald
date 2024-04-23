** purpose: conduct analysis on pums
** apply external control totals 
** rake as appropriate for each table
** compile tables with MOEs (WIP)
** export dataset

** v04: add language ~ add regions ~ change disability coding.
** v03: add disability ~ currently separate modules, but count consider combining into one series of rakes.
** v02: change to faster, consistent totals by county
** v01: first version, sequential totals 1/36


/***
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
	version 13: table county if state=="41", contents(sum pwgtp sum pwt1 sum pwt2 mean totpop) format(%7.0fc) row // pwt2 matches ACS SF.
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

// totals by OMB rarest race/ethnicity and age/sex (don't need by sex, but retaining)
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

// totals by REALD primary race and age/sex (don't need by sex, but retaining)
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

/***
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
 
* !! note that the totals for disability are generated by a raking step that occurs AFTER the detailed age/sex rake.
/* From Marjorie: For Disability:  
	Statewide and Regions: DA7compACSall DISDi; DA4cat and the 
	DAOICv2 vars where:  0 "Does not have this limitation" ; 1 "This limitation only" and  "2+ limitations".   
	At a county level – for very small counties… the same except likely DA7compACSall – please advise after you can run some tables…
*/ 

// update weights for disability tables
	cap confirm file 05_ipf_pums_v01_disaby.dta
// obtain control totals by age/sex/disaby
	tempfile tmp
	local T="B18101"
	censusapi, url("https://api.census.gov/data/2021/acs/acs5?get=group(`T')&for=county:*&in=state:41")
	save `tmp', replace
	censusapi, url("https://api.census.gov/data/2021/acs/acs5?get=group(`T')&for=county:011&in=state:53")
	append using `tmp'
	tostring state, replace format(%02.0f) 
	tostring county, replace format(%03.0f)
	gen disaby_0004_1=b18101_004e
	gen disaby_0517_1=b18101_007e
	gen disaby_1834_1=b18101_010e
	gen disaby_3564_1=b18101_013e
	gen disaby_6599_1=b18101_016e+b18101_019e
	gen disaby_0004_2=b18101_023e
	gen disaby_0517_2=b18101_026e
	gen disaby_1834_2=b18101_029e
	gen disaby_3564_2=b18101_032e
	gen disaby_6599_2=b18101_035e+b18101_038e
	gen disabn_0004_1=b18101_005e
	gen disabn_0517_1=b18101_008e
	gen disabn_1834_1=b18101_011e
	gen disabn_3564_1=b18101_014e
	gen disabn_6599_1=b18101_017e+b18101_020e
	gen disabn_0004_2=b18101_024e
	gen disabn_0517_2=b18101_027e
	gen disabn_1834_2=b18101_030e
	gen disabn_3564_2=b18101_033e
	gen disabn_6599_2=b18101_036e+b18101_039e
	keep state county disaby_* disabn_*
	reshape long disaby_0004_ disaby_0517_ disaby_1834_ disaby_3564_ disaby_6599_ ///
				 disabn_0004_ disabn_0517_ disabn_1834_ disabn_3564_ disabn_6599_, i(state county) j(sex)
	reshape long disaby_@_ disabn_@_, i(state county sex) j(agecat) string
	rename agecat agec5
	egen disabytot=sum(disaby__), by(state county)
	egen disabntot=sum(disabn__), by(state county)
	gen int year=2021 
	save control_dis_tmp.dta, replace
// obtain control totals by detailed age/sex
	tempfile tmp
	local T="B01001"
	censusapi, url("https://api.census.gov/data/2021/acs/acs5?get=group(`T')&for=county:*&in=state:41")
	save `tmp', replace
	censusapi, url("https://api.census.gov/data/2021/acs/acs5?get=group(`T')&for=county:011&in=state:53")
	append using `tmp'
	tostring state, replace format(%02.0f) 
	tostring county, replace format(%03.0f)
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
	keep state county a_*
	reshape long a_0004_ a_0514_ a_1517_ a_1819_ a_2024_ a_2529_ a_3039_ a_4049_ a_5059_ a_6064_ a_6599_, i(state county) j(sex)
	reshape long a_@_, i(state county sex) j(agecat) string
	rename agecat agec11
	egen atot=sum(a__), by(state county)
	gen int year=2021
	save control_age_tmp.dta, replace
// LOAD pums data from prior step and ADD control totals
	use state county sex agep dis* disdi da4cat da7compacsall d*oicv2 pwgtp* using 5ACS21_ORWA_RELDPRI.dta, clear 
	gen int year=2021
	gen agec5=""
	replace agec5="0004" if inrange(agep,0,4)
	replace agec5="0517" if inrange(agep,5,17)
	replace agec5="1834" if inrange(agep,18,34)
	replace agec5="3564" if inrange(agep,35,64)
	replace agec5="6599" if inrange(agep,65,99)
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
	merge m:1 state county sex agec5 using control_dis_tmp.dta, assert(3) nogen
	merge m:1 state county sex agec11 using control_age_tmp.dta, assert(3) nogen
// RAKE by detailed age/sex (gen pwt1) THEN by disability/age/sex (gen pwt2)
	set seed 1337170
	survwgt poststratify pwgtp, by(state county agec11 sex) totvar(a__) gen(pwt1)
	clonevar pwt2=pwt1
	set seed 1337170
	survwgt poststratify pwt1 if dis==1, by(state county agec5 sex) totvar(disaby__) gen(tmpwt)
	replace pwt2=tmpwt if dis==1
	drop tmpwt
	set seed 1337170
	survwgt poststratify pwt1 if dis==0, by(state county agec5 sex) totvar(disabn__) gen(tmpwt)
	replace pwt2=tmpwt if dis==0
	drop tmpwt
	* could add a weight step for tot inst and noncivil pop by age.	
// CHECK totals
	version 13: table county if state=="41", contents(sum pwt1 sum pwt2 mean atot) // note that the disaby tot won't confirm.
	version 13: table county if state=="41" & dis==1, contents(sum pwgtp sum pwt2 mean disabytot)
// CLEAN and SAVE
	keep state county sex da7compacsall disdi da4cat d*oicv2 disabytot agep pwt* pwgtp*
	egen byte agecat=cut(agep),at(0,5,15,18,20,25,30,40,50,60,65,99)
	destring state, replace
	replace county=strofreal(state,"%02.0f")+county 
	destring county, replace 
	drop state 
	compress
	svyset [iw=pwt2], sdr(pwgtp1-pwgtp80) vce(sdr)
	save 05_ipf_pums_v01_disaby.dta, replace
	}
	else use 05_ipf_pums_v01_disaby.dta, clear
	gen byte one=1 
// totals by disability (don't need by sex)
	mat master=J(1,14,.)
	mat colnames master="county" "sex" "disvar" "disval" "agecat" "b" "se" "z" "p" "ll" "ul" "df" "crit" "eform"
	levelsof agecat, local(ages)
	local i=0
	foreach d of varlist disdi da7compacsall da4cat dearoicv2 deyeoicv2 dremoicv2 dphyoicv2 ddrsoicv2 doutoicv2 { 
		sort county sex agecat `d'
		fillin county sex agecat `d'
		qui for var pwt2 pwgtp1-pwgtp80: replace X=0 if X==. 
		local ++i
		levelsof `d', local(levels) // or >0 to exclude non-disabled?
		foreach l of local levels {
			nois di _newline ". Disab: `d':`l' | Age: " _cont
			foreach a of local ages {
				nois di "`a'." _cont
				ereturn clear
				svy sdr: total one if agecat==`a' & `d'==`l', over(county) 
				mat table=r(table)
				mat table=table'
				mata: st_matrix("county", range(1,37,1))
				mat sex=J(37,1,0)
				mat disvar=J(37,1,`i')
				mat disval=J(37,1,`l')
				mat agecat=J(37,1,`a')
				mat result=county,sex,disvar,disval,agecat,table
				mat master=master\result
			}
		}
		drop if _fillin==1
		drop _fillin
	}
	drop _all
	svmat master, names(col)
	tostring disvar, replace
	foreach d in "1 disdi" "2 dearoicv2" "3 deyeoicv2" "4 dremoicv2" "5 dphyoicv2" "6 ddrsoicv2" "7 doutoicv2" "8 da7compacsall" "9 da4cat" {
		tokenize `d'
		replace disvar="`2'" if disvar=="`1'"
	}
	save results_agesex_disdi.dta, replace
	** clean for excel export
	drop if county==.
	collapse (sum) b, by(county disaby agecat)
	reshape wide b, i(county agecat) j(disaby)
	rename *1 *disy
	reshape wide bdisy, i(county) j(agecat) 
	order *, seq
	order county

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

// update weights for language tables
// LOAD pums data from prior step and ADD control totals
	cap confirm file "05_ipf_pums_v01_lang.dta"
	if _rc {
	use state county sex agep lanp eng fl_* flep* fa* pwgtp* using 5ACS21_ORWA_RELDPRI.dta, clear 
	gen int year=2021
	merge m:1 year state county using oha_reald_controldata.dta, assert(3) nogen
	destring county, replace
	gen coalpha=(county+1)/2
	sum coalpha if state=="41", mean
	assert `r(min)'==1 & `r(max)'==36
// rake by LEP/age
// rake by language >> convert pwt1 to pwt2
	cap drop pwt1
	clonevar pwt1=pwgtp
	local i=0
	_dots 0, title(second rake: disability/age/sex) reps(10)
	set seed 13371701 
	qui foreach a in "0004" "0517" "1834" "3564" "6599" {
		foreach s in "male" "female" {
			survwgt poststratify pwgtp if fdisaby_a`a'_`s'==1, by(state county) totvar(disaby_a`a'_`s'_e) gen(tmpwt) // reweight to match county total by age*sex 
			replace pwt1=tmpwt if fdisaby_a`a'_`s'==1 
			drop tmpwt
			local ++i
			nois _dots `i' 0
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
// CHECK
	version 13: table county if state=="41", contents(sum pwgtp sum pwt1 sum pwt2 mean totpop) format(%7.0fc) row // pwt2 matches ACS SF.
// CLEAN and SAVE
	keep state county sex disdi agep pwt* pwgtp*
	egen byte agecat=cut(agep),at(0,5,15,18,20,25,30,40,50,60,65,99)
	destring state, replace
	replace county=state*1000+county
	compress
	svyset [iw=pwt2], sdr(pwgtp1-pwgtp80) vce(sdr)
	gen byte one=1 
	save 05_ipf_pums_v01_disaby.dta, replace
	}
	else use 05_ipf_pums_v01_disaby.dta, clear
// totals by disability
	fillin county sex disdi agecat
	qui for var pwt2 pwgtp1-pwgtp80: replace X=0 if X==. 
	drop _fillin
	mat master=J(1,13,.)
	mat colnames master="county" "sex" "disaby" "agecat" "b" "se" "z" "p" "ll" "ul" "df" "crit" "eform"
	levelsof agecat, local(ages)
	forvalues s=1/2 {
		if `s'==1 local slbl="male"
		if `s'==2 local slbl="female"
		nois di _newline ". Now running: Disab: Y Sex: `slbl' Age: " _cont
		foreach a of local ages {
			nois di "`a'." _cont
			ereturn clear
			nois cap svy sdr: total one if agecat==`a' & sex==`s' & disdi==1, over(county) 
			if _rc mat table=J(9,37,0)
			else mat table=r(table)
			mat table=table'
			mata: st_matrix("county", range(1,37,1))
			mat sex=J(37,1,`s')
			mat disdi=J(37,1,1)
			mat agecat=J(37,1,`a')
			mat result=county,sex,disdi,agecat,table
			mat master=master\result
		}
	}
	drop _all
	svmat master, names(col)
	save results_agesex_disdi.dta, replace
	** clean for excel export
	drop if county==.
	keep county sex disdi agecat b
	reshape wide b, i(county agecat disdi) j(sex)
	rename *1 *male
	rename *2 *female
	reshape wide bmale bfemale, i(county agecat) j(disdi) string
	rename *1 *disy
	reshape wide bmale* bfemale*, i(county) j(agecat) 
	order *, seq
	order county




	// THIRD, two rakes: LEP + language
	cap drop pwt3
	clonevar pwt3=pwt2
	local i=0
	_dots 0, title(third rake: language by county) reps(10)
	set seed 13371701 
	qui foreach l in "eng" "spa" "fre" "ger" "sla" "kor" "chn" "vie" "tgl" "ara" "oap" "oie" "oth" {
		survwgt poststratify pwt2 if fl_`l'==1, by(state county) totvar(l_`l'_e) gen(tmpwt) // reweight to match county total by age*sex 
		replace pwt3=tmpwt if fl_`l'==1
		drop tmpwt
		local ++i
		nois _dots `i' 0
	}
	qui foreach a in "0017" "1864" "6599" {
		survwgt poststratify pwt3 if flep_a`a'==1, by(state county) totvar(lep_a`a'_e) gen(tmpwt) // reweight to match county total by age*sex 
		replace pwt3=tmpwt if flep_a`a'==1 
		drop tmpwt
		local ++i
		nois _dots `i' 0
	}
	
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


