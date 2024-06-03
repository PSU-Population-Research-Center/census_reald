* v13: increased iterations; removed mata:st_matrix in favor of tab, matrow

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
		ren a__ as_n // N by agesex
		rename agecat agec11
		gen int year=`year'
		*collapse (sum) as_n, by(stcofips year agec11)
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
	survwgt poststratify pwgtp, by(stcofips agec11 sex) totvar(as_n) gen(pwt1)
	set seed 1337170
	survwgt poststratify pwt1, by(stcofips agec3 dnum) totvar(dnum_n) gen(pwt2)
	set seed 1337170
	survwgt poststratify pwt2, by(stcofips agec5 sex dis) totvar(dis_n) gen(pwt3)
	replace pwt3=0 if pwt3==.
	// RAKE by specific conditions ~ starting with n=4th iteration, minimum 6 further iterations.
	local i=4 // starting number
	qui while `i'<=40 { // ending number (end-start = N iterations)
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
		survwgt poststratify pwt`i', by(stcofips agec11 sex) totvar(as_n) replace
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
		version 13: table stcofips, contents(sum pwt1 sum pwt3 sum pwt4 sum pwt40 mean atot) 
		version 13: table stcofips if dis==1, contents(sum pwgtp sum pwt3 sum pwt4 sum pwt40 mean dis1_tot) 
	// repeat RAKE by detailed age/sex to ensure consistent totals
		** not needed because this dataset is not used for total population, only disabled.
		*set seed 1337170
		*survwgt poststratify pwt2, by(state county agec11 sex) totvar(a_n) gen(pwt1)
	// CLEAN and SAVE
		keep stcofips sex d* agep atot as_n dis_n pwt1 pwt2 pwt3 pwt40 pwgtp* agec5 agec3
		egen byte agecat=cut(agep),at(0,5,15,18,20,25,30,40,50,60,65,99)
		destring stcofips, replace // svy total, over(X) requires num.
		svyset [iw=pwt40], sdr(pwgtp1-pwgtp80) vce(sdr) // pwt3: agesex->dnum->disdi pwt4: +conditions.
		compress
		save 5ACS`y'_ORWA_RELDPRI_disaby.dta, replace
end
*disabyFile 2020

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
		qui for var pwt40 pwgtp1-pwgtp80: replace X=0 if X==. 
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
		save results/results_disdi_`1'.dta, replace
	}
	** clean for excel export
	collapse (sum) b, by(stcofips disdi agecat)
	reshape wide b, i(stcofips agecat) j(disdi )
	rename b* disdi*_
	reshape wide disdi0_ disdi1_, i(stcofips) j(agecat) 
	order *, seq
	order stcofips
end
*tabdisdi 2020

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
		qui for var pwt40 pwgtp1-pwgtp80: replace X=0 if X==. 
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
		save results/results_da4cat_`1'.dta, replace
	}
	** clean for excel export
	collapse (sum) b, by(stcofips da4cat agecat)
	reshape wide b, i(stcofips agecat) j(da4cat )
	rename b* da4cat*_
	reshape wide da4cat0_ da4cat1_ da4cat2_ da4cat3_, i(stcofips) j(agecat) 
	order *, seq
	order stcofips
end
*tabda4 2020

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
		qui for var pwt40 pwgtp1-pwgtp80: replace X=0 if X==. 
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
		save results/results_da7compacsall_`1'.dta, replace
	}
	** clean for excel export
	collapse (sum) b, by(stcofips da7compacsall agecat)
	reshape wide b, i(stcofips agecat) j(da7compacsall )
	rename b* da7compacsall*_
	reshape wide da7compacsall0_ da7compacsall1_ da7compacsall2_ da7compacsall3_ ///
				 da7compacsall4_ da7compacsall5_ da7compacsall6_, i(stcofips) j(agecat) 
	order *, seq
	order stcofips
end
*tabda7 2020

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
			qui for var pwt40 pwgtp1-pwgtp80: replace X=0 if X==. 
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
			save results/results_`v'oicv2_`1'.dta, replace
			restore
		}
	}
	** clean for excel export
	foreach v in "dear" "deye" "dphy" "drem" "ddrs" "dout" {
		use results/results_`v'oicv2_`1'.dta, clear
		collapse (sum) b, by(stcofips `v'oicv2 agecat)
		reshape wide b, i(stcofips agecat) j(`v'oicv2 )
		rename b* `v'oicv2*_
		reshape wide `v'oicv20_ `v'oicv21_ `v'oicv22_, i(stcofips) j(agecat) 
		order *, seq
		order stcofips
		*browse
		*pause on
		*pause
	}
end
*tabdaoic 2020

	