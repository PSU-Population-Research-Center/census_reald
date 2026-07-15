// title: jet.do
// purpose: impute Jewish ethnicity status in ACS PUMS via PU learning model and county control totals
// author: sharygin@pdx.edu
/* notes
   . v15: update to use new ajpp annual county-level totals (2020-24)
   . v14: rewrite of jet_v13.r in Stata (original code, has some bugs)
   . outputs file jet_5acsYY.dta, with state/serialno/sporder/ethgrpi for merge to ACS PUMS.
   . Requires the user-written `censusapi` package and CURL in %PATH%
   . Requires a Census API key in textfile _censuskey.txt
   . Requires the following data:
        jet/portland-jcs-2023-public-dataset-071823.zip (Brandeis JCS)
		jet/2020_County.xlsx (appendix to AJYB via Berman Jewish DataBank)
todo:
   . revise so that the entire program can run 2 years in sequence, or using a `year' argument
   . consider ways that AJPP control totals may change after 2020, to use `year' argument effectively.
   . realize that you have disturbed the original values of pwgtp, and consider the implications
*/

// setup
cd "c:/users/sharygin/desktop/prc_reldpri24_5ACS23" // I:/_PROJECTS/_OHA_REALD24_ACS/Research/Shares/population_research/
cap file close ckey
file open ckey using _censuskey.txt, read text
file read ckey ckey
global ckey "`ckey'"
global preds "agecat8 educat5 hhicat5 racerc_white racerc_hisp fpl250 forborn lanp_ru lanp_en"
cd jet

// explore Pew -- not used in PU-learning
// all USA.
* screener contains basic info on all adults in hhds, including non-jewish
* extended contains good details about jewish adults, but only for 1 respondent per hhd
* household contains data on all hhd members, including children
cap prog drop pewinfo
prog def pewinfo
	unzipfile "Pew_Jewish_Americans_2020_Datasets_v2.zip", replace ifilter("Jewish Americans in 2020 (Household|Extended) Dataset\.dta")
	use QKEY ETHGRP INCOMEMOD WORKFOR CITIZENMOD EDUC4CAT EXTWEIGHT using "Jewish Americans in 2020 Extended Dataset.dta", clear
	rename _all, lower
	gen byte person_id_fin = 1 // identify as the respondent
	tabulate ethgrp   // 2/3 identify as ashkenazi, 1/3 as other (small % sephardi)
	tempfile ext
	save `ext'
	use QKEY PERSON_ID_FIN AGE SEX RACETHN HHWEIGHT JEWISHCAT JEWISHCATCHILD using "Jewish Americans in 2020 Household Dataset.dta", clear
	rename _all, lower
	cap destring hh_pers_type, replace
	rename age age4cat
	merge 1:1 qkey person_id_fin using `ext', assert(1 3)
	keep if inlist(jewishcat,1,2,3,4) | inlist(jewishcatchild,1,2,3)  // keep jewish (adult|child)
	keep if inrange(racethn,1,4)                                      // nonmissing race
	keep if inrange(age4cat,1,5)                                      // nonmissing age
	gen ethrc=ethgrp						 // collapsed recode
	replace ethrc=3 if inrange(ethgrp,3,8)   // recode all others as mizrahi/other
	replace ethrc=3 if inrange(ethgrp,90,98) // recode convert/unsure as other
	replace ethrc=. if ethgrp==99 // drop if refused specific jewish identity
	bysort qkey (ethrc): replace ethrc=ethrc[1] if missing(ethgrp) // carryforward ethgrp of respondent to rest of hhd.
	bysort qkey (incomemod): replace incomemod=incomemod[1] if missing(incomemod) // carryforwrd income of respondent to rest of hhd.
	*keep if inrange(incomemod,1,12)   // nonmissing income
	lab def ethrc 1 "Ashkenazi" 2 "Sephardi" 3 "Mizrahi/Other"
	label values ethrc ethrc
	tab1 ethgrp ethrc if ethgrp<99 // 73% ashkenazim, 3% sephardim, 24% other/none ~ mostly 'just jewish'/'not sure' (<1% Mizrahi)
	for any "Extended" "Household": rm "Jewish Americans in 2020 X Dataset.dta"
