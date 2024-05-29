** project: census_reald
** purpose: adjust pums data for agreement with marginal totals by county from controls, and export tabulations
** author: sharygin@pdx.edu
/* notes:
	- prerequisites:
		- controldata_YYYY.dta = control totals by county from ACS tables for year YYYY (from 02_prep_control.do)
		- 5ACS`y'_ORWA_RELDPRI.dta = 5-year ACS pums for period ending YY (from 03_prep_pums.do)
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
changelog: ~ timestamp for deliverables from 2024-04-------
	v13: updating language tables to comply with SOS needs; splitting re/d/l into separate dofiles.
	v12: updated language tables to include split by lep*agecat for each language.
	v11: completed sequential raking (1) by langc39-lep (2) by lang12-lep-agesex-langc42st.
	v10: working language rake, but excluding langc39 rake for small counties
	v09: changing donor dataset to be broader time and geography PUMS 
	v08: adding dummy exposure from older ACS PUMS instead of synthetic obs 
	v07: adding empty persons to ensure successful language rake 
	v06: converted blocks to functions and updated filenames/paths; added place for language analysis (WIP)
	v05: fixed disability code ~ timestamp for deliverables from 2024-01-16
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
foreach p in "survwgt" "censusapi" "hotdeckvar" {
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
* The data source is the 5-year ACS PUMS and associated 100% tabulations. PUMS results have been adjusted for consistency with county level tabulations from the 100% ACS.
* Therefore, totals may differ from data in published ACS tables or from ACS PUMS calculations with unadjusted person or household weights.
* The reweighting process results in non-integer counts, and these have been left as is. They can be displayed as or rounded to whole counts (in which case, rounding errors will mean that totals may not sum exactly).
* Language is assessed for the population age 5+ only; therefore, sums across languages will not sum to the total population.
* Detailed language is implicitly treated as distributed proportionally to population of the aggregated language family between each county of a multi-county PUMA 
* For example, two distinct languages in the PUMS that are part of the same 12-way classification and known at a PUMA level where the PUMA countains multiple counties will be proportionally divided between the counties according to the county's share of total speakers of the languages in the 12-way classification.
* Disability status is assessed only for the civilian noninstitutionalized population (excluding the population in institutional group quarters such as skilled nursing facilities whose disability status is not surveyed); therefore, sums across disability status will not sum to total population.
* REALD race/ethnicity is imputed using language, place of birth, and other person-level characteristics, and then adjusted for consistency at the county level by OMB race/ethnicity only. 
* REALD subgroups for White, Asian, or Black are implicitly treated as distributed proportionally to population across each county of a multi-county PUMA. 
* REALD approaches are under ongoing development and results may not match totals published elsewhere.

// add subroutines to memory
do 03a_raceeth_v13.do // add subroutines to memory
do 03b_disab_v12.do // add subroutines to memory
do 03c_language_v14.do // add subroutines to memory

// race-eth
reControls 2019 // download control totals
reFile 2019 // generate raked microdata
chkTotal 2019 // compare totals
tabSex 2019 // export results by age/sex
tabReldRR 2019 // export results by omb rarest race
tabReldPri 2019 // export totals by reald primary race

// disability
disabyControls 2019 // download control totals
disabyFile 2019 // generate raked microdata
tabdisdi 2019 // tables by any disbaility
tabda4 2019 // tabulate by 4-way classification
tabda7 2019 // tabulate by 7-way classification
tabdaoic 2019 // tables by specific disabilities, AOIC

// languages
langControls 2019 // download control totals
langFile 2019 // generate raked microdata
tablang 2019 // export county tables w/SE (broad age groups)
tablangSt 2019 // export state table w/SE (detailed age groups)
*sosTable 2019 // copy-paste into Excel
*sosSplit 2019 // copy-paste into Excel
