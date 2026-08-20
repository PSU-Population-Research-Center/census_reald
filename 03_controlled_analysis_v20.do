** project: census_reald
** purpose: adjust pums data for agreement with marginal totals by county from controls, and export tabulations
** author: sharygin@pdx.edu
/* notes:
	- prerequisites:
		- langxwalk.dta = dataset containing crosswalk between lanp16, lang39, lang41, lang12, lang5, langfnl, langoha (ISO639-3),
		- Census API key stored in "_censuskey.txt"
		- subdirectory "results" for saving tabulations
		- subdirectory "temp" for storing control totals
	- outputs:
		- **.dta = copies of the PUMS dataset with new weights for specific tables
		- temp/control_***_tmp.dta = temporary files with control totals
		- results/results_***_`y'.dta = tabulations of REALD traits by county and age group
	- TBD: track SPD15 updates. for example, may need to add MENA to ombrr.
	- TBD: expand disability tables to not just noninscil==1 using results from CDC-Places?
	- TBD: expand health insurance tables for consistency with SAIHE?
	- TBD: refactor code to reduce duplication of PUMS datasets; read and write only necessary variables for downnscaling/tabulation
	- TBD: use of (1) lc5/lep/ac3 or (2) ancestry/waob controls may lead to marginally more accurate county lang blend within langc39/langc42.
	- TBD: rewrite to use downloaded ACS PUMS instead of PUMS API calls.
	- TBD: restore functionality to work with deprecated REALD 2020 standards as well
changelog:
	v20: clear files from last run
	~ timestamp for deliverables from 2026-08-20
	v19: call additional HINS datasets and tables and fixed some missing A3 tables (not part of REALD technically).
	v18: reflect new version of preppums and raceeth that add Jewish controls.
	v19: minor update to call additional HINS datasets and tables and fixed some missing A3 tables (not part of REALD technically).
	v18: minor update to reflect new version of preppums and raceeth that add Jewish controls.
	~ timestamp for deliverables from 2026-07-14
	v17: major update to reflect new workflows and changes to subroutines (see notes to each .do)
	~ timestamp for deliverables from 2026-07-01
	v16: updated associated dofiles to add Stata metadata; added report code to output csv.
	~ timestamp for deliverables from 2025-05-01
	v15: proportional weighting of SE, and call PUMS prep from this dofile.
	~ timestamp for deliverables from 2025-03-20
	v14: added randomtag to required packages; updated subroutine library version to work with 5ACS23
	~ timestamp for deliverables from 2024-05-28
	v13: updating language tables to comply with SOS needs; split re/d/l into separate dofiles
	~ timestamp for deliverables from 2024-04-24
	v12: updated language tables to include split by lep*agecat for each language.
	v11: completed sequential raking (1) by langc39-lep (2) by lang12-lep-agesex-langc42st.
	v10: working language rake, but excluding langc39 rake for small counties
	v09: changing donor dataset to be broader time and geography PUMS 
	v08: adding dummy exposure from older ACS PUMS instead of synthetic obs 
	v07: adding empty persons to ensure successful language rake 
	v06: converted blocks to functions and updated filenames/paths; added place for language analysis (WIP)
	~ timestamp for deliverables from 2024-01-16
	v05: fixes to disability code 
	v04: wip to add disability
	v03: wip to add disbaility
	v02: change to faster, consistent totals by county
	v01: first version, sequential totals 1/36
*/

// setup
clear
clear matrix
clear mata
set maxvar 32767 // required for fillReport
import delim using "_censuskey.txt", varn(nonames) clear
qui levelsof v1, clean local(ckey)
global ckey "`ckey'"

