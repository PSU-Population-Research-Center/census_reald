# Population Data in Oregon REALD categories
This document describes the plan of work for the project “County-level REALD population estimates”. It includes a description of the data sources and methodologies to be applied to generate county-level estimates of population by REALD from American Community Survey (ACS) data at mixed spatial scales, and associated confidence intervals, for Oregon counties and for Clark County, WA.

# ACS PUBLIC USE MICRODATA SAMPLE (PUMS) DATA FIELDS
The starting estimates for the population by REALD characteristics are estimated from the ACS PUMS, a microdata sample of individual ACS responses. The ACS survey reaches approximately 2% of the population of Oregon each year. The PUMS contains approximately half of ACS record-level item response data. Starting in 2014, the ACS PUMS data are published as single-year samples, weighted to the mid-year population, or in five-year aggregated samples, combining 5 cumulative years of ACS response data, and weighted to the mid-year population of the third year of the sample. In order to construct a more statistically reliable and consistent sample, data from the five-year PUMS samples are used for all areas. The data also contain replicate weights for persons and households to evaluate statistical uncertainty.

The REALD & SOGI unit of OHA developed coding heuristics which use the following official ACS data fields in order to classify persons according to race, ethnicity, language, and disability status in a manner consistent with the REALD definitions:

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

# ACS PUBLIC USE MICRODATA AREA (PUMA) GEOGRAPHY

In order to protect respondent privacy and prevent reidentification of households, the ACS PUMS employs several disclosure avoidance strategies, including aggregation of responses to geographies that represent 100,000 persons or more as of the last decennial Census. These geographies, called PUMAs, are made up of contiguous census tracts, and typically change after each Census. Because of the 100,000 persons minimum threshold, PUMAs may be larger or smaller than counties, and may contain parts of counties when a county contains more than one tract. For example, a consistent grouping which delineates whole counties in Oregon (plus Clark County, WA) only includes 16 geographical units (PUMA-Counties or PUMAC), ranging from 1 to 9 counties in each area:

|     | **2010 Census PUMACs (2012-2021 PUMS):** |     |     |     |     |
| --- | --- | --- | --- | --- | --- |
| 1   | BAKER, UMATILLA, UNION, WALLOWA | 6   | BENTON, LINN | 11  | MARION |
| 2   | CROOK, GILLIAM, GRANT, HOOD RIVER, JEFFERSON, MORROW, SHERMAN, WASCO, WHEELER | 7   | LANE | 12  | POLK, YAMHILL |
| 3   | HARNEY, KLAMATH, LAKE, MALHEUR | 8   | COOS, CURRY, JOSEPHINE | 13  | MULTNOMAH |
| 4   | DESCHUTES | 9   | JACKSON | 14  | CLACKAMAS |
| 5   | CLATSOP, COLUMBIA, LINCOLN, TILLAMOOK | 10  | DOUGLAS | 15  | WASHINGTON |
|     |     |     |     | 16  | CLARK (WA) |
| &nbsp; | **2020 Census PUMACs (2022-2031 PUMS):** | &nbsp; | &nbsp; | &nbsp; | &nbsp; |
| 1   | BAKER, GRANT, GILLIAM, HOOD RIVER, MORROW, SHERMAN, UMATILLA, UNION, WASCO, WALLOWA, WHEELER | 6   | BENTON, LINN | 11  | MARION |
| 2   | CROOK, JEFFERSON, DESCHUTES | 7   | LANE | 12  | POLK, LINCOLN |
| 3   | HARNEY, KLAMATH, LAKE, MALHEUR | 8   | COOS, CURRY, JOSEPHINE | 13  | MULTNOMAH |
| 4   | YAMHILL | 9   | JACKSON | 14  | CLACKAMAS |
| 5   | CLATSOP, COLUMBIA, TILLAMOOK | 10  | DOUGLAS | 15  | WASHINGTON |
|     |     |     |     | 16  | CLARK (WA) |

