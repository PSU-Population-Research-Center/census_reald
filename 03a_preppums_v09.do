* v09 - retain Jewish flag (jet) for later control totals in raceeth dofile
* v08 - removed hhwgt, ogdirc, added racnhpi; dropped vachu (pwgtp==.)
* v07 - added ombrrn code (rarest OMB race, pre-REALD24) to complement 'omb' var (rarest OMB race, based on REALD24 primary race)
* v06 - updated _rc conditions and added stub code for OHA disability flags.
* v05 - FORK. update REALD assignment code and rarest race code to use 2024 revision instrument.
*	approach taken: two separate scripts in R make Jewish and other REALD24 assignments, respectively, which are then merged.
*	first, 01_jet_v12.r is run, then 02_reld24_v04.r
*	the file acs_realdpri_2023_5yr.csv is export with ReldPri (primary REALD24) race and state+serialno+sporder for merging.
*	so the "old" paradigm calls a Stata do file (based on Marjorie's) and the "new" runs two separate R scripts.
*	the "new" and "old" can both be re-run, and the resulting ReldPri per ST,SERIALNO,SPORDER can be merged to prior results.
* v04 - updating with proportional weights for better SE for each county sub-sample in multi-county PUMAs.
* v03 - updating for 5ACS23. n.b.! Iu Mien and Central Asian (Kazakh/Uzbek at least) have their own RAC2P values. THESE SHOULD BE USED GOING FORWARD.
*	(it will be in the REALD25 SOW). temporarily recoding RAC2P23 to RAC2P19 for consistency, e.g.:
*	Mien, Kazakh, Uzbek -> Other Asian; Sikh -> Asian Indian; Aztec/Maya/Mixtec -> Mexican Indian; Taino/Tarasco/Inca -> Latin Am Indian
* v02 - updated for post-2020 pumas (starting with 2022 ACS); removed flags for control populations (need to rewrite 05a_raceeth.do)
* v01 - working version up to 2021

// setup
foreach p in "zipfile" "censusapi" {
	cap which `p'
	if _rc ssc install `p'
}

// 5. process ACS PUMS ~ retain items used for downscaling
cap prog drop preppums
prog def preppums
	args year
	local y=substr("`year'",3,2)
	cap confirm file "5ACS`y'_ORWA.dta" // cleaned ACS output file name
	if !_rc {
		nois di "File already exists (5ACS`y'_ORWA.dta)"
	}
	if _rc {
		cd acs
		tempfile h p
		local i=0
		foreach s in "or 41" "wa 53" {
			local S=upper(substr("`s'",1,2))
			local st=real(substr("`s'",4,.))
			local s=substr("`s'",1,2)
			** housing 
			cap confirm file "`S'_House_`y'.zip" 
			if _rc {
				!curl -k "https://www2.census.gov/programs-surveys/acs/data/pums/`year'/5-Year/csv_h`s'.zip" --output "`S'_House_`y'.zip"
			}
			unzipfile "`S'_House_`y'.zip", ifilter(`"(.*\.(csv)$)"') replace
			import delim using "psam_h`st'.csv", clear case(upper) delim(",")
			if `year'<=2015 {
				ren ST STATE
				local GEO="PUMA00 PUMA10"
				if "`s'"=="wa" keep if inlist(PUMA00,2200,2101,2102) | inlist(PUMA10,11101,11102,11103,11104)
			}	
			if inrange(`year',2016,2021) {
				ren ST STATE
				ren PUMA PUMA10
				local GEO="PUMA10"
				if "`s'"=="wa" keep if inlist(PUMA10,11101,11102,11103,11104)
			}
			if `year'==2022 {
				ren ST STATE
				local GEO="PUMA10 PUMA20"
				if "`s'"=="wa" keep if inlist(PUMA10,11101,11102,11103,11104) | inlist(PUMA20,21101,21102,21103,21104)
			}
			if `year'>=2023 {
				ren PUMA PUMA20
				local GEO="PUMA20"
				if "`s'"=="wa" keep if inlist(PUMA20,21101,21102,21103,21104)
			}
			if `year'<2020 ren TYPE TYPEHUGQ
			keep STATE SERIALNO RT `GEO' TYPEHUGQ HINCP ADJINC NP HUPAOC HUPARC HUGCL NOC NRC NPP CPLT HHT2 PARTNER R60 R65 
			gen int YEAR=`year'
			save `h', replace
			rm "psam_h`st'.csv"
			*rm "`S'_House_`y'.zip"
			** person
			cap confirm file "`S'_Indiv_`y'.zip" 
			if _rc {
				!curl -k "https://www2.census.gov/programs-surveys/acs/data/pums/`year'/5-Year/csv_p`s'.zip" --output "`S'_Indiv_`y'.zip"
			}
			unzipfile "`S'_Indiv_`y'.zip", ifilter(`"(.*\.(csv)$)"') replace
			import delim using "psam_p`st'.csv", clear case(upper) delim(",")
			if `year'<=2015 {
				ren ST STATE
				local GEO="PUMA00 PUMA10"
				if "`s'"=="wa" keep if inlist(PUMA00,2200,2101,2102) | inlist(PUMA10,11101,11102,11103,11104)
			}
			if inrange(`year',2016,2021) {
				ren ST STATE
				ren PUMA PUMA10
				local GEO="PUMA10"
				if "`s'"=="wa" keep if inlist(PUMA10,11101,11102,11103,11104)
			}
			if `year'==2022 {
				ren ST STATE
				local GEO="PUMA10 PUMA20"
				if "`s'"=="wa" keep if inlist(PUMA10,11101,11102,11103,11104) | inlist(PUMA20,21101,21102,21103,21104)
			}
			if `year'>=2023 { 
				ren PUMA PUMA20
				local GEO="PUMA20"
				if "`s'"=="wa" keep if inlist(PUMA20,21101,21102,21103,21104)
			}
			keep STATE SERIALNO SPORDER RT `GEO' PWGTP SEX AGEP HISP POBP MIGSP LANP ///
				RACAIAN RACASN RACBLK RACNH RACNUM RACPI RACSOR RACWHT RAC1P RAC2P* RAC3P ///
				HINS* DIS DOUT DPHY DREM DEYE DEAR DDRS HICOV PUBCOV PRIVCOV RELSHIPP ///
				WKW PAP POVPIP ENG LANX LANP WAOB GCL GCR MIL PWGTP*
			rm "psam_p`st'.csv"
			*rm "`S'_Indiv_`y'.zip"
			* combine, save
			merge m:1 STATE SERIALNO using `h', keep(1 2 3) nogen // drop hhd records w/no persons (e.g., vacant).
			if `i'>0 append using "../5ACS`y'_ORWA.dta"
			save "../5ACS`y'_ORWA.dta", replace
			local ++i
		}
		cd ..
	}
