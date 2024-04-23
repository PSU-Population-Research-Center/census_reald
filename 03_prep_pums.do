** purpose; add REALD to acs pums
** then split PUMS to duplicate for each county
** NOT able to do analysis for those counties until apply controls.

// notes
* output: reald_pums_ogdi.dta nd reald_pums_ogdi_di.dta
* requirements: cURL, various cleaning dofiles, plus ACS2017_21Setup_2v8RELD_ORandWA_copy.do, 01_varstable_v01_api.xlsx (attach flags for eligible pops for control weights)

// tbd
* use colrange to speed up csv reading
* figure out what missing variables are: Insur, Region, NonInstDi

// setup
*global path
*installs

// 5. process ACS PUMS ~ add REALD from OHA code
cap prog drop preppums
prog def preppums
	args year
	local y=substr("`year'",3,2)
	cap confirm file "5ACS`y'_ORWA_Indiv2v2.dta" // oha output file name
	if !_rc nois di "File already exists (5ACS`y'_ORWA_Indiv2v2.dta)"
	if _rc {
		// oregon
		cd acs
		!$curl -k "https://www2.census.gov/programs-surveys/acs/data/pums/`year'/5-Year/csv_hor.zip" --output "OR_House.zip"
		unzipfile "OR_House.zip"
		import delim using "psam_h41.csv", clear case(upper) delim(",")
		keep RT SERIALNO ST PUMA WGTP TYPEHUGQ HINCP ADJINC NP HUPAOC HUPARC HUGCL NOC NRC NPP CPLT HHT2 PARTNER R60 R65 WGTP*
		gen int YEAR=2021
		save OR_House.dta, replace
		rm "psam_h41.csv"
		rm "OR_House.zip"
		!$curl -k "https://www2.census.gov/programs-surveys/acs/data/pums/`year'/5-Year/csv_por.zip" --output "OR_Indiv.zip"
		unzipfile "OR_Indiv.zip"
		import delim using "psam_p41.csv", clear case(upper) delim(",")
		keep RT SERIALNO SPORDER ST PUMA PWGTP SEX AGEP HISP POBP ANC1P ANC2P RAC1P RAC2P RAC3P MIGSP LANP ///
			RACAIAN RACASN RACBLK RACNH RACNUM RACPI RACSOR RACWHT ///
			HINS* DIS DOUT DPHY DREM DEYE DEAR DDRS HICOV PUBCOV PRIVCOV RELSHIPP ///
			WKW PAP POVPIP ENG LANX LANP WAOB GCL GCR MIL PWGTP*
		save "OR_Indiv.dta", replace
		rm "psam_p41.csv"
		rm "OR_Indiv.zip"
		merge m:1 SERIALNO using OR_House.dta, keep(1 3) nogen // drop hhd records w/no persons (e.g., vacant).
		// save temp
		cd ..
		save "5ACS`y'_ORWA_Indiv2v2.dta", replace
		// washington (clark)
		cd acs
		!$curl -k "https://www2.census.gov/programs-surveys/acs/data/pums/`year'/5-Year/csv_hwa.zip" --output "WA_House.zip"
		unzipfile "WA_House.zip"
		import delim using "psam_h53.csv", clear case(upper) delim(",")
		keep if inlist(PUMA,11101,11102,11103,11104)
		keep RT SERIALNO ST PUMA WGTP TYPEHUGQ HINCP ADJINC NP HUPAOC HUPARC HUGCL NOC NRC NPP CPLT HHT2 PARTNER R60 R65 WGTP*
		gen int YEAR=2021
		save 5ACS21WA_House.dta, replace
		rm "psam_h53.csv"
		rm "WA_House.zip"
		!$curl -k "https://www2.census.gov/programs-surveys/acs/data/pums/`year'/5-Year/csv_pwa.zip" --output "WA_Indiv.zip"
		unzipfile "WA_Indiv.zip"
		import delim using "psam_p53.csv", clear case(upper) delim(",")
		keep if inlist(PUMA,11101,11102,11103,11104)
		keep RT SERIALNO SPORDER ST PUMA PWGTP SEX AGEP HISP POBP ANC1P ANC2P RAC1P RAC2P RAC3P MIGSP LANP ///
			RACAIAN RACASN RACBLK RACNH RACNUM RACPI RACSOR RACWHT ///
			HINS* DIS DOUT DPHY DREM DEYE DEAR DDRS HICOV PUBCOV PRIVCOV RELSHIPP ///
			WKW PAP POVPIP ENG LANX LANP WAOB GCL GCR MIL PWGTP*
		save "WA_Indiv.dta", replace
		rm "psam_p53.csv"
		rm "WA_Indiv.zip"
		merge m:1 SERIALNO using WA_House.dta, keep(1 3) nogen // drop hhd records w/no persons (e.g., vacant).
		// append temp
		cd ..
		append using "5ACS`y'_ORWA_Indiv2v2.dta"
		for any "migsp" "pobp" "anc" "rachisp" "lanp": do "acs/X.do" // adds value labels
		gen int year=`y'
		// cleanup and save result (based on "ACS201721_Setup_1v8_ORandWA.do")
		gen byte Male=SEX==1
		gen byte Female=SEX==2
		gen byte EastOR=(ST==41 & PUMA==100)
		gen byte WashCo=(ST==41 & inrange(PUMA,1320,1324))
		gen byte MultCo=(ST==41 & inlist(PUMA,1301,1302,1303,1305,1314,1316))
		gen byte ClackCo=(ST==41 & inlist(PUMA,1317,1318,1319))
		gen byte YamPCo=(ST==41 & PUMA==1200)
		gen byte OHAeeoc=WashCo==1|MultCo==1|YamPCo==1|(ST==41 & inlist(PUMA,1103,1104,1105,705,600))
		gen byte ClarkCo=(ST==53 & inrange(PUMA,11101,11104))
		label var OHAeeoc "Tri Co., Marion, Lane, Linn/Benton, Yamhill/Polk"
		label var EastOR "Umatilla, Union, Baker & Wallowa Counties"
		label var WashCo "Wash Co"
		label var MultCo "Mult Co"
		label var YamPCo "Yamhill & Polk Counties"
		label var ClarkCo "Clark Co"
		gen byte Insur=.
		replace Insur=0 if PUBCOV==2 & PRIVCOV==1
		replace Insur=1 if PUBCOV==1 & Insur==.
		replace Insur=2 if HICOV==2 & Insur==. & PUBCOV!=1
		label define Insur 0 "PrivInsurOnly" 1 "PubInsur" 2 "NoInsur", modify
		label value Insur Insur  
		label var Insur "Health Insur type"
		gen byte Region = 1 if (WashCo==1|MultCo==1|ClackCo==1) // TriCnty==1
		replace Region = 1 if PUMA==200 // ColRiv==1	
		replace Region = 2 if inlist(PUMA,1103,1104,1105) // MarionCo==1
		replace Region = 2 if inlist(PUMA,703,704,705) // LaneCo==1
		replace Region = 2 if PUMA==1200 // YamPolkCo==1
		replace Region = 2 if PUMA==600 // LinnBenCo==1
		replace Region = 3 if inlist(PUMA,901,902) // JacksonCo==1
		replace Region = 3 if PUMA==1000 // Douglas==1
		replace Region = 4 if PUMA==300 // SOEasOR==1
		replace Region = 4 if PUMA==100 // EastOR==1	
		replace Region = 4 if PUMA==400 // DescCo==1	
		replace Region = 5 if PUMA==500 // NCcoast==1	
		replace Region = 5 if PUMA==800 // SWcoasOR==1	
		label def Region 1 "Mult/Clack/Wash/Col.Gorge" 2 "Marion/Lane/Yamhill/Polk/Lane" 3 "Southern OR" 4 "SE & Eastern OR" 5 "OR Coast", modify 
		label value Region Region
		gen NonInstDi=(RELSHIPP!=37)
		label var NonInstDi "Non-Institutionalized"
		gen NonInsCil=1
		replace NonInsCil=0 if MIL==1 | RELSHIPP==37
		label var NonInsCil "Non-Institutionalized Civilians-all ages"
		save "5ACS`y'_ORWA_Indiv2v2.dta", replace
		// remove tempfiles
		rm "acs/OR_Indiv.dta"
		rm "acs/WA_Indiv.dta" 
		rm "acs/OR_House.dta"
		rm "acs/WA_House.dta"
	} 