// TABLES
* Notes:
* REALD approaches are under ongoing development and results may not match totals published elsewhere.
* The data source is the 5-year ACS PUMS and associated 100% tabulations. PUMS results have been adjusted for consistency with county level tabulations from the 100% ACS. Totals may differ from data in published ACS tables or from ACS PUMS calculations with unadjusted person or household weights.
* The reweighting process results in non-integer counts, and these have been left as is. They can be displayed as or rounded to whole counts (in which case, rounding errors will mean that totals may not sum exactly).
* Language refers to primary language spoken at home for individuals. Language is assessed for the population age 5+ only; therefore, sums across languages will not sum to the total population. 
* Chinese includes all spoken dialects; Persian includes Farsi/Dari.
* Disability status is self-assessed only for the civilian noninstitutionalized population (excluding the population in institutional group quarters such as skilled nursing facilities whose disability status is not surveyed); therefore, sums across disability status will not sum to total population.

// add subroutines to memory
* do 01_jet_v15.do		// run REALD24 Jewish imputations
* 02_reald24_v10.r		// run REALD24 other race/ethnicity imputations
do 03a_preppums_v09.do  // load subroutines: preppums, pumsreld, expandpums
do 03b_raceeth_v21.do 	// load subroutines: pumsreld, reControls, reFile, tabAgeSex, tabReldRR, tabReldPri
do 03c_disab_v20.do 	// load subroutines: disabyControls, disabyFile, tabdisdi, tabda4, tabda7, tabdaoic
do 03d_language_v20.do 	// load subroutines: langControls, langxwalk, topdown42, langFile, donorLang, tablang, tablangSt, sosTable, sosSplit
do 04_report_v07.do 	// load subroutines: fillReport

cap prog drop doRealdCo
prog def doRealdCo
	// clear previous run data
	local tempfiles: dir "temp" files "control*.dta"
	foreach f of local tempfiles {
		erase temp/`f'
	}
	/*
	local results: dir "results" files "results*`1'.dta"
	foreach f of local results {
		erase results/`f'
	}
	*/

	// reald values
	** eventually, put the jet and reald imputation code here.
	** expand that code to add the disability and language codes needed.
	** then, this file becomes 01_run_all.do, then 02_jet and 03_reald, etc.
	
	// pums initialization (ORWA > ORWA_co.dta)
*	preppums `1' // retrieve variables needed for downscale
*	expandpums `1' // generate synthetic county level data
*	pumsreld `1' 2024 // attach imputed REALD status (2020 or 2024 version)
	
	// race-eth (ORWA_co > ORWA_raceeth.dta)
*	reControls `1' // download control totals
*	reFile `1' // generate raked microdata
*	chkTotal `1' // compare totals (interactively)
*	tabAgeSex `1' // export results by age/sex
*	tabReldRR `1' // export results by omb rarest race (from var 'ombrrn')
*	tabReldPri `1' // export totals by reald primary race (from var 'realdpri')

	// disability (ORWA_co > ORWA_disaby.dta)
*	disabyControls `1' // download control totals
*	disabyFile `1' // generate raked microdata
*	tabdisdi `1' // tables by any disability
*	tabda4 `1' // tabulate by 4-way classification
*	tabda7 `1' // tabulate by 7-way classification
*	tabdaoic `1' // tables by specific disabilities, AOIC
*	tabmaid `1' // tables for medicare
	
	// languages (ORWA_co > ORWA_lang.dta)
*	langControls `1' // download control totals
*	langxwalk // read csv to update language crosswalk between census-sos-oha codes
*	topdown42 `1' // perform SOS adjustments 
*	donorLang `1' // generate donor observation dataset(s) when languages are missing in PUMS
*	langFile `1' // generate raked microdata
*	tablang `1' // export county tables w/SE (broad age groups)
*	tablangSt `1' // export state table w/SE (detailed age groups)
*	sosTable `1' // copy-paste into Excel
*	sosSplit `1' // copy-paste into Excel

	// Excel reports
	fillReport `1' // ('suppress' option adds suppression based on RSE)
end
*doRealdCo 2023
doRealdCo 2024