end
* pewinfo

// Brandeis: source data for PU-learning
// sample: (1) Portland ~ screener, respondent, adult roster, child roster; excludes screened non-Jewish households.
* == RESPONDENTS == 
* token ~ PID
* x_RESPGENDER 1/m 2/f 3/nb 4/oth
* RESPAGE5CAT 1/1834 2/3549 3/5064 4/6574 5/75+
* RESPEDU 2/hsg 3/aa 4/ba 5/grad 6/oth
* RESPHISP 0/no 1/yes
* RESPRACEWHITE RESPRACEBLACK RESPRACEASIAN RESPRACEAIAN RESPRACENHPI RESPRACEOTHER 0/no 1/yes
* RESPRUS 0/no 1/yes russian speaking
* RESPISPAR 0/no 1/yes parent
* X_LOCRSD raised in 1/pdx 2/usa 3/row
* X_FPL hhd is at or below 250% fpl 0/no 1/yes
* (if RJEWISH==1) RESPHERGASH RESPHERGSEP RESPHERGMIZ RESPHERGOTH RESPHERGNONE RESPHERGDK 0/1
* RESPISR Israeli citizen 0/1
* HLDISANY 0/1 HLINS 0/1
* WBINC hhd income 1/<50 2/50-74 3/75-99 4/100-149 5/150-199 6/200+ 77/dk 97/refuse -99/skip
* WBAIDINC pubasst 0/1
* WBAIDFOOD snap 0/1
* == ADULT ROSTER == ~ all adults 18+ in hhd
* other adults asked whether Jewish at all, but not about Ashkenazi/Sephardi/Mizrahi. impute same as respondent.
* HHADNUM n of adults 18+ in hhd 1-5
* HHADRLT2 relp 
* HHADAGE2_CAT 1/1834 2/3549 3/5064 4/6574 5/75+
* HHADEDU2 1/hsg 2/aa 3/ba 4/grad 5/other
* HHADRELIG2 1=JEWISH 11=MULTIPLE (HHADRLMJ2=1 IF Jewish in combination)	
* HHADCONS2 is this person not religious jewish, but otherwise jewish (ethnic/culture/family)?
* HHADHISP 0/no 1/yes
* HHRACESAME 0/no 1/yes
* if HHSRACESAME=0, HHADRACEWHITE2 HHADRACEBLACK2 HHADRACEASIAN2 HHADRACEAIAN2 HHADRACENHPI2 HHADRACEOTH2
* == Child Roster == ~ all children <18 in hhd
* children asked age, race, religion, but not Ashkenazi/Sephardi/Mizrahi. impute same as respondent.
* HHRACESAME all persons in hhd same race as respondent
* HHCHNUM n children <18 in household 0-10
* HHCHAGE3CAT1 1/05 2/612 3/1317
* HHCHRELIG1 1/2=jewish HHCHRLGSAME==1 if all children same answer
* hhchracewhite1 hhchraceblack1 hhchraceasian1 hhchraceaian1 hhchracenhpi1 hhchraceoth1 hhchhips1
* hhchage2 hhchrelig2 hhchracewhite2 hhchraceblack2 hhchraceasian2 hhchraceaian2 hhchracenhpi2 hhchraceoth2 hhchhips2
cap prog drop jetrain
prog def jetrain
	// use Portland metro Brandeis survey
	unzipfile "portland-jcs-2023-public-dataset-071823.zip", replace ifilter("cmjs-portland-public-datafile\.dta")
	// first, jewish primary respondents
	use token wt_primhh wt_primresp wt_fullhh wt_fullresp ///
		x_respage5cat 	x_resphisp x_respracewhite x_respracenonwhite ///
		x_resprus x_locrsd x_respedu wbinc x_fplpoor x_respmarital ///
		resphergash x_resphergoth resphergnone resphergdk ///
		x_respjewish if x_respjewish==1 using "cmjs-portland-public-datafile.dta", clear
	* language
	gen byte lanp_ru=.
	replace lanp_ru=0 if x_resprus==0
	replace lanp_ru=1 if x_resprus==1
	gen byte lanp_en=.
	replace lanp_en=1 if x_resprus==0
	replace lanp_en=0 if x_resprus==1
	* forborn
	gen byte forborn=.
	replace forborn=0 if inlist(x_locrsd,1,2)
	replace forborn=1 if x_locrsd==3 
	* OMB races
	gen racerc_white=(x_respracenonwhite==0) // white unless selected a race other than white (4%)
	gen racerc_hisp=(x_resphisp==1) // hispanic if selected hispanic (2%)
	* agecat8
	ren x_respage5cat agecat8
	replace agecat8=agecat8+3 // make room for child age group codes 1--3
	* educat5
	ren x_respedu educat5
	replace educat5=. if !inrange(educat5,2,5)
	* hhinc
	ren wbinc hhicat5
	replace hhicat5=. if !inrange(hhicat5,1,6)
	ren x_fplpoor fpl250
	* jewish ID
	gen byte ethgrp=.
	replace ethgrp=1 if resphergash==1        // ashkenazi
	replace ethgrp=2 if x_resphergoth==1      // sephardi/mizrahi (Sephardi, Mizrahi, other specified)
	replace ethgrp=3 if resphergdk==1 | resphergnone==1   // don't know/none -> treat as true other.
	** censored individual sephardi/mizrahi breakdown, responses; per documentation:
	** 1493 total = 1207 ashkenazi, 114 sephardi, 15 mizrahi, 8 other, 109 none, 40 don't know; (114/(114+15+8)=83% of ethgrp==2)
	** 80% Ashkenazi 8% Sephardi 12% Other (total sample) -> 78% Ashkenazi/9% Sephardi~Other/13% Other (filtered microdata sample)
	keep if lanp_ru<. & lanp_en<. & forborn<. & hhicat5<8 & educat5<5 & agecat8<. & racerc_white<. & racerc_hisp<.
	keep if ethgrp<. 
	tab ethgrp
	gen byte pnum=1 // reuse token as hhid, pnum as personid.
	keep token pnum ethgrp $preds
	tempfile tmp
	save `tmp'
	// next, other jewish adults in hhd (no race provided)
	use token x_hhadage* hhadedu* x_hhadjewish* ///
		x_respjewish if x_respjewish==1 using "cmjs-portland-public-datafile.dta", clear
	drop x_respjewish
	reshape long x_hhadage5cat hhadedu x_hhracewhite x_hhhisp x_hhadjewish, i(token) j(pnum)
	ren x_hhadage agecat8
	replace agecat8=agecat8+3 // make room for child age group codes 1--3
	ren hhadedu educat5
	replace educat5=. if !inrange(educat5,2,5)
	assert pnum>1 
	keep if x_hhadjewish==1 // jewish flag
	keep if agecat8<. & educat5<. // keep if this roster line demographics are nonmissing
	keep token pnum agecat8 educat5
	* add to hh roster
	append using `tmp' // add jewish primary respondents in household
	sort token pnum
	save `tmp', replace
	// last, children in hhd 
	use token x_hhchage3cat* x_hhchjewish* /// // x_hhchracenonwhite x_hhchhisp always missing
		x_respjewish if x_respjewish==1 using "cmjs-portland-public-datafile.dta", clear
	drop x_respjewish
	reshape long x_hhchage3cat x_hhchjewish, i(token) j(chnum)
	ren x_hhchage3cat agecat8
	keep if x_hhchjewish==1 // jewish flag
	keep if agecat8<. 
	gen byte educat5=1 // assign all children as <HSG
	keep token chnum agecat8 educat5
	* add to hh roster
	append using `tmp'
	sort token pnum chnum 
	drop chnum
	by token: replace pnum=pnum[_n-1]+1 if missing(pnum) // assign pnum to children
	* label, carryforward, and cleanup
	by token: carryforward ethgrp $preds, replace // carryforward primary adult/household traits to other adults/children (who are censored)
	drop if missing(ethgrp) // drop if missing primary adult/household traits (e.g., if other adults/children were jewish but not primary respondent-- because, no detailed ethnicity asked)
	lab def agecat8 1 "0-5" 2 "6-12" 3 "13-17" 4 "18-34" 5 "35-49" 6 "50-64" 7 "65-74" 8 "75+", replace
	lab val agecat8 agecat8 
	lab def educat5 1 "<18" 2 "HSG" 3 "AA" 4 "BA" 5 "MA+", replace 
	lab val educat5 educat5
	lab def hhicat5 1 "<50k" 2 "50-74k" 3 "75-99k" 4 "100-149k" 5 "150-199k" 6 "200k+", replace
	lab val hhicat5 hhicat5
	tab ethgrp, mis // now, with additional adults and children in household, 77% Ashkenazi 10% Sephardi 13%Other
	keep token pnum ethgrp $preds // wt_* 
	save jet_training.dta, replace
	rm cmjs-portland-public-datafile.dta
