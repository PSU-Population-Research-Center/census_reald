------------------------------------------------------------------------------------------
Documentation for ORSOS_HB3021_5ACS22_v02.xlsx
PSU PRC language data for HB3021, 2022 edition
------------------------------------------------------------------------------------------

Contents
	- Description
	- Contact
	- Notes
	- History
	
------------------------------------------------------------------------------------------
Description
------------------------------------------------------------------------------------------

File name: 			ORSOS_HB3021_5ACS22_v02.xlsx
Year:				2024
Geographic level:	County and State
Extent:				Oregon and Clark County, WA
URL (temporary): 	N/A

Contents:
	- The Excel file contains 6 tabs, containing tabulated results from analysis:
		Top10_ALL and Top10_LEP contain the top 10 languages spoken by 100 or more persons
			for the total and the limited English (LEP) population, respectively
		Chinese_Persian contains breakdowns of Persian speakers by Farsi/Dari, and 
			Chinese speakers by Simplified or Traditional orthography.
		Bins_ALL and Bins_LEP contain the estimated number of speakers for all languages
			with at least 100 speakers, overall or by LEP, respectively
		ACS contains copies of published tables from the American Community Survey used
			in the analysis and estimation process

Data Dictionary:
	N/A

------------------------------------------------------------------------------------------
Contact
------------------------------------------------------------------------------------------

This dataset was produced under bilateral interagency agreements with Portland State 
	University, Oregon Secretary of State, and Oregon Health Authority.

For further information, please contact the Population Research Center: www.pdx.edu/prc 
	or askprc@pdx.edu

Citation: 
	Population Research Center. Population estimates for Oregon by language spoken and
	limited English proficiency (LEP), version 2.0 [dataset]. Portland, OR: Portland State 
	University. 2024.

Disclaimer:
	We try to make these data as error-free as possible, but we make no formal guarantees 
	as to the accuracy of the estimated population fields. If you find a mistake, please 
	don't hesitate to reach out to us about it.

------------------------------------------------------------------------------------------
Notes
------------------------------------------------------------------------------------------

The associated data files contain demographic analysis and data for the purposes of
research and planning for service delivery and in support of needs under HB3021 and other
public policy purposes, developed in collaboration with the Oregon Secretary of State and 
the Oregon Health Authority.

The data include estimated population counts for languages spoken at the state and county
level for Oregon counties and Clark County, WA. Languages listed are consistent with the 
4-digit code system used by the US Census Bureau since 2016, which is closely related to 
the ISO 639-3 classification. The Census Bureau aggregates or combines many 4-digit codes 
in its public products, including the Public Use Microdata Sample (PUMS) and tables 
B16001 and C16001.

Starting in 2016, the Census Bureau made several revisions to language coding and 
tabulation standards, including adoption of ISO-639-3 standard; a new list of 42 languages 
to be included in table B16001, and additional geographic restrictions for table B16001 
for the 5-year sample to the national, state, MSA/CSA, CD, and PUMA levels. County/tracts 
must use the collapsed table C16001 with fewer individual languages that had 1 million or 
more speakers nationally in 2016. See more information in the published note at:
https://www.census.gov/programs-surveys/acs/technical-documentation/user-notes/2017-02.html

However, 2016+ versions of table B16001 have been published in the 1-year ACS releases for 
counties that met population size and other requirements. For example, the following OR
county-year combinations have B16001 (2016+ version) data available:

					2016	2017	2018	2019	2020	2021	2022
Multnomah County 	x		x				x				x		x	
Washington County 	x		x		x						x		x	

The starting dataset for the estimation of the number of speakers by language is the ACS
PUMS. To generate county-level estimates, data for PUMAs that contain multiple counties
were duplicated for each constituent county, and the ACS weights were adjusted such that
the county population by age/sex and race/ethnicity were consistent with ACS county
level tables B01001 and B01001A-I. For these counties, the PUMS detailed ISO language 
codes were linked to a language or language group from the published county tables, and 
then the weights representing the number of language speakers for each by LEP status were 
adjusted by weighting to the 2015 B16001 county level tabulation (with 32 unique values). 
In cases where the PUMS did not contain records for persons speaking a language that had
a non-zero control total, characteristics were imputed based on a hotdeck from a pooled 
statewide sample of speakers of that language from a year in 2016 or later. 

For Multnomah and Washington counties, a synthetic estimate of speakers for the post-2016 
language list (with 42 unique values) was generated by combining cumulative data on the 
number of speakers by LEP status for up to 5 years since 2016. This was introduced in 
version 02 to reduce the adverse impact of sample variability in the 1-year ACS, while 
leveraging the larger sample size of ACS published tables to produce more accurate counts.

The final raking step was to adjust weights such that the population counts are consistent
with the age and sex structure of the last 5-year ACS sample, as well as the county-level
language speakers by LEP status from table C16001 (and in the case of all Oregon counties,
also the B16001 statwide estimates according to the detailed language list by LEP status.

The reweighting process results in non-integer counts, which have been rounded in the 
published table of results. Rounding errors may results in totals that do not sum exactly. 
Standard errors (not shown in tables) for Clackamas, Douglas, Deschutes, Jackson, Lane, 
Marion, Multnomah, and Washington counties are from ACS replicate weights. Other counties'
standard errors are experimental and should be interpreted with caution. Missing data 
should be interpreted as zeros; missing standard errors indicate insufficient data.

The list of final languages with published counts of speakers is a subset of the PUMS
detailed ISO languages that was developed in consultation with project sponsors to meet
policy and program needs. These included estimates for 44 languages or language groups in 
the detailed tables (OHA) and for 98 languages in the summary tables (SOS).

Language and English proficiency is assessed for the resident population age 5 and older; 
therefore, totals will not sum to the total population. 

------------------------------------------------------------------------------------------
History
------------------------------------------------------------------------------------------

* v02 (2024-07-10)
	Updated results to incorporate county-level B16001 tables.
* v01 (2024-05-22)
	Preliminary release version of the dataset from 5-year ACS 2022 PUMS and tables.
