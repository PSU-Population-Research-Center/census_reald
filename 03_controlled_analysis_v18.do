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
	- TBD: reorganize such that this file comes first, calls JET/REALD20/REALD24 as needed.
	- TBD: track SPD15 updates. for example, may need to add MENA to ombrr.
	- TBD: add error metric for tracking iterations in reweighting to aid decision on # of iterations
	- TBD: expand disability tables to not just noninscil==1?
	- TBD: refactor code to reduce duplication of PUMS datasets; read and write only necessary variables for downnscaling/tabulation
	- TBD: use of (1) lc5/lep/ac3 or (2) ancestry/waob controls may lead to marginally more accurate county lang blend within langc39/langc42.
	- TBD: rewrite to use downloaded ACS PUMS instead of API, for PUMS API calls.
	- TBD: restore functionality to work with deprecated REALD 2020 standards as well
	- Requested: roll up detailed state disability tabulations by all age groups into county broad ages (5-17, 18-64, 65+)
	- Requested: additional table with sex/agecat detail for bins: (6 groups: m5-17,m18-64,m65+,f5-17,f18-64,f65+)*(3 bins: 25-100, 100-299, 300+)
	- Requested: convert Chinese and Persian splits into counts (instead of %)
changelog:
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
	v05: fixed disability code 
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

* Notes:
* REALD approaches are under ongoing development and results may not match totals published elsewhere.
* The data source is the 5-year ACS PUMS and associated 100% tabulations. PUMS results have been adjusted for consistency with county level tabulations from the 100% ACS. Totals may differ from data in published ACS tables or from ACS PUMS calculations with unadjusted person or household weights.
* The reweighting process results in non-integer counts, and these have been left as is. They can be displayed as or rounded to whole counts (in which case, rounding errors will mean that totals may not sum exactly).
* Language is assessed for the population age 5+ only; therefore, sums across languages will not sum to the total population.
* Disability status is assessed only for the civilian noninstitutionalized population (excluding the population in institutional group quarters such as skilled nursing facilities whose disability status is not surveyed); therefore, sums across disability status will not sum to total population.

// add subroutines to memory
* rcall Rscript jet.do	// run REALD24 Jewish imputations
* rcall Rscript reld.r	// run REALD24 other race/ethnicity imputations
do 03a_preppums_v09.do  // load subroutines: preppums, pumsreld, expandpums
do 03b_raceeth_v21.do 	// load subroutines: pumsreld, reControls, reFile, tabAgeSex, tabReldRR, tabReldPri
do 03c_disab_v17.do 	// load subroutines: disabyControls, disabyFile, tabdisdi, tabda4, tabda7, tabdaoic
do 03d_language_v20.do 	// load subroutines: langControls, langxwalk, topdown42, langFile, donorLang, tablang, tablangSt, sosTable, sosSplit
do 04_report_v06.do 	// load subroutines: fillReport

cap prog drop doRealdCo
prog def doRealdCo
	// reald values
	** eventually, put the jet and reald imputation code here.
	** expand that code to add the disability and language codes needed.
	** then, this file becomes 01_run_all.do, then 02_jet and 03_reald, etc.
	
	// pums initialization (ORWA > ORWA_co.dta)
	preppums `1' // retrieve variables needed for downscale
	expandpums `1' // generate synthetic county level data
	pumsreld `1' 2024 // attach imputed REALD status (2020 or 2024 version)
	
	// race-eth (ORWA_co > ORWA_raceeth.dta)
	reControls `1' // download control totals
	reFile `1' // generate raked microdata
	chkTotal `1' // compare totals (interactively)
	tabAgeSex `1' // export results by age/sex
	tabReldRR `1' // export results by omb rarest race (from var 'ombrrn')
	tabReldPri `1' // export totals by reald primary race (from var 'realdpri')

	// disability (ORWA_co > ORWA_disaby.dta)
	disabyControls `1' // download control totals
	disabyFile `1' // generate raked microdata
	tabdisdi `1' // tables by any disability
	tabda4 `1' // tabulate by 4-way classification
	tabda7 `1' // tabulate by 7-way classification
	tabdaoic `1' // tables by specific disabilities, AOIC

	// languages (ORWA_co > ORWA_lang.dta)
	langControls `1' // download control totals
	langxwalk // read csv to update language crosswalk between census-sos-oha codes
	topdown42 `1' // perform SOS adjustments 
	donorLang `1' // generate donor observation dataset(s) when languages are missing in PUMS
	langFile `1' // generate raked microdata
	tablang `1' // export county tables w/SE (broad age groups)
	tablangSt `1' // export state table w/SE (detailed age groups)
	sosTable `1' // copy-paste into Excel
	sosSplit `1' // copy-paste into Excel

	// Excel reports
	fillReport `1' // ('suppress' option adds suppression based on RSE)
end
*doRealdCo 2023
*doRealdCo 2024