end
*jetrain // create jet_training.dta from Brandeis portland survey

// ACS: Oregon + Clark CO, WA PUMS
** note! puma20 used for all data starting with 5acs23
cap prog drop jet_acs
prog def jet_acs
	local z=substr("`1'",3,.)
	local vars "STATE,SERIALNO,SPORDER,PUMA,PWGTP,AGEP,SCHL,RAC1P,ANC1P,ANC2P,LANP,WAOB,HISP,POVPIP,HINCP,ADJINC" // MAR CIT COW FINCP NP SEX
	censusapi, url("https://api.census.gov/data/`1'/acs/acs5/pums?get=`vars'&for=public%20use%20microdata%20area:*&in=state:41&key=$ckey")
	tempfile or
	save `or', replace
	** filter Clark Co, WA PUMA20s
	censusapi, url("https://api.census.gov/data/`1'/acs/acs5/pums?get=`vars'&for=public%20use%20microdata%20area:21101,21102,21103,21104&in=state:53&key=$ckey")
	append using `or'
	** recode to match Brandeis-Portland training data codes
	recode agep (0/5=1) (6/12=2) (13/17=3) (18/34=4) (35/49=5) (50/64=6) (65/74=7) (75/99=8), gen(agecat8)
	recode schl (1/15=1) (16/18=2) (19/20=3) (21=4) (22/24=5), gen(educat5)
	replace educat5=1 if inrange(agecat8,1,3) // all youth in trianing data labeled this way
	recode povpip (-1=.) (0/249=1) (250/998=0), gen(fpl250)
	gen racerc_white=(rac1p==1) 
	gen racerc_hisp=(inrange(hisp,2,25))
	recode waob (1/2=0) (3/8=1), gen(forborn)
	destring lanp, replace ignore("N")
	gen lanp_ru=(lanp==1250)
	gen lanp_en=missing(lanp)
	assert inrange(adjinc,1,2) 
	if !_rc gen hincpa=hincp*adjinc 
	else ren hincp hincpa // just in case might have the wrong implied decimals 
	recode hincpa (-999999/-1=.) (0/49999=1) (50000/74999=2) (75000/99999=3) (100000/149999=4) (150000/199999=5) (200000/99999999=6), gen(hhicat5)
	assert inrange(hhicat5,1,6)|hhicat5==.
	** label recodes
	lab def agecat8 1 "0-5" 2 "6-12" 3 "13-17" 4 "18-34" 5 "35-49" 6 "50-64" 7 "65-74" 8 "75+", replace
	lab val agecat8 agecat8 
	lab def educat5 1 "<18" 2 "HSG" 3 "AA" 4 "BA" 5 "MA+", replace 
	lab val educat5 educat5
	lab def hhicat5 1 "<50k" 2 "50-74k" 3 "75-99k" 4 "100-149k" 5 "150-199k" 6 "200k+", replace
	lab val hhicat5 hhicat5 
	** add county/puma groups (puma20 to county/county group)
    gen byte county = .
    replace county = 1  if state==41 & inlist(puma,301,4301)                      // benton+linn
    replace county = 2  if state==41 & inlist(puma,501,502,503,504)               // clackamas
    replace county = 3  if state==41 & inlist(puma,1701,1702,1703)                // crook,jefferson,deschutes
    replace county = 4  if state==41 & puma==1900                                 // douglas
    replace county = 5  if state==41 & inlist(puma,2901,2902)                     // jackson
    replace county = 6  if state==41 & inlist(puma,3903,3904,3905)                // lane
    replace county = 7  if state==41 & inlist(puma,4703,4704,4705)                // marion
    replace county = 8  if state==41 & inlist(puma,5101,5102,5103,5105,5114,5116) // multnomah
    replace county = 9  if state==41 & inlist(puma,5901,6501)                     // umatilla...wheeler
    replace county = 10 if state==41 & inlist(puma,6720,6721,6722,6723,6724)      // washington
    replace county = 11 if state==41 & puma==7100                                 // yamhill
    replace county = 12 if state==41 & puma==9000                                 // tillamook,columbia,clatsop
    replace county = 13 if state==41 & puma==9100                                 // josephine,coos,curry
    replace county = 14 if state==41 & puma==9200                                 // klamath,malheur,lake,harney
    replace county = 15 if state==41 & puma==9300                                 // polk,lincoln
    replace county = 16 if state==53 & inlist(puma,21101,21102,21103,21104)       // clark(WA)
	assert county<.
	** prelim naive flag Jewish
	gen byte ethgrp_tmp=.
	replace ethgrp_tmp=1 if ethgrp_tmp==. & lanp==1130 // yiddish=ashkenazi
	replace ethgrp_tmp=1 if ethgrp_tmp==. & lanp==4545 // hebrew=ashkenazi
	replace ethgrp_tmp=2 if ethgrp_tmp==. & lanp==1200 & (inlist(anc1p,419,490)|inlist(anc2p,419,490)) // spanish+middle-eastern=sephardi
	replace ethgrp_tmp=3 if ethgrp_tmp==. & lanp==4545 & (anc1p==490|anc2p==490) // hebrew+middleeastern=other
	replace ethgrp_tmp=3 if ethgrp_tmp==. & anc1p==419|anc2p==419 // israeli ancestry, none else=other
    * remember to subtract from needed control: 1171+248=1419 persons for OR; 106 for Clark,WA.
    tabulate ethgrp_tmp state [fw=pwgtp], missing
	keep state serialno sporder county pwgtp ethgrp_tmp $preds
	compress
	save jet_5acs`z'.dta, replace
