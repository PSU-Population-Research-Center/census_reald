# Downloads
Downloads are currently available as Stata datasets only, where the file year refers to the final year of the 5-year ACS data release. Each dataset contains fields identifying the geography (stcofips, the state and or county FIPS codes), the subpopulation for which the estimates are generated, and the estimate (b) and standard error of the estimate (se).

Population by age/sex: [2019](results/results_agesex_2019.dta) [2020](results/results_agesex_2020.dta) [2021](results/results_agesex_2021.dta) [2022](results/results_agesex_2022.dta)<br />
Population by age/sex and OMB race (ombrr): [2019](results/results_agesex_ombrr_2019.dta) [2020](results/results_agesex_ombrr_2020.dta) [2021](results/results_agesex_ombrr_2021.dta) [2022](results/results_agesex_ombrr_2022.dta)<br />
Population by age/sex and REALD primary race (reldpri): [2019](results/results_agesex_reldpri_2019.dta) [2020](results/results_agesex_reldpri_2020.dta) [2021](results/results_agesex_reldpri_2021.dta) [2022](results/results_agesex_reldpri_2022.dta)<br />
Population by Disability (disdi): [2019](results/results_disdi_2019.dta) [2020](results/results_disdi_2020.dta) [2021](results/results_disdi_2021.dta) [2022](results/results_disdi_2022.dta)<br />
Population by Disability, combined (da4): [2019](results/results_da4cat_2019.dta) [2020](results/results_da4cat_2020.dta) [2021](results/results_da4cat_2021.dta) [2022](results/results_da4cat_2022.dta)<br />
Population by Disability, detailed (da7): [2019](results/results_da7compacsall_2019.dta) [2020](results/results_da7compacsall_2020.dta) [2021](results/results_da7compacsall_2021.dta) [2022](results/results_da7compacsall_2022.dta)<br />
Population by Disability, sight (eye): [2019](results/results_deyeoicv2_2019.dta) [2020](results/results_deyeoicv2_2020.dta) [2021](results/results_deyeoicv2_2021.dta) [2022](results/results_deyeoicv2_2022.dta)<br />
Population by Disability, hearing (ear): [2019](results/results_dearoicv2_2019.dta) [2020](results/results_dearoicv2_2020.dta) [2021](results/results_dearoicv2_2021.dta) [2022](results/results_dearoicv2_2022.dta)<br />
Population by Disability, self-care (drs): [2019](results/results_ddrsoicv2_2019.dta) [2020](results/results_ddrsoicv2_2020.dta) [2021](results/results_ddrsoicv2_2021.dta) [2022](results/results_ddrsoicv2_2022.dta)<br />
Population by Disability, ambulatory (phy): [2019](results/results_dphyoicv2_2019.dta) [2020](results/results_dphyoicv2_2020.dta) [2021](results/results_dphyoicv2_2021.dta) [2022](results/results_dphyoicv2_2022.dta)<br />
Population by Disability, cognitive (rem): [2019](results/results_dremoicv2_2019.dta) [2020](results/results_dremoicv2_2020.dta) [2021](results/results_dremoicv2_2021.dta) [2022](results/results_dremoicv2_2022.dta)<br />
Population by Disability, independent living (out): [2019](results/results_doutoicv2_2019.dta) [2020](results/results_doutoicv2_2020.dta) [2021](results/results_doutoicv2_2021.dta) [2022](results/results_doutoicv2_2022.dta)<br />
Population by LEP and Language Spoken at Home (counties): [2019](results/results_lang_2019.dta) [2020](results/results_lang_2020.dta) [2021](results/results_lang_2021.dta) [2022](results/results_lang_2022.dta)<br />
Population by LEP and Language Spoken at Home (state; additional age detail): [2019](results/results_langst_2019.dta) [2020](results/results_langst_2020.dta) [2021](results/results_langst_2021.dta) [2022](results/results_langst_2022.dta)<br />