end
preppums 2021 // syntax: `1' is endign year of 5-year ACS of desired file.

capture prog drop pumsreld
prog def pumsreld
	args year
	local y=substr("`year'",3,2)
	cap confirm file "5ACS`y'_ORWA_Indiv3v11.dta" // oha output file name
	if !_rc nois di "File already exists (5ACS`y'_ORWA_Indiv3v11.dta)"
	if _rc {
		// attach REALD (based on ACS201721_Setup_2v11RELD_ORandWA.do) 
		use "5ACS`y'_ORWA_Indiv2v2.dta", clear
		nois do "OHA/ACS201721_Setup_2v11RELD_ORandWA_copy.do" // modified to run on my location 
		save "5ACS`y'_ORWA_Indiv3v11.dta", replace
		** requires input of "201721ORWA_Indiv2v2.dta" and outputs file "201721ORWA_Indiv3v11.dta"
		for num 1/7: cap rm TempFileXv2.dta 
		rm TempFile1b.dta
		rm RaceTemp5v2.dta
	}
	// extra race summary
	cap confirm var reldpri
	if _rc use "5ACS`y'_ORWA_Indiv3v11.dta", clear
	cap drop sex
	rename *, lower
	gen age=agep
	replace age=90 if agep>90 // age 90 represents 90+
	*assert alasknat==1 if antribe==1
	*assert amind==1 if amtribe==1
	*assert aian==1  if tribe==1
	gen canind=. 
	label var canind "canadian inuit, metis, or first nation"
	// assign string primary reald race (full detail)
	** use RareRaceAdj = single "primary" REALD race based on rarest.
	nois do ACS/reldpri_v02.do
	// omb races
	gen omb=""
	replace omb="Hispanic" if inlist(reldpri,"HisCen","HisMex","HisOth","HisSou")
	replace omb="NHPI" if inlist(reldpri,"Cham","Marshall","COFA","NatHaw","Samoan","NHPIoth","NHPIAgg")
	replace omb="White" if inlist(reldpri,"WestEur","EastEur","Slavic","WhiteOth","WhiteAgg") | inlist(reldpri,"NoAfr","MidEast","MENAAgg")
	replace omb="AIAN" if inlist(reldpri,"AmInd","CanInd","LatInd","AlaskNat","AIANAgg")
	replace omb="Black" if inlist(reldpri,"AfrAm","Caribbean","Ethiopian","Somali","African","BlackOth","BlackAgg")
	replace omb="Asian" if inlist(reldpri,"AsianInd","Cambodian","Chinese","Filipino","Hmong","SoAsian") | /// 
		inlist(reldpri,"Japanese","Korean","Laotian","Myanmar","Vietnamese","AsianAgg","AsianOth") 
	replace omb="Other" if reldpri=="RaceOth"
	assert omb!=""
	version 13: nois table omb, contents(sum pwgtp) format(%11.0fc) row // statewide total by rarest race = OK
	// ogdi races
	gen ogdi=.
	lab def ogdi 1 "HL_Mex" 2 "HL_Oth" 3 "NHPI" 4 "W_SEE" 5 "W_OTH" 6 "AIAN" 7 "B_AAM" 8 "B_AFR" 9 "MENA" 10 "A_E" 11 "A_S" 12 "A_OTH" 13 "UNK", replace
	replace ogdi=1 if inlist(reldpri,"HisMex")
	replace ogdi=2 if inlist(reldpri,"HisCen","HisOth","HisSou")
	replace ogdi=3 if inlist(reldpri,"Cham","Marshall","COFA","NatHaw","Samoan","NHPIoth","NHPIAgg")
	replace ogdi=4 if inlist(reldpri,"EastEur","Slavic")
	replace ogdi=5 if inlist(reldpri,"WestEur","WhiteOth","WhiteAgg")
	replace ogdi=6 if inlist(reldpri,"AmInd","CanInd","LatInd","AlaskNat","AIANAgg")
	replace ogdi=7 if inlist(reldpri,"AfrAm")
	replace ogdi=8 if inlist(reldpri,"Caribbean","Ethiopian","Somali","African","BlackOth","BlackAgg")
	replace ogdi=9 if inlist(reldpri,"NoAfr","MidEast","MENAAgg")
	replace ogdi=11 if inlist(reldpri,"AsianInd","SoAsian")
	replace ogdi=10 if inlist(reldpri,"Chinese","Japanese","Korean")
	replace ogdi=12 if inlist(reldpri,"Cambodian","Filipino","Hmong","Laotian","Myanmar","Vietnamese","AsianAgg","AsianOth") 
	replace ogdi=13 if reldpri=="RaceOth"
	assert ogdi!=.
	label values ogdi ogdi
	version 13: nois table ogdi, contents(sum pwgtp) format(%11.0fc) row mis // statewide total by rarest race = OK
	// rarest OMB race (rarest per puma, aoic)
	gen ombrrace=""	
	// state and pumas
	save "5ACS`y'_ORWA_RELDPRI.dta", replace
	}
	rm  "5ACS`y'_ORWA_Indiv2v2.dta"
	rm  "5ACS`y'_ORWA_Indiv3v11.dta"
