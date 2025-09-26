** project: census_reald
** purpose: adjust pums data for agreement with marginal totals by county from controls, and export tabulations
** author: sharygin@pdx.edu
/* notes:
	- prerequisites:
		- 5ACS`y'_ORWA_RELDPRI.dta = 5-year ACS pums for period ending YY (from 01_prep_pums.do)
		- 02_langxwalk.dta = dataset of code correspondence between lang39, lang41, langfnl, lang12, lang5
		- Census API key stored in "censuskey.txt"
		- subdirectory "results" for saving tabulations
		- subdirectory "temp" for storing control totals
	- outputs:
		- 5ACS`y'_ORWA_RELDPRI_raceeth.dta = ACS pums with person weights consistent with county totals by age/sex and OMB race/eth
		- 5ACS`y'_ORWA_RELDPRI_disaby.dta = as above, but consistent by OHA-derived disability status and age/sex
		- 5ACS`y'_ORWA_RELDPRI_lang.dta = as above, but additionally consistent by language spoken at home for LEP population by age/sex
		- temp/control_***_tmp.dta = temporary files
		- results/results_***_`y'.dta = tabulations of REALD traits by county and age group
	- to run
		- run after 01_prep_pums.do
		- run after 02_langxwalk.dta has been updated
	- TBD: add error metric for tracking iterations in disability reweighting to aid decision on # of iterations
	- TBD: consider adding 06-10 PUMS for small counties only to inflate representation of rare conditions (especially languages)
	- TBD: roll up detailed state tabulations (age groups 0-14, 15-17, 18-19, 20(5)30, 30(10)60, 60+) into county broad ages (5-17, 18-64, 65+)
changelog:
	v17: load new language (v20) and report routines (v04).
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
if "$censuskey"=="" {
	import delim using "censuskey.txt", varn(nonames) clear
	qui levelsof v1, clean local(censuskey)
	global ckey "`censuskey'"
}
foreach p in "survwgt" "censusapi" "hotdeckvar" "randomtag" {
	cap which `p'
	if _rc ssc install `p'
}

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
do 01_prep_pums_v04.do // add subroutines to memory
do 03a_raceeth_v17.do // add subroutines to memory
do 03b_disab_v14.do // add subroutines to memory
do 03c_language_v20.do // add subroutines to memory
do 04_report_v04.do // subroutines for Excel final report

forvalues y=2019/2023 {

// prep PUMS
*preppums `y' // combine WA/OR and rename
*pumsreld `y' // add imputed REALD status
*expandpums `y' // generate synthetic county level data

// race-eth
*reControls `y' // download control totals
*reFile `y' // generate raked microdata
*chkTotal `y' // compare totals
*tabAgeSex `y' // export results by age/sex
*tabReldRR `y' // export results by omb rarest race
*tabReldPri `y' // export totals by reald primary race

// disability
*disabyControls `y' // download control totals
*disabyFile `y' // generate raked microdata
*tabdisdi `y' // tables by any disability
*tabda4 `y' // tabulate by 4-way classification
*tabda7 `y' // tabulate by 7-way classification
*tabdaoic `y' // tables by specific disabilities, AOIC

// languages
*langControls `y' // download control totals
*topdown42 `y' // perform SOS adjustments 
*langFile `y' // generate raked microdata
*donorLang `y' // generate donor observation dataset 
*tablang `y' // export county tables w/SE (broad age groups)
*tablangSt `y' // export state table w/SE (detailed age groups)
*sosTable `y' // copy-paste into Excel
*sosSplit `y' // copy-paste into Excel

// reports
*if `y'==2023 fillReport `y' suppress // load results, export to Excel (suppress option adds suppression)

}
