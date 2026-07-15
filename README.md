# Oregon REALD County-Level Population Estimates

County-level population estimates by Race, Ethnicity, Language, and Disability (REALD) classification, produced by the Portland State University Population Research Center (PRC) in partnership with the Oregon Health Authority (OHA) and the Oregon Secretary of State.

## Table of Contents

- [About](#about)
- [Downloads](#downloads)
- [Updates](#updates)
- [Data Usage and Suppression](#data-usage-and-suppression)
- [REALD Imputation](#reald-imputation)
  - [Race/Ethnicity Classification and Primary Race](#raceethnicity-classification-and-primary-race)
  - [Disability](#disability)
  - [Languages and Limited English Proficiency (LEP)](#languages-and-limited-english-proficiency-lep)
- [County-Level Estimation](#county-level-estimation)
  - [ACS Data Availability and Geography](#acs-data-availability-and-geography)
  - [Small Area Estimation](#small-area-estimation)
- [Funding Acknowledgement](#funding-acknowledgement)
- [References](#references)

## About

Oregon House Bill 2134 (2013) directed the Oregon Health Authority (OHA) and Department of Human Services (DHS) to adopt uniform standards for the collection of race, ethnicity, preferred language, and disability data. Following a community-led advisory and rulemaking process, the initial Race, Ethnicity, Language, and Disability (REALD) standards were finalized and adopted in 2014.

To support these efforts, the Portland State University Population Research Center (PRC) partnered with the Oregon Health Authority's REALD & SOGI Unit within the Equity & Inclusion Division and the Oregon Secretary of State to produce county-level population estimates by REALD classification. The estimates are derived from the American Community Survey (ACS), a nationally representative survey of approximately two percent of the U.S. population annually, combined with published ACS tabulations and small-area estimation methods. The goal of the collaboration is to produce the best available approximations of population data in REALD categories to be used for planning purposes, including as denominators in calculations of shares or rates.

Since the initial 2014 release, the REALD standard has undergone several [updates](https://www.oregon.gov/oha/EI/Reports/REALDSOGILegislativeReport_2024.pdf). Reporting categories for race/ethnicity were expanded in 2020, and again in 2024. The county-level estimates presented here have been updated to reflect the current generation of the REALD framework in place since July 2024 ([EID 2-2024](https://secure.sos.state.or.us/oard/view.action?ruleNumber=950-030-0030)). Data releases from ACS samples during 2019–2023 are available according to the deprecated "REALD20" standards; however, users should be aware that changes to classification rules, coding structures, and reporting categories may affect comparisons between releases, even for categories that did not change under EID 2-2024.

## Downloads

Releases are published as Stata-formatted datasets. Release tags follow the pattern `{acs-end-year}-reald{standard-year}-v{revision}` — for example, `acs5-2023-reald24-v01` is the ACS 5-year sample ending in 2023, classified under the REALD24 standard, first published revision. When a vintage is revised (see [Updates](#updates)), a new release is published under the same release tag with a new version suffix `-v{revision}`.

| Release | ACS 5-Year Period | REALD Standard | Download |
|---|---|---|---|
| `acs5-2024-reald24-v02` | 2020–2024 | REALD24 *(current)* | [.zip](https://github.com/PSU-Population-Research-Center/census_reald/releases/tag/acs5-2024-reald24) |
| `acs5-2023-reald24-v02` | 2019–2023 | REALD24 *(current)* | [.zip](https://github.com/PSU-Population-Research-Center/census_reald/releases/tag/acs5-2023-reald24) |
| `acs5-2023-reald20-v02` | 2019–2023 | REALD20 *(deprecated)* | [.zip](https://github.com/PSU-Population-Research-Center/census_reald/releases/tag/acs5-2023-reald20) |
| `acs5-2022-reald20-v02` | 2018–2022 | REALD20 *(deprecated)* | [.zip](https://github.com/PSU-Population-Research-Center/census_reald/releases/tag/acs5-2022-reald20) |
| `acs5-2021-reald20-v02` | 2017–2021 | REALD20 *(deprecated)* | [.zip](https://github.com/PSU-Population-Research-Center/census_reald/releases/tag/acs5-2021-reald20) |
| `acs5-2020-reald20-v02` | 2016–2020 | REALD20 *(deprecated)* | [.zip](https://github.com/PSU-Population-Research-Center/census_reald/releases/tag/acs5-2020-reald20) |
| `acs5-2019-reald20-v02` | 2015–2019 | REALD20 *(deprecated)* | [.zip](https://github.com/PSU-Population-Research-Center/census_reald/releases/tag/acs5-2019-reald20) |

> Note that `acs5-2023-reald20-v01` and `acs5_2023-reald24-v01` cover the same underlying ACS sample (2019–2023) but classify race/ethnicity, language, and disability according to two different REALD standard vintages — see [REALD Imputation](#reald-imputation). They are not duplicates and are not interchangeable.

Each release contains a set of datasets based on one ACS 5-year PUMS, with fields identifying the estimate (`b`) and standard error of the estimate (`se`), and derived relative standard error (`rse`). Counties are identified by ([FIPS code](https://www.census.gov/library/reference/code-lists/ansi.html#cou)). Datasets are labeled with additional metadata (metadata is preserved when reading in R using the package 'readstata13'). 

<details>
<summary>Datasets contained in each Release</summary>

| File | Population |
|---|---|
| `results_agesex_YYYY.dta` | Age and sex |
| `results_agesex_ombrr_YYYY.dta` | Age and sex and OMB primary race (`ombrr`) |
| `results_agesex_reldpri_YYYY.dta` | Age and sex and REALD primary race (`reldpri`) |
| `results_disdi_YYYY.dta` | Disability status (`disdi`) |
| `results_da4cat_YYYY.dta` | Disability, combined (`da4`) |
| `results_dac7compacsall_YYYY.dta` | Disability, detailed (`da7`) |
| `results_deyeoicv2_YYYY.dta` | Disability, sight (`eye`) |
| `results_dearoicv2_YYYY.dta` | Disability, hearing (`ear`) |
| `results_ddrsoicv2_YYYY.dta` | Disability, self-care (`drs`) |
| `results_dphyoicv2_YYYY.dta` | Disability, ambulatory (`phy`) |
| `results_dremoicv2_YYYY.dta` | Disability, cognitive (`rem`) |
| `results_doutoicv2_YYYY.dta` | Disability, independent living (`out`) |
| `results_lang_YYYY.dta` | LEP/Language spoken at home (`langoha') |
| `results_langst_YYYY.dta` | LEP/Language (state-level; additional age groups) |

</details>

## Updates

<small>
| Date | Description |
|---|---|
| 2026-07-15 | Updated REALD24 estimates datasets v02 releases (2023-2024). Added special handling of LatAfr and new control totals for some categories. |
| 2026-06-30 | New implementation and v01 releases for REALD 2024 standards (2023-2024). |
| 2025-05-01 | Updated REALD20 estimates datasets v02 releases (2019-2023). Improved estimates for county standard errors and addition of reliability metrics. Totals across all age groups are now included in each dataset. |
| 2024-05-31 | Initial REALD20 estimates datasets v01 releases (2019-2022). |
</small>

## Data Usage and Suppression

Survey results are estimates of population values and always contain some error because they are based on samples. Confidence intervals are one tool for assessing the reliability, or precision, of survey estimates. Another tool for assessing reliability is the relative standard error (RSE) of an estimate. Estimates with large RSEs are considered less reliable than estimates with small RSEs.

The ACS is a survey, and the results are subject to sampling and nonsampling error. The Relative Standard Error (RSE) is one metric for assessing reliability based on the ratio of the SE to the estimate, and can be interpreted as a measure of reliability of individual estimates. Lower RSE indicates greater confidence in the estimates for a particular group, while high RSE indicates unreliable estimates (or estimates which are likely to be different in the underlying population than in the ACS sample). Following informal NCHS guidance, estimates are flagged as unreliable if their relative standard error exceeds 30%[^1]. We have additionally flagged estimates as highly unreliable if their RSE exceeds 0.5, indicating results that are indistinguishable from zero at the 95% confidence level.

<details>
<summary>Derivation of the 0.5 RSE threshold</summary>

For a point estimate $\theta$ with standard error $\mathrm{SE}$, the two-sided confidence interval at the desired confidence level is $\theta \pm \mathrm{SE} \cdot z_{\alpha/2}$, where $z_{\alpha/2}$ is the critical value of the standard normal distribution corresponding to the desired confidence level. The lower bound of this interval reaches zero when $\theta - \mathrm{SE} \cdot z_{\alpha/2} = 0$. Solving for the ratio of $\mathrm{SE}$ to $\theta$ — which is the definition of RSE — gives $\mathrm{RSE} = \mathrm{SE}/\theta = 1/z_{\alpha/2}$. At the 95% confidence level, $\alpha = 0.05$ and $z_{\alpha/2} \approx 1.96$, so $\mathrm{RSE} = 1/1.96 \approx 0.51$.

This is the RSE at which an estimate's 95% confidence interval would just reach zero — i.e., the point where the estimate becomes statistically indistinguishable from zero at that confidence level.

</details>

Estimates can be combined arithmetically to derive totals or proportions across or within groups or geographies. Following US Census Bureau guidance, approximations of standard errors for combined sums/differences and proportions/percents can be approximated by the following methods[^2]:

- The standard error of a sum or difference:

$$\mathrm{SE}(X_1 \pm X_2)=\sqrt{\mathrm{SE}(X_1)^2+\mathrm{SE}(X_2)^2}$$

- The standard error of a percent or proportion P = X/Y (where the numerator is a subset of the denominator):

$$\mathrm{SE}(P)=\frac{1}{Y}\sqrt{\mathrm{SE}(X)^2-\frac{X^2}{Y^2}\mathrm{SE}(Y)^2}$$

- In cases where this formula provides a negative standard error, or for the standard error of a ratio P = X/Y (where the numerator is not a subset of the denominator):

$$\mathrm{SE}(P)=\frac{1}{Y}\sqrt{\mathrm{SE}(X)^2+\frac{X^2}{Y^2}\mathrm{SE}(Y)^2}$$

## REALD Imputation

The ACS survey population is classified according to Oregon REALD standards using detailed demographic and health characteristics available in the PUMS that closest approximate REALD items. The following sections describe the process for imputation of each item: race/ethnicity, language, and disability.

### Race/Ethnicity Classification and Primary Race

The ACS itself contains insufficient detail to characterize Oregon's population directly according to REALD race/ethnicity categories (OAR 950-030-0030). Instead, REALD subpopulation sizes are estimated by identifying ACS PUMS respondents who may belong to one or more REALD groups, and imputing their REALD status. Assignment is based on a combination of the following ACS PUMS variables:

- **ANC1P, ANC2P:** ancestry
- **HISP:** detailed Hispanic ethnicity
- **RAC1P, RACAIAN, RACASN, RACBLK, RACNH, RACPI, RACSOR, RACWHT:** OMB (federal) race classifications
- **RAC2P, RAC3P:** detailed race classifications
- **POBP:** place of birth
- **LANP:** language spoken at home (available only for respondents age 5 years and older)

Assignment criteria for race/ethnicity were updated in 2026 during joint review sessions with PRC and OHA teams. The criteria are intended to predict how a person in the ACS would have identified if presented with a REALD questionnaire. A full description of classification algorithms applied is available in accompanying [methodology documentation](docs/2026_reald_guidelines_PRC_PSU.pdf). 

Because respondents may meet criteria for multiple REALD groups, each individual is subsequently assigned a single primary federal ([OMB](https://www.federalregister.gov/d/97-28653)) and state (REALD) category. Primary race/ethnicity assignment uses a **rarest race procedure** designed to maximize representation of smaller populations[^3]:

1. For each major REALD category (Asian, American Indian/Alaska Native, Middle Eastern/North African, African/Black, Latin, Pacific Islander, and European/White), calculate the weighted number of respondents identifying with at least one REALD group in that category using the ACS person weight (`PWGTP`).
2. Rank the major REALD categories from the smallest weighted population to the largest.
3. Within the rarest major category, rank all constituent REALD groups from rarest to most common according to their weighted population size.
4. Beginning with the rarest REALD group, assign that group as the primary REALD for all individuals belonging to the group. Those individuals are then removed from all remaining group counts.

Step 4 is repeated until all groups within the category have been assigned. The procedure then continues with the next rarest major REALD category and repeats until all specified categories have been processed. After all categories have been evaluated, any remaining individuals are assigned to **Other/Unassigned**. This category primarily consists of respondents whose OMB race classification is "Some Other Race alone" and who do not meet criteria for another REALD group.

Following completion of the rarest race procedure, special treatment is applied for individuals with Latin-African ancestry characteristics. Approximately 8 percent of these individuals are reassigned to the **Latin-African** primary REALD category. Without this adjustment, the sequential assignment process would result in few or no respondents receiving a Latin-African primary REALD designation. The 8 percent reassignment rate is derived from internal Oregon Health Authority data.

### Disability

The items available or derivable from the ACS do not fully cover all of the items and populations covered by the current REALD disability data collection standard (OAR 950-030-0050). The current ACS instrument to collect disability status was introduced in 2008, and collects six items to assess disability among the non-institutionalized population, according to the age of the respondent. Respondents who report one or more of the following six disability types are considered to have a disability:

| Item | Description | Screening |
|---|---|---|
| Hearing (`ear`) | Deaf or having serious difficulty hearing | All ages |
| Vision (`eye`) | Blind or having serious difficulty seeing, even when wearing glasses | All ages |
| Cognitive (`rem`) | Physical, mental, or emotional problem that causes difficulty remembering, concentrating, or making decisions | Ages 5+ |
| Ambulatory (`phy`) | Serious difficulty walking or climbing stairs | Ages 5+ |
| Self-care (`drs`) | Difficulty bathing or dressing | Ages 5+ |
| Independent living (`out`) | Physical, mental, or emotional problem that causes difficulty doing errands alone such as visiting a doctor's office or shopping | Ages 18+ |

Several additional indicators are provided that capture the total population with any disability and categorical indicators for persons with one or multiple disabilities (`da4cat`, `da7cat`).

Disability status in the ACS is assessed only for the civilian noninstitutionalized population (therefore, excluding the population in institutional group quarters such as skilled nursing facilities); therefore totals by disability status will not sum to the total population. The [CDC PLACES](https://www.cdc.gov/places/) program offers modeled data based on the ACS with coverage of additional populations not directly surveyed.

### Languages and Limited English Proficiency (LEP)

The current REALD language standard includes some items that are not derivable from the ACS (e.g., use of sign language or preferred language), and others that have analogous concepts, although not identical (English proficiency and language used at home). To estimate the population by limited English proficiency (LEP) status and language spoken at home, the detailed language codes used in the ACS PUMS were identified according to their corresponding [ISO-639-3](https://iso639-3.sil.org/code_tables/639/data) language code, per the current REALD implementation rules (OAR 950-030-0040).

There are several special processing rules applied for language tabulations to address changes in data availability and coding over time in the ACS. Starting in 2016, the Census Bureau made several revisions to language coding and tabulation standards, including adoption of the ISO-639-3 standard; a new list of 42 languages to be included in table B16001; and additional geographic restrictions for table B16001 for the 5-year sample to the national, state, MSA/CSA, CD, and PUMA levels. After these changes, county/tract control totals must come from table C16001, which contains fewer individual languages — only those meeting the threshold of 1 million or more speakers nationally in 2016. In some cases, new versions of table B16001 have been published in the 1-year ACS releases for counties that met population size and other requirements. For example, the following OR county-year combinations have B16001 (2016+ version) data available:

| County | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Multnomah County | x | x | | x | | x | x | x | |
| Washington County | x | x | x | | | x | x | x | x |

For Multnomah and Washington counties only, a synthetic estimate of speakers for the post-2016 language list (with 42 unique values) was generated by combining cumulative data on the number of speakers by LEP status for up to 5 years since 2016. This was introduced to reduce the adverse impact of sample variability in the 1-year ACS, while leveraging the larger sample size of ACS published tables to produce more accurate counts.

In some cases, the ACS PUMS language code describes a group of languages that could not be further disaggregated in the data, or a residual of a collective language minus specified ISO-639 languages; in these cases, a non-standard 3-letter code was used, in the reserved range `qaa`–`qtz`.

Language is assessed for the population age 5+ only; therefore, sums across languages will not sum to the total population.

## County-Level Estimation

ACS PUMS data are available only for [PUMA geographies](https://www.census.gov/programs-surveys/geography/guidance/geo-areas/pumas.html), corresponding to groups of census tracts that sum to 100,000 or more residents as of the last decennial census. A US county is also represented by 1 or more census tracts. The following sections describe the process used for generating county-level estimates from PUMA level data.

### ACS Data Availability and Geography

ACS releases are currently published in two formats: as single-year samples for areas of 65,000 or more persons, weighted to the mid-year population; or in five-year aggregated samples for all areas, combining 5 cumulative years of ACS response data and weighted to the mid-year population of the third year of the sample. In order to construct a more statistically reliable and consistent data series, REALD population estimates are based on the five-year PUMS samples.

Because of the 100,000 persons minimum threshold, PUMAs may be larger or smaller than counties, and may contain only a part of a county when that county contains more than one tract. PUMA geographies also change after the most recent census, and so a 5-year sample may contain multiple sets of PUMA codes for parts of the 5-year window that occurred on either side of a change in PUMA codes. For this project, a consistent grouping was developed which delineates 13 areas consisting of one or more counties in Oregon (plus Clark County, WA) across the 2010 and 2020 PUMA definitions:

| Combined Code (2012–2031) | Counties |
|---|---|
| 1 | Baker, Grant, Gilliam, Hood River, Morrow, Sherman, Umatilla, Union, Wasco, Wallowa, Wheeler, Crook, Jefferson, Deschutes |
| 2 | Harney, Klamath, Lake, Malheur |
| 3 | Polk, Yamhill, Lincoln, Clatsop, Columbia, Tillamook |
| 4 | Benton, Linn |
| 5 | Lane |
| 6 | Coos, Curry, Josephine |
| 7 | Jackson |
| 8 | Douglas |
| 9 | Marion |
| 10 | Multnomah |
| 11 | Clackamas |
| 12 | Washington |
| 13 | Clark (WA) |

These areas represent the minimum groups of counties that can be identified when data are used from the respective ACS samples.

<details>
<summary>2010 and 2020 Census PUMA groupings (component detail)</summary>

| 2010 Census (2012–2021) | 2020 Census (2022–2031) |
|---|---|
| 1: Baker, Umatilla, Union, Wallowa | 1: Baker, Grant, Gilliam, Hood River, Morrow, Sherman, Umatilla, Union, Wasco, Wallowa, Wheeler |
| 2: Crook, Gilliam, Grant, Hood River, Jefferson, Morrow, Sherman, Wasco, Wheeler | 2: Crook, Jefferson, Deschutes |
| 3: Harney, Klamath, Lake, Malheur | 3: Harney, Klamath, Lake, Malheur |
| 4: Deschutes | 4: Yamhill |
| 5: Clatsop, Columbia, Lincoln, Tillamook | 5: Clatsop, Columbia, Tillamook |
| 6: Polk, Yamhill | 6: Polk, Lincoln |
| 7: Benton, Linn | 7: Benton, Linn |
| 8: Lane | 8: Lane |
| 9: Coos, Curry, Josephine | 9: Coos, Curry, Josephine |
| 10: Jackson | 10: Jackson |
| 11: Douglas | 11: Douglas |
| 12: Marion | 12: Marion |
| 13: Multnomah | 13: Multnomah |
| 14: Clackamas | 14: Clackamas |
| 15: Washington | 15: Washington |
| 16: Clark (WA) | 16: Clark (WA) |

</details>

### Small Area Estimation

Individual county datasets were created for each member of a multi-county PUMA under the combined codes schema for 13 county or county groups. For each county, ACS PUMS records are reweighted to reproduce published ACS county-level control totals for age, sex, race/ethnicity, language, and disability characteristics. 

The reweighting approach is based on spatial microsimulation and iterative proportional fitting (IPF, or raking) methods widely used for small-area estimation from census microdata[^5]. Each PUMS record includes an associated weight that is adjusted such that the sum of weights corresponds to an independently published total ("constraint", or "control"). IPF is a strategy to calibrate one set of weights to match multiple constraints. The approach relies on the use of numerous external constraints which guide the allocation of data from the PUMA to the tract or county level, selected on the basis of their relationship as a valid proxy for  traits in the PUMS and which have a high degree of variation between counties within the same PUMA. The approach ensures consistency with ACS published tables based on 100% sample data from the same 5-year survey period as the PUMS, while preserving the underlying relationships of the person records in the PUMS microdata[^6].

<details>
<summary>ACS tables used as county population controls</summary>

- [B01001](https://censusreporter.org/tables/B01001/)+: Sex by Age
- [B02003](https://censusreporter.org/tables/B02003/): Detailed Race
- [B02014](https://censusreporter.org/tables/B02014/): American Indian and Alaska Native Alone for Selected Tribal Groupings
- [B02015](https://censusreporter.org/tables/B02015/): Asian Alone by Selected Groups
- [B02016](https://censusreporter.org/tables/B02016/): Native Hawaiian and Other Pacific Islander Alone by Selected Groups
- [B03001](https://censusreporter.org/tables/B03001/): Hispanic or Latino Origin by Specific Origin
- [B03002](https://censusreporter.org/tables/B03002/): Hispanic or Latino Origin by Race
- [B05013](https://censusreporter.org/tables/B05013/): Sex by Age for the Foreign-born Population
- [B16001](https://censusreporter.org/tables/B16001/): Language Spoken at Home by Ability to Speak English
- [B16004](https://censusreporter.org/tables/B16004/): Age by Language Spoken at Home by Ability to Speak English
- [B16005](https://censusreporter.org/tables/B16005/)+: Nativity by Language Spoken at Home by Ability to Speak English
- [B18101](https://censusreporter.org/tables/B18101/)+: Sex by Age by Disability Status
- [B18102](https://censusreporter.org/tables/B18102/): Sex by Age by Hearing Difficulty
- [B18103](https://censusreporter.org/tables/B18103/): Sex by Age by Vision Difficulty
- [B18104](https://censusreporter.org/tables/B18104/): Sex by Age by Cognitive Difficulty
- [B18105](https://censusreporter.org/tables/B18105/): Sex by Age by Ambulatory Difficulty
- [B18106](https://censusreporter.org/tables/B18106/): Sex by Age by Self-care Difficulty
- [B18107](https://censusreporter.org/tables/B18107/): Sex by Age by Independent Living Difficulty

> `+` indicates that table iterations are available by OMB race/ethnicity.

</details>

IPF can only redistribute weight among records that already exist in the PUMA-level PUMS sample. This creates a problem when a county's published control total says a characteristic is present (for example, a small number of speakers of a particular language) but, by chance, no PUMS respondent in that PUMA happens to have that characteristic. These cases are known as "structural zeros"; IPF alone cannot satisfy a nonzero control total from a pool of zero matching records. To resolve this, hot deck imputation was used as a seeding mechanism: a small number of matching donor records were pulled in from a larger reference pool (all Oregon PUMS records collected in the preceding 10 years) and added to the county's PUMS extract with a minimal starting weight. This lets the raking alrogithm satisfy every constraint without inventing implausible combinations of traits just to match control totals[^5] [^6]. The reweighting process results in non-integer counts, and these have been left untouched; they can be displayed or rounded to whole number population counts, in which case rounding error means that totals may not sum exactly.

The ACS PUMS includes replicate weights that capture the sensitivity of estimates to sampling variability and are the basis of calculated margins of error. In this project, those replicate weights are converted from PUMA to county areas by assuming that the variability within each county sub-sample is equal, in which case errors are proportional to sample size[^7]; the resulting standard errors are the `se` values reported alongside each estimate (`b`) in the released datasets (see [Downloads](#downloads)) and are the basis for the RSE reliability flags described above (see [Data Usage and Suppression](#data-usage-and-suppression)).

## Funding Acknowledgement

- OHA IGA #179509, "County-level REALD population estimates"
- Oregon Secretary of State IGA #16500-00006522, "Census and demographic data for ORS 251.167 language access"

## References

[^1]: Klein RJ, Proctor SE, Boudreault MA, Turczyn KM. 2002. "Healthy People 2010 criteria for data suppression." *Healthy People 2010 Stat Notes.* (24):1-12. PMID: [12117004](https://pubmed.ncbi.nlm.nih.gov/12117004/).

[^2]: US Census Bureau. 2020. "Worked Examples for Approximating Standard Errors Using American Community Survey Data." [Online resource](https://www2.census.gov/programs-surveys/acs/tech_docs/accuracy/2020_ACS_Accuracy_Document_Worked_Examples.pdf).

[^3]: Mays VM, Ponce NA, Washington DL, Cochran SD. 2003. "Classification of race and ethnicity: implications for public health." *Annu Rev Public Health.* 24:83-110. doi: [10.1146/annurev.publhealth.24.100901.140927](https://doi.org/10.1146/annurev.publhealth.24.100901.140927).

[^4]: Beckman RJ, Baggerly KA, McKay MD. 1996. "Creating synthetic baseline populations." *Transportation Research Part A: Policy and Practice.* 30(6):415-429. doi: [10.1016/0965-8564(96)00004-3](https://doi.org/10.1016/0965-8564(96)00004-3).

[^5]: Lovelace R, Birkin M, Ballas D, Van Leeuwen E. 2015. "Evaluating the performance of iterative proportional fitting for spatial microsimulation: New tests for an established technique." *Journal of Artificial Societies and Social Simulation.* 18(2):21. doi: [10.18564/jasss.2768](https://doi.org/10.18564/jasss.2768).

[^6]: de Waal T, Coutinho W, Shlomo N. 2017. "Calibrated Hot Deck Imputation for Numerical Data Under Edit Restrictions." *Journal of Survey Statistics and Methodology.* 5(3):372-397. doi: [10.1093/jssam/smw037](https://doi.org/10.1093/jssam/smw037).

[^7]: Fay RE, Herriot RA. 1979. "Estimates of Income for Small Places: An Application of James-Stein Procedures to Census Data." *Journal of the American Statistical Association.* 74(366):269-277. doi: [10.1080/01621459.1979.10482505](https://doi.org/10.1080/01621459.1979.10482505).
