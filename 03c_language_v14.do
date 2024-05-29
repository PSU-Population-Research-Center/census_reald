* v14: added statewide table for detailed age groups; improved SOS tables code
* v13: removed foreign birthplace controls; moved to below (language splits)
* v13: added code for OR SOS tables by langfnl, and support for some 2022 geography/api changes
* TBD: 
*	add race/eth OR ancestry/waob for more accurate county lang codes.
*	address the elephant in the room (Somali)
*	summary document explaining languages added/dropped from list
*	additional table with sex/agecat detail for bins: (6 groups: m5-17,m18-64,m65+,f5-17,f18-64,f65+)*(3 bins: 25-100, 100-299, 300+)
*	convert Chinese and Persian splits into counts (instead of %)

/*** part 3
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
// -- tabulations, per SOS files (imported from _ORSOS_HB3021_languages_vXX)

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
	** consider: include 5ACS10, 5ACS15 PUMS for small populations
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
		gen int year=`year'
		subsave if stcofips!="41" using temp/control_langc42co_tmp.dta, replace // county totals (wash/multco only)
		keep if stcofips=="41"
		ren stcofips stfips
		ren lc42_n lc42st_n
		version 13: table langc42 lep, contents(sum lc42st_n) col
		save temp/control_langc42st_tmp.dta, replace // state totals (OR only)
	// obtain control totals by lang12 (latest, state + county)
	** consider: 
		local T="C16001"
		tempfile tmp
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:*&in=state:41")
		save `tmp', replace
		censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(`T')&for=county:011&in=state:53")
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
		version 13: table langc12 lep, contents(sum lc12_n) col
		save temp/control_langc12_tmp.dta, replace
	// obtain latest counts by birthplace in hong kong/taiwan, mainland china, iran/afghanistan
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
	// obtain control totals by detailed race/ethnicity (ACS tables B02014-B03001)		
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
*langControls 2021

// generate donor samples from previous ACS PUMS 
** 	used only to get traits (age/sex/lep) for language speakers not in PUMS, but in ACS tables
** 	pulls single-year PUMS from up to 5-years ago (starting in 2016, so that langcodes + pumas match)
cap prog drop donorLang
prog def donorLang
	local start=max(`1'-5,2016)
	local end=`1'
	if `start'<=`end' {
		local yabbv=substr("`1'",3,2)
		local i=1
		tempfile tmp
		forvalues y=`start'/`end' {
			foreach g in "for=state:41" "for=state:53" {
				if inrange(`y',2016,2021) & substr("`g'",-2,2)=="53" local g="for=public%20use%20microdata%20area:11101,11102,11103,11104&in=state:53"
				if inrange(`y',2022,2031) & substr("`g'",-2,2)=="53" local g="for=public%20use%20microdata%20area:21101,21102,21103,21104&in=state:53"
				local vars="ST,AGEP,SEX,LANX,ENG,LANP,PWGTP" // not keeping PUMA or PUMA10/PUMA20 for donor obs...
				censusapi, url("https://api.census.gov/data/`y'/acs/acs1/pums?get=`vars'&`g'&key=$ckey") 
				assert st!="" // ensure it worked
				if `i'==1 save `tmp'
				if `i'>1 {
					append using `tmp'
					save `tmp', replace
				}
				local ++i
			}
		}
		cap drop publicusemicroda
		cap drop state
		destring lanp, replace ignore("N")
		keep if inrange(lanp,1000,9999) // keep persons with a language other than english
		ren lanp lanp16
		merge m:1 lanp16 using 02_langxwalk.dta, assert(2 3) keep(1 3) nogen keepus(langfnl)
		gen lep=.
		replace lep=0 if eng==1 | lanx==2
		replace lep=1 if inlist(eng,2,3,4)
		assert lep<. if agep>=5 
		save "acs/donor_lanp_5acs`yabbv'.dta", replace 
	}
end
*donorLang 2021

// attach merge/rake points in PUMS
cap prog drop langFile
prog def langFile
	local year=`1'
	local y=substr("`year'",3,2)
	** load PUMS
	use year state county sex agep lanx lanp eng pw* using 5ACS`y'_ORWA_RELDPRI.dta, clear
	gen stfips=state
	gen stcofips=state+county
	drop state county
	** language categories
	ren lanp lanp16 // only works for PUMS samples from 2016+
	merge m:1 lanp16 using 02_langxwalk.dta, keep(1 3) nogen keepus(langfnl lf_label)
	labmask langfnl, values(lf_label)
	drop lf_label
	** lep
	gen lep=.
	replace lep=0 if eng==1 | lanx==2
	replace lep=1 if inlist(eng,2,3,4)
	assert lep<. if agep>=5 
	** fillin such that every lang*lep status is represented and has nonmissing age/sex
	** this is necessary because sometimes control totals require adjustment of weights where no matching speakers exist in PUMS
	** (1) make a list of lang*lep that are missing for each county; (2) hotdeck from donor obs without geo restriction
	preserve
	tempfile tmp2
	fillin year stcofips langfnl lep // ensure complete list of langfnl for each county
	drop if inlist(langfnl,85,85,86,90,91,92) // languages w/o donors in region, and with another lang39/lang42/lang12 record
	drop if inlist(langfnl,94,95,97,98,99,100) // drop specific aian languages when unknown EXCEPT navajo (because it's on the lang39 list)
	keep if _fillin==1 & langfnl<. & lep<. 
	replace stfips=substr(stcofips,1,2) if stfips==""
	keep year stfips stcofips langfnl lep lanx lanp16 agep sex
	append using acs/donor_lanp_5acs16.dta, keep(langfnl lanp16 lep lanx lanp agep sex) gen(add) // hardcoded to 5ACS16
	append using acs/donor_lanp_5acs21.dta, keep(langfnl lanp16 lep lanx lanp agep sex) gen(add2) // hardcoded to 5ACS21
	set seed 13371701
	bys langfnl lep: hotdeckvar lanp16 lanx agep sex, suffix("_m1")
	bys langfnl: hotdeckvar lanp16 lanx agep sex, suffix("_m2")
	drop if add==1 | add2==1
	for var lanp16 lanx agep sex: replace X=X_m1 if X==. & X_m1<. \\ replace X=X_m2 if X==. & X_m2<.
	drop add *_m1 *_m2
	assert sex<. & agep<. & lanp<. & lanx<. & langfnl<. & lep<.
	keep if sex<. & agep<. & lanp<. & lanx<. & langfnl<. & lep<.
	gen pwgtp=1e-3 
	save `tmp2'
	restore
	append using `tmp2'
	** summarized language categories
	merge m:m langfnl using 02_langxwalk.dta, keep(1 3) nogen keepus(lf_label langc39 langc42 langc12 langc5)
	tab1 langc39 langc42 langc12 langc5 if lanp16<., mis // ensure no missings for non-english languages
	** fix english only speakers
	for var langc*: replace X="eng" if lanx==2 // ensure speaks english only is given lang="eng"
	assert lep==0 if lanx==2
	tab langc12 lep, mis 
	tab langc39 lep, mis 
	tab langc42 lep, mis 
	tab1 langc39 langc42 langc12 langc5 if lanp16<. | (lanx==2), mis // ensure no missings for non-english languages
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
	** merge control totals by age/sex
	assert stcofips!="" & year<. & sex<. & agec11!=""
	merge m:1 stcofips sex agec11 using temp/control_age_tmp.dta, assert(3) keepus(as_n) nogen
	** merge control totals by lc5/lep/ac3?
	*assert stcofips!="" & year<. & sex<. & (agec3=="" | langc5!="")	
	*merge m:1 stcofips agec3 langc5 lep using temp/control_lc5ac3lep_tmp.dta, assert(1 3) // broad lang/age detail
	*drop _merge
	** merge place of birth detail ~ help allocation within multi-county pumas
	*TBD
	** merge control totals by 2015 langc39 
	assert stcofips!="" & year<. & (lep<.|agec11=="0004") & (langc39!=""|agec11=="0004")
	merge m:1 stcofips langc39 lep using temp/control_langc39_tmp.dta, assert(1 3) keepus(lc39_n) // old county lang39
	ren lc39_n lc39_n_co
	assert _merge==3 if agec11!="0004"
	drop _merge
	** merge latest county totals by langc12/lep
	assert stcofips!="" & year<. & (lep<.|agec11=="0004") & (langc12!=""|agec11=="0004")
	merge m:1 stcofips year langc12 lep using temp/control_langc12_tmp.dta, assert(1 3) keepus(lc12_n) // latest county lang12
	ren lc12_n lc12_n_co
	assert _merge==3 if agec11!="0004"
	drop _merge
	** merge OR state totals by langc42/lep
	assert stfips!="" & year<. & (lep<.|agec11=="0004") & (langc42!=""|agec11=="0004")
	merge m:1 stfips year langc42 lep using temp/control_langc42st_tmp.dta, assert(1 3) keepus(lc42st_n) // state total by lang42
	assert _merge==3 if (agec11!="0004" & stfips=="41") // no state control for Clark Co.
	drop _merge
	// define weights
	svrset set pw pwgtp
	svrset set rw pwgtp1-pwgtp80
	svyset [pw=pwgtp], sdr(pwgtp1-pwgtp80) vce(sdr) mse
	// PRE-RAKE: counties by age & sex
	*set seed 1337170
	*survwgt poststratify pwgtp, by(stcofips agec11 sex) totvar(as_n) gen(pwt0) 
	// PRE-RAKE: small counties to their 2015 lang39 (last detailed county tables)
	gen touse=!inlist(stcofips,"41029","41019","41039","41017","41047","41051","41005","41067","53011") // single-county PUMAs
	set seed 1337170
	survwgt poststratify pwgtp if touse==1 & agep>=5, by(stcofips langc39 lep) totvar(lc39_n) gen(pwt1) // control to 2015 detailed languages (for multi-county PUMAs)
	replace pwt1=pwgtp if touse==0 | agep<5 // use original PUMS weights for single-county PUMAs
	replace pwt1=1e-3 if pwt1==0 | pwt1==. // ensure non-zero probability of selection in future rake
	// PRE-RAKE: small counties to their pobp to improve detailed language distribution
	*tbd; will require more fillin and pre-seed by donor obs
	// RAKE. OR counties to state lang42 + county lang12 + county age/sex
	egen id1=group(stfips langc42 lep)
	egen id2=group(stcofips langc12 lep)
	egen id3=group(stcofips agec11 sex)
	set seed 13371701
	survwgt rake pwt1 if stfips=="41" & agep>=5, by(id1 id2 id3) totvars(lc42st_n lc12_n as_n) gen(pwt3) maxrep(255)
	*survwgt rake pwt1 if stfips=="41" & agep>=5, by(id1 id2) totvars(lc42st_n lc12_n) gen(pwt3) maxrep(255)
	// RAKE. WA counties to county lang12 + county age/sex
	set seed 13371701
	survwgt rake pwt1 if stfips=="53" & agep>=5, by(id2 id3) totvars(lc12_n as_n) gen(pwt2) maxrep(255)
	*survwgt rake pwt1 if stfips=="53" & agep>=5, by(id2) totvars(lc12_n) gen(pwt2) maxrep(255)
	replace pwt3=pwt2 if stfips=="53"
	// mark final weights and check table and save
	svyset [pw=pwt3], sdr(pwgtp1-pwgtp80) vce(sdr) mse
	tab stcofips agec3 if stfips=="41" [iw=pwt3] // check that totals agree ~ OR 3,948,032 age>=5
	destring stcofips, replace
	save 5ACS`y'_ORWA_RELDPRI_lang.dta, replace
end
*langFile 2021

// tables by langoha (subset of langfnl, for languages in any county's top10 total or by lep) 
cap prog drop tablang
prog def tablang
	cap use results/results_lang_`1'.dta, clear
	if _rc {
		local y=substr("`1'",3,2)
		use 5ACS`y'_ORWA_RELDPRI_lang.dta, clear
		** add language categories for use by oha: lang42 + english + ukrainian out of other slavic
		gen langtmp=langc42
		replace langtmp="ukr" if langfnl==18 // make ukrainian distinct
		encode langtmp, gen(langoha)
		labmask langoha, values(langtmp) // matrices can only store numeric
		** init table storage
		mat master=J(1,14,.)
		mat colnames master="stcofips" "sex" "langoha" "lep" "agec3" "b" "se" "z" "p" "ll" "ul" "df" "crit" "eform"
		** rectangularize (to ensure 37 rows for each svy total results matrix)
		sort stcofips agec3 langoha lep
		fillin stcofips agec3 langoha lep
		qui for var pwt3 pwgtp1-pwgtp80: replace X=0 if X==. 
		drop _fillin
		** aggregate matrices (lang*lep*agecat)
		gen byte one=1 
		levelsof agec3, local(ages)
		levelsof langoha, local(ls)
		qui foreach l of local ls {
			local label: label langoha `l'
			nois di _newline ". Language: `l' (`label') | Age/LEP: " _cont
			forvalues e=0/1 {
				foreach a of local ages {
					nois di "`a'/`e' " _cont
					if "`a'"=="0004" | (`e'==1 & "`label'"=="eng") { // no languages for age 0-4 and no LEP for english
						mat table=J(37,9,0)
					}
					else {
						cap svy sdr: total one if agec3=="`a'" & lep==`e' & langoha==`l', over(stcofips) 
						if !_rc mat table=r(table)'
						else if _rc==461 { // if subpopulation is zero ~ check to confirm
							nois di " >> zero! >> " _cont
							mat table=J(37,9,0) 
						}
					}
					mata: st_matrix("stcofips", range(1,37,1))
					mat sex=J(37,1,0)
					mat lang=J(37,1,`l')
					mat lep=J(37,1,`e')
					mat agec3=J(37,1,`a')
					mat result=stcofips,sex,lang,lep,agec3,table
					mat master=master\result
				}
			}
		}
		** replace data with stored matrices
		drop _all
		svmat master, names(col)
		label values lang langoha
		save results/results_lang_`1'.dta, replace
	}
	** clean for excel export
	drop if stcofips==.
	collapse (sum) b, by(stcofips lang lep agec3)
	reshape wide b, i(stcofips agec3 lep ) j(lang)
	rename b* lang*_
	reshape wide lang*_, i(stcofips agec3) j(lep)
	rename lang*_* lang*_*_	
	reshape wide lang*_, i(stcofips) j(agec3)
	order *, seq
	order stcofips
	*for var lang*: replace X=round(X,.01) // by default, results are not rounded
end
*tablang 2021

// state tabulation for langages (by agec11)
cap prog drop tablangSt
prog def tablangSt
	local y=substr("`1'",3,2)
	use 5ACS`y'_ORWA_RELDPRI_lang.dta, clear
	** add language categories for use by oha: lang42 + english + ukrainian out of other slavic
	gen langtmp=langc42
	replace langtmp="ukr" if langfnl==18 // make ukrainian distinct
	encode langtmp, gen(langoha)
	labmask langoha, values(langtmp) // matrices can only store numeric
	** init table storage
	mat master=J(1,14,.)
	mat colnames master="stcofips" "sex" "langoha" "lep" "agec11" "b" "se" "z" "p" "ll" "ul" "df" "crit" "eform"
	** rectangularize (to ensure 37 rows for each svy total results matrix)
	sort stcofips agec11 langoha lep
	fillin stcofips agec11 langoha lep
	qui for var pwt3 pwgtp1-pwgtp80: replace X=0 if X==. 
	drop _fillin
	** aggregate matrices (lang*lep*agecat)
	gen byte one=1 
	levelsof agec11, local(ages)
	levelsof langoha, local(ls)
	qui foreach l of local ls {
		local label: label langoha `l'
		nois di _newline ". Language: `l' (`label') | Age/LEP: " _cont
		forvalues e=0/1 {
			foreach a of local ages {
				nois di "`a'/`e' " _cont
				if "`a'"=="0004" | (`e'==1 & "`label'"=="eng") { // no languages for age 0-4 and no LEP for english
					mat table=J(1,9,0)
				}
				else {
					cap svy sdr: total one if agec11=="`a'" & lep==`e' & langoha==`l' & substr(strofreal(stcofips),1,2)=="41"
					if !_rc mat table=r(table)'
					else if _rc==461 { // if subpopulation is zero ~ check to confirm
						nois di " >> zero! >> " _cont
						mat table=J(1,9,0) 
					}
				}
				mat stcofips=J(1,1,41) // 41=statewide
				mat sex=J(1,1,0) // 0=both sexes combined
				mat lang=J(1,1,`l')
				mat lep=J(1,1,`e')
				mat agec11=J(1,1,`a')
				mat result=stcofips,sex,lang,lep,agec11,table
				mat master=master\result
			}
		}
	}
	** replace data with stored matrices
	drop _all
	svmat master, names(col)
	label values lang langoha
	save results/results_langSt_`1'.dta, replace
	** clean for excel export
	drop if stcofips==.
	collapse (sum) b, by(stcofips lang lep agec11)
	reshape wide b, i(stcofips agec11 lep) j(lang)
	rename b* lang*_
	reshape wide lang*_, i(stcofips agec11) j(lep)
	rename lang*_* lang*_*_	
	reshape wide lang*_, i(stcofips) j(agec11)
	order *, seq
	order stcofips
	*for var lang*: replace X=round(X,.01) // by default, results are not rounded
end
*tablangSt 2021

// add SOS variable langfnl, collapse by table
cap prog drop sosTable
prog define sosTable
	local year=`1'
	local y=substr("`year'",3,2)
	use 5ACS`y'_ORWA_RELDPRI_lang.dta, clear
	keep if agep>=5
	replace langfnl=0 if agep>=5 & lanx==2 // English-only
	keep pwt3 langfnl lep stcofips
	label define langfnl 0 "English", add
	collapse (sum) pwt3, by(stcofips langfnl lep)
	reshape wide pwt3, i(stcofips langfnl) j(lep)
	for var pwt30 pwt31: replace X=0 if X==. // missing -> 0
	replace pwt30=pwt30+pwt31 // add not lep + lep
	ren pwt30 total_`year'
	ren pwt31 lep_`year'
	save SOS/lang_table_`year'.dta, replace
	// special adjustments
	** tbd
	// add OR state total
	keep if substr(strofreal(stcofips),1,2)=="41"
	collapse (sum) total* lep*, by(langfnl)
	gen stcofips=41
	append using SOS/lang_table_`year'.dta 
	for var total* lep*: assert X<.
	order stcofips langfnl total* lep*
	for var "total_`year'" "lep_`year'": format X %7.0f
	// drop English or Eng Creole
	drop if langfnl==0 | langfnl==1
	// check no 0 spanish totals (affected Gilliam 5ACS21)
	assert total_`year'>0 if langfnl==11
	// change labels for Persian, Pashto, Chinese, Lao, Burmese, Khmer, Tagalog
	lab def langfnl 21 "Bulgarian", modify
	lab def langfnl 23 "Lithuanian/Latvian", modify // drop 'Lettish'
	lab def langfnl 25 "Persian", modify
	lab def langfnl 27 "Pashto", modify
	lab def langfnl 48 "Chinese", modify
	lab def langfnl 50 "Myanma", modify
	lab def langfnl 58 "Lao", modify
	lab def langfnl 59 "Khmer", modify
	lab def langfnl 63 "Tagalog", modify
	lab def langfnl 22 "Serbo-Croatian", modify // Serbian/Croatian/Bosnian
	lab def langfnl 97 "Siouan", modify // Dakota/Lakota/Nakota/Siouan
	lab def langfnl 102 "Central/SA", modify // Other Central/South American
	// imputation of AIAN languages to associated tribal areas in OR
	replace langfnl=203 if langfnl==101 & inlist(stcofips,41059,41031,41065) // "UMATILLA","WASCO","JEFFERSON"
	lab def langfnl 203 "Sahaptin", add modify
	// drop groups
	drop if inlist(langfnl,36,37,62,66,73,82,87,88,93,102,103) // drop language groups ~ unrankable and unidentifiable ~ except AIAN
	// bin languages by N speakers 
	for var "total_`year'" "lep_`year'": recode X (0/99.999=.) (100/299.999=1 "100-299") (300/499.999=2 "300-499") (500/.=3 "500+"), gen(X_bin)
	// flag largest N for counties without 100+ lep
	foreach x in "total" "lep" {
		egen chk=max(`x'_`year'), by(stcofips)
		egen minlang=max(`x'_`year') if chk<100, by(stcofips)
		drop chk
		replace `x'_`year'_bin=0 if `x'_`year'==minlang
		lab def `x'_`year'_bin 0 "<100", modify
		drop minlang
		// ranking
		gsort stcofips -`x'_`year'_bin -`x'_`year' 
		by stcofips: gen `x'_rank=_n
	}
	save SOS/lang_table_`year'.dta, replace
	// new table 1+2 design: OR state + county TOP 10 non-English by N of speakers THEN LEP speakers 
	foreach p in "total" "lep" {
		preserve
		keep if inrange(`p'_rank,1,10) & (`p'_rank==1 | `p'_`year'>=100) // suppression
		decode langfnl, gen(langs)
		compress
		replace langs=langs+"|"+strofreal(`p'_`year',"%7.0fc")
		keep stcofips langs `p'_rank
		reshape wide langs, i(stcofips) j(`p'_rank)
		egen list=concat(lang*), punct("|")
		drop langs*
		browse
		pause on
		pause
		restore
	}
	// new table 3 design: OR state + counties BINS non-English by 100s of speakers THEN LEP speakers
	foreach p in "total" "lep" {
		preserve
		keep stcofips langfnl `p'_* 
		ren `p'_`year'_bin bin
		ren `p'_`year' `p'
		ren `p'_rank rank
		keep if bin<.  // filter by 100+ speakers
		decode bin, gen(bins)
		replace bins=subinstr(bins,"-","_",.)
		replace bins=subinstr(bins,"+","",.)
		decode langfnl, gen(langs)
		compress
		replace langs=langs+"|"+strofreal(`p',"%6.0fc")
		keep stcofips langs bins rank
		gsort stcofips bins rank
		by stcofips bins: gen listme=_n
		subsave stcofips listme langs if bins=="100_299" using tmp1.dta, replace
		subsave stcofips listme langs if bins=="300_499" using tmp2.dta, replace
		subsave stcofips listme langs if bins=="500" using tmp3.dta, replace
		contract stcofips listme
		drop _freq
		merge 1:1 stcofips listme using tmp1.dta, assert(1 3) keepus(langs) nogen
		ren langs langs_100_299
		merge 1:1 stcofips listme using tmp2.dta, assert(1 3) keepus(langs) nogen
		ren langs langs_300_499
		merge 1:1 stcofips listme using tmp3.dta, assert(1 3) keepus(langs) nogen
		ren langs langs_500
		for num 1/3: rm tmpX.dta
		drop listme
		bys stcofips: gen listme=_n
		bys stcofips: ingap 1 if listme==1
		replace langs_100_299=strofreal(stcofips) if listme==.
		replace langs_100_299="100-299|" if listme==.
		replace langs_300_499="300-499|" if listme==.
		replace langs_500="500+" if listme==.
		replace stcofips=listme if listme<.
		drop listme*
		qui for var langs*: replace X="|" if X==""
		drop if langs_100_299=="|"&langs_300_499=="|"&langs_500=="|"&stcofips>1
		browse
		pause
		restore
	}
end
*sosTable 2019

cap prog drop sosSplit
prog def sosSplit
	// table of county splits for chinese & persian
	** for PDX Metro, use the last 5-year; for others, use two non-overlapping 5-years, and if no data, use last full state breakdown.
	tempfile tmp
	local year=`1'
	local y=substr("`year'",3,2)
	/*
	censusapi, url("https://api.census.gov/data/2012/acs/acs5?get=group(B05006)&for=county:*&in=state:41")
	drop if inlist(county,29,17,39,47) // drop lane/mari/jack/desc from oldest data
	drop if inlist(county,51,67,3) // drop mul/cla/was from historical data
	save `tmp', replace
	*/
	local past=max(`year'-5,2012)
	censusapi, url("https://api.census.gov/data/`past'/acs/acs5?get=group(B05006)&for=county:*&in=state:41")
	drop if inlist(county,51,67,3) // drop mul/cla/was from historical data
	*append using `tmp'
	save `tmp', replace
	censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(B05006)&for=county:*&in=state:41")
	append using `tmp'
	save `tmp', replace
	censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(B05006)&for=county:011&in=state:53")
	append using `tmp'
	save `tmp', replace
	censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=group(B05006)&for=state:41")
	append using `tmp'
	rename b05006_*e e*
	*gen fbbpld_eur=e002 // europe
	*gen fbbpld_asi=e047 // asia
	*gen fbbpld_afr=e095 // africa
	*gen fbbpld_oce=e130 // oceania
	*gen fbbpld_lac=e139 // latin america and caribbean
	*gen fbbpld_nam=e176 // north america
	gen fbbpld_chn=e050 // mainland china
	gen fbbpld_hkg=e051 // hongkong
	gen fbbpld_twn=e052 // taiwan
	gen fbbpld_irn=e061 // iran
	gen fbbpld_taj=e067 // tajikistan=in other south central asia
	gen fbbpld_afg=e057 // afghanistan
	tostring state, replace format(%02.0f) 
	tostring county, replace format(%03.0f)
	gen stcofips=state+county
	collapse (sum) fbbpld_*, by(stcofips)
	gen Simplified=fbbpld_chn/(fbbpld_chn+fbbpld_hkg+fbbpld_twn)
	sum Simplified if stcofips=="41."
	*replace Simplified=`r(mean)' if Simplified==. // use state mean for zero pop areas
	gen Traditional=1-Simplified
	gen Farsi=(fbbpld_irn+fbbpld_taj)/(fbbpld_irn+fbbpld_taj+fbbpld_afg)
	sum Farsi if stcofips=="41."
	*replace Farsi=`r(mean)' if Farsi==. // use state mean for zero pop areas
	gen Dari=1-Farsi
	save sos/lang_split_`year'.dta, replace
	browse stcofips Dari Farsi Traditional Simplified
end
*sosSplit 2019