end
* pumsreld 2021 

// define expansion program (parts 6, 7)
cap prog drop expandpums
prog def expandpums
	args year
	local y=substr("`year'",3,2)
	// generate flags in ACS PUMS that correspond to data points in SF tables 
	import excel using "01_varstable_v02_api.xlsx", sheet(Sheet1) firstrow clear allstring
	drop if varname==""
	dropmiss, force
	gen cmd="gen byte f"+varname+"=("+filter+")"
	outfile cmd using "03b_varstable_v02_pums.do", replace nolabel noquote 
	use "5ACS`y'_ORWA_RELDPRI.dta", clear
	nois do 03b_varstable_v02_pums.do // add flags in PUMS that correspond to eligibility to be reweighted by published table totals
	rm 03b_varstable_v02_pums.do // remove, no longer needed.
	gen byte fdisaby_severe=dis==1 & (dout==1 | dphy==1 | ddrs==1) // excludes hearing, vision, memory; includes ambulatory, self-care, independent living
	compress // f-prefixed are flags for reweight eligibility
	// convert PUMAC to county. 
	ren puma puma10
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
	tostring state, replace force
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
	lab def pumac_lbl 16 "CLARK-WA", add
	replace county="011" if pumac==. & state=="53" & inrange(puma10,11101,11104)
	replace pumac=16 if state=="53" & inrange(puma10,11101,11104)
	bigtab pumac state county, nocum nol
	assert county!="" & year!=. & state!=""
	unique state county
	assert `r(unique)'==37
	compress
	drop listme factor
	save "5ACS`y'_ORWA_RELDPRI.dta", replace
end
* expandpums 2021