# Data and Methods
The ACS is a nationally representative sample of approximately 2% of the US resident population each year. Results of the ACS data are published as tables, aggregated into a variety of summary file releases such as subject tables, demographic profiles, detailed tables, and others. The ACS tables do not contain sufficient detail to count the population by REALD characteristics. Therefore, the starting estimates for the population by REALD characteristics are estimated from the ACS PUMS, a microdata sample of individual ACS responses. 

The published tables differ from the PUMS in several respects: they are calculated from the 100% ACS sample (rather than the portion of the sample included in the PUMS), which provides greater statistical confidence. They are also available for many geographical levels including individual census tracts and counties (rather than the PUMA geographies which are the only level available for the PUMS). The ACS PUMS contains approximately 50% of unit-level response data from the ACS. ACS releases are currently published as single-year samples, weighted to the mid-year population, or in five-year aggregated samples, combining 5 cumulative years of ACS response data, and weighted to the mid-year population of the third year of the sample (as estimated in the fifth year of the sample). In order to construct a more statistically reliable and consistent sample, data from the five-year PUMS samples are used for all areas. The data also contain replicate weights for persons and households for evaluating statistical uncertainty.

The REALD & SOGI unit of OHA developed coding heuristics which use the following ACS PUMS data fields in order to classify persons according to race, ethnicity, language, and disability status in a manner consistent with the REALD definitions:

|     | **ACS PUMS variables** |     |     |     |     |
| --- | --- | --- | --- | --- | --- |
| ST  | State (FIPS code) | RACAIAN | Am. Ind. or AK Native race | LANP | Language spoken at home |
| PUMA | PUMA code (2010 or 2020 PUMAs) | RACASN | Asian race | ENG | Ability to speak English |
| PWGT\* | Person weight and replicate weights | RACBLK | Black or African American race | DIS | Recoded disability (Y/N) |
| SEX | Binary sex (Male/Female) | RACNH | Native Hawaiian race | DOUT | Independent living difficulty |
| AGEP | Age in years (mean-corrected topcoding 90+) | RACPI | Pacific Islander race | DPHY | Ambulatory difficulty |
| POBP | State or country of birth | RACSOR | Some other race | DREM | Cognitive difficulty |
| MIGSP | Movers during past year: state or country of origin | RACWHT | White race | DEYE | Vision difficulty |
| RELSHIPP | Relation to respondent | RACNUM | Number of races selected | DEAR | Hearing difficulty |
| ANC1P | Ancestry (first response) | RAC1P | Recoded detailed race code (9 values) | DDRS | Self-care difficulty |
| ANC2P | Ancestry (second response) | RAC2P | Recoded detailed race code (68 values) | HINS\* | Health insurance (multiple codes) |
| HISP | Hispanic ethnicity (multiple codes) | RAC3P | Recoded detailed race code (100 values) | .   | .   |

In order to protect respondent privacy and prevent reidentification of households, the ACS PUMS employs several disclosure avoidance strategies, including aggregation of responses to geographies that represent 100,000 persons or more as of the last decennial Census. These geographies, called PUMAs, are made up of contiguous census tracts, and are updated after each decennial census. Because of the 100,000 persons minimum threshold, PUMAs may be larger or smaller than counties, and may contain parts of counties when a county contains more than one tract. For example, a consistent grouping which delineates whole counties in Oregon (plus Clark County, WA) only includes 16 geographical units (PUMA-Counties or PUMAC), ranging from 1 to 9 counties in each area:

**2010 Census PUMACs (2012-2021 PUMS):** <br />
1: BAKER, UMATILLA, UNION, WALLOWA<br />
2: CROOK, GILLIAM, GRANT, HOOD RIVER, JEFFERSON, MORROW, SHERMAN, WASCO, WHEELER<br />
3: HARNEY, KLAMATH, LAKE, MALHEUR<br />
4: DESCHUTES<br />
5: CLATSOP, COLUMBIA, LINCOLN, TILLAMOOK<br />
6: BENTON, LINN<br />
7: LANE<br />
8: COOS, CURRY, JOSEPHINE<br />
9: JACKSON<br />
10: DOUGLAS<br />
11: MARION<br />
12: POLK, YAMHILL<br />
13: MULTNOMAH<br />
14: CLACKAMAS<br />
15: WASHINGTON<br />
16: CLARK (WA)<br />

