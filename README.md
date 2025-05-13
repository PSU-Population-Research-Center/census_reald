# Downloads
Downloads are currently available as Stata datasets only, where the file year refers to the final year of the 5-year ACS data release. Each dataset contains fields identifying the the estimate (b) and standard error of the estimate (se), as well as the geography (state and county [FIPS codes](https://www.census.gov/library/reference/code-lists/ansi.html#cou)) and the subpopulation for which the estimates are generated.

Population by age/sex: [2019](results/results_agesex_2019.dta) [2020](results/results_agesex_2020.dta) [2021](results/results_agesex_2021.dta) [2022](results/results_agesex_2022.dta) [2023](results/results_agesex_2023.dta)<br />
Population by age/sex and OMB race (ombrr): [2019](results/results_agesex_ombrr_2019.dta) [2020](results/results_agesex_ombrr_2020.dta) [2021](results/results_agesex_ombrr_2021.dta) [2022](results/results_agesex_ombrr_2022.dta) [2023](results/results_agesex_ombrr_2023.dta)<br />
Population by age/sex and REALD primary race (reldpri): [2019](results/results_agesex_reldpri_2019.dta) [2020](results/results_agesex_reldpri_2020.dta) [2021](results/results_agesex_reldpri_2021.dta) [2022](results/results_agesex_reldpri_2022.dta) [2023](results/results_agesex_reldpri_2023.dta)<br />
Population by Disability (disdi): [2019](results/results_disdi_2019.dta) [2020](results/results_disdi_2020.dta) [2021](results/results_disdi_2021.dta) [2022](results/results_disdi_2022.dta) [2023](results/results_disdi_2023.dta)<br />
Population by Disability, combined (da4): [2019](results/results_da4cat_2019.dta) [2020](results/results_da4cat_2020.dta) [2021](results/results_da4cat_2021.dta) [2022](results/results_da4cat_2022.dta) [2023](results/results_da4cat_2023.dta)<br />
Population by Disability, detailed (da7): [2019](results/results_da7compacsall_2019.dta) [2020](results/results_da7compacsall_2020.dta) [2021](results/results_da7compacsall_2021.dta) [2022](results/results_da7compacsall_2022.dta) [2023](results/results_da7compacsall_2023.dta)<br />
Population by Disability, sight (eye): [2019](results/results_deyeoicv2_2019.dta) [2020](results/results_deyeoicv2_2020.dta) [2021](results/results_deyeoicv2_2021.dta) [2022](results/results_deyeoicv2_2022.dta) [2023](results/results_deyeoicv2_2023.dta)<br />
Population by Disability, hearing (ear): [2019](results/results_dearoicv2_2019.dta) [2020](results/results_dearoicv2_2020.dta) [2021](results/results_dearoicv2_2021.dta) [2022](results/results_dearoicv2_2022.dta) [2023](results/results_dearoicv2_2023.dta)<br />
Population by Disability, self-care (drs): [2019](results/results_ddrsoicv2_2019.dta) [2020](results/results_ddrsoicv2_2020.dta) [2021](results/results_ddrsoicv2_2021.dta) [2022](results/results_ddrsoicv2_2022.dta) [2023](results/results_ddrsoicv2_2023.dta)<br />
Population by Disability, ambulatory (phy): [2019](results/results_dphyoicv2_2019.dta) [2020](results/results_dphyoicv2_2020.dta) [2021](results/results_dphyoicv2_2021.dta) [2022](results/results_dphyoicv2_2022.dta) [2023](results/results_dphyoicv2_2023.dta)<br />
Population by Disability, cognitive (rem): [2019](results/results_dremoicv2_2019.dta) [2020](results/results_dremoicv2_2020.dta) [2021](results/results_dremoicv2_2021.dta) [2022](results/results_dremoicv2_2022.dta) [2023](results/results_dremoicv2_2023.dta)<br />
Population by Disability, independent living (out): [2019](results/results_doutoicv2_2019.dta) [2020](results/results_doutoicv2_2020.dta) [2021](results/results_doutoicv2_2021.dta) [2022](results/results_doutoicv2_2022.dta) [2023](results/results_doutoicv2_2023.dta)<br />
Population by LEP and Language Spoken at Home (counties): [2019](results/results_lang_2019.dta) [2020](results/results_lang_2020.dta) [2021](results/results_lang_2021.dta) [2022](results/results_lang_2022.dta) [2023](results/results_lang_2023.dta)<br />
Population by LEP and Language Spoken at Home (state; additional age detail): [2019](results/results_langst_2019.dta) [2020](results/results_langst_2020.dta) [2021](results/results_langst_2021.dta) [2022](results/results_langst_2022.dta) [2023](results/results_langst_2023.dta)<br />

# Updates
- 2025-05-01: Updated REALD estimates datasets release (2019-2023). Improved estimates for county standard errors and addition of reliability metrics. Totals across all age groups are now included in each dataset.
- 2025-01-23: 5-year ACS PUMS for 2023 released.
- 2024-05-31: Initial REALD estimates datasets release (2019-2022).
- 2024-01-25: 5-year ACS PUMS for 2022 released.

# Data Usage and Suppression

Survey results are estimates of population values and always contain some error because they are based on samples. Confidence intervals are one tool for assessing the reliability, or precision, of survey estimates. Another tool for assessing reliability is the relative standard error (RSE) of an estimate. Estimates with large RSEs are considered less reliable than estimates with small RSEs.

The ACS is a survey, and the results are subject to sampling and nonsampling error. The Relative Standard Error (RSE) is one metric for assessing reliability based on the ratio of the SE to the estimate, and can be interpreted as a measure of reliability of individual estimates. Lower RSE indicates greater confidence in the estimates for a particular group, while high RSE indicates unreliable estimates (or estimates which are likely to be different in the underlying population than in the ACS sample). Following informal NCHS guidance, estimates are flagged as unreliable if their relative standard error exceeds 30%.<sup>[\[4\]](#footnote-4)</sup> We have additionally flagged estimates are highly unreliable if their RSE exceeds 0.5, indicating results that are indistinguishable from zero at the 95% confidence level (see [Notes](#footnote-notes)). 

Estimates can be combined arithemetically to derive totals or proportions across or within groups or geographies. Following US Census Bureau guidance, approximations of standard errors for combined sums/differences and proportions/percents can be done by: 
- The standard error of a sum or difference can be approximated by the square root of the sum of squared errors: $ \text{SE}(X_1 \pm X_2) = \sqrt{\text{SE}(X_1)^2 + \text{SE}(X_2)^2} $;
- The standard error of a percent or proportion, $ P = \frac{X}{Y} $ (where the numerator is a subset of the denominator), is approximated by:  $ \text{SE}(P) = \frac{1}{Y} \cdot \sqrt{\text{SE}(X)^2 - \frac{X^2}{Y^2} \cdot \text{SE}(Y)^2} $ (in cases where this formula provides a negative standard error, use the formula for the combined standard error of a ratio);
- The standard error of a ratio (where the numerator is \emph{not} a subset of the denominator) is approximated by: $ \text{SE}(P) = \frac{1}{Y} \cdot \sqrt{\text{SE}(X)^2 + \frac{X^2}{Y^2} \cdot \text{SE}(Y)^2} $; 
- The standard error of an estimate of percent change over time between time periods $ X $ and $ Y $ is approximated by: $ \text{SE}\left(\frac{X}{Y}\right) $.

Additional scenarios and issues are considered in ACS guidance provided by the US Census Bureau.<sup>[\[5\]](#footnote-5)</sup>

# Data and Methods
The ACS is a nationally representative sample of approximately 2% of the US resident population each year. Results of the ACS data are published as tables, aggregated into a variety of summary file releases such as subject tables, demographic profiles, detailed tables, and others. The ACS tables do not contain sufficient detail to count the population by [Oregon REALD](https://www.oregon.gov/oha/EI/Pages/REALD.aspx) characteristics. Therefore, the starting estimates for the population by REALD characteristics are imputed using the ACS PUMS, a microdata sample of individual ACS responses that contain additional demographic detail associated with REALD elements. 

The published ACS tables (e.g., at data.census.gov) differ from the PUMS in several respects: notably, the former are calculated from the 100% ACS sample (rather than the portion of the sample included in the PUMS), and are available for many geographical levels including individual census tracts and counties. The PUMS are based on approximately 50% of unit-level responses to the ACS, and subject to disclosure avoidance and other statistical adjustments that means totals do not always equal published data from the 100% ACS. In addition, PUMS are available only for PUMA geographies, corresponding to groups of census tracts that sum to 100,000 or more residents as of the last decennial census. ACS releases are currently published in two formats: as single-year samples for areas of 65,000 or more persons, weighted to the mid-year population, or in five-year aggregated samples for all areas, combining 5 cumulative years of ACS response data, and weighted to the mid-year population of the third year of the sample. In order to construct a more statistically reliable and consistent data series, REALD population estimates are based on the five-year PUMS samples. 

The REALD & SOGI unit of OHA developed coding heuristics which use the following ACS PUMS data fields in order to classify persons according to race, ethnicity, language, and disability status in a manner consistent with the REALD (pre-2024) definitions:

|     | **ACS PUMS variables** |     |     |     |     |
| --- | --- | --- | --- | --- | --- |
| ST  | State (FIPS code) | RACAIAN | Am. Ind. or AK Native race | LANP | Language spoken at home |
| PUMA | PUMA code (2010 or 2020 PUMAs) | RACASN | Asian race | ENG | Ability to speak English |
| PWGT | Person weight and replicate weights | RACBLK | Black or African American race | DIS | Recoded disability (Y/N) |
| SEX | Binary sex (Male/Female) | RACNH | Native Hawaiian race | DOUT | Independent living difficulty |
| AGEP | Age in years (mean-corrected topcoding 90+) | RACPI | Pacific Islander race | DPHY | Ambulatory difficulty |
| POBP | State or country of birth | RACSOR | Some other race | DREM | Cognitive difficulty |
| MIGSP | Movers during past year: state or country of origin | RACWHT | White race | DEYE | Vision difficulty |
| RELSHIPP | Relation to respondent | RACNUM | Number of races selected | DEAR | Hearing difficulty |
| ANC1P | Ancestry (first response) | RAC1P | Recoded detailed race code (9 values) | DDRS | Self-care difficulty |
| ANC2P | Ancestry (second response) | RAC2P | Recoded detailed race code (68 values) | HINS | Health insurance (multiple codes) |
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
- primary REALD race/ethnicity;<br />
- OMB single race (according to [Federal Register Doc No 97-28653](https://www.federalregister.gov/d/97-28653), and based on the rarest race heuristic<sup>[\[2\]](#footnote-2)</sup>);<br />
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

After the REALD characteristics are imputed from the available PUMS data fields, the records are segmented by PUMA, and the original data fields are used to impute new weights that accord to the small area constraining totals for each of the counties that constitute the multi-county PUMAs. The ACS PUMS includes replicate weights, which allow analysts to assess the statistical uncertainty in most types of tabulations generated from the PUMS. Replicate weights are converted from PUMA to county areas by assuming that the variability within each county sub-sample is equal, in which case errors are proportional to sample size.<sup>[\[3\]](#footnote-3)</sup>

# Languages

There are several special processing rules applied for language tabulations to address variable data quality and availability. Starting in 2016, the Census Bureau made several revisions to language coding and tabulation standards, including adoption of ISO-639-3 standard; a new list of 42 languages to be included in table B16001, and additional geographic restrictions for table B16001 for the 5-year sample to the national, state, MSA/CSA, CD, and PUMA levels. County/tracts must use the collapsed table C16001 with fewer individual languages that had 1 million or 
more speakers nationally in 2016. However, 2016+ versions of table B16001 have been published in the 1-year ACS releases for counties that met population size and other requirements. For example, the following OR county-year combinations have B16001 (2016+ version) data available:

|  | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Multnomah County | x | x |   | x |   | x | x | x |
| Washington County | x | x | x |   |   | x | x | x |

The starting dataset for the estimation of the number of speakers by language is the ACS PUMS. To generate county-level estimates, data for PUMAs that contain multiple counties were duplicated for each constituent county, and the ACS weights were adjusted such that the county population by age/sex and race/ethnicity were consistent with ACS county level tables B01001 and B01001A-I. For these counties, the PUMS detailed ISO language codes were linked to a language or language group from the published county tables, and then the weights representing the number of language speakers for each by LEP status were adjusted by weighting to the 2015 B16001 county level tabulation (with 32 unique values). In cases where the PUMS did not contain records for persons speaking a language that had a non-zero control total, characteristics were imputed based on a hotdeck from a pooled statewide sample of speakers of that language from a year in 2016 or later. 

For Multnomah and Washington counties, a synthetic estimate of speakers for the post-2016 language list (with 42 unique values) was generated by combining cumulative data on the number of speakers by LEP status for up to 5 years since 2016. This was introduced to reduce the adverse impact of sample variability in the 1-year ACS, while leveraging the larger sample size of ACS published tables to produce more accurate counts. The final raking step imposed consistency with the age and sex structure of the last 5-year ACS sample, as well as the county-level language speakers by LEP status from table C16001 (and in the case of all Oregon counties, also the B16001 statwide estimates according to the detailed language list by LEP status).

# Notes [↑](#footnote-notes)
- The reweighting process results in non-integer counts, and these have been left as is. They can be displayed as or rounded to whole counts (in which case, rounding errors will mean that totals may not sum exactly).<br />
- Language is assessed for the population age 5+ only; therefore, sums across languages will not sum to the total population.<br />
- Disability status is assessed only for the civilian noninstitutionalized population (excluding the population in institutional group quarters such as skilled nursing facilities whose disability status is not surveyed); therefore, sums across disability status will not sum to total population.<br />
- REALD race/ethnicity is imputed using language, place of birth, and other person-level characteristics, and then adjusted for consistency at the county level by OMB race/ethnicity only. REALD subgroups for White, Asian, or Black are implicitly treated as distributed proportionally to population across each county of a multi-county PUMA. REALD approaches are under ongoing development and results may not match totals published elsewhere.
- RAC2P values changed for the [2023 ACS](https://www.census.gov/programs-surveys/acs/microdata/documentation.html); for the purposes of consistency with prior ACS datasets, RAC2P23 codes were converted to corresponding RAC2P19 codes used in previous releases. Where no corresponding code was available, the RAC2P23 and RAC2P19 codes were collapsed to the most disaggregated common scheme possible between the two data sources. 
- Derivation of Relative Standard Error (RSE) thresholds for data reliability: the confidence interval for $\hat{\theta}$ is given by: $\hat{\theta} \pm z_{\alpha/2} \cdot \text{SE}$, where $\hat{\theta}$ represents the point estimate and $\text{SE}$ the standard error of  the estimate, and $z_{\alpha/2}$ is the critical value for the standard normal distribution corresponding to the desired confidence level. The lower bound of the confidence interval includes zero when: $\hat{\theta} - z_{\alpha/2} \cdot \text{SE} = 0$. Rearranging terms, we get $\frac{\text{SE}}{\hat{\theta}} = \frac{1}{z_{\frac{\alpha}{2}}} = \text{RSE}$. For 95\% confidence, $\alpha = 0.05, $z_{\alpha/2} \approx 1.96$. Thus, $\text{RSE} = \frac{1}{1.96} \approx 0.51$.

# Funding Acknowledgement
OHA IGA#179509 "County-level REALD population estimates"

# References
1. Ruther M, Maclaurin G, Leyk S, Buttenfield B, Nagle N. 2013. “Validation of spatially allocated small area estimates for 1880 Census demography”. _Demographic Research_, 29(22):579–616. doi: 10.4054/DemRes.2013.29.22 [↑](#footnote-ref-1)
2. Mays VM, Ponce NA, Washington DL, Cochran SD. 2003. “Classification of race and ethnicity: implications for public health.” _Annu Rev Public Health_. 24:83-110. doi: 10.1146/annurev.publhealth.24.100901.140927 [↑](#footnote-ref-2)
3. Fay RE, Herriot RA. 1979. "Estimates of Income for Small Places: An Application of James-Stein Procedures to Census Data." _Journal of the American Statistical Association_. 74(366):269-277. doi: 10.1080/01621459.1979.10482505 [↑](#footnote-ref-3)
4. Klein RJ, Proctor SE, Boudreault MA, Turczyn KM. 2002. "Healthy People 2010 criteria for data suppression." _Healthy People 2010 Stat Notes_. (24):1-12. PMID: 12117004. [↑](#footnote-ref-4)
5. US Census Bureau. 2020. "Worked Examples for Approximating Standard Errors Using American Community Survey Data". Online resource (https://www2.census.gov/programs-surveys/acs/tech_docs/accuracy/2020_ACS_Accuracy_Document_Worked_Examples.pdf) [↑](#footnote-ref-5) 
