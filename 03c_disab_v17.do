* v17: (wip) add tables by h (hins4, medicad) and h_r (by ombrr race) and h_r_a3 (+ 3-way age group). filter variables when loading PUMS; 
*		add API key; add REALD disability items in disabyFile subroutine (formerly in OHA REALD code, moved here); rescale repwgt.
* v16: fixed bug in a_r control; added health insurance tables; adding additional universe constraints (for when U=CIV NINST)
*		major rework to PUMS-SF harmonization (by adding donor obs from statewide PUMS, rather than synthetic observations as before)
*		(maybe wasn't needed because during raking we're only adjusting weights for nonmissing values and NIU will not be a raked value)
* v15: adding 3-way broad age groups
* v14: add label/metadata for stata data exports and totals.
* v13: increased iterations; removed mata:st_matrix in favor of tab, matrow; iw insead of fw.

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
	// obtain control totals by specific impairment by age (U=civ ninst)
	foreach t in "dis 18101" "dear 18102" "deye 18103" "drem 18104" "dphy 18105" "ddrs 18106" "dout 18107" { 
		tokenize `t'
		tempfile tmp
		local T="B`2'"
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:*&in=state:41&key=$ckey")
		save `tmp', replace
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:011&in=state:53&key=$ckey")
		append using `tmp'
		drop *m *ea *ma
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
		gen byte noninscil=1
		save temp/control_`1'_tmp.dta, replace // merge by state county year agec5 `i'(1=yes/2=no/.=na)
	}
	// obtain control totals by age/n_of_disaby (U=civ ninst)
		tempfile tmp
		local T="C18108"
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:*&in=state:41&key=$ckey")
		save `tmp', replace
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:011&in=state:53&key=$ckey")
		append using `tmp'
		drop *m *ea *ma
		rename c18108_*e e*
		gen disn1_0017=e003
		gen disn2_0017=e004
		gen disn0_0017=e005
		gen disn1_1864=e007
		gen disn2_1864=e008
		gen disn0_1864=e009
		gen disn1_6599=e011
		gen disn2_6599=e012
		gen disn0_6599=e013
		tostring state, replace format(%02.0f) 
		tostring county, replace format(%03.0f)
		gen stcofips=state+county
		keep stcofips disn*
		reshape long disn0_@ disn1_@ disn2_@, i(stcofips) j(agecat) string
		reshape long disn@_, i(stcofips agecat) j(disn)
		ren disn_ disn_n
		ren agecat agec3
		egen disn2tot=sum(disn_n) if disn==2, by(stcofips)
		gen int year=`year'
		gen byte noninscil=1
		save temp/control_disn_tmp.dta, replace
	// obtain control totals by medicaid (U=civ ninst)
		*"SAHIE is the only source for single-year estimates of health insurance coverage for all US counties. If you are working with county-level analysis, it is probably a better source than the ACS."
		tempfile tmp
		local T="C27007"
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:*&in=state:41&key=$ckey")
		save `tmp', replace
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:011&in=state:53&key=$ckey")
		append using `tmp'
		drop *m *ea *ma
		rename c27007_*e e*
		gen maid_0018_1=e004+e014
		gen maid_1964_1=e007+e017
		gen maid_6599_1=e010+e020
		gen maid_0018_0=e005+e015
		gen maid_1964_0=e008+e018
		gen maid_6599_0=e011+e021
		tostring state, replace format(%02.0f) 
		tostring county, replace format(%03.0f)
		gen stcofips=state+county
		keep stcofips maid*
		reshape long maid_@_0 maid_@_1, i(stcofips) j(agecat) string
		reshape long maid__@, i(stcofips agecat) j(maid)
		ren maid__ maid_n
		ren agecat agec3b 
		gen int year=`year'
		gen byte noninscil=1
		save temp/control_maid_tmp.dta, replace
	// obtain by insured/uninsured by age/race (U=civ ninst) (r=b,n,a,p,o,m,h,wanh)
		tempfile tmp
		local T="B27001" 
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:*&in=state:41&key=$ckey")
		save `tmp', replace
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:011&in=state:53&key=$ckey")
		append using `tmp'
		drop *m *ea *ma
		rename b27001_*e e*
		gen hins_0005_1=e004+e032
		gen hins_0618_1=e007+e035
		gen hins_1925_1=e010+e038
		gen hins_2634_1=e013+e041
		gen hins_3544_1=e016+e044
		gen hins_4554_1=e019+e047
		gen hins_5564_1=e022+e050
		gen hins_6574_1=e025+e053
		gen hins_7599_1=e028+e056
		gen hins_0005_0=e005+e033
		gen hins_0618_0=e008+e036
		gen hins_1925_0=e011+e039
		gen hins_2634_0=e014+e042
		gen hins_3544_0=e017+e045
		gen hins_4554_0=e020+e048
		gen hins_5564_0=e023+e051
		gen hins_6574_0=e026+e054
		gen hins_7599_0=e029+e057
		tostring state, replace format(%02.0f) 
		tostring county, replace format(%03.0f)
		gen stcofips=state+county
		keep stcofips hins*
		reshape long hins_@_0 hins_@_1, i(stcofips) j(agecat) string
		reshape long hins__@, i(stcofips agecat) j(hins) 
		ren hins__ hins_n
		ren agecat agec9
		gen int year=`year'
		gen byte noninscil=1
		save temp/control_hins_tmp.dta, replace
		** race iterations
		local T="C27001"
		foreach r in "BB" "CN" "DA" "EP" "FO" "GM" "HH" "IWNH" {
			local s=substr("`r'",1,1)
			local r=substr("`r'",2,.)
			tempfile tmp
			censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T'`s')&for=county:*&in=state:41&key=$ckey")
			save `tmp', replace
			censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T'`s')&for=county:011&in=state:53&key=$ckey")
			append using `tmp'
			drop *m *ea *ma
			local s=lower("`s'")
			ren c27001`s'_*e e*
			gen hins_0018_1_`r'=e003
			gen hins_1964_1_`r'=e006
			gen hins_6599_1_`r'=e009
			gen hins_0018_0_`r'=e004
			gen hins_1964_0_`r'=e007
			gen hins_6599_0_`r'=e010
			tostring state, replace format(%02.0f) 
			tostring county, replace format(%03.0f)
			gen stcofips=state+county
			keep stcofips hins_*`r'
			reshape long hins_@_1_`r' hins_@_0_`r', i(stcofips) j(agecat) string
			reshape long hins__@_`r', i(stcofips agecat) j(hins)
			ren agecat agec3b
			ren hins___`r' hinsr`r'_n
			gen int year=`year'
			gen byte noninscil=1
			ren *, lower
			if "`r'"!="B" merge 1:1 stcofips year agec3b hins using temp/control_hinsr_tmp.dta, nogen assert(3) // iterations beyond the 1st
			save temp/control_hinsr_tmp.dta, replace
		}
	// obtain control totals by detailed age/sex (U=total)
		tempfile tmp
		local T="B01001"
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:*&in=state:41&key=$ckey")
		save `tmp', replace
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:011&in=state:53&key=$ckey")
		append using `tmp'
		drop *ea *m *ma
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
		ren a__ as_n // N by agesex
		rename agecat agec11
		gen int year=`year'
		*collapse (sum) as_n, by(stcofips year agec11)
		save temp/control_age_tmp.dta, replace
		** race iterations
		local T="B01001"
		foreach r in "BB" "CN" "DA" "EP" "FO" "GM" "HH" "IWNH" {
			local s=substr("`r'",1,1)
			local r=substr("`r'",2,.)
			tempfile tmp
			censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T'`s')&for=county:*&in=state:41&key=$ckey")
			save `tmp', replace
			censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T'`s')&for=county:011&in=state:53&key=$ckey")
			append using `tmp'
			drop *ea *m *ma
			local s=lower("`s'")
			ren b01001`s'_*e e*
			gen a_0004_`r'=e003+e018
			gen a_0514_`r'=e004+e005+e019+e020
			gen a_1517_`r'=e006+e021
			gen a_1819_`r'=e007+e022
			gen a_2024_`r'=e008+e023
			gen a_2529_`r'=e009+e024
			gen a_3034_`r'=e010+e025
			gen a_3544_`r'=e011+e026
			gen a_4554_`r'=e012+e027
			gen a_5564_`r'=e013+e028
			gen a_6599_`r'=e014+e015+e016+e029+e030+e031
			tostring state, replace format(%02.0f) 
			tostring county, replace format(%03.0f)
			gen stcofips=state+county
			keep stcofips a_*_`r'
			reshape long a_@_`r', i(stcofips) j(agecat) string
			ren agecat agec11b
			ren a__`r' a`r'_n
			ren *, lower
			gen int year=`year'
			if "`r'"!="B" merge 1:1 stcofips year agec11b using temp/control_ager_tmp.dta, assert(3) nogen // iterations beyond the 1st
			save temp/control_ager_tmp.dta, replace
		}