**2020 Census PUMACs (2022-2031 PUMS):** <br />
1: BAKER, GRANT, GILLIAM, HOOD RIVER, MORROW, SHERMAN, UMATILLA, UNION, WASCO, WALLOWA, WHEELER<br />
2: CROOK, JEFFERSON, DESCHUTES<br />
3: HARNEY, KLAMATH, LAKE, MALHEUR<br />
4: YAMHILL<br />
5: CLATSOP, COLUMBIA, TILLAMOOK<br />
6: BENTON, LINN<br />
7: LANE<br />
8: COOS, CURRY, JOSEPHINE<br />
9: JACKSON<br />
10: DOUGLAS<br />
11: MARION<br />
12: POLK, LINCOLN<br />
13: MULTNOMAH<br />
14: CLACKAMAS<br />
15: WASHINGTON<br />
16: CLARK (WA)<br />

The PUMACs represent the minimum group of counties that can be identified by a single PUMA. For multi-county PUMAs, the data for the PUMA are used but the weights are adjusted by poststratification so that the weighted totals equal the published county total population by age and sex from the 100% ACS tabulation. After 2020, the number of PUMACs remained the same but the configurations of several PUMACs were changed. These affect ACS PUMS releases starting with the releases containing survey response data from calendar year 2022.

To obtain county-level data from the PUMS dataset, we adopt an allocation approach based on maximum entropy imputation weighting, which has been demonstrated to produce accurate characteristics from census microdata samples at the PUMA level when downscaled to the census tract level and compared against tables generated from 100% of the census microdata.<sup>[\[1\]](#footnote-1)</sup> The approach relies on the use of meaningful ‘constraining variables’ which guide the allocation of data from the PUMA to the tract or county level. The most important constraining totals are those which have a high degree of variation between the lower-level geographic units. For example, binary sex would be a poor constraint because it may not be differently distributed at the county level compared to the PUMA level; language spoken at home is certainly more important when there are intra-PUMA regional differences in distribution of households who speak different languages.

The final collection of tables includes REALD characteristics broken down by age group (county level tabulations will include the age groups 0-4, 5-17, 18-64, and 65+), including:<br />
- detailed REALD race/ethnicity;<br />
- OMB race (based on the rarest race heuristic);<sup>[\[2\]](#footnote-2)</sup><br />
- Any disability;<br />
- Disability by type;<br />
- Binary sex;<br />
- Limited English proficient (LEP) population;<br />
- Language spoken at home (overall and for the LEP population only).

Because of the narrow focus of these tabulations, the constraining totals chosen are those which correspond as closely as possible to the required characteristics (and their joint distributions). The marginal totals at the tract or county level from the following ACS detailed tables are used:

[B01001\*](https://censusreporter.org/tables/B01001/): Sex by Age<br />
[B02003](https://censusreporter.org/tables/B02003/): Detailed Race<br />
[B02014](https://censusreporter.org/tables/B02014/): American Indian and Alaska Native Alone for Selected Tribal Groupings<br />
[B02015](https://censusreporter.org/tables/B02015/): Asian Alone by Selected Groups<br />
[B02016](https://censusreporter.org/tables/B02016/): Native Hawaiian and Other Pacific Islander Alone by Selected Groups<br />
[B03001](https://censusreporter.org/tables/B03001/): Hispanic or Latino Origin by Specific Origin<br />
[B03002](https://censusreporter.org/tables/B03002/): Hispanic or Latino Origin by Race<br />
[B05013](https://censusreporter.org/tables/B05013/): Sex by Age for the Foreign-born Population<br />
[B16001](https://censusreporter.org/tables/B16001/): Language Spoken at Home by Ability to Speak English<br />
[B16004](https://censusreporter.org/tables/B16004/): Age by Language Spoken at Home by Ability to Speak English<br />
[B16005\*](https://censusreporter.org/tables/B16005/): Nativity by Language Spoken at Home by Ability to Speak English<br />
[B18101\*](https://censusreporter.org/tables/B18101/): Sex by Age by Disability Status<br />
[B18102](https://censusreporter.org/tables/B18102/): Sex by Age by Hearing Difficulty<br />
[B18103](https://censusreporter.org/tables/B18103/): Sex by Age by Vision Difficulty<br />
[B18104](https://censusreporter.org/tables/B18104/): Sex by Age by Cognitive Difficulty<br />
[B18105](https://censusreporter.org/tables/B18105/): Sex by Age by Ambulatory Difficulty<br />
[B18106](https://censusreporter.org/tables/B18106/): Sex by Age by Self-care Difficulty<br />
[B18107](https://censusreporter.org/tables/B18107/): Sex by Age by Independent Living Difficulty<br />
\*: indicates that tables iterations are available by OMB race/ethnicity.

After the REALD characteristics are imputed from the available PUMS data fields, the records are segmented by PUMA, and the original data fields are used to impute new weights that accord to the small area constraining totals for each of the counties that constitute the multi-county PUMAs.

The ACS PUMS includes replicate weights, which allow analysts to assess the statistical uncertainty in most types of tabulations generated from the PUMS. The ACS published tables also generally include 90% margins of error, which can be converted back to standard errors. These sources of statistical uncertainty can be combined in the final estimates by repeated measurements drawn from normal distributions defined by the point estimates and standard errors in the ACS. Over the course of many repeated simulations, the results can be collapsed into cumulative means and standard errors. There are additional errors associated with the assumptions that are inherent in the maximum entropy imputation weighting method, which are nonquantifiable and not represented in the final means and standard errors. 

# Notes
- The reweighting process results in non-integer counts, and these have been left as is. They can be displayed as or rounded to whole counts (in which case, rounding errors will mean that totals may not sum exactly).<br />
- Language is assessed for the population age 5+ only; therefore, sums across languages will not sum to the total population. Detailed language is implicitly treated as distributed proportionally to population of the aggregated language family between each county of a multi-county PUMA. For example, two distinct languages in the PUMS that are part of the same 12-way classification and known at a PUMA level where the PUMA countains multiple counties will be proportionally divided between the counties according to the county's share of total speakers of the languages in the 12-way classification.<br />
- Disability status is assessed only for the civilian noninstitutionalized population (excluding the population in institutional group quarters such as skilled nursing facilities whose disability status is not surveyed); therefore, sums across disability status will not sum to total population.<br />
- REALD race/ethnicity is imputed using language, place of birth, and other person-level characteristics, and then adjusted for consistency at the county level by OMB race/ethnicity only. REALD subgroups for White, Asian, or Black are implicitly treated as distributed proportionally to population across each county of a multi-county PUMA. REALD approaches are under ongoing development and results may not match totals published elsewhere.

# Funding Acknowledgement
OHA IGA#179509 "County-level REALD population estimates"

# References
1. Ruther M, Maclaurin G, Leyk S, Buttenfield B, Nagle N. 2013. “Validation of spatially allocated small area estimates for 1880 Census demography”. _Demographic Research_, 29(22):579–616. doi: 10.4054/DemRes.2013.29.22 [↑](#footnote-ref-1)
2. Mays VM, Ponce NA, Washington DL, Cochran SD. 2003. “Classification of race and ethnicity: implications for public health.” _Annu Rev Public Health_. 24:83-110. doi: 10.1146/annurev.publhealth.24.100901.140927 [↑](#footnote-ref-2)
