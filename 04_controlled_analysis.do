** purpose: conduct analysis on pums
** apply external control totals 
** rake as appropriate for each table
** compile tables with MOEs (WIP)
** export dataset

** v05: fixed disability code (tbd: add language, regions)
** v04: wip to add disability
** v03: wip to add disbaility
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

// obtain control totals by age/sex/disaby
	foreach t in "dis 18101" "dear 18102" "deye 18103" "drem 18104" "dphy 18105" "ddrs 18106" "dout 18107" { 
		tokenize `t'
		tempfile tmp
		local T="B`2'"
		censusapi, url("https://api.census.gov/data/2021/acs/acs5?get=group(`T')&for=county:*&in=state:41")
		save `tmp', replace
		censusapi, url("https://api.census.gov/data/2021/acs/acs5?get=group(`T')&for=county:011&in=state:53")
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
		gen int year=2021 
		*collapse (sum) `1'_n, by(stcofips year agec5 `1') // don't need sex detail
		save control_`1'_tmp.dta, replace // merge by state county year agec5 `i'(1=yes/2=no/.=na)
	}
// obtain control totals by age/n_of_disaby
	tempfile tmp
	local T="C18108"
	censusapi, url("https://api.census.gov/data/2021/acs/acs5?get=group(`T')&for=county:*&in=state:41")
	save `tmp', replace
	censusapi, url("https://api.census.gov/data/2021/acs/acs5?get=group(`T')&for=county:011&in=state:53")
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
	gen int year=2021
	save control_dnum_tmp.dta, replace
// obtain control totals by detailed age/sex
	tempfile tmp
	local T="B01001"
	censusapi, url("https://api.census.gov/data/2021/acs/acs5?get=group(`T')&for=county:*&in=state:41")
	save `tmp', replace
	censusapi, url("https://api.census.gov/data/2021/acs/acs5?get=group(`T')&for=county:011&in=state:53")
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
	gen int year=2021
	*collapse (sum) a_n, by(stcofips year agec11)
	save control_age_tmp.dta, replace

//
// LOAD pums data from prior step and ADD control totals
cap confirm file 05_ipf_pums_v01_disaby.dta
if _rc {
	use stcofips sex agep dis deye dear ddrs dphy drem dout disdi da4cat da7compacsall d*oicv2 pwgtp* using 5ACS21_ORWA_RELDPRI.dta, clear 
	*gen stcofips=state+county
	*drop state county
	gen int year=2021
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
			replace year=2021 if _fillin==1
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
		merge m:1 stcofips year sex agec5 `d' using control_`d'_tmp.dta, assert(1 3) nogen
	}
	** add control totals by dnum
	merge m:1 stcofips year agec3 dnum using control_dnum_tmp.dta, assert(3) nogen 
	** add control totals by age/sex
	merge m:1 stcofips year sex agec11 using control_age_tmp.dta, assert(3) nogen
//
// RAKE by detailed age/sex (gen pwt1) THEN by age/numdis THEN by age/sex/dis (gen pwt2)
	set seed 1337170
	survwgt poststratify pwgtp, by(stcofips agec11 sex) totvar(a_n) gen(pwt1)
	
	
	
	set seed 1337170
	survwgt poststratify pwt1, by(stcofips agec3 dnum) totvar(dnum_n) gen(pwt3)
	set seed 1337170
	survwgt poststratify pwt3, by(stcofips agec5 sex dis) totvar(dis_n) gen(pwt2)
// CHECK totals
	version 13: table stcofips, contents(sum pwt1 sum pwt2 mean atot) // note that the disaby tot won't confirm.
	version 13: table stcofips if dis==1, contents(sum pwgtp sum pwt2 mean dis1_tot) 
// RAKE by deatiled disability and number of disabilities, then by age/sex/dis
	*set seed 1337170
	*survwgt poststratify pwt2, by(state county agec11 sex) totvar(a_n) gen(pwt1)
// CLEAN and SAVE
	keep stcofips sex d* agep atot a_n dis_n pwt* pwgtp* agec5 agec3
	egen byte agecat=cut(agep),at(0,5,15,18,20,25,30,40,50,60,65,99)
	destring stcofips, replace // svy total, over(X) requires num.
	svyset [iw=pwt2], sdr(pwgtp1-pwgtp80) vce(sdr)
	compress
	save 05_ipf_pums_v01_disaby.dta, replace
}

//	
// TABLES for OHA, using pwt2, with additional control steps for each disability, if necessary.
// disdi
	use 05_ipf_pums_v01_disaby.dta, clear
	gen byte one=1 
	mat master=J(1,13,.)
	mat colnames master="stcofips" "sex" "disdi" "agecat" "b" "se" "z" "p" "ll" "ul" "df" "crit" "eform"
	sort stcofips agecat disdi
	fillin stcofips agecat disdi // rectangularize (to ensure 37 rows for each svy total results matrix)
	qui for var pwt2 pwgtp1-pwgtp80: replace X=0 if X==. 
	drop _fillin
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
	save results_agesex_disdi.dta, replace
	** clean for excel export
	drop if stcofips==.
	collapse (sum) b, by(stcofips disdi agecat)
	reshape wide b, i(stcofips agecat) j(disdi )
	rename b* disdi*_
	reshape wide disdi0_ disdi1_, i(stcofips) j(agecat) 
	order *, seq
	order stcofips
// da4cat (none/one/two+/severe)
	use 05_ipf_pums_v01_disaby.dta, clear
	gen byte one=1 
	mat master=J(1,13,.)
	mat colnames master="stcofips" "sex" "da4cat" "agecat" "b" "se" "z" "p" "ll" "ul" "df" "crit" "eform"
	sort stcofips agecat da4cat
	fillin stcofips agecat da4cat // rectangularize (to ensure 37 rows for each svy total results matrix)
	qui for var pwt2 pwgtp1-pwgtp80: replace X=0 if X==. 
	drop _fillin
	levelsof agecat, local(ages)
	levelsof da4cat, local(ds)
	qui foreach d of local ds {
		nois di _newline ". Disab: da4cat:`d' | Age: " _cont
		foreach a of local ages {
			if `d'==3 & `a'==0 { // no iadl/severe for age 0-4
				mat table=J(1,37,0)
				exit
			}
			else {
				nois di "`a'." _cont
				ereturn clear
				svy sdr: total one if agecat==`a' & da4cat==`d', over(stcofips) 
				*if _rc mat table=J(1,37,0) // if all zeros, svy total will fail.
				mat table=r(table)
			}
			mat table=table'
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
	save results_agesex_da4cat.dta, replace
	** clean for excel export
	drop if stcofips==.
	collapse (sum) b, by(stcofips da4cat agecat)
	reshape wide b, i(stcofips agecat) j(da4cat )
	rename b* da4cat*_
	reshape wide da4cat0_ da4cat1_ da4cat2_ da4cat3_, i(stcofips) j(agecat) 
	order *, seq
	order stcofips
// da7compacsall 

	
	
	
	
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