end
*disabyControls 2023

// LOAD pums data; ADD disability control totals; IPF by marginal totals
capture prog drop disabyFile
prog def disabyFile
	local year=`1'
	local y=substr("`year'",3,2)
	use state county year ombrrn reldpri agep sex hisp rac* hins* dis ddrs dear deye dout dphy drem typehugq mil pwgtp* ///
		using 5ACS`y'_ORWA_co.dta, clear 
	gen stcofips=state+county
	drop state county
	** add non institutioanlized civilian flag
	gen byte noninscil=(typehugq!=2&mil!=1)
	drop typehugq mil
	** add hins/maid flags
	gen byte hins=.
	replace hins=1 if hins1==1|hins2==1|hins3==1|hins4==1|hins5==1|hins6==1|hins7==1 // any insurance
	replace hins=0 if hins1==2&hins2==2&hins3==2&hins4==2&hins5==2&hins6==2&hins7==2 // no insurance
	gen byte maid=.
	replace maid=1 if hins4==1 // medicaid
	replace maid=0 if hins4==2 
	** add race dummies
	gen byte h=1 if inrange(hisp,2,24)
	gen byte b=1 if rac1p==2
	gen byte n=1 if inlist(rac1p,3,4,5)
	gen byte a=1 if rac1p==6
	gen byte p=1 if rac1p==7
	gen byte o=1 if rac1p==8
	gen byte m=1 if rac1p==9
	gen byte wnh=1 if rac1p==1 & hisp==1 
	** add REALD disability items 
	for var dis ddrs dear deye dout dphy drem: gen Xdi=X*-1+2 // convert 1=y,2=n into 0=n,1=y
	egen byte disn=rowtotal(ddrsdi deardi deyedi doutdi dphydi dremdi)
	replace disn=2 if disn>2 & disn<. 
	label var dphydi "Have physical limitation?"
	label var deyedi "Have vision limitation?"
	label var deardi "Have hearing limitation?"
	label var ddrsdi "Have self-care limitation?"
	label var doutdi "Have indep.liv limitation?"
	label var dremdi "Have cognitive/memory limitation?"
	label var disdi "Disabled?"
	label var disn "Number of functional limitations (0/1/2+)"
	label def DA4catACSlab ///
		0 "Non-disabled" ///
		1 "1 Limitation" ///
		2 "All others with 2+ limitations"  ///
		3 "Indep.Liv/Self-Care/PermDA/SSI/LTC", replace
	gen byte da4cat=.
	replace da4cat=0 if disn==0
	replace da4cat=1 if disn==1 & deardi==1
	replace da4cat=1 if disn==1 & deyedi==1
	replace da4cat=1 if disn==1 & dremdi==1
	replace da4cat=1 if disn==1 & dphydi==1
	replace da4cat=2 if disn>=2 & disn<. & da4cat==.
	replace da4cat=3 if (doutdi==1|ddrsdi==1)
	lab val da4cat DA4catACSlab
	label var da4cat "Four Category Disability (by # & severity)"
	label def DA7compACSlab  ///
		0 "Non-disabled" ///
		1 "Hearing limitation only" ///
		2 "Vision limitation only" ///
		3 "Mobility limitation only" ///
		4 "Cognitive/Memory limitation only" ///
		5  "2+ limitations(excluding IL/SC)" ///
		6 "IndLiv/SelfCare (IL/SC)" ///
		-7 "NA/other reason" -4 "Missing" -3 "Declined" ///
		-2 "Don't Understand"	-1 "Unknown" , replace
	gen byte da7compacsall=. 
	replace da7compacsall=0 if disdi==0 & da7compacsall==.
	replace da7compacsall=1 if deardi==1 & disn==1 & da7compacsall==.
	replace da7compacsall=2 if deyedi==1 & disn==1 & da7compacsall==.
	replace da7compacsall=3 if dphydi==1 & disn==1 & da7compacsall==.
	replace da7compacsall=4 if dremdi==1 & disn==1 & da7compacsall==.
	replace da7compacsall=5 if disn>=2 & disn<. & da7compacsall==.
	replace da7compacsall=6 if ddrs==1|dout==1
	replace da7compacsall=-4 if da7compacsall==.
	label var da7compacsall "Seven Category ACS Disability with missing codes" 
	lab val da7compacsall DA7compACSlab	
	lab def DAOIC ///
		0 "Non-disabled" ///
		1 "This limitation only" ///
		2 "2+ limitations", replace
	foreach v in "ear" "eye" "rem" "phy" "drs" "out" {
		gen byte d`v'oic=0 if disdi==0
		replace d`v'oic=1 if d`v'di==1 & disn==1
		replace d`v'oic=2 if d`v'di==1 & disn>=2 & disn<.
		lab val d`v'oic DAOIC
	}
	label var dearoic "Hearing limitation OIC"
	label var deyeoic "Vision limitation OIC"
	label var dphyoic "Mobility limitation OIC"
	label var dremoic "Cognitive limitation OIC"
	label var ddrsoic "Self-Care limitation OIC"
	label var doutoic "Indep living limitation OIC"
	lab def DAOICv2 ///
		0 "Does not have this limitation" ///
		1 "This limitation only" ///
		2 "2+ limitations", replace
	foreach v in "ear" "eye" "rem" "phy" "drs" "out" {
		gen byte d`v'oicv2=0 if d`v'di==0
		replace d`v'oicv2=1 if d`v'di==1 & disn==1
		replace d`v'oicv2=2 if d`v'di==1 & disn>=2 & disn<.
		lab val d`v'oicv2 DAOICv2
	}
	label var dearoicv2 "Hearing limitation OIC"
	label var deyeoicv2 "Vision limitation OIC"
	label var dphyoicv2 "Mobility limitation OIC"
	label var dremoicv2 "Cognitive limitation OIC"
	label var ddrsoicv2 "Self-Care limitation OIC"
	label var doutoicv2 "Indep living limitation OIC"
	// generate age groups
	for any "agec3" "agec3b" "agec5" "agec9" "agec11" "agec11b": cap drop X \\ gen X=""
	replace agec3="0017" if inrange(agep,0,17)
	replace agec3="1864" if inrange(agep,18,64)
	replace agec3="6599" if inrange(agep,65,99)
	replace agec3b="0018" if inrange(agep,0,18)
	replace agec3b="1964" if inrange(agep,19,64)
	replace agec3b="6599" if inrange(agep,65,99)
	replace agec5="0004" if inrange(agep,0,4) 
	replace agec5="0517" if inrange(agep,5,17)
	replace agec5="1834" if inrange(agep,18,34)
	replace agec5="3564" if inrange(agep,35,64)
	replace agec5="6599" if inrange(agep,65,99)
	replace agec9="0005" if inrange(agep,0,5)
	replace agec9="0618" if inrange(agep,6,18)
	replace agec9="1925" if inrange(agep,19,25)
	replace agec9="2634" if inrange(agep,26,34)
	replace agec9="3544" if inrange(agep,35,44)
	replace agec9="4554" if inrange(agep,45,54)
	replace agec9="5564" if inrange(agep,55,64)
	replace agec9="6574" if inrange(agep,65,74)
	replace agec9="7599" if inrange(agep,75,99)
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
	save 5ACS`y'_ORWA_disaby.dta, replace 
	** add donor obs if necessary to ensure all SF controls reflected in PUMS
	use 5ACS`y'_ORWA_disaby.dta, clear 
	qui foreach d in "dis agec5" "disn agec3" "maid agec3b" "hins agec9" "dear agec5" "deye agec5" "dphy agec5" "drem agec5" "ddrs agec5" "dout agec5"  { 
		tokenize `d'
		local d="`1'"
		local a="`2'"
		local s="" 
		if inlist("`d'","dis","dear","deye","dphy","drem","ddrs","dout") local s="sex" // sex, only for dis-dear-deye-dphy-drem-ddrs-dout
		nois di "adding controls for `d'"
		merge m:1 stcofips year `a' `s' noninscil `d' using temp/control_`d'_tmp.dta, keepus(`d'*_n) update // wildcard for hinsr nhw-b-n-a-p-o-m-h
		cap assert _merge!=2 // if SF controls had no matched PUMS observations
		if _rc { // add observations from donor records (sensitive to sort order, do not use m:m generally!)
			nois di ".  adding proxy/donor obs for PUMS to accord with SF (`d' x `a')"
			preserve
			keep if _merge==2
			nois di ".  found " _N " control cells in SF without a matching PUMS record"
			keep stcofips year `a' `s' noninscil `d' // not keeping `d'_n because they will be missing for donor obs added in subsequent iterations of the loop.
			merge m:m year `a' `s' noninscil `d' using 5ACS`y'_ORWA_disaby.dta, keep(3 4 5) update // add donor obs, use each matching obs only once (smaller set).
			*joinby year `a' `s' noninscil `d' using 5ACS`y'_ORWA_disaby.dta, unmatched(none) // add donor obs, all matching (larger set)
			assert _N>0 // ensure match found
			nois di ".  added " _N " obs"
			replace pwgtp=1e-6 // minimal weight for new obs. (0 or 1e-6)
			save tmp.dta
			restore
			drop if _merge==2 // drop unmatched SF controls
			append using tmp.dta // add PUMS donor obs w/associated controls
			drop _merge
			rm tmp.dta
		}
		else {
			nois di ".  all SF controls matched to PUMS"
			drop _merge
		}
	}
	** add control totals (adding to any donor obs. added above)
	foreach d in "dis agec5" "disn agec3" "maid agec3b" "hins agec9" "dear agec5" "deye agec5" "dphy agec5" "drem agec5" "ddrs agec5" "dout agec5" { 
		tokenize `d'
		local d="`1'"
		local a="`2'"
		local s="" 
		if inlist("`d'","dis","dear","deye","dphy","drem","ddrs","dout") local s="sex" // sex, only for dis-dear-deye-dphy-drem-ddrs-dout
		di "adding controls (`d' x `a')"
		merge m:1 stcofips year `a' `s' noninscil `d' using temp/control_`d'_tmp.dta, keepus(`d'*_n) update
		assert _merge!=2
		drop _merge
	}
	** add control totals by age/sex and age/race
	merge m:1 stcofips year sex agec11 using temp/control_age_tmp.dta, assert(3) nogen keepus(as_n)
	merge m:1 stcofips year agec11b using temp/control_ager_tmp.dta, assert(3) nogen keepus(a*_n)	
	** add control totals for hins by race
	merge m:1 stcofips year agec3b noninscil hins using temp/control_hinsr_tmp.dta, assert(1 3) keepus(hinsr*_n) 
	assert noninscil==0 if _merge==1 // _m==1 for NIU 
	drop _merge
	// initial rake ~ detailed age/sex (gen pwt1) 
	set seed 1337170
	survwgt poststratify pwgtp, by(stcofips agec11 sex) totvar(as_n) gen(pwt1)
	** 2nd rake by age/sex/dis (gen pwt2) ~ 3rd rake by age/numdis (gen pwt3) => deprecated, moved into loop below.
	// iterated raking ~ multiple conditions (gen pwt2--pwtN, one per loop) 
	local i=2 // starting number
	qui while `i'<=50 { // ending number (end-start = N iterations) ~ 40 iter: <2.5% ~ 50 iter: <1.5%
		local h=`i'-1
		clonevar pwt`i'=pwt`h'
		** battery 1: age/sex/dis
		set seed 1337170
		survwgt poststratify pwt`i' if noninscil==1, by(stcofips agec5 sex noninscil dis) totvar(dis_n) gen(tmp)
		replace pwt`i'=tmp if noninscil==1
		drop tmp		
		** battery 2: number of disabilities
		set seed 1337170
		survwgt poststratify pwt`i' if noninscil==1, by(stcofips agec3 noninscil disn) totvar(disn_n) gen(tmp) 
		replace pwt`i'=tmp if noninscil==1
		drop tmp
		** battery 3: specific disabilities
		foreach d in "dis" "dear" "deye" { // all ages civ ninst
			set seed 1337170
			survwgt poststratify pwt`i' if noninscil==1, by(stcofips agec5 sex noninscil `d') totvar(`d'_n) gen(tmp)
			replace pwt`i'=tmp if noninscil==1
			drop tmp
		}
		foreach d in "dphy" "drem" "ddrs" { // ages 5+ civ ninst
			set seed 1337170
			survwgt poststratify pwt`i' if noninscil<. & agep>=5, by(stcofips agec5 sex noninscil `d') totvar(`d'_n) gen(tmp)
			replace pwt`i'=tmp if noninscil==1 & agep>=5
			drop tmp
		}
		foreach d in "dout" { // ages 18+ civ ninst
			set seed 1337170
			survwgt poststratify pwt`i' if noninscil==1 & agep>=18, by(stcofips agec5 sex noninscil `d') totvar(`d'_n) gen(tmp)
			replace pwt`i'=tmp if noninscil==1 & agep>=18
			drop tmp
		}
		** battery 4: health insurance by age/race
		set seed 1337170
		survwgt poststratify pwt`i' if noninscil==1, by(stcofips agec9 noninscil hins) totvar(hins_n) gen(tmp) // all civ ninst
		replace pwt`i'=tmp if noninscil==1
		drop tmp
		foreach r in "b" "n" "a" "p" "o" "m" "h" "wnh" {
			set seed 1337170
			survwgt poststratify pwt`i' if `r'==1 & noninscil==1, by(stcofips agec3b noninscil hins `r') totvar(hinsr`r'_n) gen(tmp)
			replace pwt`i'=tmp if `r'==1 & noninscil==1
			drop tmp
		}
		** battery 5: medicaid by age
		set seed 1337170
		survwgt poststratify pwt`i' if noninscil==1, by(stcofips agec9 noninscil maid) totvar(maid_n) gen(tmp)
		replace pwt`i'=tmp if noninscil==1
		drop tmp
		** battery 6: detailed age/sex/race
		set seed 1337170
		survwgt poststratify pwt`i', by(stcofips agec11 sex) totvar(as_n) replace // all
		foreach r in "b" "n" "a" "p" "o" "m" "h" "wnh" {
			set seed 1337170
			survwgt poststratify pwt`i' if `r'==1, by(stcofips agec11b `r') totvar(a`r'_n) gen(tmp)
			replace pwt`i'=tmp if `r'==1
			drop tmp
		}		
		** report
		replace pwt`i'=0 if pwt`i'==.
		gen diff=abs(pwt`i'-pwt`h')*100
		sum diff, mean
		local dl: di %4.1f `r(mean)'
		drop diff
		gen diff=abs(pwt`i'-pwgtp)*100
		sum diff, mean
		local da: di %4.1f `r(mean)'
		drop diff
		nois di "iteration: `i' (mean abs % change in pwt this iteration: `dl'% / all time: `da'%)" 
		if `i'==0 { // never display.
			version 13: nois table stcofips if deye==1, contents(sum pwgtp sum pwt1 sum pwt`h' sum pwt`i' mean deye1_tot)  // vision totals
			version 13: nois table stcofips if maid==1, contents(sum pwgtp sum pwt1 sum pwt`h' sum pwt`i' mean maid_n)  // medicaid totals
			version 13: nois table stcofips if b==1, contents(sum pwgtp sum pwt1 sum pwt`h' sum pwt`i' mean ab_n) // Black totals
		}
		local ++i
	}
	// CHECK totals (and also check whether any improvement from more iterations)
	**	pwt1=after age/sex/dis ; pwt4=after first loop; pwt40=after 40 rounds of raking
		*version 13: table stcofips, contents(sum pwgtp sum pwt4 sum pwt40 mean a_tot) 
		*version 13: table stcofips if dis==1, contents(sum pwgtp sum pwt4 sum pwt40 mean dis1_tot) 
	// CLEAN and SAVE
		keep stcofips sex reldpri ombrrn agep noninscil a*_n d* maid hins* pwt50 pwgtp* 
		egen byte agecat=cut(agep),at(0,5,15,18,20,25,30,40,50,60,65,99) // for A11, 11-way age tables
		destring stcofips, replace // svy total, over(X) requires num.
		compress
		// define sample weights
		qui for num 1/80: replace pwgtpX=pwgtpX*(pwt50/pwgtp) // rescale repwt
		svyset [iw=pwt50], sdr(pwgtp1-pwgtp80) vce(sdr) // pwt3: agesex->disn->disdi pwt4: +conditions.
		save 5ACS`y'_ORWA_disaby.dta, replace 
end
*disabyFile 2020

// labels for datasets
cap prog drop diLabel
prog def diLabel
	gen int year=`1'
	label var year "last year of 5ACS`1' sample"
	label var stcofips "FIPS code (2-digit State + 3-digit County)"
	label var sex "Sex (0=Total 1=Male 2=Female)"
	label var agecat "Age Group (-1=Total;-2=Age<18;-3=Age18-64) (0-4 5-14 15-17 18-19 20-24 25-29 30-39 40-49 50-59 60-64 65+)"
	label var b "Estimate"
	format b %9.0g
	label var se "Standard Error"
	format se %7.4g
	label var p "p-value of hypothesis: b not equal to 0"
	format p %4.3f
	label var ll "90% CI: lower value"
	replace ll=max(0,ll)
	format ll %7.0f
	label var ul "90% CI: upper value"
	format ul %7.0f
	drop z df crit eform
	lab def SEX 0 "Total" 1 "Male" 2 "Female", replace
	lab def AGEC11 -3 "18-64" -2 "<18" -1 "Total" 0 "0-4" 5 "5-14" 15 "15-17" 18 "18-19" 20 "20-24" 25 "25-29" 30 "30-39" 40 "40-49" 50 "50-59" 60 "60-64" 65 "65+", replace
	label values agecat AGEC11
	label values sex SEX
	recast byte sex
	recast byte agecat
	gen rse=se/b
	format rse %3.2f
	label var rse "Relative Standard Error (RSE=se/b)"
	replace rse=round(rse,.01)
	recode rse (0/.299=1) (.3/.499=2) (.5/.=3), gen(flag)
	label var flag "RSE-derived reliability flag (0 reliable; >.3 unreliable; >.5 highly unreliable)"
	lab def FLAG 1 "Reliable" 2 "Unreliable" 3 "Highly Unreliable"
	label values flag FLAG
	assert flag<.
	// disability-specific labels
end

// tables by disdi
cap prog drop tabdisdi
prog def tabdisdi
	cap use results/results_disdi_`1'.dta, clear
	if _rc {
		local y=substr("`1'",3,2)
		use stcofips sex agecat pwt* pwgtp* disdi noninscil if noninscil==1 using 5ACS`y'_ORWA_disaby.dta, clear
		drop noninscil 
		mat master=J(1,13,.)
		mat colnames master="stcofips" "sex" "disdi" "agecat" "b" "se" "z" "p" "ll" "ul" "df" "crit" "eform"
		sort stcofips agecat disdi
		fillin stcofips agecat disdi // rectangularize (to ensure 37 rows for each svy total results matrix)
		recode agecat (0/17=-2) (18/64=-3) (65/99=.), gen(agec3)
		qui for var pwt50 pwgtp1-pwgtp80: replace X=0 if X==. 
		drop _fillin
		gen byte one=1 
		levelsof agec3, local(acats)
		levelsof agecat, local(ages)
		qui forvalues d=-1/1 {
			nois di _newline ". Disab: disdi:`d' | Age: " _cont
			** detailed ages 
			foreach a of local ages {
				nois di "`a'." _cont
				ereturn clear
				if `d'>=0 svy sdr: total one if agecat==`a' & disdi==`d', over(stcofips) 
				else if `d'==-1 svy sdr: total one if agecat==`a' & disdi<., over(stcofips) 
				mat table=r(table)
				mat table=table'
				qui tab stcofips, matrow(stcofips)
				mat sex=J(37,1,0)
				mat disdi=J(37,1,`d')
				mat agecat=J(37,1,`a')
				mat result=stcofips,sex,disdi,agecat,table
				mat master=master\result
			}
			** total
			nois di "-1." _cont
			ereturn clear
			if `d'>=0 svy sdr: total one if disdi==`d', over(stcofips) 
			else if `d'==-1 svy sdr: total one if disdi<., over(stcofips) 
			mat table=r(table)
			mat table=table'
			qui tab stcofips, matrow(stcofips)
			mat sex=J(37,1,0)
			mat disdi=J(37,1,`d')
			mat agecat=J(37,1,-1)
			mat result=stcofips,sex,disdi,agecat,table
			mat master=master\result
			** broad ages
			foreach a of local acats {
				nois di "`a'." _cont
				ereturn clear
				if `d'>=0 svy sdr: total one if agec3==`a' & disdi==`d', over(stcofips) 
				else if `d'==-1 svy sdr: total one if agec3==`a' & disdi<., over(stcofips) 
				mat table=r(table)
				mat table=table'
				qui tab stcofips, matrow(stcofips)
				mat sex=J(37,1,0)
				mat disdi=J(37,1,`d')
				mat agecat=J(37,1,`a')
				mat result=stcofips,sex,disdi,agecat,table
				mat master=master\result
			}
		}
		drop _all
		svmat master, names(col)
		drop if stcofips==.
		diLabel `1'
		lab def DIS2 -1 "Total" 0 "No disability" 1 "One or more conditions", replace
		lab var disdi "Disability status (2-way)"
		label values disdi DISDI
		save results/results_disdi_`1'.dta, replace
	}
end
*tabdisdi 2020

// tables by da4cat (none/one/two+/severe) 
cap prog drop tabda4
prog def tabda4
	cap use results/results_da4cat_`1'.dta, clear
	if _rc {
		local y=substr("`1'",3,2)
		use stcofips sex agecat pwt* pwgtp* da4cat noninscil if noninscil==1 using 5ACS`y'_ORWA_disaby.dta, clear
		drop noninscil 
		mat master=J(1,13,.)
		mat colnames master="stcofips" "sex" "da4cat" "agecat" "b" "se" "z" "p" "ll" "ul" "df" "crit" "eform"
		sort stcofips agecat da4cat
		fillin stcofips agecat da4cat // rectangularize (to ensure 37 rows for each svy total results matrix)
		recode agecat (0/17=-2) (18/64=-3) (65/99=.), gen(agec3)
		qui for var pwt50 pwgtp1-pwgtp80: replace X=0 if X==. 
		drop _fillin
		gen byte one=1 
		levelsof agecat, local(ages)
		qui forvalues d=-1/3 {
			nois di _newline ". Disab: da4cat:`d' | Age: " _cont
			** detailed ages
			foreach a of local ages {
				nois di "`a'." _cont
				ereturn clear
				if `d'==3 & `a'==0 { // no iadl/severe for age 0-4
					mat table=J(37,9,0)
				}
				else {
					if `d'>=0 svy sdr: total one if agecat==`a' & da4cat==`d', over(stcofips) 
					else if `d'==-1 svy sdr: total one if agecat==`a' & da4cat<., over(stcofips) 
					mat table=r(table)'
				}
				qui tab stcofips, matrow(stcofips)
				mat sex=J(37,1,0)
				mat da4cat=J(37,1,`d')
				mat agecat=J(37,1,`a')
				mat result=stcofips,sex,da4cat,agecat,table
				mat master=master\result
			}
			** totals
			nois di "-1." _cont
			ereturn clear
			if `d'>=0 svy sdr: total one if da4cat==`d', over(stcofips) 
			else if `d'==-1 svy sdr: total one if da4cat<., over(stcofips) 
			mat table=r(table)'
			qui tab stcofips, matrow(stcofips)
			mat sex=J(37,1,0)
			mat da4cat=J(37,1,`d')
			mat agecat=J(37,1,-1)
			mat result=stcofips,sex,da4cat,agecat,table
			mat master=master\result
			** broad ages
			foreach a of local acats {
				nois di "`a'." _cont
				ereturn clear
				if `d'==3 & `a'==0 { // no iadl/severe for age 0-4
					mat table=J(37,9,0)
				}
				else {
					if `d'>=0 svy sdr: total one if agec3==`a' & da4cat==`d', over(stcofips) 
					else if `d'==-1 svy sdr: total one if agec3==`a' & da4cat<., over(stcofips) 
					mat table=r(table)'
				}
				qui tab stcofips, matrow(stcofips)
				mat sex=J(37,1,0)
				mat da4cat=J(37,1,`d')
				mat agecat=J(37,1,`a')
				mat result=stcofips,sex,da4cat,agecat,table
				mat master=master\result
			}
		}
		drop _all
		svmat master, names(col)
		drop if stcofips==.
		diLabel `1'
		lab def DIS4 -1 "Total" 0 "No disability" 1 "One limitation of hearing/vision/mobility/memory" 2 "Two or more limitations of hearing/vision/mobility/memory" 3 "Limited indep.liv/self-care/perm.da/ssi/ltc", replace
		lab var da4cat "Disability status (4-way)"
		label values da4cat DIS4
		save results/results_da4cat_`1'.dta, replace
	}