end // syntax: jet_acs YYYY (where year is 2023 or later)
*jet_acs 2023
*jet_acs 2024

// pu-learning
* acs variables used in the PU-learning model
* training data predictors used in the PU-learning model (used throughout below)
cap prog drop fitPu
prog def fitPu
	args k z
	tempfile postmp
	* training data: s=1 labeled positives for ethgrp==k
	use if ethgrp==`k' using jet_training.dta, clear
	if _N==0 {
		di "category `k': no positive cases in training data; skip"
		exit
	}
	keep $preds // wt_primresp
	gen byte s=1
	* ren wt_primresp w // not using svy weight b/c of new geometry
	gen w=1 
	save `postmp', replace
	* acs data: s=0 for unlabeled
	use jet_5acs`z'.dta, clear
	keep state serialno sporder $preds pwgtp
	gen byte s=0
	ren pwgtp w
	append using `postmp' // add labeled data
	qui sum w
	replace w=w/`r(mean)'
    * fit logistic P(s=1|x); iweight mirrors R glm()'s `weights=` argument
	glm s i.agecat8 i.educat5 i.hhicat5 racerc_w racerc_h fpl250 forborn lanp_ru lanp_en ///
		[iw=w], family(binomial) link(logit) ltol(1e-6) iter(15)
	est sto pu_cat`k'
	* elkan-noto correction; c_hat=mean(s_hat|y=1), over labeled positives w/all preds.
	* pu-corrected posterior score [0,1]
	predict s_hat if s==1, mu
	qui sum s_hat if s==1
	scalar c_hat_`k'=`r(mean)'
	di "category `k': c_hat=" c_hat_`k'
	predict phat_cat`k', mu
	replace phat_cat`k'=phat_cat`k'/c_hat_`k'
	replace phat_cat`k'=0 if phat_cat`k'<0
	replace phat_cat`k'=1 if phat_cat`k'>1
	* save results
	keep state serialno sporder phat_cat`k'
	drop if state==. // drop labeled positives
	save tmp_cat`k'.dta, replace