end
*preppums 2023 // syntax: `1' is endign year of 5-year ACS of desired file.

// define expansion program 
cap prog drop expandpums
prog def expandpums
	args year
	// save county control population and share of PUMAC (weight factors)
	censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=GEO_ID,B01001_001E&for=county:*&in=state:41&key=$ckey")
	ren b01001_001e totpop
	save "temp/co_control_pop.dta", replace
	censusapi, url("https://api.census.gov/data/`year'/acs/acs5?get=GEO_ID,B01001_001E&for=county:011&in=state:53&key=$ckey")
	ren b01001_001e totpop
	append using "temp/co_control_pop.dta"
	destring state county, replace 
	save "temp/co_control_pop.dta", replace
	if inrange(`year',2016,2025) {
		gen byte pumac10=.
		replace pumac10=1 if inlist(county,1,59,61,63)
		replace pumac10=2 if inlist(county,13,21,23,27,31,49,55,65,69)
		replace pumac10=3 if inlist(county,25,35,37,45)
		replace pumac10=4 if county==17
		replace pumac10=5 if inlist(county,7,9,41,57)
		replace pumac10=6 if inlist(county,3,43)
		replace pumac10=7 if county==39
		replace pumac10=8 if inlist(county,11,15,33)
		replace pumac10=9 if county==29
		replace pumac10=10 if county==19
		replace pumac10=11 if county==47
		replace pumac10=12 if inlist(county,53,71)
		replace pumac10=13 if county==51
		replace pumac10=14 if county==5
		replace pumac10=15 if county==67
		replace pumac10=16 if state==53 & county==11
		assert pumac10<. & (state==41|pumac10==16)
	}
	if inrange(`year',2022,2025) {
		gen byte pumac20=.
		replace pumac20=1 if inlist(county,1,59,61,63)
		replace pumac20=2 if inlist(county,21,23,27,49,55,65,69)
		replace pumac20=3 if inlist(county,25,35,37,45)
		replace pumac20=4 if inlist(county,17,13,31)
		replace pumac20=5 if inlist(county,7,9,57)
		replace pumac20=6 if inlist(county,3,43)
		replace pumac20=7 if county==39
		replace pumac20=8 if inlist(county,11,15,33)
		replace pumac20=9 if county==29
		replace pumac20=10 if county==19
		replace pumac20=11 if county==47
		replace pumac20=12 if inlist(county,53,41)
		replace pumac20=13 if county==51
		replace pumac20=14 if county==5
		replace pumac20=15 if county==67
		replace pumac20=16 if county==71
		replace pumac20=17 if county==11 & state==53
		assert pumac20<. & (state==41|pumac20==17)
	}
	forvalues n=10(10)20 {
		cap confirm var pumac`n'
		if !_rc {
			egen chksum`n'=sum(totpop), by(pumac`n')
			gen afrac`n'=totpop/chksum`n'
			bigtab pumac`n' geo_id afrac`n'
		}
	}
	save "temp/co_control_pop.dta", replace	
	// load PUMS
	local y=substr("`year'",3,2)
	use "5ACS`y'_ORWA.dta", clear
	ren *, lower
	cap ren st state
	destring state, replace
	// convert PUMAC to county (only 2010 PUMAs)
	if inrange(`year',2016,2021) {
		do acs/pumac10.do
		gen byte factor=.
		replace factor=4 if pumac==1
		replace factor=9 if pumac==2
		replace factor=4 if pumac==3
		replace factor=4 if pumac==5
		replace factor=2 if pumac==6
		replace factor=3 if pumac==8
		replace factor=2 if pumac==12
		replace factor=1 if factor==.
		assert factor<.
		expand factor, gen(flag)
		bys serialno sporder: gen listme=_n // should top out at factorvalue.
		gen county=""
		replace county="001" if pumac==1 & listme==1 // baker
		replace county="059" if pumac==1 & listme==2 // umatilla
		replace county="061" if pumac==1 & listme==3 // union
		replace county="063" if pumac==1 & listme==4 // wallowa
		replace county="013" if pumac==2 & listme==1 // crook
		replace county="021" if pumac==2 & listme==2 // gilliam
		replace county="023" if pumac==2 & listme==3 // grant
		replace county="027" if pumac==2 & listme==4 // hood river
		replace county="031" if pumac==2 & listme==5 // jefferson
		replace county="049" if pumac==2 & listme==6 // morrow
		replace county="055" if pumac==2 & listme==7 // sherman
		replace county="065" if pumac==2 & listme==8 // wasco
		replace county="069" if pumac==2 & listme==9 // wheeler
		replace county="025" if pumac==3 & listme==1 // harney
		replace county="035" if pumac==3 & listme==2 // klamath
		replace county="037" if pumac==3 & listme==3 // lake
		replace county="045" if pumac==3 & listme==4 // malheur
		replace county="017" if pumac==4 // deschutes
		replace county="007" if pumac==5 & listme==1 // clatsop
		replace county="009" if pumac==5 & listme==2 // columbia
		replace county="041" if pumac==5 & listme==3 // lincoln
		replace county="057" if pumac==5 & listme==4 // tillamook
		replace county="003" if pumac==6 & listme==1 // benton
		replace county="043" if pumac==6 & listme==2 // linn
		replace county="039" if pumac==7 // lane
		replace county="011" if pumac==8 & listme==1 // coos
		replace county="015" if pumac==8 & listme==2 // curry
		replace county="033" if pumac==8 & listme==3 // josephine
		replace county="029" if pumac==9 // jackson
		replace county="019" if pumac==10 // douglas
		replace county="047" if pumac==11 // marion
		replace county="053" if pumac==12 & listme==1 // polk
		replace county="071" if pumac==12 & listme==2 // yamhill
		replace county="051" if pumac==13 // multnomah
		replace county="005" if pumac==14 // clackamas
		replace county="067" if pumac==15 // washington
		replace county="011" if pumac==. & state==53 & inrange(puma10,11101,11104)
		replace pumac=16 if state==53 & inrange(puma10,11101,11104)
		assert county!=""
		lab def pumac10_lbl 16 "CLARK-WA", add modify
	}
	// convert PUMAC to county (mixed 2010 and 2020 PUMAs)
	if inrange(`year',2022,2025) {
		gen byte factor=.
		if `year'==2022 {
			do acs/pumac10.do
			replace pumac=16 if state==53 & inrange(puma10,11101,11104)
			lab def pumac10_lbl 16 "CLARK-WA", add modify
			ren pumac tmp10
		}
		do acs/pumac20.do
		replace pumac=17 if state==53 & inlist(puma20,21101,21102,21103,21104)
		lab def pumac20_lbl 17 "CLARK-WA", add modify
		ren pumac pumac20
		if `year'==2022 {
			ren tmp10 pumac10
			replace factor=4 if pumac10==1
			replace factor=9 if pumac10==2
			replace factor=4 if pumac10==3
			replace factor=1 if pumac10==4
			replace factor=4 if pumac10==5
			replace factor=2 if pumac10==6
			replace factor=1 if pumac10==7
			replace factor=3 if pumac10==8
			replace factor=1 if pumac10==9
			replace factor=1 if pumac10==10
			replace factor=1 if pumac10==11
			replace factor=2 if pumac10==12
			replace factor=1 if pumac10==13
			replace factor=1 if pumac10==14
			replace factor=1 if pumac10==15 
			replace factor=1 if pumac10==16 // wa: clark
		}
		replace factor=4 if pumac20==1 
		replace factor=7 if pumac20==2
		replace factor=4 if pumac20==3
		replace factor=3 if pumac20==4
		replace factor=3 if pumac20==5
		replace factor=2 if pumac20==6
		replace factor=1 if pumac20==7
		replace factor=3 if pumac20==8
		replace factor=1 if pumac20==9
		replace factor=1 if pumac20==10
		replace factor=1 if pumac20==11
		replace factor=2 if pumac20==12
		replace factor=1 if pumac20==13
		replace factor=1 if pumac20==14
		replace factor=1 if pumac20==15
		replace factor=1 if pumac20==16
		replace factor=1 if pumac20==17 // wa: clark
		assert factor<.
		expand factor, gen(flag)
		bys serialno sporder: gen listme=_n // should top out at factorvalue.
		gen county=""
		cap gen pumac10=. // doesn't exist in 5ACS23+
		replace county="001" if (pumac10==1 & listme==1) | (pumac20==1 & listme==1) // baker
		replace county="059" if (pumac10==1 & listme==2) | (pumac20==1 & listme==2) // umatilla
		replace county="061" if (pumac10==1 & listme==3) | (pumac20==1 & listme==3) // union
		replace county="063" if (pumac10==1 & listme==4) | (pumac20==1 & listme==4) // wallowa
		replace county="013" if (pumac10==2 & listme==1) | (pumac20==4 & listme==2) // crook
		replace county="021" if (pumac10==2 & listme==2) | (pumac20==2 & listme==1) // gilliam
		replace county="023" if (pumac10==2 & listme==3) | (pumac20==2 & listme==2) // grant
		replace county="027" if (pumac10==2 & listme==4) | (pumac20==2 & listme==3) // hood river
		replace county="031" if (pumac10==2 & listme==5) | (pumac20==4 & listme==3) // jefferson
		replace county="049" if (pumac10==2 & listme==6) | (pumac20==2 & listme==4) // morrow
		replace county="055" if (pumac10==2 & listme==7) | (pumac20==2 & listme==5) // sherman
		replace county="065" if (pumac10==2 & listme==8) | (pumac20==2 & listme==6) // wasco
		replace county="069" if (pumac10==2 & listme==9) | (pumac20==2 & listme==7) // wheeler
		replace county="025" if (pumac10==3 & listme==1) | (pumac20==3 & listme==1) // harney
		replace county="035" if (pumac10==3 & listme==2) | (pumac20==3 & listme==2) // klamath
		replace county="037" if (pumac10==3 & listme==3) | (pumac20==3 & listme==3) // lake
		replace county="045" if (pumac10==3 & listme==4) | (pumac20==3 & listme==4) // malheur
		replace county="017" if (pumac10==4) | (pumac20==4 & listme==1) // deschutes
		replace county="007" if (pumac10==5 & listme==1) | (pumac20==5 & listme==1) // clatsop
		replace county="009" if (pumac10==5 & listme==2) | (pumac20==5 & listme==2) // columbia
		replace county="041" if (pumac10==5 & listme==3) | (pumac20==12 & listme==2) // lincoln
		replace county="057" if (pumac10==5 & listme==4) | (pumac20==5 & listme==3) // tillamook
		replace county="003" if (pumac10==6 & listme==1) | (pumac20==6 & listme==1) // benton
		replace county="043" if (pumac10==6 & listme==2) | (pumac20==6 & listme==2) // linn
		replace county="039" if (pumac10==7) | (pumac20==7) // lane
		replace county="011" if (pumac10==8 & listme==1) | (pumac20==8 & listme==1) // coos
		replace county="015" if (pumac10==8 & listme==2) | (pumac20==8 & listme==2) // curry
		replace county="033" if (pumac10==8 & listme==3) | (pumac20==8 & listme==3) // josephine
		replace county="029" if (pumac10==9) | (pumac20==9) // jackson
		replace county="019" if (pumac10==10) | (pumac20==10) // douglas
		replace county="047" if (pumac10==11) | (pumac20==11) // marion
		replace county="053" if (pumac10==12 & listme==1) | (pumac20==12 & listme==1) // polk
		replace county="071" if (pumac10==12 & listme==2) | (pumac20==16) // yamhill
		replace county="051" if (pumac10==13) | (pumac20==13) // multnomah
		replace county="005" if (pumac10==14) | (pumac20==14) // clackamas
		replace county="067" if (pumac10==15) | (pumac20==15) // washington
		replace county="011" if state==53 & (pumac10==16|pumac20==17) // clark/wa
		assert county!=""
	}
	// adjust weights and replicate weights proportionally by the county share of the PUMA population
	** for better initialization and variance estimation (assuming equal variance, ignoring design effects etc)
	destring state county, replace
	merge m:1 state county using "temp/co_control_pop.dta", assert(3) keepus(afrac*) nogen
	forvalues n=10(10)20 {
		cap confirm var pumac`n'
		if !_rc qui for var pwgtp*: replace X=X*afrac`n' if pumac`n'<. 
	}
	// drop vacant HU 
	assert pwgtp==. if (typehugq==1 & np==0)
	drop if pwgtp==.
	// check results
	version 13: table county if state==41, contents(sum pwgtp count pwgtp) row format(%11.0fc) // some oddness possible here, but overall Ok.
	assert county<. & year<. & state<.
	unique state county
	assert `r(unique)'==37
	compress
	drop listme factor afrac*
	tostring state, replace format("%02.0f") force // drop value labels
	tostring county, replace format("%03.0f")
	save "5ACS`y'_ORWA_co.dta", replace
	rm "5ACS`y'_ORWA.dta"