end
*tabda4 2020

// tables by da7compacsall 
capture prog drop tabda7
prog def tabda7
	cap use results/results_da7compacsall_`1'.dta, clear
	if _rc {
		local y=substr("`1'",3,2)
		use stcofips sex agecat pwt* pwgtp* da7compacsall noninscil if noninscil==1 using 5ACS`y'_ORWA_disaby.dta, clear
		drop noninscil 
		mat master=J(1,13,.)
		mat colnames master="stcofips" "sex" "da7compacsall" "agecat" "b" "se" "z" "p" "ll" "ul" "df" "crit" "eform"
		sort stcofips agecat da7compacsall
		fillin stcofips agecat da7compacsall // rectangularize (to ensure 37 rows for each svy total results matrix)
		recode agecat (0/17=-2) (18/64=-3) (65/99=.), gen(agec3)
		qui for var pwt50 pwgtp1-pwgtp80: replace X=0 if X==. 
		drop _fillin
		gen byte one=1 
		levelsof agecat, local(ages)
		qui forvalues d=-1/6 {
			nois di _newline ". Disab: da7compacsall:`d' | Age: " _cont
			** detailed ages
			foreach a of local ages {
				nois di "`a'." _cont
				ereturn clear
				if `a'==0 & inlist(`d',3,4,6) {
					mat table=J(37,9,0) // all zeros
				}
				else {
					if `d'>=0 svy sdr: total one if agecat==`a' & da7compacsall==`d', over(stcofips) 
					else if `d'==-1 svy sdr: total one if agecat==`a' & da7compacsall<., over(stcofips) 
					mat table=r(table)'
				}
				qui tab stcofips, matrow(stcofips)
				mat sex=J(37,1,0)
				mat da7compacsall=J(37,1,`d')
				mat agecat=J(37,1,`a')
				mat result=stcofips,sex,da7compacsall,agecat,table
				mat master=master\result
			}
			** totals
			nois di "-1." _cont
			ereturn clear
			if `d'>=0 svy sdr: total one if da7compacsall==`d', over(stcofips) 
			else if `d'==-1 svy sdr: total one if da7compacsall<., over(stcofips) 
			mat table=r(table)'
			qui tab stcofips, matrow(stcofips)
			mat sex=J(37,1,0)
			mat da7compacsall=J(37,1,`d')
			mat agecat=J(37,1,-1)
			mat result=stcofips,sex,da7compacsall,agecat,table
			mat master=master\result
			** broad ages
			foreach a of local acats {
				nois di "`a'." _cont
				ereturn clear
				if `a'==0 & inlist(`d',3,4,6) {
					mat table=J(37,9,0) // all zeros
				}
				else {
					if `d'>=0 svy sdr: total one if agec3==`a' & da7compacsall==`d', over(stcofips) 
					else if `d'==-1 svy sdr: total one if agec3==`a' & da7compacsall<., over(stcofips) 
					mat table=r(table)'
				}
				qui tab stcofips, matrow(stcofips)
				mat sex=J(37,1,0)
				mat da7compacsall=J(37,1,`d')
				mat agecat=J(37,1,`a')
				mat result=stcofips,sex,da7compacsall,agecat,table
				mat master=master\result
			}
		}
		drop _all
		svmat master, names(col)
		drop if stcofips==.
		diLabel `1'
		lab def DIS7 -1 "Total" 0 "No disability" 1 "Hearing only" 2 "Vision only" 3 "Mobility only" 4 "Cognitive only" 5 "Two or more limitations (excl. IL/SC)" 6 "Indep.Liv./Self Care", replace
		lab var da7compacsall "Disability status (7-way)"
		label values da7compacsall DIS7
		save results/results_da7compacsall_`1'.dta, replace
	}