end
*for num 1/3: fitPu X 23 // export 3 datasets, scores for each k.
*for num 1/3: fitPu X 24 // careful, because it will overwrite the scores ~ only one year at a time.

// cleanup intermediate files
*rm jet_training.dta
*rm jet_5acs`z'.dta

// control totals
** from 2020, 2024 AJPP special estimates; interpolated; here, sum to the PUMA groups.
cap prog drop jCont
prog def jCont
	args y
	local y=`y'-2 // ACS est midpoint of 5-yr interval
	import excel using jet_est.xlsx, cellrange(d29:o67) clear firstrow
	destring est*, replace ignore(",")
	confirm var est_`y'
	for any "OR" "WA": replace cname=subinstr(cname," County, X","",.)
	// county controls to ACS PUMAs
	gen byte county = .
	replace county = 1  if inlist(cname,"Benton","Linn")
	replace county = 2  if cname=="Clackamas"
	replace county = 3  if inlist(cname,"Crook","Jefferson","Deschutes")
	replace county = 4  if cname=="Douglas"
	replace county = 5  if cname=="Jackson"
	replace county = 6  if cname=="Lane"
	replace county = 7  if cname=="Marion"
	replace county = 8  if cname=="Multnomah"
	replace county = 9  if inlist(cname,"Baker","Gilliam","Grant","Hood River","Morrow","Sherman","Umatilla","Union")|inlist(cname,"Wallowa","Wasco","Wheeler")
	replace county = 10 if cname=="Washington"
	replace county = 11 if cname=="Yamhill"
	replace county = 12 if inlist(cname,"Tillamook","Columbia","Clatsop")
	replace county = 13 if inlist(cname,"Josephine","Coos","Curry")
	replace county = 14 if inlist(cname,"Klamath","Malheur","Lake","Harney")
	replace county = 15 if inlist(cname,"Polk","Lincoln")
	replace county = 16 if cname=="Clark"
	drop if cname=="Skamania"
	assert county<.
	// totals by puma
	collapse (sum) 	est_`y', by(county)
	mkmat est_`y', mat(control)
	mat control=control'
	*mat control=(1550,3000,2035,300,4000,3500,2000,33800,510,15100,900,950,1250,210,1000,5400) // AJPP 2020 hardcode.
	mat row_s=control*J(colsof(control),1,1)
	scalar N_pos_total=row_s[1,1] 
	scalar list N_pos_total // statewide total (consistent with county control totals)
	//
	// weighted shares per category
	use jet_training.dta, clear
	gen w=1
	qui sum w if ethgrp>0 & !missing(ethgrp)
	local w_tot=`r(sum)'
	mat share_by_cat=J(1,3,0)
	forvalues k=1/3 {
		qui sum w if ethgrp==`k'
		local s_`k'=`r(sum)'/`w_tot'
		mat share_by_cat[1,`k']=`s_`k''
	}
	mat list share_by_cat // statewide share by jet
	//
	// control totals by category
	mat control_cat=J(3,16,0)
	forvalues k=1/3 {
		forvalues c=1/16 {
			mat control_cat[`k',`c']=round(control[1,`c']*share_by_cat[1,`k'])
		}
	}
	mat cat_s=control_cat*J(16,1,1)
	mat N_by_cat=cat_s'
	mat list N_by_cat // statewide total by jet (internally consistent with county control totals by jet)end
end
*jCont 2023
*jCont 2024

// reconcile ACS to control total (counties only; earlier versions in R did state total as a first step)
** basic approach: random draw to select N by jet with score as weight, check total selected and gsample up or down.
** wrinkle is that pwgtp may never sum exactly to the control total, so may have to split observations based on a fractional share jewish
cap prog drop doJeti
prog def doJeti
	args z
	use jet_5acs`z'.dta, clear
	for num 1/3: merge 1:1 state serialno sporder using tmp_catX, keep(1 3) keepus(phat_catX) nogen // // attach model predictions
	gen byte ethgrpi=.
	for num 1/3: replace ethgrpi=X if ethgrp_tmp==X // pre-seed those with imputed jewish purely on ACS traits
	clonevar pwt1=pwgtp
	qui forvalues g=1/16 {
		forvalues e=1/3 {
			local control_`e'=el(control_cat,`e',`g') // get the county control
			sum pwt1 if county==`g' & ethgrpi==`e', mean // check pums records 
			local diff=`control_`e''-`r(sum)'
			while `diff'!=0 {
				nois di "County `g'/16 (Eth `e'/3): Found `r(sum)' assignments; `control_`e'' needed (`diff')."
				if `diff'>0 { // too few, need to add
					gsort county -ethgrpi -phat_cat`e' pwt1 // sort descending by likelihood 
					gen cum_w=sum(pwt1) if county==`g' & ethgrpi==.
					gen include=cum_w<=`diff'
					gen last=(cum_w[_n-1]<`diff')&(cum_w>`diff') // record puts over the control total
					replace pwt1=`diff'-cum_w[_n-1] if last==1 // adjust pwt1 in last obs.
					replace ethgrpi=`e' if county==`g' & ethgrpi==. & (include==1|last==1) // attach JET
					drop include last cum_w
				}
				if `diff'<0 { // too many, need to remove
					local diff=abs(`diff')
					gsort county -ethgrpi phat_cat`e' pwt1 // sort ascending by likelihood 
					gen cum_w=sum(pwt1) if county==`g' & ethgrpi==`e'
					gen exclude=cum_w<=`diff'|((cum_w[_n-1]<`diff')&(cum_w>`diff')) 
					replace ethgrpi=. if county==`g' & ethgrpi==`e' & exclude==1 // detach JET
					drop exclude cum_w
				}
				sum pwt1 if county==`g' & ethgrpi==`e', mean
				local diff=`control_`e''-`r(sum)'
			}
		}
	}
	// export results, cleanup
	*for num 1/3: rm tmp_catX.dta
	table county ethgrpi [fw=pwt1] 
	mat list N_by_cat
	scalar list N_pos_total
	keep state serialno sporder ethgrpi pwgtp pwt1
	lab def ethgrpi 1 "Ashkenazi" 2 "Sephardi" 3 "Other"
	lab val ethgrpi ethgrpi 
	save jet_5acs`z'_i.dta, replace
end
*doJeti 23 // run 5ACSZZ, impute to match control totals stored in named matrices using predicted JET scores from PU-learning
*doJeti 24

// return to parent directory
cd ..