The PUMACs represent the minimum group of counties that can be identified by a single PUMA. For multi-county PUMAs, the data for the PUMA are used but the weights are adjusted by poststratification so that the weighted totals equal the known county total population, for a given array characteristics for which the PUMA and county totals are both known. After 2020, the number of PUMACs remained the same but the configurations of several PUMACs were changed. These affect ACS PUMS releases starting with the releases containing survey response data from calendar year 2022.

# ACS TABULAR DATA
Besides the PUMS, ACS response data are also available in published tables, aggregated into a variety of summary file releases such as subject tables, demographic profiles, detailed tables, and others. The published tables differ from the PUMS in several respects: they are calculated from the 100% ACS sample (rather than the portion of the sample included in the PUMS), which provides greater statistical certainty. They are also available for many geographical levels including individual census tracts and counties (rather than the PUMA geographies which are the only level available for the PUMS). Another minor difference is that, due to the use of different sample sizes and weighting procedures, the weighted populations are not exactly equal between the published tables and PUMS.

# PUMAC-COUNTY DOWNSCALING BY PROXY POPULATIONS
To obtain county-level data from the PUMS dataset, we adopt an allocation approach based on maximum entropy imputation weighting, which has been demonstrated to produce accurate characteristics from census microdata samples at the PUMA level when downscaled to the census tract level and compared against tables generated from 100% of the census microdata.<sup>[\[1\]](#footnote-1)</sup> The approach relies on the use of meaningful ‘constraining variables’ which guide the allocation of data from the PUMA to the tract or county level. The most important constraining totals are those which have a high degree of variation between the lower-level geographic units. For example, binary sex would be a poor constraint because it may not be differently distributed at the county level compared to the PUMA level; language spoken at home is certainly more important when there are intra-PUMA regional differences in distribution of households who speak different languages.

The final collection of tables includes REALD characteristics broken down by age group (county level tabulations will include the age groups 0-4, 5-17, 18-64, and 65+), including:
- Most detailed REALD race/ethnicity;
- Rarest race (based on frequency of race/ethnicity by PUMA);<sup>[\[2\]](#footnote-2)</sup>
- Any disability;
- Disability type;
- Binary sex;
- Limited English proficient (LEP) population;
- Language spoken at home (overall and for the LEP population only);

Because of the narrow focus of these tabulations, the constraining totals chosen are those which correspond as closely as possible to the required characteristics (and their joint distributions). The marginal totals at the tract or county level from the following ACS detailed tables are used:

| **ACS Table** | **Description** | **ACS Table** | **Description** |
| [B01001\*](https://censusreporter.org/tables/B01001/) | Sex by Age | [B16004](https://censusreporter.org/tables/B16004/) | Age by Language Spoken at Home by Ability to Speak English |
| [B02003](https://censusreporter.org/tables/B02003/) | Detailed Race | [B16005\*](https://censusreporter.org/tables/B16005/) | Nativity by Language Spoken at Home by Ability to Speak English |
| [B02014](https://censusreporter.org/tables/B02014/) | American Indian and Alaska Native Alone for Selected Tribal Groupings | [B18101\*](https://censusreporter.org/tables/B18101/) | Sex by Age by Disability Status |
| [B02015](https://censusreporter.org/tables/B02015/) | Asian Alone by Selected Groups | [B18102](https://censusreporter.org/tables/B18102/) | Sex by Age by Hearing Difficulty |
| [B02016](https://censusreporter.org/tables/B02016/) | Native Hawaiian and Other Pacific Islander Alone by Selected Groups | [B18103](https://censusreporter.org/tables/B18103/) | Sex by Age by Vision Difficulty |
| [B03001](https://censusreporter.org/tables/B03001/) | Hispanic or Latino Origin by Specific Origin | [B18104](https://censusreporter.org/tables/B18104/) | Sex by Age by Cognitive Difficulty |
| [B03002](https://censusreporter.org/tables/B03002/) | Hispanic or Latino Origin by Race | [B18105](https://censusreporter.org/tables/B18105/) | Sex by Age by Ambulatory Difficulty |
| [B05013](https://censusreporter.org/tables/B05013/) | Sex by Age for the Foreign-born Population | [B18106](https://censusreporter.org/tables/B18106/) | Sex by Age by Self-care Difficulty |
| [B16001](https://censusreporter.org/tables/B16001/) | Language Spoken at Home by Ability to Speak English | [B18107](https://censusreporter.org/tables/B18107/) | Sex by Age by Independent Living Difficulty |
| \*: indicates that tables iterations are available by OMB race/ethnicity. |     |     |     |

After the REALD characteristics are imputed from the available PUMS data fields, the records are segmented by PUMA, and the original data fields are used to impute new weights that accord to the small area constraining totals for each of the counties that constitute the multi-county PUMAs.

# PROPAGATING UNCERTAINTY TO FINAL CONFIDENCE INTERVALS
The ACS PUMS includes replicate weights, which allow analysts to assess the statistical uncertainty in most types of tabulations generated from the PUMS. The ACS published tables also generally include 90% margins of error, which can be converted back to standard errors for other confidence levels. These sources of statistical uncertainty can be combined in the final estimates by repeated measurements drawn from normal distributions defined by the point estimates and standard errors in the ACS. Over the course of many repeated simulations, the results can be collapsed into cumulative means and standard errors. There are additional errors associated with the assumptions that are inherent in the maximum entropy imputation weighting method, which are nonquantifiable and not represented in the final means and standard errors. 

# RELEASE NOTES
The 5-year ACS PUMS for 2020 and 2021 have been processed. Summary results from the 2021 5-year ACS are included in the published Excel file. The dates of subsequent ACS releases is provided here:

| **ACS Series** | **Tables Date** | **PUMS Date** | **Midpoint** | **Status** |
| 5ACS19 | 2020-12-10 | 2021-1-14 | 2017 | WIP |
| 5ACS20 | 2022-3-17 | 2022-3-31 | 2018 | Complete |
| 5ACS21 | 2022-12-8 | 2023-1-26 | 2019 | Complete |
| 5ACS22 | 2023-12-7 | 2024-1-25 | 2020 | WIP |
| 5ACS23 | TBD | TBD | 2021 | TBD |

The data source is the 5-year ACS PUMS and associated 100% tabulations. PUMS results have been adjusted for consistency with county level tabulations from the 100% ACS. Therefore, totals may differ from data in published ACS tables or from ACS PUMS calculations with unadjusted person or household weights. The reweighting process results in non-integer counts, and these have been left as is. They can be displayed as or rounded to whole counts (in which case, rounding errors will mean that totals may not sum exactly).

Language is assessed for the population age 5+ only; therefore, sums across languages will not sum to the total population. Detailed language is implicitly treated as distributed proportionally to population of the aggregated language family between each county of a multi-county PUMA. For example, two distinct languages in the PUMS that are part of the same 12-way classification and known at a PUMA level where the PUMA countains multiple counties will be proportionally divided between the counties according to the county's share of total speakers of the languages in the 12-way classification.

Disability status is assessed only for the civilian noninstitutionalized population (excluding the population in institutional group quarters such as skilled nursing facilities whose disability status is not surveyed); therefore, sums across disability status will not sum to total population.

REALD race/ethnicity is imputed using language, place of birth, and other person-level characteristics, and then adjusted for consistency at the county level by OMB race/ethnicity only. REALD subgroups for White, Asian, or Black are implicitly treated as distributed proportionally to population across each county of a multi-county PUMA. REALD approaches are under ongoing development and results may not match totals published elsewhere.


# FUNDING ACKNOWLEDGEMENT
OHA IGA#179509 "County-level REALD population estimates"

# REFERENCES
1. Ruther M, Maclaurin G, Leyk S, Buttenfield B, Nagle N. 2013. “Validation of spatially allocated small area estimates for 1880 Census demography”. _Demographic Research_, 29(22):579–616. doi: 10.4054/DemRes.2013.29.22 [↑](#footnote-ref-1)
2. Mays VM, Ponce NA, Washington DL, Cochran SD. 2003. “Classification of race and ethnicity: implications for public health.” _Annu Rev Public Health_. 24:83-110. doi: 10.1146/annurev.publhealth.24.100901.140927 [↑](#footnote-ref-2)