end
*tabda7 2020

// tables by d*oicv2 
capture prog drop tabdaoic
prog def tabdaoic
	local y=substr("`1'",3,2)
	use stcofips sex agecat pwt* pwgtp* d*oicv2 noninscil if noninscil==1 using 5ACS`y'_ORWA_disaby.dta, clear
	drop noninscil 
	foreach v in "dear" "deye"  "dphy" "drem" "ddrs" "dout" {  
		cap confirm file results/results_`v'oicv2_`1'.dta
		if _rc {
			preserve
			mat master=J(1,13,.)
			mat colnames master="stcofips" "sex" "`v'oicv2" "agecat" "b" "se" "z" "p" "ll" "ul" "df" "crit" "eform"
			sort stcofips agecat `v'oicv2
			fillin stcofips agecat `v'oicv2 // rectangularize (to ensure 37 rows for each svy total results matrix)
			recode agecat (0/17=-2) (18/64=-3) (65/99=.), gen(agec3)
			qui for var pwt50 pwgtp1-pwgtp80: replace X=0 if X==. 
			drop _fillin
			gen byte one=1 
			levelsof agecat, local(ages)
			forvalues d=0/2 {
				nois di _newline ". Disab: `v'oicv2:`d' | Age: " _cont
				** detailed age groups
				qui foreach a of local ages {
					nois di "`a'." _cont
					ereturn clear
					if (`a'==0 & inlist("`v'","dphy","drem","ddrs","dout")) | ///
					   (`a'==5 & inlist("`v'","dout")) {
						mat table=J(37,9,0)
					}
					else {
						if `d'>=0 svy sdr: total one if agecat==`a' & `v'oicv2==`d', over(stcofips) 
						else if `d'==-1 svy sdr: total one if agecat==`a' & `v'oicv2<., over(stcofips) 
						mat table=r(table)'
					}
					qui tab stcofips, matrow(stcofips)
					mat sex=J(37,1,0)
					mat `v'oicv2=J(37,1,`d')
					mat agecat=J(37,1,`a')
					mat result=stcofips,sex,`v'oicv2,agecat,table
					mat master=master\result
				}
				** total
				nois di "-1." _cont
				ereturn clear
				if `d'>=0 svy sdr: total one if `v'oicv2==`d', over(stcofips) 
				else if `d'==-1 svy sdr: total one if `v'oicv2<., over(stcofips) 
				mat table=r(table)'
				qui tab stcofips, matrow(stcofips)
				mat sex=J(37,1,0)
				mat `v'oicv2=J(37,1,`d')
				mat agecat=J(37,1,-1)
				mat result=stcofips,sex,`v'oicv2,agecat,table
				mat master=master\result
				** broad age groups
				qui foreach a of local acats {
					nois di "`a'." _cont
					ereturn clear
					if (`a'==0 & inlist("`v'","dphy","drem","ddrs","dout")) | ///
					   (`a'==5 & inlist("`v'","dout")) {
						mat table=J(37,9,0)
					}
					else {
						if `d'>=0 svy sdr: total one if agec3==`a' & `v'oicv2==`d', over(stcofips) 
						else if `d'==-1 svy sdr: total one if agec3==`a' & `v'oicv2<., over(stcofips) 
						mat table=r(table)'
					}
					qui tab stcofips, matrow(stcofips)
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
			drop if stcofips==.
			diLabel `1'
			lab def DIS3 0 "Without this condition" 1 "With this condition only" 2 "With this and one or more other conditions", replace
			lab values `v'oicv2 DIS3
			cap lab var dearoicv2 "Hearing impairment (3-way)"
			cap lab var deyeoicv2 "Vision impairment (3-way)"
			cap lab var dphyoicv2 "Mobility impairment (3-way)"
			cap lab var dremoicv2 "Cognitive impairment (3-way)"
			cap lab var ddrsoicv2 "Self-care impairment (3-way)"
			cap lab var doutoicv2 "Independent Living impairment (3-way)"
			save results/results_`v'oicv2_`1'.dta, replace
			restore
		}
	}
end
*tabdaoic 2020

// tables by hisn4 (maid) and hins4*race
// totals by OMB rarest race/ethnicity (H, HR, HRA3)
capture prog drop tabHinsR
prog def tabHinsR
	cap use results/results_hins_ombrr_`1'.dta, clear
	if _rc {
		local y=substr("`1'",3,2)
		use stcofips sex ombrrn agecat pwt* pwgtp* hins noninscil if noninscil==1 using 5ACS`y'_ORWA_disaby.dta, clear
		drop noninscil 
		fillin stcofips sex ombrrn agecat
		recode agecat (0/17=-2) (18/64=-3) (65/99=.), gen(agec3) // 65+ already done.
		qui for var pwt50 pwgtp1-pwgtp80: replace X=0 if X==.
		drop _fillin
		mat master=J(1,14,.)
		mat colnames master="stcofips" "sex" "hins" "ombrrn" "agecat" "b" "se" "z" "p" "ll" "ul" "df" "crit" "eform"
		gen byte one=1 
		levelsof agecat, local(ages)
		levelsof agec3 if agec3<., local(acats) 
		forvalues h=0/1 { // 0=entire Univ; 1=has medicaid/hins4==true.
			forvalues r=0/7 {
				local rlbl: label ombrrn `r'
				if `r'==0 local rlbl="total"
				nois di _newline ". Now running: Medicaid (HINS4) for OMBRR: `rlbl' Age: " _cont
				/** detailed ages 
				foreach a of local ages {
					nois di "`a'." _cont
					ereturn clear
					if `h'>0 & `r'>0 qui svy sdr: total one if agecat==`a' & ombrrn==`r' & hins==`h', over(stcofips) 
					else if `h'==0 & `r'>0 qui svy sdr: total one if agecat==`a' & ombrrn==`r' & hins<., over(stcofips) 
					else if `h'==0 & `r'==0 qui svy sdr: total one if agecat==`a' & ombrrn<. & hins<., over(stcofips) 
					else if `h'>0 & `r'==0 qui svy sdr: total one if agecat==`a' & ombrrn<. & hins==`h', over(stcofips) 
					mat table=r(table)
					mat table=table'
					qui tab stcofips, matrow(stcofips)
					mat hins=J(37,1,1)
					mat ombrrn=J(37,1,`r')
					mat agecat=J(37,1,`a')
					mat result=stcofips,hins,ombrrn,agecat,table
					mat master=master\result
				} */
				** all ages
				nois di "-1." _cont
				ereturn clear
				if `h'>0 & `r'>0 qui svy: total one if ombrrn==`r' & hins==`h', over(stcofips)
				else if `h'==0 & `r'>0 qui svy: total one if ombrrn==`r' & hins<., over(stcofips)
				else if `h'==0 & `r'==0 qui svy: total one if ombrrn<. & hins<., over(stcofips)
				else if `h'>0 & `r'==0 qui svy: total one if ombrrn<. & hins==`h', over(stcofips)
				mat table=r(table)
				mat table=table'
				qui tab stcofips, matrow(stcofips)
				mat sex=J(37,1,0)
				mat hins=J(37,1,`h')
				mat ombrrn=J(37,1,`r')
				mat agecat=J(37,1,-1)
				mat result=stcofips,sex,hins,ombrrn,agecat,table
				mat master=master\result
				** broad age groups
				foreach a of local acats {
					nois di "`a'." _cont
					ereturn clear
					if `h'>0 & `r'>0 qui svy sdr: total one if agec3==`a' & ombrrn==`r' & hins==`h', over(stcofips) 
					else if `h'==0 & `r'>0 qui svy sdr: total one if agec3==`a' & ombrrn==`r' & hins<., over(stcofips) 
					else if `h'==0 & `r'==0 qui svy sdr: total one if agec3==`a' & ombrrn<. & hins<., over(stcofips) 
					else if `h'>0 & `r'==0 qui svy sdr: total one if agec3==`a' & ombrrn<. & hins==`h', over(stcofips) 
					mat table=r(table)
					mat table=table'
					qui tab stcofips, matrow(stcofips)
					mat sex=J(37,1,0)
					mat hins=J(37,1,`h')
					mat ombrrn=J(37,1,`r')
					mat agecat=J(37,1,`a') 
					mat result=stcofips,sex,hins,ombrrn,agecat,table
					mat master=master\result
				}
			}
		}
		di _newline
		drop _all
		svmat master, names(col)
		lab def ombrr 0 "total" 1 "aian" 2 "asian" 3 "black" 4 "hispanic" 5 "nhpi" 6 "other" 7 "white", replace
		label values ombrrn ombrr
		decode ombrrn, gen(ombrr)
		drop ombrrn
		drop if stcofips==.
		diLabel `1'
		gen byte noninscil=1
		label var noninscil "non-institutionalized civilian (0=no/1=yes)"
		label var ombrr "OMB Single Race (1997 Standard; Rarest Race Method)"
		save results/results_hins_ombrr_`1'.dta, replace
	}
end
*tabHinsR 2023