end
*expandpums 2023

// attach REALD races and primary race
capture prog drop pumsreld
prog def pumsreld
	args year ver
	// race recode
	cap assert inlist(`ver',2020,2024)
	if _rc {
		nois di "Must specify (2020) or (2024) definitions"
		exit
	}
	local y=substr("`year'",3,2)
	local z=substr("`ver'",3,2)
	cap confirm file "prc_reldpri`z'_5acs`y'.dta"
	if _rc {
		nois di "Could not find REALD assignment file (prc_reldpri`z'_5acs`y'.dta)"
		exit
	}
	use "5ACS`y'_ORWA_co.dta", clear
	destring state, replace
	merge m:1 state serialno sporder using prc_reldpri`z'_5acs`y'.dta, assert(3) keepus(realdpri jet) nogen
	tostring state, replace
	cap ren realdpri reldpri // later code uses this name.
	cap gen racnhpi=(racnh==1|racpi==1) // this is OK -- racnum is still 1 if only NH+PI. racnum is # of OMB races and NH/PI is same OMB race.
	cap drop racnh racpi 
	replace jet=jet!=.
	label drop jet
	assert inrange(jet,0,1)
	// rarest OMB97 race ~ statewide frequency AOIC: nhpi (37787)<black (140010)<aian (163101)<asian (288867)<hispan ()<white()<sora
	gen ombrr=""
	replace ombrr="nhpi" if racnhpi==1 & ombrr==""
	replace ombrr="black" if racblk==1 & ombrr==""
	replace ombrr="aian" if racaian==1 & ombrr==""
	replace ombrr="asian" if racasn==1 & ombrr==""
	replace ombrr="hisp" if hisp>1 & ombrr==""
	replace ombrr="white" if racwht==1 & ombrr==""
	replace ombrr="other" if racsor==1 & ombrr=="" // nh+sora
	version 13: table ombrr state, contents(sum pwgtp) format(%10.0fc) row
	encode ombrr, gen(ombrrn) // alpha order 1=n 2=a 3=b 4=h 5=p 6=o 7=w
	lab def ombrr 0 "total", add
	assert ombrrn<.
	drop ombrr
	save "5ACS`y'_ORWA_co.dta", replace
end
*pumsreld 2023 2024 // or 2020 definitions.