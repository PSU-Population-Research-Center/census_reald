 //  program:   ACS201721_Setup_2v11RELD_ORandWA.do
 //  Task: 		Setup  of ACS files Race language Disability set up-OR
 //  project:   Set up of 
 //  author:    marjorie mcgee and Jake Tarrence

// setup
local date "2023-5-26"
//  setup
 version 17
 set linesize 180

*1**********************************************************************

** removed read 

svyset [pw=PWGTP], sdrweight(PWGTP1-PWGTP80) vce(sdr)

******************************************************************************
*45  RAC1P lables 
******************************************************************************

label define RAC1P ///
1	"White alone" ///
2	"Black alone" ///
3	"Am Indian alone" ///
4	"Alaska Native alone" ///
5	"All other AIAN" ///
6	"Asian alone" ///
7	"NHPI alone" ///
8	"Some Other Race alone" ///
9	"Two or More Races", modify
label value RAC1P RAC1P
tab RAC1P, miss

******************************************************************************
*47  RAC2P - labels
******************************************************************************
label define RAC2P	1	"White alone", modify
label define RAC2P	2	"Black alone", modify
label define RAC2P	3	"Apache alone", modify
label define RAC2P	4	"Blackfeet alone", modify
label define RAC2P	5	"Cherokee alone", modify
label define RAC2P	6	"Cheyenne alone", modify
label define RAC2P	7	"Chickasaw alone", modify
label define RAC2P	8	"Chippewa alone", modify
label define RAC2P	9	"Choctaw alone", modify
label define RAC2P	10	"Comanche alone", modify
label define RAC2P	11	"Creek alone", modify
label define RAC2P	12	"Crow alone", modify
label define RAC2P	13	"Hopi alone", modify
label define RAC2P	15	"Lumbee alone", modify
label define RAC2P	14	"Iroquois alone", modify
label define RAC2P	16	"Mexican Am Indian alone", modify
label define RAC2P	17	"Navajo alone", modify
label define RAC2P	18	"Pima alone", modify
label define RAC2P	19	"Potawatomi alone", modify
label define RAC2P	20	"Pueblo alone", modify
label define RAC2P	21	"Puget Sound Salish alone", modify
label define RAC2P	22	"Seminole alone", modify
label define RAC2P	23	"Sioux alone", modify
label define RAC2P	24	"South Am Indian alone", modify
label define RAC2P	25	"Tohono O'Odham alone", modify
label define RAC2P	26	"Yaqui alone", modify
label define RAC2P	27	"Other specified Am Indian tribes alone", modify
label define RAC2P	28	"All other specified Am Indian tribe combinations", modify
label define RAC2P	29	"Am Indian, tribe not specified", modify
label define RAC2P	30	"Alaskan Athabascan alone", modify
label define RAC2P	31	"Tlingit-Haida alone", modify
label define RAC2P	32	"Inupiat alone", modify
label define RAC2P	33	"Yup'ik alone", modify
label define RAC2P	34	"Aleut alone", modify
label define RAC2P	35	"Other Alaska Native", modify
label define RAC2P	36	"Other ReAIANG specified", modify
label define RAC2P	37	"AIAN, not specified", modify
label define RAC2P	38	"Asian Indian alone", modify
label define RAC2P	39	"Bangladeshi alone", modify
label define RAC2P	40	"Bhutanese alone", modify
label define RAC2P	41	"Burmese alone", modify
label define RAC2P	42	"Cambodian alone", modify
label define RAC2P	43	"ReChinese, except Taiwanese, alone", modify
label define RAC2P	44	"Taiwanese alone", modify
label define RAC2P	45	"ReFilipino alone", modify
label define RAC2P	46	"Hmong alone", modify
label define RAC2P	47	"Indonesian alone", modify
label define RAC2P	48	"ReJapanese alone", modify
label define RAC2P	49	"ReKorean alone", modify
label define RAC2P	50	"ReLaotian alone", modify
label define RAC2P	51	"Malaysian alone", modify
label define RAC2P	52	"Mongolian alone", modify
label define RAC2P	53	"Nepalese alone", modify
label define RAC2P	54	"Pakistani alone", modify
label define RAC2P	55	"Sri Lankan alone", modify
label define RAC2P	56	"Thai alone", modify
label define RAC2P	57	"Vietnamese alone", modify
label define RAC2P	58	"Other Asian alone", modify
label define RAC2P	59	"All combinations of Asian races only", modify
label define RAC2P	60	"NH alone", modify
label define RAC2P	61	"ReSamoan alone", modify
label define RAC2P	62	"ReTongan alone", modify
label define RAC2P	63	"Guamanian or Chamorro alone", modify
label define RAC2P	64	"Marshallese alone", modify
label define RAC2P	65	"Fijian alone", modify
label define RAC2P	66	"Other NH and Other Pacific Islander", modify
label define RAC2P	67	"Some Other Race alone", modify
label define RAC2P	68	"Two or More Races", modify
label define RAC2P	66	"Other NH and Other Pacific Islander", modify

******************************************************************************
*48  RAC3P - labels
******************************************************************************
label define RAC3P 		1	"White alone", modify
label define RAC3P 		2	"Black alone", modify
label define RAC3P 		3	"AIAN  alone", modify
label define RAC3P 		4	"Asian Indian alone", modify
label define RAC3P 		5	"Chinese alone", modify
label define RAC3P 		6	"Filipino alone", modify
label define RAC3P 		7	"Japanese alone", modify
label define RAC3P 		8	"Korean alone", modify
label define RAC3P 		9	"Vietnamese alone", modify
label define RAC3P 		10	"Other Asian alone", modify
label define RAC3P 		11	"NatHaw alone", modify
label define RAC3P 		12	"Guamanian or CHamorro alone", modify
label define RAC3P 		13	"Samoan alone", modify
label define RAC3P 		14	"OPI alone", modify
label define RAC3P 		15	"SOR alone", modify
label define RAC3P 		16	"White; Black/Afr Am", modify
label define RAC3P 		17	"White; AIAN", modify
label define RAC3P 		18	"White; Asian Indian", modify
label define RAC3P 		19	"White; Chinese", modify
label define RAC3P 		20	"White; Filipino", modify
label define RAC3P 		21	"White; Japanese", modify
label define RAC3P 		22	"White; Korean", modify
label define RAC3P 		23	"White; Vietnamese", modify
label define RAC3P 		24	"White; Other Asian", modify
label define RAC3P 		25	"White; NatHaw", modify
label define RAC3P 		26	"White; Guamanian or Chamorro", modify
label define RAC3P 		27	"White; Samoan", modify
label define RAC3P 		28	"White; OPI", modify
label define RAC3P 		29	"White; SOR", modify
label define RAC3P 		30	"Black/AfrAm; AIAN", modify
label define RAC3P 		31	"Black/AfrAm; Asian Indian", modify
label define RAC3P 		32	"Black/AfrAm; Chinese", modify
label define RAC3P 		33	"Black/AfrAm; Filipino", modify
label define RAC3P 		34	"Black/AfrAm; Japanese", modify
label define RAC3P 		35	"Black/AfrAm; ReKorean", modify
label define RAC3P 		36	"Black/AfrAm; Other Asian", modify
label define RAC3P 		37	"Black/AfrAm; OPI", modify
label define RAC3P 		38	"Black/AfrAm; SOR", modify
label define RAC3P 		39	"AIAN; Asian Indian", modify
label define RAC3P 		40	"AIAN; Filipino", modify
label define RAC3P 		41	"AIAN; SOR", modify
label define RAC3P 		42	"Asian Indian; Other Asian", modify
label define RAC3P 		43	"Asian Indian; SOR", modify
label define RAC3P 		44	"Chinese; Filipino", modify
label define RAC3P 		45	"Chinese; Japanese", modify
label define RAC3P 		46	"Chinese; Korean", modify
label define RAC3P 		47	"Chinese; Vietnamese", modify
label define RAC3P 		48	"Chinese; Other Asian", modify
label define RAC3P 		49	"Chinese; NatHaw", modify
label define RAC3P 		50	"Filipino; Japanese", modify
label define RAC3P 		51	"Filipino; NatHaw", modify
label define RAC3P 		52	"Filipino; OPI", modify
label define RAC3P 		53	"Filipino; SOR", modify
label define RAC3P 		54	"Japanese; ReKorean", modify
label define RAC3P 		55	"Japanese; NatHaw", modify
label define RAC3P 		56	"Vietnamese; Other Asian", modify
label define RAC3P 		57	"Other Asian; OPI", modify
label define RAC3P 		58	"Other Asian; SOR", modify
label define RAC3P 		59	"OPI; SOR", modify
label define RAC3P 		60	"White; Black/AfrAm; AIAN", modify
label define RAC3P 		61	"White; Black/AfrAm; Filipino", modify
label define RAC3P 		62	"White; Black/AfrAm; SOR", modify
label define RAC3P 		63	"White; AIAN; Filipino", modify
label define RAC3P 		64	"White; AIAN; SOR", modify
label define RAC3P 		65	"White; Chinese; Filipino", modify
label define RAC3P 		66	"White; Chinese; Japanese", modify
label define RAC3P 		67	"White; Chinese; NatHaw", modify
label define RAC3P 		68	"White; Filipino; NatHaw", modify
label define RAC3P 		69	"White; Japanese; NatHaw", modify
label define RAC3P 		70	"White; Other Asian; SOR", modify
label define RAC3P 		71	"Chinese; Filipino; NatHaw", modify
label define RAC3P 		72	"White; Chinese; Filipino; NatHaw", modify
label define RAC3P 		73	"White; Chinese; Japanese; NatHaw", modify
label define RAC3P 		74	"Black/AfrAm; Asian groups", modify
label define RAC3P 		75	"Black/AfrAm; NH & OPI groups", modify
label define RAC3P 		76	"Asian Indian; Asian groups", modify
label define RAC3P 		77	"Filipino; Asian groups", modify
label define RAC3P 		78	"White; Black/AfrAm; Asian groups", modify
label define RAC3P 		79	"White; AIAN; Asian groups", modify
label define RAC3P 		80	"White; NH & OPI groups; and/or SOR", modify
label define RAC3P 		81	"White; Black/AfrAm; AIAN; Asian groups", modify
label define RAC3P 		82	"White; Black/AfrAm; AIAN; and/or NH & OPI groups; and/or SOR", modify
label define RAC3P 		83	"White; Black/AfrAm; and/or Asian groups; and/or NH & OPI groups; and/or SOR", modify
label define RAC3P 		84	"White; AIAN; and/or Asian groups; and/or NH & OPI groups", modify
label define RAC3P 		85	"White; Chinese; Filipino; and/or Asian groups; and/or NH & OPI groups; and/or SOR", modify
label define RAC3P 		86	"White; Chinese; and/or Asian groups; and/or NH & OPI groups; and/or SOR", modify
label define RAC3P 		87	"White; Filipino; and/or NH & OPI groups; and/or SOR", modify
label define RAC3P 		88	"White; Japanese; and/or Asian groups; and/or NH & OPI groups; and/or SOR", modify
label define RAC3P 		89	"White; Asian groups; and/or NH & OPI groups; and/or SOR", modify
label define RAC3P 		90	"Black/AfrAm; AIAN; and/or Asian groups; and/or NH & OPI groups; and/or SOR", modify
label define RAC3P 		91	"Black/AfrAm; Asian groups; and/or NH & OPI groups; and/or SOR", modify
label define RAC3P 		92	"AIAN; Asian groups; and/or NH & OPI groups; and/or SOR", modify
label define RAC3P 		93	"Asian Indian; and/or White; and/or Asian groups; and/or NH & OPI groups; and/or SOR", modify
label define RAC3P 		94	"Chinese; Japanese; NatHaw; and/or other Asian and/or Pacific Islander groups", modify
label define RAC3P 		95	"Chinese; and/or Asian groups; and/or NH & OPI groups; and/or SOR", modify
label define RAC3P 		96	"Filipino; and/or Asian groups; and/or NH & OPI groups; and/or SOR", modify
label define RAC3P 		97	"Japanese; and/or Asian groups; and/or NH & OPI groups; and/or SOR", modify
label define RAC3P 		98	"Korean; and/or Vietnamese; and/or Other Asian; and/or NH & OPI groups; and/or SOR", modify
label define RAC3P 		99	"NatHaw; and/or Pacific Islander groups; and/or SOR", modify
label define RAC3P 		100	"White; and/or Black/AfrAm; and/or AIAN; and/or Asian groups; and/or NH & OPI groups; and/or SOR", modify

label value RAC3P RAC3P
**2*********************************************************************
decode HISP, gen(HISPS)
decode POBP, gen(POBPS)
decode ANC1P, gen(ANC1PS)
decode ANC2P, gen(ANC2PS)
decode RAC1P, gen(RAC1PS)
decode RAC2P, gen(RAC2PS)
decode RAC3P, gen(RAC3PS)
decode MIGSP, gen(MIGSPS)
decode LANP, gen(LANPS)
***********************************************************************
 *HIspanic  
 *Change on 10/10/21 -ordered ReHispG first as when started with ReWhiteG it was over inflating with respec to Spanish on Lanp or on ANC1p -ReHispG ancestry
*3********** *********** *********** *********** *********** ***********
recode HISP(1=0)(else=1), gen(HISPdi)
replace HISPdi=. if HISP==.
 label var HISPdi "Hispanic?"
 label value HISPdi no0yes1
 tab HISP HISPdi , miss

 
***********************************************************************
*Latinx sub groups
*4**********************************************************************
 gen ReHisMex =. 
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReHisMex=1 if regexm(`var', "Mexican") ==1 & HISPdi==1
replace ReHisMex=1 if regexm(`var', "Chicano") ==1 
replace ReHisMex=1 if regexm(`var', "Mexico") ==1 
 }
  * svy:  tab  ReHisMex , count ci format(%-12.0g)  csepwidth(10) stubwidth(30)
   *2019 1 yr estimates: 461710	10695
* 453204- 462049=
   
 gen ReHisCen =.
foreach var of varlist POBPS MIGSPS   {
replace ReHisCen=1 if regexm(`var', "Belize") ==1 & HISPdi==1
replace ReHisCen=1 if regexm(`var', "Costa Rica") ==1  & HISPdi==1
replace ReHisCen=1 if regexm(`var', "Salvador") ==1  & HISPdi==1
replace ReHisCen=1 if regexm(`var', "Guatemal") ==1 & HISPdi==1
replace ReHisCen=1 if regexm(`var', "Hondur") ==1  & HISPdi==1
replace ReHisCen=1 if regexm(`var', "Nicaragua") ==1 & HISPdi==1
replace ReHisCen=1 if regexm(`var', "Panama") ==1 & HISPdi==1
replace ReHisCen=1 if regexm(`var', "Central America, Not Specified") ==1 & HISPdi==1
replace ReHisCen=1 if regexm(`var', "Other Central American") ==1 & HISPdi==1
 }
 
foreach var of varlist  RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  HISPS  {
replace ReHisCen=1 if regexm(`var', "Belize") ==1 
replace ReHisCen=1 if regexm(`var', "Costa Rica") ==1  
replace ReHisCen=1 if regexm(`var', "Salvador") ==1  
replace ReHisCen=1 if regexm(`var', "Guatemal") ==1 
replace ReHisCen=1 if regexm(`var', "Hondur") ==1  
replace ReHisCen=1 if regexm(`var', "Nicaragua") ==1 
replace ReHisCen=1 if regexm(`var', "Panama") ==1 
replace ReHisCen=1 if regexm(`var', "Central America, Not Specified") ==1 
replace ReHisCen=1 if regexm(`var', "Other Central American") ==1 
 }
replace ReHisCen =1 if MIGSP==316 & HISPdi==1
replace ReHisCen =1 if POBP==316 & HISPdi==1

 gen ReHisSou =.
foreach var of varlist HISPS  POBPS MIGSPS    {
replace ReHisSou=1 if regexm(`var', "Argentin") ==1  & HISPdi==1
replace ReHisSou=1 if regexm(`var', "Bolivi") ==1  & HISPdi==1
replace ReHisSou=1 if regexm(`var', "Brazil") ==1  & HISPdi==1
replace ReHisSou=1 if regexm(`var', "Colombia") ==1 & HISPdi==1
replace ReHisSou=1 if regexm(`var', "Chile") ==1  & HISPdi==1
replace ReHisSou=1 if regexm(`var', "Ecuador") ==1 & HISPdi==1
replace ReHisSou=1 if regexm(`var', "Paraguay") ==1 & HISPdi==1
replace ReHisSou=1 if regexm(`var', "Peru") ==1  & HISPdi==1
replace ReHisSou=1 if regexm(`var', "Uruguay") ==1 & HISPdi==1
replace ReHisSou=1 if regexm(`var', "Venezuela") ==1 & HISPdi==1
replace ReHisSou=1 if regexm(`var', "South America") ==1  & HISPdi==1

 }
foreach var of varlist  RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  HISPS  {
replace ReHisSou=1 if regexm(`var', "Argentin") ==1  
replace ReHisSou=1 if regexm(`var', "Bolivi") ==1  
replace ReHisSou=1 if regexm(`var', "Brazil") ==1  
replace ReHisSou=1 if regexm(`var', "Colombia") ==1 
replace ReHisSou=1 if regexm(`var', "Chile") ==1  
replace ReHisSou=1 if regexm(`var', "Ecuador") ==1 
replace ReHisSou=1 if regexm(`var', "Paraguay") ==1 
replace ReHisSou=1 if regexm(`var', "Peru") ==1  
replace ReHisSou=1 if regexm(`var', "Uruguay") ==1 
replace ReHisSou=1 if regexm(`var', "Venezuela") ==1 
replace ReHisSou=1 if regexm(`var', "South America") ==1  
 }
 
  gen ReHisOth =.
foreach var of varlist  POBPS  MIGSPS HISPS  {
replace ReHisOth=1 if regexm(`var', "Puerto Ric") ==1  & HISPdi==1
replace ReHisOth=1 if regexm(`var', "Cuban") ==1  & HISPdi==1
replace ReHisOth=1 if regexm(`var', "Dominican") ==1  & HISPdi==1
replace ReHisOth=1 if regexm(`var', "Trinidad") ==1  & HISPdi==1 

 }
   *Added 6/7 
foreach var of varlist   LANPS  {
replace ReHisSou=1 if regexm(`var', "Portug") ==1  & RACBLK==1
replace ReHisOth=1 if regexm(`var', "Spani") ==1  & RACBLK==1
 }
 
foreach var of varlist RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  HISPS   {
replace ReHisOth=1 if regexm(`var', "Puerto Ric") ==1  
replace ReHisOth=1 if regexm(`var', "Cuban") ==1  
replace ReHisOth=1 if regexm(`var', "Dominican") ==1  
replace ReHisOth=1 if regexm(`var', "Trinidad") ==1  
 }
replace ReHisOth=1 if 		HISP== 3	//	Puerto Rican
replace ReHisOth=1 if 		HISP== 4	//	Cuban
replace ReHisOth=1 if 		HISP== 5	//	Dominican
replace ReHisOth=1 if 		HISP== 23	//	Spaniard
replace ReHisOth=1 if 		HISP== 24	//	All Other Spanish/ReHispG/Latino
replace ReHisMex=1 if 		HISP== 2	//	Mexican

replace ReHisCen=1 if 		HISP== 6	//	Costa Rican
replace ReHisCen=1 if 		HISP== 7	//	Guatemalan
replace ReHisCen=1 if 		HISP== 8	//	Honduran
replace ReHisCen=1 if 		HISP== 9	//	Nicaraguan
replace ReHisCen=1 if 		HISP== 10	//	Panamanian
replace ReHisCen=1 if 		HISP== 11	//	Salvadoran
replace ReHisCen=1 if 		HISP== 12	//	Other Central American

replace ReHisSou=1 if 		HISP== 13	//	Argentinean
replace ReHisSou=1 if 		HISP== 14	//	Bolivian
replace ReHisSou=1 if 		HISP== 15	//	Chilean
replace ReHisSou=1 if 		HISP== 16	//	Colombian
replace ReHisSou=1 if 		HISP== 17	//	Ecuadorian
replace ReHisSou=1 if 		HISP== 18	//	Paraguayan
replace ReHisSou=1 if 		HISP== 19	//	Peruvian
replace ReHisSou=1 if 		HISP== 20	//	Uruguayan
replace ReHisSou=1 if 		HISP== 21	//	Venezuelan
replace ReHisSou=1 if 		HISP== 22	//	Other South American

*5**********************************************************************
egen float ReHispG = rownonmiss(ReHisMex ReHisCen ReHisSou ReHisOth) 
replace ReHispG =1 if ReHispG >=2 & ReHispG! =.

 *svy:  tab  ReHispG , count ci format(%-12.0g)  csepwidth(10) stubwidth(30)
 *2019 1 yr estimates: 566839
* 554253-559326
order  RACWHT RACBLK RACASN RACAIAN RACNH RACPI RACSOR  HISP
 order RACNUM LANP ANC1P ANC2P ANC1PS ANC2PS, after(HISP)

 for var ReHispG: tab  X [fw=PWGTP]  if ST ==41  // boxes 1--4
 for var ReHispG: tab  X [fw=PWGTP]  if ST ==41 & AGEP>=18 // boxes 1--4
*comes very close to Census 2020 
*588757 for all ages
*389394 for age 18+
 drop ReHispG
********************************************************************************
 **ReAIANG 
 *6*******************************************************************************
gen ReLatInd =. 
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReLatInd=1 if regexm(`var', "Central American Indian") ==1 
replace ReLatInd=1 if regexm(`var', "South American Indian") ==1 
replace ReLatInd=1 if regexm(`var', "Mexican American Indian") ==1 
replace ReLatInd=1 if regexm(`var', "Mexican Indian") ==1 
replace ReLatInd=1 if regexm(`var', "Central and South American lang") ==1 
 }
 gen ReAIANLeg=.
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReAIANLeg=1 if regexm(`var', "American Indian and Alaska Native") ==1 
replace ReAIANLeg=1 if regexm(`var', "AIAN") ==1   &   RAC1P!=1
 }

gen ReAlaskNat =. 
replace ReAlaskNat =1 if  RAC1P== 4

foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReAlaskNat=1 if regexm(`var', "Aleut") ==1 
replace ReAlaskNat=1 if regexm(`var', "Eskimo") ==1 
replace ReAlaskNat=1 if regexm(`var', "Alaska Native") ==1 & ReAIANLeg==.
replace ReAlaskNat=1 if regexm(`var', "Alaskan Athabascan") ==1 
replace ReAlaskNat=1 if regexm(`var', "Tlingit") ==1 
replace ReAlaskNat=1 if regexm(`var', "Inupiat") ==1 
 }
gen ReAmInd=.
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReAmInd=1 if regexm(`var', "American Indian") ==1  & ReAIANLeg==.     &   RAC1P!=1
replace ReAmInd=1 if regexm(`var', "Native North American") ==1     &   RAC1P!=1
replace ReAmInd=1 if regexm(`var', "Cherokee") ==1     &   RAC1P!=1
 }

replace ReAmInd =1 if RAC1P==3
replace ReAmInd=1 if RAC2P>=3 & RAC2P<=15 
replace ReAmInd=1 if RAC2P>=17 & RAC2P<=23
replace ReAmInd=1 if RAC2P>=25 & RAC2P<=29
replace ReAmInd=1 if RAC2P>=25 & RAC2P<=29
replace ReAmInd=1 if RAC3P==3 & ReAlaskNat==. 
replace ReAmInd=1 if ANC1P>=917 & ANC1P<=920 &  RAC1P==5  // added 260

gen CanInd=.
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace CanInd=1 if regexm(`var', "First Nation") ==1  
 }
tab CanInd
drop CanInd
 **7********* *********** *********** *********** *********** ***********
egen float ReAIANG = rownonmiss( ReAIANLeg ReAlaskNat ReLatInd ReAmInd) 
tab RACAIAN if ReAIANG==0
replace ReAIANG =1 if ReAIANG >=2 & ReAIANG! =.
tab RACAIAN ReAIANG, miss
 for var ReAIANG: tab  X [fw=PWGTP]  if ST ==41 & RACAIAN==0 

  *svy:  tab  ReAIANG , count ci format(%-12.0g)  csepwidth(10) stubwidth(30)
  *ACS 2019 1 year estimates American Indian tribes, specified, alone or in any combination: 91898	5144
*    126662- 133903

  drop ReAIANG
  
 save "TempFile1v2.dta", replace
 
use "TempFile1v2.dta", replace
 
************************************************************************
*ReBlackG sub groups
*8**********************************************************************
*ReSomali
gen ReSomali=.
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReSomali=1 if regexm(`var', "Somali") ==1    & RACBLK==1
replace ReSomali=1 if regexm(`var', "Somali") ==1   &   RAC1P!=1 
 }
 
*9***********************************************************************
*ReEthiopian
gen ReEthiopian=.
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS   MIGSPS HISPS  {
replace ReEthiopian=1 if regexm(`var', "Ethiopia") ==1    & RACBLK==1
replace ReEthiopian=1 if regexm(`var', "Eritrea") ==1    & RACBLK==1
replace ReEthiopian=1 if regexm(`var', "Oromo") ==1    & RACBLK==1
replace ReEthiopian=1 if regexm(`var', "Amharic") ==1    & RACBLK==1
 }
 foreach var of varlist  RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS    HISPS  {
replace ReEthiopian=1 if regexm(`var', "Ethiopia") ==1   &   RAC1P!=1
replace ReEthiopian=1 if regexm(`var', "Eritrea") ==1   &   RAC1P!=1 
replace ReEthiopian=1 if regexm(`var', "Oromo") ==1   &   RAC1P!=1 
replace ReEthiopian=1 if regexm(`var', "Amharic") ==1   &   RAC1P!=1 
 }
foreach var of varlist   LANPS    {
replace ReEthiopian=1 if regexm(`var', "Ethiopia") ==1  
replace ReEthiopian=1 if regexm(`var', "Eritrea") ==1  
replace ReEthiopian=1 if regexm(`var', "Oromo") ==1  
replace ReEthiopian=1 if regexm(`var', "Amharic") ==1   
 }

 ********************************************************************
  gen ReAfrAm = . 
  foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReAfrAm=1 if regexm(`var', "African American") ==1  & RACBLK==1   & POBP<=78
replace ReAfrAm=1 if regexm(`var', "Blk/Afr") ==1  & RACBLK==1 & POBP>=0 & POBP<=78
replace ReAfrAm=1 if regexm(`var', "Negro") ==1    & RACBLK==1
replace ReAfrAm=1 if regexm(`var', "Afro") ==1  & RACBLK==1
 }

 
*7/24 - controlled so that ReSomali and ReEthiopian didn't also get coded as ReAfrican below
 egen float ReSomEth = rownonmiss( ReSomali ReEthiopian) 
 tab ReSomEth
 

*ReAfrican
gen ReAfrican =.
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS {
replace ReAfrican=1 if regexm(`var', "Yemen") ==1  & RACBLK==1
replace ReAfrican=1 if regexm(`var', "Afrikaans") ==1    & RACBLK==1
replace ReAfrican=1 if regexm(`var', "South Africa") ==1   & RACBLK==1
replace ReAfrican=1 if regexm(`var', "Kenya") ==1   & RACBLK==1
replace ReAfrican=1 if regexm(`var', "Congo") ==1   & RACBLK==1
replace ReAfrican=1 if regexm(`var', "Cameroon") ==1    & RACBLK==1
replace ReAfrican=1 if regexm(`var', "Ghana") ==1    & RACBLK==1
replace ReAfrican=1 if regexm(`var', "Gambia") ==1    & RACBLK==1
replace ReAfrican=1 if regexm(`var', "Cape Verdean") ==1    & RACBLK==1
replace ReAfrican=1 if regexm(`var', "Liberi") ==1    & RACBLK==1
replace ReAfrican=1 if regexm(`var', "Nigeria") ==1    & RACBLK==1
replace ReAfrican=1 if regexm(`var', "Senegal") ==1    & RACBLK==1
replace ReAfrican=1 if regexm(`var', "Sierra Leo") ==1    & RACBLK==1
replace ReAfrican=1 if regexm(`var', "Sudanese") ==1   & RACBLK==1
replace ReAfrican=1 if regexm(`var', "Togo") ==1    & RACBLK==1
replace ReAfrican=1 if regexm(`var', "Ugand") ==1     & RACBLK==1
replace ReAfrican=1 if regexm(`var', "Zimbabw") ==1   & RACBLK==1
replace ReAfrican=1 if regexm(`var', "Subsaharan African") ==1    & RACBLK==1 
replace ReAfrican=1 if regexm(`var', "Western African") ==1    & RACBLK==1
replace ReAfrican=1 if regexm(`var', "Ugand") ==1   & RACBLK==1
replace ReAfrican=1 if regexm(`var', "Zimbabw") ==1  & RACBLK==1
replace ReAfrican=1 if regexm(`var', "Africa") ==1 & ReAfrAm ==.   & RACBLK==1 &  POBP>=79 & ReSomEth==0
replace ReAfrican=1 if regexm(`var', "Swahili") ==1  & RACBLK==1   & ReSomEth==0
replace ReAfrican=1 if regexm(`var', "Arabic") ==1  & RACBLK==1 & ReSomEth==0
 }
*11********** *Added 6/7/21
*7/24 - controlled so that ReSomali and ReEthiopian didn't also get coded as ReAfrican in this case...and in the case on the two lines just proceeding. 
 foreach var of varlist   LANPS  {
replace ReAfrican=1 if regexm(`var', "French") ==1  & RACBLK==1 & ReSomali==. & ReEthiopian==.
replace ReAfrican=1 if regexm(`var', "Portug") ==1  & RACBLK==1 & ReSomali==. & ReEthiopian==.
 }
 foreach var of varlist   LANPS  {
replace ReAfrican=1 if  regexm(`var', "Afar") ==1    
replace ReAfrican=1 if  regexm(`var', "Bambara") ==1 
replace ReAfrican=1 if  regexm(`var', "Bantu") ==1 
replace ReAfrican=1 if  regexm(`var', "Bantu") ==1  
replace ReAfrican=1 if  regexm(`var', "Dinka") ==1  
replace ReAfrican=1 if  regexm(`var',"Ewe") ==1  
replace ReAfrican=1 if  regexm(`var',"Fiote") ==1 
replace ReAfrican=1 if  regexm(`var',"Fulani") ==1  
replace ReAfrican=1 if  regexm(`var',"Hausa") ==1  
replace ReAfrican=1 if  regexm(`var',"Igbo") ==1  
replace ReAfrican=1 if  regexm(`var',"Kabiye") ==1    
replace ReAfrican=1 if  regexm(`var',"Kikongo") ==1     
replace ReAfrican=1 if  regexm(`var',"Kinyarwanda") ==1     
replace ReAfrican=1 if  regexm(`var',"Kirundi") ==1 
replace ReAfrican=1 if  regexm(`var', "Nigeria") ==1 
replace ReAfrican=1 if  regexm(`var',"Swahili") ==1  
replace ReAfrican=1 if  regexm(`var', "Tonga") ==1    &  regexm(`var',"Nyasa") ==1   
replace ReAfrican=1 if  regexm(`var', "Krio"  ) ==1  
replace ReAfrican=1 if  regexm(`var', "Lingala" ) ==1   
replace ReAfrican=1 if  regexm(`var', "Luganda"  ) ==1  
replace ReAfrican=1 if  regexm(`var', "Luo"  ) ==1  
replace ReAfrican=1 if  regexm(`var', "Maay Maay"  ) ==1  
replace ReAfrican=1 if  regexm(`var', "Madi"  ) ==1  
replace ReAfrican=1 if  regexm(`var', "Mai (Bantu)" ) ==1   
replace ReAfrican=1 if  regexm(`var', "Mandingo"  ) ==1  
replace ReAfrican=1 if  regexm(`var', "Mina"  ) ==1  
replace ReAfrican=1 if  regexm(`var', "Nyanja"  ) ==1  
replace ReAfrican=1 if  regexm(`var', "Shona" ) ==1  
replace ReAfrican=1 if  regexm(`var', "Tigre"  ) ==1  
replace ReAfrican=1 if  regexm(`var', "Tigrinya") ==1  
replace ReAfrican=1 if  regexm(`var', "Tshiluba"  ) ==1  
replace ReAfrican=1 if  regexm(`var', "Twi"  ) ==1  
  }
*12***********
 
 gen ReCaribbean =. 
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS LANPS MIGSPS HISPS  {
replace ReCaribbean=1 if regexm(`var', "Cuba") ==1   & RACBLK==1
replace ReCaribbean=1 if regexm(`var', "Dominica") ==1   & RACBLK==1
replace ReCaribbean=1 if regexm(`var', "Haiti") ==1   &  RACBLK==1
replace ReCaribbean=1 if regexm(`var', "Jamaica") ==1  & RACBLK==1
replace ReCaribbean=1 if regexm(`var', "Trinidad") ==1    & RACBLK==1
replace ReCaribbean=1 if regexm(`var', "Bahama") ==1   & RACBLK==1
replace ReCaribbean=1 if regexm(`var', "West Indies") ==1   & RACBLK==1
replace ReCaribbean=1 if regexm(`var', "Caribbean") ==1  & RACBLK==1
replace ReCaribbean=1 if regexm(`var', "Bermuda") ==1  & RACBLK==1
replace ReCaribbean=1 if regexm(`var', "Puerto Ric") ==1  & RACBLK==1
replace ReCaribbean=1 if regexm(`var', "Virgin Islands") ==1  & RACBLK==1
replace ReCaribbean=1 if regexm(`var', "Antigua") ==1  & RACBLK==1 
replace ReCaribbean=1 if regexm(`var', "French-Based Creoles") ==1  & RACBLK==1 
replace ReCaribbean=1 if regexm(`var', "Saint Lucian Creole French") ==1  & RACBLK==1 
 }


 egen float ReBlackG = rownonmiss( ReCaribbean ReAfrican ReAfrAm ReSomali ReEthiopian) 
 replace ReBlackG =1 if ReBlackG >=2 & ReBlackG! =.
  
for var ReBlackG:  tab  X [fw=PWGTP]  if ST ==41 

*svy:  tab  ReBlackG , count ci format(%-12.0g)  csepwidth(10) stubwidth(30)
*ACS 2019 1 year estimtes: 124502	3283
* 118444.1793          122299.8207

replace ReAfrAm=1 if ANC1P==902 // ReAfrican Am
replace ReAfrAm=1 if ANC2P==902 // ReAfrican Am
replace ReAfrAm=1 if ANC1P==599 & POBP<=78  // ReAfrican
replace ReAfrAm=1 if ANC2P==599  & POBP<=78  // ReAfrican
replace ReAfrican=1 if ANC1P==599 & POBP>78 & ReBlackG==0  & ReSomali==.  & ReEthiopian==. // ReAfrican
replace ReAfrican=1 if ANC2P==599  & POBP>78 & ReBlackG==0 & ReSomali==.  & ReEthiopian==. // ReAfrican

drop ReBlackG
egen float ReBlackG = rownonmiss( ReCaribbean ReAfrican ReAfrAm ReSomali ReEthiopian) 
replace ReBlackG =1 if ReBlackG >=2 & ReBlackG! =.
* svy:  tab  ReBlackG , count ci format(%-12.0g)  csepwidth(10) stubwidth(30)
* 120967-  125298
* svy:  tab  RACBLK , count ci format(%-12.0g)  csepwidth(10) stubwidth(30)
*    118324- 122163

tab RAC1PS if ReBlackG ==0 & RACBLK==1
tab RAC2PS if ReBlackG ==0 & RACBLK==1
tab RAC3PS if ReBlackG ==0 & RACBLK==1

tab LANPS if ReBlackG ==0 & RACBLK==1
tab ANC2PS if ReBlackG ==0 & RACBLK==1
tab ANC1PS if ReBlackG ==0 & RACBLK==1
*13*****************************************************************
gen ReBlackLeg =.

 foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS LANPS MIGSPS HISPS  {
replace ReBlackLeg=1 if regexm(`var', "Black or ReAfrican American") ==1  & RACBLK==1 & ReBlackG==0 & ReSomEth==0
replace ReBlackLeg=1 if regexm(`var', "Blk/Afr") ==1   & RACBLK==1  & ReBlackG==0 & ReSomEth==0
replace ReBlackLeg=1 if `var'== "Black"  & RACBLK==1  & ReBlackG==0 & ReSomEth==0
 }
 

 drop ReBlackG
  egen float ReBlackG = rownonmiss(ReBlackLeg ReCaribbean ReAfrican ReAfrAm ReSomali ReEthiopian) 
 replace ReBlackG =1 if ReBlackG >=2 & ReBlackG! =.
 
gen ReBlackOth =1 if  ReBlackG ==0 & RACBLK==1  & ReSomEth==0
tab ReBlackOth ReBlackLeg, miss
tab ReBlackOth ReBlackLeg, miss
tab RACBLK if ReBlackG==0
drop ReBlackG 

egen float ReBlackG = rownonmiss ( ReCaribbean ReAfrican ReAfrAm ReSomali ReEthiopian ReBlackOth) 
replace ReBlackLeg=. if ReBlackG>=1
tab ReBlackLeg RACBLK, miss


drop ReBlackG
egen float ReBlackG = rownonmiss(ReBlackLeg ReCaribbean ReAfrican ReAfrAm ReSomali ReEthiopian ReBlackOth) 
tab ReBlackG
replace ReBlackG =1 if ReBlackG >=2 & ReBlackG! =.


  for var ReBlackG: tab  X [fw=PWGTP]  if ST ==41 
  

  *Census 2020: all ages: 134692
  * 127,173
 for var ReBlackG: tab  X [fw=PWGTP]  if ST ==41 & AGEP>=18 
 *84,4784
 
tab LANPS if ReBlackG ==0 & RACBLK==1
  
 tab RAC1PS if ReBlackG ==0 & RACBLK==1
tab RAC2PS if ReBlackG ==0 & RACBLK==1
tab ReBlackG RACBLK, miss

tab ReBlackLeg RACBLK, miss
tab ReBlackLeg , miss
tab ReBlackOth, miss
 for var ReBlackLeg: tab  X ReBlackOth  [fw=PWGTP] , miss
 

 
 foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS LANPS MIGSPS HISPS  {
tab `var' if  ReBlackLeg==1 & ReBlackOth!=1 & RACBLK==1
 }
  
drop ReBlackG  ReSomEth 


save "Tempfile1b.dta", replace

 ***********************************************************************
 **ReAsianG
*14************************************************************************
*South Asians: Bhutan Brunei India Indoesia Nepal Pakistan Tibet Bangladesh Sri Lanka
*ReSoAsian Bangladesh Bhutan Maldives Nepal Pakistan Sri Lanka
gen ReSoAsian =.
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReSoAsian=1 if regexm(`var', "Nepal") ==1  & RACASN==1
replace ReSoAsian=1 if regexm(`var', "Banglad") ==1    & RACASN==1
replace ReSoAsian=1 if regexm(`var', "Pakista") ==1    & RACASN==1
replace ReSoAsian=1 if regexm(`var', "Maldive") ==1    & RACASN==1
replace ReSoAsian=1 if regexm(`var', "Bhutan") ==1    & RACASN==1
replace ReSoAsian=1 if regexm(`var', "Sri Lanka") ==1    & RACASN==1
replace ReSoAsian=1 if regexm(`var', "Brunei") ==1    & RACASN==1
replace ReSoAsian=1 if regexm(`var', "Indoesia") ==1    & RACASN==1
replace ReSoAsian=1 if regexm(`var', "Tibet") ==1    & RACASN==1
replace ReSoAsian=1 if regexm(`var', "Tamil") ==1    & RACASN==1
replace ReSoAsian=1 if regexm(`var', "Indonesian") ==1    & RACASN==1

 }
foreach var of varlist  RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  HISPS  {
replace ReSoAsian=1 if regexm(`var', "Nepal") ==1   &   RAC1P!=1
replace ReSoAsian=1 if regexm(`var', "Banglad") ==1   &   RAC1P!=1  
replace ReSoAsian=1 if regexm(`var', "Pakista") ==1   &   RAC1P!=1  
replace ReSoAsian=1 if regexm(`var', "Maldive") ==1   &   RAC1P!=1  
replace ReSoAsian=1 if regexm(`var', "Bhutan") ==1   &   RAC1P!=1  
replace ReSoAsian=1 if regexm(`var', "Sri Lanka") ==1   &   RAC1P!=1  
replace ReSoAsian=1 if regexm(`var', "Brunei") ==1   &   RAC1P!=1  
replace ReSoAsian=1 if regexm(`var', "Indoesia") ==1   &   RAC1P!=1  
replace ReSoAsian=1 if regexm(`var', "Tibet") ==1   &   RAC1P!=1  
replace ReSoAsian=1 if regexm(`var', "Tamil") ==1   &   RAC1P!=1  
replace ReSoAsian=1 if `var'=="Shan"  
replace ReSoAsian=1 if `var'=="Sindhi"  
replace ReSoAsian=1 if `var'=="Sinhalese"  
replace ReSoAsian=1 if `var'=="Tamil"  
replace ReSoAsian=1 if regexm(`var', "Afghan") ==1   
replace ReSoAsian=1 if regexm(`var', "Tajik") ==1   
replace ReSoAsian=1 if regexm(`var', "Uzbek") ==1  
 }
 
/*ReAsianInd*/
gen ReAsianInd =.

foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReAsianInd=1 if regexm(`var', "Asian Indian") ==1  & RACASN==1
replace ReAsianInd=1 if regexm(`var', "Bengali") ==1  		& RACASN==1
replace ReAsianInd=1 if regexm(`var', "East Indian") ==1  	& RACASN==1
replace ReAsianInd=1 if regexm(`var', "Panjabi") ==1  		& RACASN==1
replace ReAsianInd=1 if regexm(`var', "Punjabi") ==1  		& RACASN==1
replace ReAsianInd=1 if regexm(`var', "Hindi") ==1  			& RACASN==1
replace ReAsianInd=1 if regexm(`var', "Sinhala") ==1  		& RACASN==1
replace ReAsianInd=1 if regexm(`var', "West Indian") ==1		 & RACASN==1
replace ReAsianInd=1 if regexm(`var', "Telugu") ==1  			& RACASN==1
replace ReAsianInd=1 if regexm(`var', "Kannada") ==1  		& RACASN==1 
replace ReAsianInd=1 if regexm(`var', "Asian Indian") ==1   &   RAC1P!=1
replace ReAsianInd=1 if regexm(`var', "Bengali") ==1   		&   RAC1P!=1
replace ReAsianInd=1 if regexm(`var', "East Indian") ==1  	 &   RAC1P!=1
replace ReAsianInd=1 if regexm(`var', "Panjabi") ==1  		&   RAC1P!=1
replace ReAsianInd=1 if regexm(`var', "Punjabi") ==1  	 &   RAC1P!=1
replace ReAsianInd=1 if regexm(`var', "Hindi") ==1   		&   RAC1P!=1
replace ReAsianInd=1 if regexm(`var', "Sinhala") ==1   		&   RAC1P!=1
replace ReAsianInd=1 if regexm(`var', "West Indian") ==1 	&   RAC1P!=1
replace ReAsianInd=1 if regexm(`var', "Telugu") ==1   &   RAC1P!=1
replace ReAsianInd=1 if regexm(`var', "Kannada") ==1   &   RAC1P!=1 
replace ReAsianInd=1 if regexm(`var', "Assamese") ==1  
replace ReAsianInd=1 if regexm(`var', "Bengali") ==1   
replace ReAsianInd=1 if regexm(`var', "Gujarati") ==1     
replace ReAsianInd=1 if regexm(`var', "Hindi") ==1     
replace ReAsianInd=1 if regexm(`var', "Kannada") ==1     
replace ReAsianInd=1 if regexm(`var', "Malayalam") ==1     
replace ReAsianInd=1 if regexm(`var', "Marathi") ==1  
replace ReAsianInd=1 if regexm(`var', "Panjabi") ==1  
replace ReAsianInd=1 if regexm(`var',"Oriya"  ) ==1 
replace ReAsianInd=1 if regexm(`var',"Punjabi"  ) ==1 
replace ReAsianInd=1 if regexm(`var',"Rajasthani" ) ==1  
replace ReAsianInd=1 if regexm(`var',"Sanskrit"  ) ==1 
replace ReAsianInd=1 if regexm(`var',"Telugu"   ) ==1 
replace ReAsianInd=1 if regexm(`var',"Zomi") ==1 
replace ReAsianInd =1 if MIGSP==210 & RACASN==1
replace ReAsianInd =1 if POBP==210  & RACASN==1
replace ReAsianInd=1 if ANC1PS=="Indian"  & RACASN==1
replace ReAsianInd=1 if ANC2PS=="Indian"  & RACASN==1
replace ReAsianInd=1 if ANC1PS=="Asian Indian" 
replace ReAsianInd=1 if ANC2PS=="Asian Indian"
  }

**MYANMAR
gen ReMyanmar =.
replace ReMyanmar=1 if ANC2P==700
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReMyanmar=1 if regexm(`var', "Burme") ==1  & RACASN==1
replace ReMyanmar=1 if regexm(`var', "Myanmar") ==1  & RACASN==1
replace ReMyanmar=1 if regexm(`var', "Karen") ==1  & RACASN==1
replace ReMyanmar=1 if regexm(`var', "Chin languag") ==1  & RACASN==1
replace ReMyanmar=1 if regexm(`var', "Burme") ==1   &   RAC1P!=1
replace ReMyanmar=1 if regexm(`var', "Myanmar") ==1   &   RAC1P!=1
replace ReMyanmar=1 if regexm(`var', "Karen") ==1   &   RAC1P!=1
replace ReMyanmar=1 if regexm(`var', "Chin languag") ==1   &   RAC1P!=1
replace ReMyanmar=1 if  regexm(`var', "Falam Chin") ==1
replace ReMyanmar=1 if  regexm(`var', "Tedim Chin") ==1  
replace ReMyanmar=1 if regexm(`var', "Burme") ==1  
replace ReMyanmar=1 if regexm(`var', "Burma") ==1 
replace ReMyanmar=1 if regexm(`var', "Karen") ==1  
replace ReMyanmar=1 if regexm(`var', "Myanma") ==1  
replace ReMyanmar=1 if regexm(`var',"Falam"  ) ==1 
replace ReMyanmar=1 if regexm(`var',"Kachin"  ) ==1 
replace ReMyanmar=1 if regexm(`var',"Rohingya"  ) ==1 
replace ReMyanmar=1 if `var'=="Falam"  
replace ReMyanmar=1 if `var'=="Kachin"  
replace ReMyanmar=1 if `var'=="Rohingya" 
 }
 

*ReCambodian
gen ReCambodian =.
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReCambodian=1 if regexm(`var', "Cambodia") ==1  & RACASN==1
replace ReCambodian=1 if regexm(`var', "Khmer") ==1  & RACASN==1
 }
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReCambodian=1 if regexm(`var', "Khmer") ==1  & RACASN==1
 }
foreach var of varlist  RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  HISPS  {
replace ReCambodian=1 if regexm(`var', "Cambodia") ==1   &   RAC1P!=1
replace ReCambodian=1 if regexm(`var', "Khmer") ==1   &   RAC1P!=1
 }
  
*CHINESE
gen ReChinese = .
replace ReChinese = 1 if RAC3P==5
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReChinese=1 if regexm(`var', "Chinese") ==1  & RACASN==1
replace ReChinese=1 if regexm(`var', "Mandarin") ==1  & RACASN==1
replace ReChinese=1 if regexm(`var', "Cantonese") ==1  & RACASN==1
replace ReChinese=1 if regexm(`var', "Hong Kong") ==1  & RACASN==1
replace ReChinese=1 if regexm(`var', "Taiwan") ==1  & RACASN==1
replace ReChinese=1 if regexm(`var', "China") ==1  & RACASN==1
replace ReChinese=1 if  regexm(`var', "Taochiew") ==1  & RACASN==1

 }
foreach var of varlist  RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  HISPS  {
replace ReChinese=1 if regexm(`var', "Chinese") ==1   &   RAC1P!=1
replace ReChinese=1 if regexm(`var', "Mandarin") ==1   &   RAC1P!=1
replace ReChinese=1 if regexm(`var', "Cantonese") ==1   &   RAC1P!=1
replace ReChinese=1 if regexm(`var', "Hong Kong") ==1   &   RAC1P!=1
replace ReChinese=1 if regexm(`var', "Taiwan") ==1   &   RAC1P!=1
replace ReChinese=1 if regexm(`var', "China") ==1   &   RAC1P!=1
replace ReChinese=1 if  regexm(`var', "Taochiew") ==1  & RAC1P==1
 }
*HMONG 
gen ReHmong =.
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReHmong=1 if regexm(`var', "Hmong") ==1  & RACASN==1
replace ReHmong=1 if regexm(`var', "Iu Mien") ==1   & RACASN==1
 }
foreach var of varlist  RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  HISPS  {
replace ReHmong=1 if regexm(`var', "Hmong") ==1   &   RAC1P!=1
replace ReHmong=1 if regexm(`var', "Iu Mien") ==1   &   RAC1P!=1
 }
*ReLaotian
gen ReLaotian =.
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReLaotian=1 if regexm(`var', "Lao") ==1  & RACASN==1

 }
foreach var of varlist  RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  HISPS  {
replace ReLaotian=1 if regexm(`var', "Lao") ==1   &   RAC1P!=1 
 }
*ReKorean
gen ReKorean =.
replace ReKorean = 1 if RAC3P==8
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReKorean=1 if regexm(`var', "Korea") ==1  & RACASN==1

 }
foreach var of varlist  RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  HISPS  {
replace ReKorean=1 if regexm(`var', "Korea") ==1   &   RAC1P!=1 
 }
*ReJapanese
gen ReJapanese =.
foreach var of varlist POBPS  MIGSPS   {
replace ReJapanese=1 if regexm(`var', "Japan") ==1  & RACASN==1
replace ReJapanese=1 if regexm(`var', "Okina") ==1  & RACASN==1
 }
 foreach var of varlist  RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  HISPS  {
replace ReJapanese=1 if regexm(`var', "Japan") ==1   &   RAC1P!=1
replace ReJapanese=1 if regexm(`var', "Okina")==1   &   RAC1P!=1
replace ReJapanese=1 if regexm(`var', "Japan") ==1   & RACASN==1
replace ReJapanese=1 if regexm(`var', "Okina")==1   & RACASN==1
 }

gen ReFilipino=.
foreach var of varlist POBPS MIGSPS   {
replace ReFilipino=1 if regexm(`var', "Philippin") ==1  & RACASN==1
replace ReFilipino=1 if regexm(`var', "Filipin") ==1  & RACASN==1
replace ReFilipino=1 if regexm(`var', "Tagalog") ==1  & RACASN==1
replace ReFilipino=1 if regexm(`var', "Bisaya") ==1  & RACASN==1
replace ReFilipino=1 if regexm(`var', "Cebuuano") ==1  & RACASN==1
replace ReFilipino=1 if regexm(`var', "Llocano") ==1  & RACASN==1
replace ReFilipino=1 if regexm(`var', "Hiligay") ==1  & RACASN==1
replace ReFilipino=1 if regexm(`var', "Ilonggo") ==1  & RACASN==1
replace ReFilipino=1 if regexm(`var', "Waray") ==1  & RACASN==1
replace ReFilipino=1 if regexm(`var', "Kapampan") ==1  & RACASN==1
replace ReFilipino=1 if regexm(`var', "Maguindan") ==1  & RACASN==1
replace ReFilipino=1 if regexm(`var', "Pangasin") ==1  & RACASN==1
 }
foreach var of varlist  RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  HISPS  {
replace ReFilipino=1 if regexm(`var', "Philippin") ==1   &   RAC1P!=1
replace ReFilipino=1 if regexm(`var', "Filipin") ==1   &   RAC1P!=1
replace ReFilipino=1 if regexm(`var', "Tagalog") ==1   &   RAC1P!=1
replace ReFilipino=1 if regexm(`var', "Bisaya") ==1   &   RAC1P!=1
replace ReFilipino=1 if regexm(`var', "Cebuuano") ==1   &   RAC1P!=1
replace ReFilipino=1 if regexm(`var', "Llocano") ==1   &   RAC1P!=1
replace ReFilipino=1 if regexm(`var', "Hiligay") ==1   &   RAC1P!=1
replace ReFilipino=1 if regexm(`var', "Ilonggo") ==1   &   RAC1P!=1
replace ReFilipino=1 if regexm(`var', "Waray") ==1   &   RAC1P!=1
replace ReFilipino=1 if regexm(`var', "Kapampan") ==1   &   RAC1P!=1
replace ReFilipino=1 if regexm(`var', "Maguindan") ==1   &   RAC1P!=1
replace ReFilipino=1 if regexm(`var', "Pangasin") ==1   &   RAC1P!=1

 }
*ReVietnamese
gen ReVietnamese =.
 foreach var of varlist POBPS MIGSPS   {
replace ReVietnamese=1 if regexm(`var', "Vietnam") ==1  & RACASN==1
 }
foreach var of varlist  RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  HISPS  {
replace ReVietnamese=1 if regexm(`var', "Vietnam") ==1   &   RAC1P!=1 
 }
foreach var of varlist  RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  HISPS  {
replace ReVietnamese=1 if regexm(`var', "Vietnam") ==1   &   RACASN==1
 }
*******************************************************************
*15 *******************************************************************
/*https://www.nacacnet.org/globalassets/documents/professional-development/guiding-the-way-to-inclusion/2018-presentations/b1_understanding-the-implications-of-disaggregating-data-for-asian.asian-american-students.pdf*/
*******************************************************************
*SE ASIAN ReMyanmar, Cambodia, Laos, Malaysia, Philippines, Singapore, Thailand, ReVietnamese
gen ReAsianSE=.
 foreach var of varlist POBPS MIGSPS   {
replace ReAsianSE=1 if regexm(`var', "Thai") ==1  & RACASN==1
replace ReAsianSE=1 if regexm(`var', "Singapore") ==1  & RACASN==1
replace ReAsianSE=1 if regexm(`var', "Malay") ==1  & RACASN==1
 }
foreach var of varlist  RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  HISPS  {
replace ReAsianSE=1 if regexm(`var', "Thai") ==1   &   RAC1P!=1
replace ReAsianSE=1 if regexm(`var', "Singapore") ==1   &   RAC1P!=1
replace ReAsianSE=1 if regexm(`var', "Malay") ==1   &   RAC1P!=1
 }
replace ReAsianSE=1 if ReVietnamese ==1
replace ReAsianSE=1 if ReCambodian ==1 
replace ReAsianSE=1 if ReMyanmar ==1
replace ReAsianSE=1 if ReFilipino ==1
replace ReAsianSE=1 if ReLaotian ==1
*******************************************************************
* 16 East Asians: ReChinese, ReJapanese, ReKorean, Mongolian, Okinawan Taiwanese 
*******************************************************************
gen ReAsianE=.
foreach var of varlist   RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  HISPS  {
replace ReAsianE=1 if regexm(`var', "Mongolia") ==1   &   RAC1P!=1
replace ReAsianE=1 if regexm(`var', "Chinese") ==1   &   RAC1P!=1
replace ReAsianE=1 if regexm(`var', "Mandarian") ==1   &   RAC1P!=1
replace ReAsianE=1 if regexm(`var', "Cantonese") ==1   &   RAC1P!=1
replace ReAsianE=1 if regexm(`var', "Japan") ==1   &   RAC1P!=1
replace ReAsianE=1 if regexm(`var', "Korean") ==1   &   RAC1P!=1
replace ReAsianE=1 if regexm(`var', "Okinawa") ==1   &   RAC1P!=1
replace ReAsianE=1 if regexm(`var', "Taiwan") ==1   &   RAC1P!=1
 }
replace ReAsianE =1 if ReKorean ==1
replace ReAsianE =1 if ReChinese ==1
replace ReAsianE =1 if ReJapanese ==1

foreach var of varlist POBPS MIGSPS   {
replace ReAsianE=1 if regexm(`var', "Mongolia") ==1  & RACASN==1
replace ReAsianE=1 if regexm(`var', "Chinese") ==1   &  RACASN==1
replace ReAsianE=1 if regexm(`var', "Mandarian") ==1   &  RACASN==1
replace ReAsianE=1 if regexm(`var', "Cantonese") ==1   &  RACASN==1
replace ReAsianE=1 if regexm(`var', "Japan") ==1   &  RACASN==1
replace ReAsianE=1 if regexm(`var', "Korean") ==1   &   RACASN==1
replace ReAsianE=1 if regexm(`var', "Okinawa") ==1   &   RACASN==1
replace ReAsianE=1 if regexm(`var', "Taiwan") ==1   &  RACASN==1
 }
 *******************************************************************
 *17 Central ReAsianG – Uzbeks, Turkic peoples, Kazakhs, Tajiks, Uyghurs, Kyrgyz people, Turkmens
 *******************************************************************
gen ReAsianC=.
 foreach var of varlist POBPS MIGSPS   {
replace ReAsianC=1 if regexm(`var', "Uzbek") ==1  & RACASN==1
replace ReAsianC=1 if regexm(`var', "Kazak") ==1 & RACASN==1
replace ReAsianC=1 if regexm(`var', "Turk") ==1  & RACASN==1
replace ReAsianC=1 if regexm(`var', "Uyghur") ==1  & RACASN==1
replace ReAsianC=1 if regexm(`var', "Kyrgyz") ==1  & RACASN==1
 }
 
foreach var of varlist   RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  HISPS  {
replace ReAsianC=1 if regexm(`var', "Uzbek") ==1   &   RAC1P!=1
replace ReAsianC=1 if regexm(`var', "Kazak") ==1   &   RAC1P!=1
replace ReAsianC=1 if regexm(`var', "Turk") ==1   &   RAC1P!=1
replace ReAsianC=1 if regexm(`var', "Tajik") ==1   &   RAC1P!=1
replace ReAsianC=1 if regexm(`var', "Uyghur") ==1  &  RAC1P!=1
replace ReAsianC=1 if regexm(`var', "Kyrgyz") ==1  &  RAC1P!=1
 }


replace ReAsianS=1 if ReAsianInd==1
replace ReAsianS=1 if ReSoAsian==1

egen float ReAsianG = rownonmiss(ReAsianInd ReCambodian ReChinese ReFilipino ///
ReHmong ReJapanese ReKorean ReLaotian ReMyanmar ReVietnamese ReSoAsian ) 
replace ReAsianG =1 if ReAsianG >=2 & ReAsianG! =.
* svy:  tab  ReAsianG , count ci format(%-12.0g)  csepwidth(10) stubwidth(30)
* 257140-  262571
*2019 estimates: 263017	3066

 tab RACASN if ReAsianG ==0 
foreach var of varlist  RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  HISPS  {
tab `var' if ReAsianG==0 &  RACASN ==1
 } 
 *******************************************************************
*18***ReAsianOth********
*******************************************************************
gen ReAsianOth =.
foreach var of varlist  RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  HISPS  {
replace ReAsianOth=1 if regexm(`var', "Other Asian") ==1 & ReAsianG==0 &  RACASN ==1
replace ReAsianOth=1 if regexm(`var', "Indonesian") ==1  &  RACASN ==1
 } 
foreach var of varlist POBPS MIGSPS   {
replace ReAsianOth=1 if regexm(`var', "Other Asian") ==1 & ReAsianG==0 &  RACASN ==1
 } 
foreach var of varlist LANPS   {
replace ReAsianOth=1 if regexm(`var', "Other languages of Asia") ==1 & ReAsianG==0 &  RACASN ==1
 } 

 *added Uzbek, Kazak, Turk, Uyghur, Krygyz to AsianOther 7/2/2022
foreach var of varlist POBPS MIGSPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  {
replace ReAsianOth=1 if regexm(`var', "Thai") ==1  & RACASN==1
replace ReAsianOth=1 if regexm(`var', "Malaysia") ==1 & RACASN==1
replace ReAsianOth=1 if regexm(`var', "Mongoli") ==1  & RACASN==1
replace ReAsianOth=1 if regexm(`var', "Uzbek") ==1  & RACASN==1
replace ReAsianOth=1 if regexm(`var', "Kazak") ==1 & RACASN==1
replace ReAsianOth=1 if regexm(`var', "Turk") ==1  & RACASN==1
replace ReAsianOth=1 if regexm(`var', "Uyghur") ==1  & RACASN==1
replace ReAsianOth=1 if regexm(`var', "Kyrgyz") ==1  & RACASN==1

replace ReAsianOth=1 if  regexm(`var', "Iu Mien") ==1    & RACASN==1
replace ReAsianOth=1 if `var'=="Malay"    & RACASN==1
replace ReAsianOth=1 if `var'=="Mon"    & RACASN==1
replace ReAsianOth=1 if `var'=="Mongolian"     & RACASN==1
replace ReAsianOth=1 if `var'=="Thai"     & RACASN==1
replace ReAsianOth=1 if `var'=="Tibetan"   & RACASN==1
replace ReAsianOth=1 if  regexm(`var', "Indonesian"  ) ==1     
replace ReAsianOth=1 if  regexm(`var', "Javanese"  ) ==1     
replace ReAsianOth=1 if  regexm(`var', "Austronesian"  ) ==1   
 }
 
 drop ReAsianG 
 
    egen float ReAsianG = rownonmiss( ReCambodian ReChinese ReFilipino ///
ReHmong ReJapanese ReKorean ReLaotian ReMyanmar ReVietnamese ReSoAsian ReAsianInd) 
foreach var of varlist POBPS MIGSPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  {
replace ReAsianOth=1 if regexm(`var', "Other Asian") ==1  & RACASN==1 & ReAsianG ==0

 }
 

   drop ReAsianG

**19***************************************************************
   egen float ReAsianG = rownonmiss( ReCambodian ReChinese ReFilipino ///
ReHmong ReJapanese ReKorean ReLaotian ReMyanmar ReVietnamese ReSoAsian ReAsianInd) 
replace ReAsianG =1 if ReAsianG >=2 & ReAsianG! =.
 *****************************************************************
gen ReAsianLeg =.
foreach var of varlist  RAC1PS RAC2PS RAC3PS  ANC1PS ANC2PS  LANPS  HISPS  {
replace ReAsianLeg=1 if regexm(`var', "Asia") ==1 & ReAsianG==0 &  RACASN ==1
 } 
 foreach var of varlist POBPS MIGSPS   {
replace ReAsianLeg=1 if regexm(`var', "Asia") ==1 & ReAsianG==0 &  RACASN ==1
 } 
drop ReAsianG

  egen float ReAsianG = rownonmiss( ReCambodian ReChinese ReFilipino ///
ReHmong ReJapanese ReKorean ReLaotian ReMyanmar ReVietnamese ReSoAsian ReAsianInd) 

replace ReAsianG =1 if ReAsianG >=2 & ReAsianG! =.
 
foreach var of varlist   RAC3PS  ANC1PS ANC2PS  {
tab `var' if ReAsianG==0 &  RACASN ==1
 } 

drop ReAsianG
egen float ReAsianG = rownonmiss( ReCambodian ReChinese ReFilipino ///
ReHmong ReJapanese ReKorean ReLaotian ReMyanmar ReVietnamese ReSoAsian ReAsianInd) 
tab ReAsianG ReAsianLeg , miss

replace ReAsianLeg =. if ReAsianOth ==1
replace ReAsianLeg =. if ReAsianG >=1 & ReAsianG!=.
tab ReAsianG ReAsianLeg , miss
replace ReAsianG =1 if ReAsianG >=2 & ReAsianG!=.
tab ReAsianG RACASN , miss
drop ReAsianG
  egen float ReAsianG = rownonmiss(ReAsianInd ReCambodian ReChinese ReFilipino ///
ReHmong ReJapanese ReKorean ReLaotian ReMyanmar ReVietnamese ReSoAsian ReAsianOth ReAsianLeg ) 
replace ReAsianG =1 if ReAsianG >=2 & ReAsianG!=.


foreach var of varlist  POBPS MIGSPS    RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS   {
tab `var' if ReAsianG==0 &  RACASN ==1
 } 

replace ReAsianLeg=1 if ReAsianG==0 & RACASN==1
for var ReAsianG: tab  X [fw=PWGTP]  if ST ==41 
  *Census 2020: all ages: 275296
  *  251,200 
 for var ReAsianG: tab  X [fw=PWGTP]  if ST ==41 & AGEP>=18 
 *189,598
*svy: tab  ReAsianLeg   , count ci format(%-12.0g)  csepwidth(10) stubwidth(30)

drop ReAsianG 

  egen float ReAsianG = rownonmiss(ReAsianInd ReCambodian ReChinese ReFilipino ///
ReHmong ReJapanese ReKorean ReLaotian ReMyanmar ReVietnamese ReSoAsian ReAsianOth ReAsianLeg ) 
replace ReAsianG =1 if ReAsianG >=2 & ReAsianG!=.
gen mark =1 if RACASN==1 &  ReAsianG==0
 tab mark
 
drop ReAsianG  mark
 *****************************************************************************
 **20 ReNHPIG 
************************************************************************
 
 gen RACNHPI=1 if RACPI==1
replace RACNHPI=1 if RACNH==1
replace RACNHPI=0 if RACNHPI==.


*Chamorro
gen ReCham = 1 if RAC3P==12 & RACNHPI==1
replace ReCham =1 if LANP == 3220  
replace ReCham =1 if ANC1P == 822 
replace ReCham =1 if ANC2P == 822 

foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReCham=1 if regexm(`var', "Chamo") ==1   & RACNHPI==1
replace ReCham=1 if regexm(`var', "Guam") ==1   &  RACNHPI==1  &   RAC1P!=1
replace ReCham=1 if regexm(`var', "Guam") ==1   &  RACNHPI==1  &   RAC1P==7
replace ReCham=1 if regexm(`var', "Chamo") ==1   &  RACNHPI==1  &   RAC1P==7
replace ReCham=1 if regexm(`var', "Guamanian or Chamorro") ==1  
 } 
 

*ReMarshallese Islands5
gen ReMarshallese =.
foreach var of varlist POBPS  MIGSPS   {
replace ReMarshallese=1 if regexm(`var', "Marshall") ==1   & RACNHPI==1
 }
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReMarshallese=1 if regexm(`var', "Marshall") ==1   &   RAC1P!=1
 }
************************************************************************
/*21 Federated States of Micronesia:Yap Chuuk	Pohnpei	Kosrae Palau*/
************************************************************************
gen ReCOFA =.
replace ReCOFA=1 if POBP==512 & RACNHPI==1
replace ReCOFA=1 if ANC1P==820 
replace ReCOFA=1 if ANC2P==820 
foreach var of varlist  RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  HISPS  {
replace ReCOFA=1 if regexm(`var', "Micronesia") ==1   &   RAC1P!=1 
replace ReCOFA=1 if regexm(`var', "Palau") ==1   &   RAC1P!=1 
replace ReCOFA=1 if regexm(`var', "Kosrae") ==1   &   RAC1P!=1 
replace ReCOFA=1 if regexm(`var', "Pohnpei") ==1   &   RAC1P!=1 
replace ReCOFA=1 if regexm(`var', "Chuuk") ==1   &   RAC1P!=1 
replace ReCOFA=1 if regexm(`var', "Yap") ==1   &   RAC1P!=1 
 }
 
foreach var of varlist POBPS MIGSPS   {
replace ReCOFA=1 if regexm(`var', "Micronesia") ==1   & RACNHPI==1
replace ReCOFA=1 if regexm(`var', "Palau") ==1   & RACNHPI==1
replace ReCOFA=1 if regexm(`var', "Kosrae") ==1   & RACNHPI==1
replace ReCOFA=1 if regexm(`var', "Pohnpei") ==1   & RACNHPI==1
replace ReCOFA=1 if regexm(`var', "Chuuk") ==1   & RACNHPI==1
replace ReCOFA=1 if regexm(`var', "Yap") ==1   & RACNHPI==1
 }
replace ReCOFA=.  if ReMarshallese==1
replace ReCOFA=.  if ReCham==1

label var  ReCOFA "Communities of Micronesian Region"


*ReSamoan
gen ReSamoan =. 
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReSamoan=1 if regexm(`var', "Samoa") ==1    & RACNHPI==1
 }
foreach var of varlist  RAC1PS RAC2PS RAC3PS RAC3PS  LANPS  HISPS  {
replace ReSamoan=1 if regexm(`var', "Samoa") ==1     & RACNHPI==1
 }
 *ReTongan
gen ReTongan =. 
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReTongan=1 if regexm(`var', "Tonga") ==1    & RACNHPI==1
replace ReTongan=1 if regexm(`var', "Tonga") ==1    &  RAC1P!=1 
 }
 
 
  *ReNatHaw
gen ReNatHaw =1 if RACNH==1
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReNatHaw=1 if regexm(`var', "NatHaw") ==1     & RACNHPI==1
 }
 


************************************************************************
 *23***ReNHPIoth, ReNatHaw
 ************************************************************************
gen ReNHPIoth =.
foreach var of varlist  RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  HISPS  {
replace ReNHPIoth=1 if regexm(`var', "Australia") ==1   &   RAC1P!=1
replace ReNHPIoth=1 if regexm(`var', "New Zealander") ==1   &   RAC1P!=1
replace ReNHPIoth=1 if regexm(`var', "Polynesian") ==1   &   RAC1P!=1
replace ReNHPIoth=1 if regexm(`var', "Fiji") ==1   &   RAC1P!=1
replace ReNHPIoth=1 if regexm(`var', "Pacific Islander") ==1   &   RAC1P!=1
replace ReNHPIoth=1 if regexm(`var', "Other Pacific")==1   &   RAC1P!=1 
 }
 foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReNHPIoth=1 if regexm(`var', "Australia") ==1  & RACNHPI==1
replace ReNHPIoth=1 if regexm(`var', "New Zealander") ==1  & RACNHPI==1
replace ReNHPIoth=1 if regexm(`var', "Polynesian") ==1  & RACNHPI==1
replace ReNHPIoth=1 if regexm(`var', "Fiji") ==1  & RACNHPI==1
replace ReNHPIoth=1 if regexm(`var', "Pacific Islander") ==1   & RACNHPI==1
replace ReNHPIoth=1 if regexm(`var', "Other Pacific") ==1  & RACNHPI==1

 replace ReNHPIoth=1 if `var'=="Carolinian"  
replace ReNHPIoth=1 if `var'=="Fijian"  
replace ReNHPIoth=1 if `var'=="Indonesian"  
replace ReNHPIoth=1 if `var'=="Javanese"  
replace ReNHPIoth=1 if `var'=="Malagasy" 
 }

foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReNatHaw=1 if regexm(`var', "Hawaiian") ==1  & ReNHPIoth ==. & RACNHPI==1
 }
 


 ******
*ReNHPILeg 
gen ReNHPILeg=.
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReNHPILeg=1 if regexm(`var', "Native Hawaiian and Other Pacific Islander") ==1    & RACNHPI==1
replace ReNHPILeg=1 if regexm(`var', "Native Hawaiian and Other Pacific Islander") ==1      & RACNHPI==1
replace ReNHPILeg=1 if regexm(`var', "NH & OPI") ==1     & RACNHPI==1
replace ReNHPILeg=1 if regexm(`var', "NH & OPI") ==1     & RACNHPI==1
replace ReNHPILeg=1 if regexm(`var', "Other NH and Other Pacific Islander") ==1    & RACNHPI==1
replace ReNHPILeg=1 if regexm(`var', "Other NH and Other Pacific Islander") ==1      & RACNHPI==1
 }
 
 
 ************************************************************************
  egen float ReNHPIG = rownonmiss( ReNHPILeg ReCham ReMarshallese ReCOFA ReNatHaw ReSamoan  ReNHPIoth )
tab RACNHPI if ReNHPIG==0
 ************************************************************************
replace ReNHPIG =1 if ReNHPIG >=2 & ReNHPIG! =.

   for var ReNHPIG: tab  X [fw=PWGTP]  if ST ==41 
  *Census 2020: all ages: 39709
  * 35,838 
 for var ReNHPIG: tab  X [fw=PWGTP]  if ST ==41 & AGEP>=18 
 * 25,040 

  tab ReNHPIG RACNHPI, miss
  
foreach var of varlist  POBPS MIGSPS RAC1PS RAC2PS RAC3PS ANC1PS ANC2PS  LANPS   {
tab `var' if ReNHPIG==0 &  RACNHPI ==1
 } 
replace ReNatHaw=1 if ReNHPIG==0 &  RACNH ==1 
replace ReNHPIoth=1 if ReNHPIG==0 &  RACPI ==1

drop ReNHPIG 
*****************************************************************************
save "TempFile1v2.dta", replace
**23************************************************************************* 


use "TempFile1v2.dta", replace
 


  ************************************************************************
  *24*ReMENAG
  **************************************************************************
/* ReNoAfr North ReAfrican Algeria Egypt Libya Morocco Tunisia*/
gen ReNoAfr =.
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReNoAfr=1 if regexm(`var', "Algeria") ==1 
replace ReNoAfr=1 if regexm(`var', "Egypt") ==1 
replace ReNoAfr=1 if regexm(`var', "Libya") ==1 
replace ReNoAfr=1 if regexm(`var', "Morocco") ==1 
replace ReNoAfr=1 if regexm(`var', "Algeria") ==1 
replace ReNoAfr=1 if regexm(`var', "Morocc") ==1 
replace ReNoAfr=1 if regexm(`var', "Tunisia") ==1 
replace ReNoAfr=1 if regexm(`var', "Northern Africa") ==1 
 }
  
replace ReNoAfr =1 if ANC1P >=400 & ANC1P<=411 
replace ReNoAfr =1 if ANC2P >=400 & ANC2P<=411 
replace ReNoAfr =1 if MIGSP ==414
replace ReNoAfr =1 if POBP ==414

************************************************************************
/*Mid East Bahrain Cyprus Iran Iraq Israel Jordan Kuwait
Lebanon Oman Palestine Qatar Saudi Arabia Syria Turkey United Arab Emirates Yemen
2 Afghanistan is also considered part of Eastern Europe by some.
3 Afghanistan and Azerbaijan are also considered in the Middle East by some.
4 Afghanistan is also considered South Asian by some.*/
**for consistency - including Afghansistan as Middle eAstern
**ADDED Uzbek
  
gen ReMidEast =.
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReMidEast=1 if regexm(`var', "Cyprus") ==1 
replace ReMidEast=1 if regexm(`var', "Iran") ==1 
replace ReMidEast=1 if regexm(`var', "Iraq") ==1 
replace ReMidEast=1 if regexm(`var', "Israel") ==1 
replace ReMidEast=1 if regexm(`var', "Jordan") ==1 
replace ReMidEast=1 if regexm(`var', "Kuwait") ==1 
replace ReMidEast=1 if regexm(`var', "Oman") ==1 
replace ReMidEast=1 if regexm(`var', "Palestine") ==1 
replace ReMidEast=1 if regexm(`var', "Qatar") ==1 
replace ReMidEast=1 if regexm(`var', "Yemen") ==1 
replace ReMidEast=1 if regexm(`var', "Afghanis") ==1 
replace ReMidEast=1 if regexm(`var', "Syria") ==1 
replace ReMidEast=1 if regexm(`var', "Emirates") ==1 
replace ReMidEast=1 if regexm(`var', "Turkey") ==1 
replace ReMidEast=1 if regexm(`var', "Yemen") ==1 
replace ReMidEast=1 if regexm(`var', "Arab") ==1 
replace ReMidEast=1 if regexm(`var', "Lebanon") ==1 
replace ReMidEast=1 if regexm(`var', "Turkish") ==1 
replace ReMidEast=1 if regexm(`var', "Yiddish") ==1 
replace ReMidEast=1 if regexm(`var', "Hebrew") ==1 
replace ReMidEast=1 if regexm(`var', "Pushto") ==1 
replace ReMidEast=1 if regexm(`var', "Persian") ==1 
replace ReMidEast=1 if regexm(`var', "Kurdish") ==1 
 }

************************************************************************
 gen ReMENALeg =.
foreach var of varlist  LANPS ANC1PS ANC2PS   {
replace ReMENALeg=1 if regexm(`var', "Arabic") ==1 & ReMidEast ==. & ReNoAfr==. 
replace ReMENALeg=1 if regexm(`var', "Other Arab") ==1 & ReMidEast ==. & ReNoAfr==. 
   }
   
egen float ReMENAG = rownonmiss( ReMENALeg ReMidEast ReNoAfr)
replace ReMENAG =1 if ReMENAG>=2 & ReMENAG!=.
  
****************************************************************************
*25 WHITE
**********************************************************************

/*Eastern European: Albania Armenia Azerbaijan Estonia Georgia Hungary Latvia Lithuania Moldova Romania*/


gen ReEastEur =.
foreach var of varlist POBPS MIGSPS  RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  HISPS  {
replace ReEastEur=1 if regexm(`var', "Albania") ==1  & RACWHT==1
replace ReEastEur=1 if regexm(`var', "Armenia") ==1  & RACWHT==1
replace ReEastEur=1 if regexm(`var', "Azerbaij") ==1  & RACWHT==1
replace ReEastEur=1 if regexm(`var', "Estonia") ==1  & RACWHT==1
replace ReEastEur=1 if regexm(`var', "Georgia") ==1  & RACWHT==1
replace ReEastEur=1 if regexm(`var', "Hungar") ==1  & RACWHT==1
replace ReEastEur=1 if regexm(`var', "Latvia") ==1  & RACWHT==1
replace ReEastEur=1 if regexm(`var', "Lithuani") ==1  & RACWHT==1
replace ReEastEur=1 if regexm(`var', "Moldov") ==1  & RACWHT==1
replace ReEastEur=1 if regexm(`var', "Rom") ==1  & RACWHT==1
replace ReEastEur=1 if regexm(`var', "Eastern Europe") ==1  & RACWHT==1
replace ReEastEur=1 if regexm(`var', "Yiddish") ==1   & RACWHT==1


 }

 foreach var of varlist  RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  HISPS {
replace ReEastEur=1 if regexm(`var', "Albania") ==1     & RACSOR==1
replace ReEastEur=1 if regexm(`var', "Armenia") ==1     & RACSOR==1
replace ReEastEur=1 if regexm(`var', "Azerbaij") ==1     & RACSOR==1
replace ReEastEur=1 if regexm(`var', "Estonia") ==1     & RACSOR==1
replace ReEastEur=1 if regexm(`var', "Georgia") ==1     & RACSOR==1
replace ReEastEur=1 if regexm(`var', "Hungar") ==1     & RACSOR==1
replace ReEastEur=1 if regexm(`var', "Latvia") ==1     & RACSOR==1
replace ReEastEur=1 if regexm(`var', "Lithuani") ==1     & RACSOR==1
replace ReEastEur=1 if regexm(`var', "Moldov") ==1     & RACSOR==1
replace ReEastEur=1 if regexm(`var', "Rom") ==1     & RACSOR==1
replace ReEastEur=1 if regexm(`var', "Eastern Europe") ==1     & RACSOR==1
 }

 tab ReEastEur
*Note 7/23/2022 added    & RACSOR==1 to control the white cateogires
************************************************************************
/* 26 ReSlavic: Bosnia & Herzegovina Bulgaria Belarus
Czech Republic Croatia Macedonia Montenegro Poland
Russia Serbia Slovakia Slovenia Ukraine*/

gen ReSlavic =.
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS {
replace ReSlavic=1 if regexm(`var', "Bosnia") ==1  & RACWHT==1
replace ReSlavic=1 if regexm(`var', "Herzego") ==1  & RACWHT==1
replace ReSlavic=1 if regexm(`var', "Bulgaria") ==1  & RACWHT==1
replace ReSlavic=1 if regexm(`var', "Belarus") ==1  & RACWHT==1
replace ReSlavic=1 if regexm(`var', "Czech") ==1  & RACWHT==1
replace ReSlavic=1 if regexm(`var', "Croatia") ==1  & RACWHT==1
replace ReSlavic=1 if regexm(`var', "Serbocroat") ==1  & RACWHT==1
replace ReSlavic=1 if regexm(`var', "Macedonia") ==1  & RACWHT==1
replace ReSlavic=1 if regexm(`var', "Montenegro") ==1  & RACWHT==1
replace ReSlavic=1 if regexm(`var', "Poland") ==1  & RACWHT==1
replace ReSlavic=1 if regexm(`var', "Polish") ==1   & RACWHT==1
replace ReSlavic=1 if regexm(`var', "Russia") ==1  & RACWHT==1
replace ReSlavic=1 if regexm(`var', "Ukrain") ==1  & RACWHT==1
replace ReSlavic=1 if regexm(`var', "Serbia") ==1  & RACWHT==1
replace ReSlavic=1 if regexm(`var', "Belorussian") ==1  & RACWHT==1
replace ReSlavic=1 if regexm(`var', "Slov") ==1  & RACWHT==1
replace ReSlavic=1 if regexm(`var', "Yugosl") ==1  & RACWHT==1
replace ReSlavic=1 if regexm(`var', "USSR") ==1  & RACWHT==1
replace ReSlavic=1 if regexm(`var', "Slavic") ==1  & RACWHT==1
 }

foreach var of varlist  RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS  HISPS {
replace ReSlavic=1 if regexm(`var', "Bosnia") ==1    & RACSOR==1
replace ReSlavic=1 if regexm(`var', "Herzego") ==1     & RACSOR==1
replace ReSlavic=1 if regexm(`var', "Bulgaria") ==1     & RACSOR==1
replace ReSlavic=1 if regexm(`var', "Belarus") ==1     & RACSOR==1
replace ReSlavic=1 if regexm(`var', "Czech") ==1     & RACSOR==1
replace ReSlavic=1 if regexm(`var', "Croati") ==1     & RACSOR==1
replace ReSlavic=1 if regexm(`var', "Serbocroat") ==1     & RACSOR==1
replace ReSlavic=1 if regexm(`var', "Macedonia") ==1     & RACSOR==1
replace ReSlavic=1 if regexm(`var', "Montenegro") ==1     & RACSOR==1
replace ReSlavic=1 if regexm(`var', "Poland") ==1     & RACSOR==1
replace ReSlavic=1 if regexm(`var', "Polish") ==1     & RACSOR==1 
replace ReSlavic=1 if regexm(`var', "Russia") ==1     & RACSOR==1
replace ReSlavic=1 if regexm(`var', "Ukrain") ==1     & RACSOR==1
replace ReSlavic=1 if regexm(`var', "Serbia") ==1     & RACSOR==1
replace ReSlavic=1 if regexm(`var', "Belorussia") ==1     & RACSOR==1
replace ReSlavic=1 if regexm(`var', "Slov") ==1     & RACSOR==1
replace ReSlavic=1 if regexm(`var', "Yugosl") ==1     & RACSOR==1
replace ReSlavic=1 if regexm(`var', "USSR") ==1     & RACSOR==1
replace ReSlavic=1 if regexm(`var', "Uzbek") ==1     & RACWHT==1
replace ReSlavic=1 if regexm(`var', "Tajik") ==1     & RACWHT==1
 }
tab ReSlavic

*27***********************************************************************
gen ReWestEur =.
replace ReWestEur =1 if ANC1P >=1 & ANC1P<=99  & RACWHT==1
replace ReWestEur =1 if ANC1P >=183 & ANC1P<=187 & RACWHT==1
replace ReWestEur =1 if ANC1P >=194 & ANC1P<=200 & RACWHT==1
replace ReWestEur =1 if LANP ==1565  & RACWHT==1
replace ReWestEur =1 if MIGSP >=109 & MIGSP<= 111 & RACWHT==1
replace ReWestEur =1 if MIGSP >=114 & MIGSP<= 138 & RACWHT==1

replace ReWestEur =1 if POBP >=109 & POBP<= 111 & RACWHT==1
replace ReWestEur =1 if POBP >=114 & POBP<= 138 & RACWHT==1

foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReWestEur=1 if regexm(`var', "Western Europe") ==1 & RACWHT==1
replace ReWestEur=1 if regexm(`var', "Northern Europe") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var', "German") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var', "Swiss") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var', "Afrikaans") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var', "Swedish") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var', "Dutch") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var', "Ital") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var', "Greek") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var', "Austria") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var', "Belgium") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var', "Irish") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var', "Denmark") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var', "Finland") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var', "England") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var', "Scot") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var', "Norwegia") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var', "French") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var', "Span") ==1  & RACWHT==1 & regexm(`var', "Not Spanish") !=1 
replace ReWestEur=1 if regexm(`var', "Danish") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var', "Scandina") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var', "Southern Europe") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var', "Danish") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var',"Basque") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var',"Catalan") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var',"Finnish") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var',"Flemish") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var',"Gaelic") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var',"Gailic") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var',"German") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var',"Hungarian") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var',"Iceland") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var',"Portug") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var',"Swed") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var',"Welsh") ==1  & RACWHT==1
replace ReWestEur=1 if regexm(`var',"Walloon") ==1  & RACWHT==1
 }
 
 order POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS ReWestEur
 list POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS ReWestEur in 32
 
  *Added 6/7/21 - changed RACWHT to RAC1P
 foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReWestEur=1 if regexm(`var', "Portug") ==1  & RAC1P==1 
replace ReWestEur=1 if regexm(`var', "French") ==1  & RAC1P==1 
 }
 
tab RAC1PS  RACSOR, miss
tab ReWestEur  RACSOR, miss
   ********************************************************************************
*28  7/23/22 - added controls - &  RACSOR==1
   ********************************************************************************
foreach var of varlist  POBPS  RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS {
replace ReWestEur=1 if regexm(`var', "Western Europe") ==1    &  RACSOR==1
replace ReWestEur=1 if regexm(`var', "Northern Europe") ==1     & RACSOR==1
replace ReWestEur=1 if regexm(`var', "German") ==1     &  RACSOR==1
replace ReWestEur=1 if regexm(`var', "Swiss") ==1     &  RACSOR==1
replace ReWestEur=1 if regexm(`var', "Afrikaans") ==1    & RACSOR==1
replace ReWestEur=1 if regexm(`var', "Swedish") ==1       & RACSOR==1
replace ReWestEur=1 if regexm(`var', "Dutch") ==1        & RACSOR==1
replace ReWestEur=1 if regexm(`var', "Ital") ==1     & RACSOR==1
replace ReWestEur=1 if regexm(`var', "Greek") ==1     & RACSOR==1
replace ReWestEur=1 if regexm(`var', "Austria") ==1     & RACSOR==1
replace ReWestEur=1 if regexm(`var', "Belgium") ==1     & RACSOR==1
replace ReWestEur=1 if regexm(`var', "Irish") ==1     & RACSOR==1
replace ReWestEur=1 if regexm(`var', "Denmark") ==1     & RACSOR==1
replace ReWestEur=1 if regexm(`var', "Finland") ==1     & RACSOR==1
replace ReWestEur=1 if regexm(`var', "Belgium") ==1     & RACSOR==1
replace ReWestEur=1 if regexm(`var', "Denmark") ==1     & RACSOR==1
replace ReWestEur=1 if regexm(`var', "Finland") ==1     & RACSOR==1
replace ReWestEur=1 if regexm(`var', "England") ==1     & RACSOR==1
replace ReWestEur=1 if regexm(`var', "Scot") ==1     & RACSOR==1
replace ReWestEur=1 if regexm(`var', "Norwegia") ==1     & RACSOR==1
replace ReWestEur=1 if regexm(`var', "Welsh") ==1     & RACSOR==1
replace ReWestEur=1 if regexm(`var', "Sicilian") ==1     & RACSOR==1
replace ReWestEur=1 if regexm(`var', "Scandinav") ==1     & RACSOR==1
replace ReWestEur=1 if regexm(`var', "Icelander") ==1     & RACSOR==1
replace ReWestEur=1 if regexm(`var', "Belgian") ==1     & RACSOR==1
replace ReWestEur=1 if regexm(`var', "Finnish") ==1     & RACSOR==1
*replace ReWestEur=1 if regexm(`var', "French") ==1  -took out on 6/7
 }
   ***********************************************************************
*29  Wasn't in 2015/19 file - added (2021) Spanish/Spaniard w/ controls
  ***********************************************************************
foreach var of varlist  RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS {
replace ReWestEur=1 if regexm(`var', "Span") ==1  & RAC1P==1   & regexm(`var', "Not Spanish") !=1 
replace ReWestEur=1 if regexm(`var', "Span") ==1  & RAC1P>=8 & HISPdi!=1 & regexm(`var', "Not Spanish") !=1 
 }
  ***********************************************************************
*30 *7/23/22 Added RACSOR as control**************************
  ***********************************************************************
 foreach var of varlist  ANC1PS ANC2PS   {
replace ReWestEur=1 if regexm(`var', "English") ==1  & RACWHT==1 
 replace ReWestEur=1 if regexm(`var', "British") ==1   & RACWHT==1 
  }
  
 foreach var of varlist  ANC1PS ANC2PS   {
replace ReWestEur=1 if regexm(`var', "English") ==1  & RACSOR==1 
replace ReWestEur=1 if regexm(`var', "British") ==1   & RACSOR==1 
  }
  ***********************************************************************
*31 ****************
  ***********************************************************************

gen ReOthwhite=. 
 foreach var of varlist  ANC1PS ANC2PS  HISPS  {
replace ReOthwhite=1 if regexm(`var', "Eurasian") ==1   & RACWHT==1
replace ReOthwhite=1 if RACWHT==1 & regexm(`var', "Not Spanish") !=1 & ReOthwhite==.
replace ReOthwhite=1 if RACWHT==1 & `var'=="White" & ReOthwhite==.
  }
replace ReOthwhite =1 if RACWHT==1 & ReMidEast==. & ReNoAfr==. & ReWestEur==. & ReEastEur ==. & ReSlavic==.
foreach var of varlist POBP RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS HISP {
tab `var' if RACWHT ==1 & ReWestEur==. & ReEastEur ==. & ReSlavic==. & ReMidEast==. & ReNoAfr==. & ReOthwhite==.
  }
foreach var of varlist POBP RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS HISP {
tab `var' if ReOthwhite ==1 
  }


egen float ReWhiteG = rownonmiss(ReWestEur ReEastEur ReSlavic ReOthwhite   ) 
replace ReWhiteG =1 if ReWhiteG>=2 & ReWhiteG!=.

gen ReWhiteLeg=1 if ReWhiteG ==0 & ReMidEast ==. & ReNoAfr==. & RACWHT==1 & ReMENALeg==. 

foreach var of varlist POBPS RAC1PS RAC2PS  RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReWhiteLeg=1 if ReWhiteG ==0 & RACWHT==1 &  regexm(`var', "White") ==1  & ReMENAG!=1
 }
for var  ReWhiteLeg:  tab  X [fw=PWGTP]  if ST ==41 

drop ReWhiteG
egen float ReWhiteG = rownonmiss(ReWestEur ReEastEur ReSlavic ReOthwhite  ) 
replace ReWhiteG =1 if ReWhiteG>=2 & ReWhiteG!=.

replace ReWhiteLeg=. if ReWhiteG==1 

drop ReWhiteG   ReMENAG

egen float ReWhiteG = rownonmiss(ReWestEur ReEastEur ReSlavic ReOthwhite ReWhiteLeg ) 
replace ReWhiteG =1 if ReWhiteG>=2 & ReWhiteG!=.

egen float ReMENAG = rownonmiss(ReMidEast ReNoAfr ReMENALeg) 
replace ReMENAG =1 if ReMENAG>=2 & ReMENAG!=.
tab RACWHT ReWhiteG if ReMENAG!=1, miss

for var  ReOthwhite:  tab  X [fw=PWGTP]  if ST ==41 
for var  ReWhiteLeg:  tab  X ReMENAG  [fw=PWGTP]  if ST ==41 
tab RACWHT if ReWhiteG!=1 & ReMENAG!=1

*ReWhiteG AOICS PSU Census 2020: 3593558
*   3,683,836
for var  ReWhiteG:  tab  X [fw=PWGTP]  if ST ==41 
for var  ReMENAG:  tab  X [fw=PWGTP]  if ST ==41 
tab ReWhiteG ReWhiteLeg, miss
drop ReWhiteG   ReMENAG

**************ReCOFAall
gen ReCOFAall=ReCOFA
replace ReCOFAall =1 if ReMarshallese ==1
replace ReCOFAall =1 if ReCham ==1
label var  ReCOFAall "Communities of Micronesian Region & Marshallese & CHamorro"
label value  ReCOFAall no0yes1

replace ReCOFAall=0 if ReCOFAall==. 

************************************************************************	
save "TempFile2v2.dta", replace
 
 *32 **********************************************************************	
use "TempFile2v2.dta", replace
 
********************************************************************************
 **33 Aggreg categories
*******************************************************************************
 egen float ReAIANG = rownonmiss( ReAIANLeg ReAlaskNat ReLatInd ReAmInd) 
 egen float ReNHPIG = rownonmiss( ReNHPILeg ReCham ReMarshallese ReCOFA ReNatHaw ReSamoan ReTongan ReNHPIoth )
egen float ReBlackG = rownonmiss( ReBlackLeg ReCaribbean ReAfrican ReAfrAm ReSomali ReEthiopian ReBlackOth) 
egen float ReMENAG = rownonmiss(ReMidEast ReNoAfr ReMENALeg) 
egen float ReWhiteG = rownonmiss(ReWhiteLeg ReWestEur ReEastEur ReSlavic ReOthwhite) 
egen float ReAsianG = rownonmiss( ReAsianInd ReCambodian ReChinese ReFilipino ///
ReHmong ReJapanese ReKorean ReLaotian ReMyanmar ReVietnamese ReSoAsian ///
ReAsianSE ReAsianE ReAsianC ReAsianOth ReAsianLeg) 
egen float ReHispG = rownonmiss(ReHisMex ReHisCen ReHisSou ReHisOth) 

egen float ReWhiteMENAG = rownonmiss(ReWhiteLeg ReWestEur ReEastEur ReSlavic ReOthwhite ReMidEast ReNoAfr ReMENALeg) 
 *34*******************************************************************************
foreach var of varlist ReHispG ReWhiteMENAG  ReMENAG  ReWhiteG  ReAIANG ReAsianG  ReNHPIG ReBlackG { 
replace `var'= 1 if `var'>=1 & `var'!=.
tab  `var'
label value `var' no0yes1
replace `var'= . if `var'==0
    } 
for var  ReNHPIG:  tab  X [fw=PWGTP]  if ST ==41 
		
***************************************************************************
save "TempFile3v2.dta", replace
***********************************************************
use "TempFile3v2.dta", replace

*ReAIANG ReAIANLeg AIANtest
drop ReAIANG
 egen float ReAIANG = rownonmiss(   ReAlaskNat ReLatInd ReAmInd) 
 replace ReAmInd =1 if HINS7==1  & ReAIANG==0 &  RAC1P >=8

tab RAC2P if ReAIANG==0
replace ReAmInd =1 if RAC2P ==29
**********************************************************************
*35**AmTribe  **ANTribe********************
**********************************************************************
gen AmTribe =1 if RAC2P >=3 & RAC2P<=28
gen ANTribe =1 if RAC2P >=30 & RAC2P<=35
replace ReAIANLeg =1 if RAC2P  >=36 & RAC2P<=37
**************************************************************************
* 36   2021 - changed this...did not do replace AmTribe =1 if HINS7==1 & ANTribe==. & RACAIAN==1 
****************************************************************************
replace ReAIANLeg =. if ReAmInd ==1
replace ReAIANLeg =. if ReAlaskNat ==1
replace ReAIANLeg =. if ReLatInd ==1
drop ReAIANG
egen float ReAIANG = rownonmiss( ReAIANLeg ReAlaskNat ReLatInd ReAmInd) 
   
for var ReAmInd ReAlaskNat  ReLatInd: tab  X [fw=PWGTP]  if ST ==41 & ReAIANG==0 &  RAC2P>=1 & RAC2P<=2 
replace ANTribe =. if RAC2P>=1 & RAC2P<=2
replace ANTribe =. if RAC2P>=38 & RAC2P<=66

replace AmTribe =. if RAC2P>=1 & RAC2P<=2
replace AmTribe =. if RAC2P>=38 & RAC2P<=66
 *AmTribe ANTribe
tab RAC2P if ANTribe==1
tab RAC2P if AmTribe==1
replace ReAmInd =1 if AmTribe==1
replace ReAlaskNat =1 if ANTribe==1
********************************************************************
*37****TribePlus***********
********************************************************************
gen TribePlus =1 if AmTribe==1
replace TribePlus =1 if ANTribe==1
drop ReAIANG
egen float ReAIANG = rownonmiss(  ReAlaskNat ReLatInd ReAmInd)  
replace ReAmInd =1 if TribePlus==1 & ReAIANG ==0
tab TribePlus ReAIANG, miss
drop ReAIANG
egen float ReAIANG = rownonmiss(  ReAlaskNat ReLatInd ReAmInd)   
	replace ReAIANG =1 if ReAIANG >=2 
	assert ReAlaskNat==1 if ANTribe==1
	assert ReAmInd==1 if AmTribe==1
	assert ReAIANG==1  if TribePlus==1
	tab ReAIANG TribePlus, miss
replace ReAmInd =1 if AmTribe==1
replace ReAlaskNat =1 if ANTribe==1

drop ReAIANG
egen float ReAIANG = rownonmiss(  ReAlaskNat ReLatInd ReAmInd)   
 tab  ReAIANG HINS7, miss

replace ReAmInd =1 if TribePlus==1 & ReAIANG ==0 & RACAIAN==1

for var ReAmInd ReAlaskNat  ReLatInd: tab  X [fw=PWGTP]  if ST ==41 // boxes 1--4
drop ReAIANG

*checking
 gen mark =1 if ReAmInd==1 & RACAIAN!=1
 order mark ReAmInd ReAlaskNat ReLatInd TribePlus AmTribe ANTribe

 gen mark2 =1 if (RAC1P<=2 | RAC1P>=6) &  RACAIAN!=1
 order  mark2
 sort mark mark2 
replace ReAmInd =. if RACAIAN!=1 & mark2==1
replace ReAlaskNat =. if RACAIAN!=1 & mark2==1

for var ReAmInd ReAlaskNat  ReLatInd: tab  X [fw=PWGTP]  if ST ==41 // boxes 1--4
drop mark* 
for var  ReAmInd ReAlaskNat  ReLatInd:replace ReAIANLeg=. if   X ==1 
egen float ReAIANG = rownonmiss( ReAIANLeg ReAlaskNat ReLatInd ReAmInd) 

foreach var of varlist ReAIANG { 
replace `var'= 1 if `var'>=1 & `var'!=.
label value `var' no0yes1
tab  `var'
replace `var'= . if `var'==0
    } 

	* svy: tab  ReAIANG  if ST ==41 , count format(%-12.0g)  csepwidth(10) stubwidth(30)
	* svy: tab  TribePlus  if ST ==41 , count format(%-12.0g)  csepwidth(10) stubwidth(30)
for var ReAIANG : tab    X [fw=PWGTP]   if ST ==41 // boxes 1--4

*Census 2020: 185726
for var ReAIANG : tab    X [fw=PWGTP]   if ST ==41 & AGEP>=18
* 96,607 18 plus :  96,607
 
  *ACS 2019 1 year estimates American Indian tribes, specified, alone or in any combination: 91898	5144
*    126662- 133903
*129,579 AI/AN (alone or in combination, ACS 2015
*compare to https://www.oregon.gov/oha/PH/PROVIDERPARTNERRESOURCES/LOCALHEALTHDEPARTMENTRESOURCES/Documents/orientation/orientation-tribal-affairs.pdf

  ***************************************************************************
 *38 *Legreg categories
**************************************************************************
 drop ReHispG ReMENAG  ReWhiteG  ReAIANG ReAsianG  ReNHPIG ReBlackG ReWhiteMENAG
*ReNHPIG 
replace  ReNHPIoth=1 if ReTongan ==1 
 drop ReTongan 	
egen float ReNHPIG = rownonmiss(  ReCham ReMarshallese ReCOFA ReNatHaw ReSamoan  ReNHPIoth )
replace ReNHPIG =1 if ReNHPIG>=2 & ReNHPIG!=. 
 for var ReNHPILeg  :replace  X =. if ReNHPIG>=1    & ReNHPIG!=. 
drop ReNHPIG

egen float ReNHPIG = rownonmiss( ReNHPILeg ReCham ReMarshallese ReCOFA ReNatHaw ReSamoan  ReNHPIoth )
replace ReNHPIG =1 if ReNHPIG>=2 & ReNHPIG!=. 
	  
for var ReNHPIG: tab  X [fw=PWGTP] if ST ==41 // boxes 1--6
*PSU Census ReNHPIG: 39709  
*36,743 

for var ReCham ReMarshallese ReCOFA ReNatHaw ReSamoan ReNHPIoth : tab  X [fw=PWGTP] if ST ==41 
drop ReNHPIG
*ReBlackG 
egen float ReBlackG = rownonmiss(ReBlackLeg ReCaribbean ReAfrican ReAfrAm ReSomali ReEthiopian  ) 
 for var ReBlackOth  :replace  X =. if ReBlackG>=1     & ReBlackG!=.
drop ReBlackG
*ReMENAG 	
egen float ReMENAG = rownonmiss(ReMidEast ReNoAfr ) 
 for var ReMENALeg  :replace  X =. if ReMENAG>=1   & ReMENAG!=.
drop ReMENAG	


*ReWhiteG  (line 1495 in 2v8 syntax file)
egen float ReWhiteG = rownonmiss( ReWestEur ReEastEur ReSlavic ReOthwhite) 
tab ReWhiteG
tab ReWhiteG ReWhiteLeg, miss
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
tab  `var' if ReWhiteLeg ==1
 }
for var ReWhiteLeg  :replace  X =. if ReWhiteG>=1   & ReWhiteG!=.
drop ReWhiteG	

egen float WhiteNoOth = rownonmiss( ReWestEur ReEastEur ReSlavic ) 
tab  WhiteNoOth ReOthwhite, miss


 foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
tab  `var' if ReOthwhite ==1
 }
 
drop WhiteNoOth

 
*ReAsianG
	egen float ReAsianG = rownonmiss( ReAsianInd ReCambodian ReChinese ReFilipino ///
ReHmong ReJapanese ReKorean ReLaotian ReMyanmar ReVietnamese ReSoAsian   ReAsianSE ReAsianE ReAsianC ReAsianOth  ) 
 for var ReAsianLeg  :replace  X =. if ReAsianG>=1   
	drop ReAsianG	

egen float ReAsianG = rownonmiss( ReAsianInd ReCambodian ReChinese ReFilipino ///
ReHmong ReJapanese ReKorean ReLaotian ReMyanmar ReVietnamese ReSoAsian   ) 
replace ReAsianOth=1 if ReAsianG ==0 & ReAsianSE==1
replace ReAsianOth=1 if ReAsianG ==0 & ReAsianE==1
replace ReAsianOth=1 if ReAsianG ==0 & ReAsianC==1
replace ReAsianOth=1 if ReAsianG ==0 & ReAsianS==1
drop ReAsianG	

  *******************************************************************
 **39 Group categories (again)
***********************************************************************
 egen float ReAIANG = rownonmiss( ReAIANLeg ReAlaskNat ReLatInd ReAmInd) 
 egen float ReNHPIG = rownonmiss( ReNHPILeg ReCham ReMarshallese ReCOFA ReNatHaw ReSamoan  ReNHPIoth )
egen float ReBlackG = rownonmiss( ReBlackLeg ReCaribbean ReAfrican ReAfrAm ReSomali ReEthiopian ReBlackOth) 
egen float ReMENAG = rownonmiss(ReMidEast ReNoAfr ReMENALeg) 
egen float ReWhiteG = rownonmiss(ReWhiteLeg ReWestEur ReEastEur ReSlavic ReOthwhite) 
 egen float ReWhiteMENAG = rownonmiss(ReWhiteLeg ReWestEur ReEastEur ReSlavic ReOthwhite ReMidEast ReNoAfr ReMENALeg) 

egen float ReAsianG = rownonmiss( ReAsianInd ReCambodian ReChinese ReFilipino ///
ReHmong ReJapanese ReKorean ReLaotian ReMyanmar ReVietnamese ReSoAsian   ReAsianOth ReAsianLeg) 

egen float ReHispG = rownonmiss( ReHisMex ReHisCen ReHisSou ReHisOth) 

foreach var of varlist ReHispG ReWhiteMENAG ReMENAG  ReWhiteG  ReAIANG ReAsianG  ReNHPIG ReBlackG { 
replace `var'= 1 if `var'>=1 & `var'!=.
label value `var' no0yes1
tab  `var'
replace `var'= . if `var'==0
    } 
 ******************************************************************************
 *40 *RaceTemp
****************************************************************************** 
 
 egen float RaceTemp = rownonmiss( ReHispG   ReMENAG  ReWhiteG  ReAIANG ReAsianG  ReNHPIG ReBlackG  )
 tab RaceTemp ReMENAG, miss

 ******************************************************************************
 **41  ReRaceOth ReMulti
******************************************************************************
 gen ReRaceOth =.
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReRaceOth=1 if regexm(`var', "Other Race") ==1 
 }
replace ReRaceOth=1 if RACSOR==1

 gen ReMulti =.
foreach var of varlist POBPS RAC1PS RAC2PS RAC3PS RAC3PS ANC1PS ANC2PS  LANPS MIGSPS HISPS  {
replace ReMulti=1 if regexm(`var', "Two or More") ==1

 }
 
 for var  ReWestEur:  tab  X ReMENAG [fw=PWGTP]  if ST ==41 

tab RaceTemp ReMENAG if ReRaceOth ==1, miss
tab RaceTemp ReMENAG if ReMulti ==1, miss
drop RaceTemp

drop Re*G
gen ReHispLeg=1 if HISPdi ==1
**************************************************************************
*
**************************************************************************

egen float ReAIANG= rownonmiss( ReAmInd ReAlaskNat  ReLatInd ) 
egen float ReMENAG= rownonmiss(ReNoAfr ReMidEast )
egen float ReWhiteG= rownonmiss( ReSlavic ReWestEur ReEastEur ReOthwhite)  
egen float ReBlackG= rownonmiss( ReAfrAm   ReCaribbean ReEthiopian ReSomali ReBlackOth ReAfrican)
egen float ReHispG = rownonmiss( ReHisMex ReHisOth ReHisCen ReHisSou)
egen float ReNHPIG = rownonmiss(   ReCham ReMarshallese ReCOFA ReNatHaw ReSamoan  ReNHPIoth )
egen float ReAsianG = rownonmiss(ReAsianInd ReCambodian ReChinese ReFilipino ReHmong ReJapanese ReKorean ReLaotian ReMyanmar ReVietnamese ReSoAsian ReAsianOth) 

replace ReAIANLeg=. if ReAIANG >=1 & ReAIANG!=.
replace ReMENALeg=. if ReMENAG >=1 & ReMENAG!=.
replace ReWhiteLeg=. if ReWhiteG >=1 & ReWhiteG!=.
replace ReBlackLeg=. if ReBlackG >=1 & ReBlackG!=.
replace ReHispLeg=. if ReHispG >=1 & ReHispG!=.
replace ReNHPILeg=. if ReNHPIG >=1 & ReNHPIG!=.
replace ReAsianLeg=. if ReAsianG >=1 & ReAsianG!=.
drop ReAIANG ReMENAG ReWhiteG ReBlackG ReHispG ReNHPIG ReAsianG 

 egen float ReAIANG= rownonmiss( ReAmInd ReAlaskNat  ReLatInd ) 
egen float ReMENAG= rownonmiss(ReNoAfr ReMidEast )
egen float ReWhiteG= rownonmiss( ReSlavic ReWestEur ReEastEur ReOthwhite)  
egen float ReBlackG= rownonmiss( ReAfrAm   ReCaribbean ReEthiopian ReSomali ReBlackOth ReAfrican)
egen float ReHispG = rownonmiss( ReHisMex ReHisOth ReHisCen ReHisSou)
egen float ReNHPIG = rownonmiss(   ReCham ReMarshallese ReCOFA ReNatHaw ReSamoan  ReNHPIoth )
egen float ReAsianG = rownonmiss(ReAsianInd ReCambodian ReChinese ReFilipino ///
ReHmong ReJapanese ReKorean ReLaotian ReMyanmar ReVietnamese ReSoAsian ReAsianOth) 
foreach var of varlist ReAIANG ReMENAG ReWhiteG ReBlackG ReHispG ReNHPIG ReAsianG  { 
replace `var'= 1 if `var'>=1 & `var'!=.
replace `var'= . if `var'==0 
           } 

**************************************************************************
*
**************************************************************************
egen float RaceTotN= rownonmiss( ReAlaskNat ReAmInd ReAsianInd  ///
ReLatInd  ReAfrAm   ReCaribbean ReEthiopian ReSomali ReBlackOth ReAfrican  ReChinese ///
ReCambodian ReMyanmar ReFilipino  ReHmong  ReJapanese  ReKorean ReLaotian  ReSoAsian  ///
ReVietnamese  ReAsianOth ReHispLeg  ReHisCen ReHisMex ReHisSou ReHisOth   ///
ReCham ReMarshallese ReCOFA ReNatHaw ReSamoan  ReNHPIoth  ///
ReMidEast ReNoAfr    ReSlavic ReEastEur ReWestEur ReOthwhite  ) 

*  Colonizing languages – require two conditions – Legacy (Agg) var and RaceTot==0
 foreach var of varlist LANPS {
replace ReHisSou=1 if regexm(`var', "Portug") ==1  & RACBLK==1 & RaceTotN==0
replace ReAfrican=1 if regexm(`var', "French") ==1  & RACBLK==1 & RaceTotN==0
replace ReAfrican=1 if regexm(`var', "Portug") ==1  & RACBLK==1 & RaceTotN==0
replace ReHisOth=1 if regexm(`var', "Spanish") ==1  & RACBLK==1  & RaceTotN==0
replace ReHisOth=1 if regexm(`var', "Spanish") ==1  & HISPdi==1  & RaceTotN==0
    }
	
 drop ReAIANG ReMENAG ReWhiteG ReBlackG ReHispG ReNHPIG ReAsianG 
 drop RaceTot*

dropmiss, force

******************************************************************************
save "TempFile4v2.dta", replace
*42*****************************************************************************


use "TempFile4v2.dta", replace


 *****************************************************************************
 *43 *RaceMainN and checking
*******************************************************************************
 egen float ReAIANG= rownonmiss( ReAmInd ReAlaskNat  ReLatInd ) 
egen float ReMENAG= rownonmiss(ReNoAfr ReMidEast )
egen float ReWhiteG= rownonmiss( ReSlavic ReWestEur ReEastEur ReOthwhite)  
egen float ReBlackG= rownonmiss( ReAfrAm   ReCaribbean ReEthiopian ReSomali ReBlackOth ReAfrican)
egen float ReHispG = rownonmiss( ReHisMex ReHisOth ReHisCen ReHisSou)
egen float ReNHPIG = rownonmiss(   ReCham ReMarshallese ReCOFA ReNatHaw ReSamoan  ReNHPIoth )
egen float ReAsianG = rownonmiss(ReAsianInd ReCambodian ReChinese ReFilipino ///
ReHmong ReJapanese ReKorean ReLaotian ReMyanmar ReVietnamese ReSoAsian ReAsianOth) 
foreach var of varlist ReAIANG ReMENAG ReWhiteG ReBlackG ReHispG ReNHPIG ReAsianG  { 
replace `var'= 1 if `var'>=1 & `var'!=.
replace `var'= . if `var'==0 
label value `var' no0yes1
           } 
		   
		   
gen ReWhiteLeg =1 if RACWHT==1  & ReWhiteG==.  & ReMENAG==. 
tab ReWhiteLeg

gen ReMENALeg=.
***************************************************************************** 
foreach var of varlist  ReAIANLeg ReAlaskNat ReLatInd ReAmInd ///
 ReAsianLeg ReAsianInd ReCambodian ReChinese ReFilipino ReHmong ReJapanese ReKorean ReLaotian ///
 ReMyanmar ReVietnamese ReSoAsian   ReAsianOth ///
ReBlackLeg ReAfrAm ReAfrican   ReCaribbean ReEthiopian ReSomali ReBlackOth ///
 ReHisMex ReHisCen ReHisSou ReHisOth ///
ReNHPILeg  ReCham   ReMarshallese ReCOFA ReNatHaw ReSamoan  ReNHPIoth  ///
 ReMidEast ReNoAfr   ReWhiteLeg ReWestEur ReEastEur ReSlavic ReOthwhite { 
label value `var' no0yes1
           } 

*****************************************************************************
 egen float RaceMainN = rownonmiss(ReWhiteG  ReMENAG ReAIANG ReAsianG ReBlackG ReHispG ReNHPIG ReRaceOth)
*****************************************************************************
 for var  ReMENAG:  tab  X RaceMainN [fw=PWGTP]  if ST ==41 
 
*****************************************************************************
 clonevar RaceOthS=ReRaceOth
 clonevar MULTIS=ReMulti
 tab ReAIANLeg
 tab ReHispG
label value ReAIANLeg no0yes1

*****************************************************************************
 **44  RaceTot & Label clean up
******************************************************************************
 egen float RaceTotAll1 = rownonmiss(ReAIANLeg ReAlaskNat ReLatInd ReAmInd ///
 ReAsianLeg ReAsianInd ReCambodian ReChinese ReFilipino ReHmong ReJapanese ReKorean ReLaotian ///
 ReMyanmar ReVietnamese ReSoAsian   ReAsianOth ///
ReBlackLeg ReAfrAm ReAfrican   ReCaribbean ReEthiopian ReSomali ReBlackOth ///
 ReHisMex ReHisCen ReHisSou ReHisOth ///
ReNHPILeg  ReCham   ReMarshallese ReCOFA ReNatHaw ReSamoan  ReNHPIoth  ///
ReMENALeg ReMidEast ReNoAfr   ReWhiteLeg ReWestEur ReEastEur ReSlavic ReOthwhite )

 replace ReRaceOth=. if RaceTotAll1>=1
replace ReMulti=. if RaceTotAll1>=1
*****************************************************************************
label var ReAIANLeg "AIAN (Legacy)"
label var  ReLatInd "Indigenous Mex/Cen/So American"
label var ReAlaskNat "Alaska Native"
label var  ReAmInd "American Indian"


label var  ReHisCen "Latinx Central American"
label var  ReHisSou "Latinx South American"
label var  ReHisMex "Latinx Mexican"
label var ReHisOth "Other Latinx"

label var  ReCOFA "ReCOFA populations"
label var ReCham "CHamorro(imputed)"
label var ReNHPILeg "NHPI (Legacy)"
label var ReAfrAm "ReAfrican American"
label var ReNHPIoth "Other Pacific Islander"
label var ReMarshallese "Marshallese (imputed)"
label var ReNatHaw "Native Hawaiian"

label var ReAfrican "ReAfrican"
label var ReCaribbean "Afro-Caribbean"
label var ReEthiopian "ReEthiopian(imputed)" 
*label var ReBlackLeg "Black(Legacy)"
label var ReSomali "ReSomali (imputed)"


label var  ReAsianInd "Asian Indian"
label var ReCambodian "Cambodian(imputed)"		
label var ReMyanmar "Communities of Myanmar (imputed)"
label var 	ReChinese		"ReChinese"
label var 	ReFilipino	"Filipino"
label var 	ReHmong		"Hmong"
label var 	ReJapanese	"Japanese"
label var 	ReKorean		"Korean"
label var 	ReLaotian		"Laotian"					
label var 	ReVietnamese	"Vietnamese"
label var 	ReSoAsian		"South Asian"
label var ReAsianSE "South East ReAsianG(Thai/Singapore/Malay/Iu Mien)"
label var ReAsianE "East ReAsianG(ReChinese/ReJapanese/ReKorean/Mongolian/Okinawan/Taiwanese)"
label var ReAsianC "Central ReAsianG(Uzbek/Kazak/Turkmen/Tajik)"
label var ReAsianOth	"Other Asian"
label var ReAsianLeg "Asian(Legacy)"


label var ReMENALeg "ReMENAG(Legacy)"
label var ReMidEast "Middle Eastern"

label var ReWhiteLeg "White(Legacy)"
label var ReWestEur "Western European"
label var ReEastEur "Eastern European"
label var ReSlavic "ReSlavic"


  *******************************************************************
 **39 Aggreg categories (again)
***********************************************************************

foreach var of varlist ReHispG  ReMENAG  ReWhiteG  ReAIANG ReAsianG  ReNHPIG ReBlackG { 
replace `var'= 0 if `var'==.
    } 
 svyset [pw=PWGTP], sdrweight(PWGTP1-PWGTP80) vce(sdr)	

 
 svy:  tab  ReMENAG if ST==41 , count ci format(%-12.0g)  csepwidth(10) stubwidth(30)	    //perfect alignment
 svy:  tab  ReNHPIG if ST==41 , count ci format(%-12.0g)  csepwidth(10) stubwidth(30)	    //perfect alignment
 svy:  tab  ReBlackG if ST==41 , count ci format(%-12.0g)  csepwidth(10) stubwidth(30)	    //perfect alignment
 svy:  tab  ReAIANG if ST==41 , count ci format(%-12.0g)  csepwidth(10) stubwidth(30)	    //perfect alignment
 svy:  tab  ReAsianG if ST==41 , count ci format(%-12.0g)  csepwidth(10) stubwidth(30)	    //perfect alignment
 svy:  tab  ReHispG if ST==41 , count ci format(%-12.0g)  csepwidth(10) stubwidth(30)	    //perfect alignment
 svy:  tab  ReWhiteG if ST==41 , count ci format(%-12.0g)  csepwidth(10) stubwidth(30)	    //perfect alignment


 foreach var of varlist ReHispG  ReMENAG  ReWhiteG  ReAIANG ReAsianG  ReNHPIG ReBlackG { 
replace `var'= . if `var'==0
label value `var' no0yes1
    } 
	

tab RAC3P if RAC1P==8

tab RAC3P if RACASN ==1 & ReAsianG ==.


replace  ReMENALeg=. if ReNoAfr ==1
replace  ReMENALeg=. if ReMidEast ==1

********************************************************************************
	save "RaceTemp5v2.dta", replace
*49*******************************************************************************	

use "RaceTemp5v2.dta", replace
*order now is ReMENAG, ReNHPIG, ReBlackG, ReAIANG, ReAsianG, ReHispG ReWhiteG, Other (Statewide - OR)


*did not do these var this time: 
******************************************************************************
*46  Rac6cat  *taking RAC1P - white as reference (not rarest group)
******************************************************************************
******************************************************************************
*50  Rac7catM  "Race/Ethnicity-rev"   (ReWhiteG as ref category)
******************************************************************************
******************************************************************************
*51  Rac7catMRev  (ReWhiteG as ref category) ReMENAG combined with white
******************************************************************************
******************************************************************************
*52  POCdi  (ReWhiteG as ref category) 
******************************************************************************
******************************************************************************
*53  Rac3catM  (ReWhiteG as ref category) - 3 categories
******************************************************************************
******************************************************************************
*54     RACE by Sex  vars; Rac4Sex RacSex 
******************************************************************************
*******************************************************************************
*58 Rac6caAll2- Pri Race(ReMENAG/ReWhiteG combined; ReNHPIG is prioritized) (alpha order)
*******************************************************************************
******************************************************************************
*55   Race "OMB Race w/ Latinx b4 white/SOR"
******************************************************************************

*MODIFIED THESE TO ALIGN WITH ATTRIBUTES/DATA DICTIONARY

  ****************************************************************************** 
*60******RareRace- Numeric var**(based one RRprimGn string var)************** 
  ****************************************************************************** 
*modified to exclude ReTongan & Guam (not REALD any more)
**Changed name from PriRacGn to RareRace since ACS tech doesn't ask about primary race

gen RareRace=.
*favoring tribal members first
replace 	RareRace=	2	if 	ANTribe ==1  & RareRace==.
replace 	RareRace=	1	if 	AmTribe ==1  & RareRace==.

*ReMENAG
replace 	RareRace=	32	if 	ReNoAfr==1  & RareRace==. 
replace 	RareRace=	31	if 	ReMidEast==1  & RareRace==. 
replace 	RareRace=	33	if 	ReMENALeg==1  & RareRace==. 
*ReNHPIG
replace 	RareRace=	37	if 	ReCOFA ==1  & RareRace==. 
replace 	RareRace=	38	if 	ReMarshallese ==1  & RareRace==.
replace 	RareRace=	39	if 	ReSamoan==1  & RareRace==.
replace 	RareRace=	34	if 	ReCham ==1 & RareRace==. 
replace 	RareRace=	41	if 	ReNatHaw ==1  & RareRace==. 
replace 	RareRace=	42	if 	ReNHPIoth==1  & RareRace==. 
replace 	RareRace=	43	if 	ReNHPILeg==1  & RareRace==. 
replace 	RareRace=	43	if 	RACNHPI==1  & RareRace==. 

**BLACK/AFRICAN
replace 	RareRace=	22	if 	ReSomali==1  & RareRace==. 
replace 	RareRace=	21	if 	ReEthiopian==1  & RareRace==. 
replace 	RareRace=	20	if 	ReCaribbean==1  & RareRace==. 
replace 	RareRace=	23	if 	ReAfrican==1  & RareRace==. 
replace 	RareRace=	19	if 	ReAfrAm==1  & RareRace==. 
replace 	RareRace=	24	if 	ReBlackOth==1  & RareRace==. 
replace 	RareRace=	25	if 	ReBlackLeg==1  & RareRace==. 
replace 	RareRace=	25	if 	RACBLK==1  & RareRace==. 

*AIAN
*replace 	RareRace=	3	if  CanInd==1   & RareRace==.
replace 	RareRace=	2	if 	ReAlaskNat==1  & RareRace==. 
replace 	RareRace=	4	if 	ReLatInd==1  & RareRace==. 
replace 	RareRace=	1	if 	ReAmInd==1  & RareRace==. 
replace 	RareRace=	5	if 	ReAIANLeg==1  & RareRace==. 
replace 	RareRace=	5	if 	RACAIAN==1  & RareRace==. 

*ASIAN
replace 	RareRace=	9	if 	ReMyanmar==1  & RareRace==. 
replace 	RareRace=	7	if 	ReCambodian==1  & RareRace==. 
replace 	RareRace=	11	if 	ReHmong==1  & RareRace==. 

replace 	RareRace=	14	if 	ReLaotian==1  & RareRace==. 
replace 	RareRace=	15	if 	ReSoAsian==1 & RareRace==.
replace 	RareRace=	13	if 	ReKorean==1  & RareRace==.
replace 	RareRace=	12	if 	ReJapanese==1  & RareRace==. 
replace 	RareRace=	6	if 	ReAsianInd==1 & RareRace==.
replace 	RareRace=	16	if 	ReVietnamese==1  & RareRace==. 
replace 	RareRace=	10	if 	ReFilipino==1  & RareRace==. 
replace 	RareRace=	8	if 	ReChinese==1  & RareRace==. 
replace 	RareRace=	17	if 	ReAsianOth==1  & RareRace==. 
* ReAsianSE ReAsianE ReAsianC ReAsianOth
replace 	RareRace=	17	if 	ReAsianC==1  & RareRace==. 
replace 	RareRace=	17	if 	ReAsianSE==1  & RareRace==. 
replace 	RareRace=	17	if 	ReAsianE==1  & RareRace==. 
replace 	RareRace=	17	if 	ReAsianS==1  & RareRace==. 
replace 	RareRace=	18	if 	ReAsianLeg==1  & RareRace==. 
replace 	RareRace=	18	if 	RACASN==1  & RareRace==. 

*HISP	
replace 	RareRace=	28	if 	ReHisSou==1  & RareRace==. 
replace 	RareRace=	27	if 	ReHisCen==1  & RareRace==. 
replace 	RareRace=	26	if 	ReHisMex==1  & RareRace==. 
replace 	RareRace=	29	if 	ReHisOth==1  & RareRace==. 
replace 	RareRace=	30	if 	ReHispG==1  & RareRace==. 
replace 	RareRace=	30	if 	HISPdi==1  & RareRace==. 

*WHITE
replace 	RareRace=	44	if 	ReEastEur==1  & RareRace==. 
replace 	RareRace=	45	if 	ReSlavic==1  & RareRace==. 
replace 	RareRace=	46	if 	ReWestEur==1  & RareRace==. 
replace 	RareRace=	47	if 	ReOthwhite==1  & RareRace==.
replace 	RareRace=	48	if 	ReWhiteLeg==1  & RareRace==.

/*note change here from attributes data dictionary
49	Not just one
50	Biracial or Multiracial
51	Multiracial (open text)
52	Multi (all)
53	Other race
55	Multi/Other (all)*/

replace 	RareRace=	52	if 	ReMulti==1  & RareRace==. 
replace 	RareRace=	53	if 	ReRaceOth==1  & RareRace==. 
replace 	RareRace=	53	if 	RACSOR==1  & RareRace==. 

 label define RareRacelab ///			
1	"American Indian" 	///
2	"Alaska Native" 	///
3	"Canadian Inuit, Metis, or First Nation" 	///
4	"Indigenous Mexican, Central or South American" 	///
5	"AIAN (Legacy)"  	///
6	"Asian Indian"	///
7	 "Cambodian" 	///
8	"Chinese" 	///
9	"Communities of Myanmar" 	///
10	"Filipino/a" 	///
11	"Hmong"	///
12	"Japanese"	///
13	"Korean" 	///
14	"Laotian" 	///
15	"South Asian" 	///
16	"Vietnamese" 	///
17	"Other Asian"	///
18	"Asian (Legacy)" 	///
19	"African American" 	///
20	"Afro-Caribbean" 	///
21	"Ethiopian" 	///
22	"Somali" 	///
23	"Other African"	///
24	"Other Black" 	///
25	"Black (Legacy)" 	///
26	"Mexican" 	///
27	"Central American" 	///
28	"South American" 	///
29	"Other Hispanic or Latino/a/x/e"	///
30	"Hispanic/Latino/a/x/e (Legacy)"	///
31	"Middle Eastern" 	///
32	"North African" 	///
33	"MENA (Legacy)" 	///
34	"CHamoru (Chamorro)" 	///
35	"Guamanian or CHamoru" 	///
36	"Guamanian" 	///
37	"Communities of Micronesian Region" 	///
38	"Marshallese" 	///
39	"Samoan" 	///
40	"ReTongan" 	///
41	"Native Hawaiian"	///
42	"Other Pacific Islander"	///
43	"NHPI (Legacy)" 	///
44	"Eastern European" 	///
45	"Slavic" 	///
46	"Western European"	///
47	"Other White"	///
48	"White (Legacy)" 	///
49 "Not just one (primary identity - NA for ACS)" /// 
50	"Biracial or Multiracial"  ///	
51	"Multiracial (open text- NA for ACS)" ///
52	"Multi (all)" ///
53	"Other race"  ///	
55	"Multi/Other (all)" ///
-1 "Unknown"  ///
-3 "Decline" ///
-4 "Missing", modify
label value RareRace RareRacelab
tab RareRace 
label var RareRace "Primary Race (Rarest Group methodology)"
label value RareRace RareRacelab
for var RareRace : tab  X [fw=PWGTP]  if ST ==41 


 *61************************************************************
*replace the 'sans' to other categories
clonevar RareRaceAdj=RareRace
replace RareRaceAdj=1 if RareRaceAdj==5  //ReAIANG to Am Ind
replace RareRaceAdj=17 if RareRaceAdj==18  //ReAsianG
replace RareRaceAdj=24 if RareRaceAdj==25 //ReBlackG

replace RareRaceAdj=29 if RareRaceAdj==30 //Latinx
replace RareRaceAdj=32	if RareRaceAdj==33	 //32	"North ReAfrican" 	///
replace RareRaceAdj=42 if RareRaceAdj==43  //ReNHPIoth
replace RareRaceAdj=47 if RareRaceAdj==48 //"Other White"
label value RareRaceAdj RareRacelab
tab RareRaceAdj
 *replace Other black to Other African for this purpose only
replace RareRaceAdj=23 if RareRaceAdj==24 
tab RareRaceAdj

label var RareRaceAdj "Primary Race  (Most Identify/Rarest Group with legacy values rolled up into 'other' categories and all multi reponses rolled up also"

 *************************************************************
*62var label clean up 

*************************************************************

	
label variable ANTribe "Alaska Native Tribal Member"
label var AmTribe "Am Indian Tribal Member"
label var TribePlus "AI/AN Tribal Member"
label variable RareRace "Primary Race (rarest grp; disaggreg)"
label variable RACNHPI "NHPI recode- from PUMS directly)"
label variable ReAIANLeg "American Indian/Alaska Native (Legacy)"
 label variable ReAsianLeg "Asian (Legacy)"
label variable ReBlackLeg "Black/African American (Legacy)"
label variable ReNHPILeg "Native Hawaiian/Pacific Islander (Legacy)"
label variable ReMENALeg "Middle Eastern/North African (Legacy)"
label variable ReWhiteLeg "White (Legacy)"
label var ReMENAG "Middle Eastern/North ReAfrican"
label var ReWhiteG "White"
label var ReAIANG "American Indian /Alaska Native"
label var ReAsianG "Asian"
label var ReNHPIG "Native Hawaiian/Pacific Islndr"
label var ReBlackG "Black/ReAfrican Am."
label var ReHispG "Latino/a/x"

************************************************************
*Rac11caAll
************************************************************
gen Rac11caAll=.
replace Rac11caAll=0 if RareRace>=1 & RareRace<=5 & TribePlus ==1
replace Rac11caAll=5 if Rac11caAll==. & RareRace>=31 & RareRace<=33 // MENA
replace Rac11caAll=4 if Rac11caAll==. & RareRace>=34 & RareRace<=43 //NHPI
replace Rac11caAll=2 if Rac11caAll==. & RareRace>=19 & RareRace<=25 // Black
replace Rac11caAll=0 if Rac11caAll==. & RareRace>=1 & RareRace<=5 // AIAN
replace Rac11caAll=1 if Rac11caAll==. & RareRace>=6 & RareRace<=18 // Asian
replace Rac11caAll=3 if Rac11caAll==. & RareRace>=26 & RareRace<=30 // Latinx
replace Rac11caAll=6 if Rac11caAll==. & RareRace>=44 & RareRace<=48 //White
replace Rac11caAll=7 if Rac11caAll==. & RareRace==49   //
replace Rac11caAll=8 if Rac11caAll==. & RareRace==50  
replace Rac11caAll=10 if Rac11caAll==. & RareRace==53

replace Rac11caAll=0 if ReAIANG==1 & TribePlus ==1 & Rac11caAll==.
replace Rac11caAll=5 if Rac11caAll==. & ReMENAG==1
replace Rac11caAll=4 if Rac11caAll==. & ReNHPIG==1
replace Rac11caAll=2 if Rac11caAll==. & ReBlackG==1
replace Rac11caAll=0 if Rac11caAll==. & ReAIANG==1
replace Rac11caAll=1 if Rac11caAll==. & ReAsianG==1
replace Rac11caAll=3 if Rac11caAll==. & ReHispG ==1
replace Rac11caAll=6 if Rac11caAll==. & ReWhiteG ==1
replace Rac11caAll=9 if Rac11caAll==. & ReMulti==1
replace Rac11caAll=10 if Rac11caAll==. & ReRaceOth==1
replace Rac11caAll=10 if Rac11caAll==. & RareRace==53


replace Rac11caAll=-1 if Rac11caAll==. & RareRace==-1
replace Rac11caAll=-3 if Rac11caAll==. & RareRace==-3

************************************************************
**Rac11caAll************************************************************
label var Rac11caAll "Aggregated Race/Ethnicity using most identify/rarest group; 11 categorical var: Most Identify / Rarest Group - Aggregated race/ethnicity categorical var (with MENA as it's own category).  Includes unknowns, declines and missing"
label define Rac11caAll ///
-4 "Missing" ///
-3 "Decline" ///
-1 "Unknown" ///
0 "AIAN" ///
1 "Asian" ///
2 "Black/AfrAm" ///
3 "Latino/a/x/e" /// ///
4 "NHPI"  ///
5 "MENA" ///
6 "White" ///
7 "No Primary identity" ///
8 "Bi-racial/Multiracial" ///
9 "Multiracial" ///
10  "Other Race" ,  modify
 label value Rac11caAll Rac11caAll
replace Rac11caAll=-4 if Rac11caAll==. 


replace RareRace=-4 if RareRace==.
replace RareRaceAdj=-4 if RareRaceAdj==.
tab RareRaceAdj Rac11caAll, miss
tab  Rac11caAll, miss


******************************************************************************  
*47  BIPOC dich var
  ******************************************************************************  
recode Rac11caAll(0/5=1)(6=0)(7/10=1)(-4/-1=.), gen(BIPOCdi)
label var BIPOCdi "Dichotomous indicator of White or Tribal Member/Person of Color"
label define BIPOCdilab ///
0 "White alone" ///
1 "Tribal/POC/Multi" ///
, modify
label value BIPOCdi BIPOCdilab
tab Rac11caAll BIPOCdi
******************************************************************************  
*48- Rac8ca var - combining other and Multi and excludes unknown, decl and missing
  ******************************************************************************  

 recode Rac11caAll(7/10=7)(-4/-1=.), gen(Rac8ca)
**Rac8ca
 label var Rac8ca "Aggregated Race/Ethnicity using most identify/rarest group (with MENA as it's own category; includes missing codes_"
  label define Rac8ca ///
0 "AIAN" ///
1 "Asian" ///
2 "Black/AfrAm" ///
3 "Latino/a/x/e" /// ///
4 "NHPI"  ///
5 "MENA"  ///
6 "White" ///
7 "Multi/other" , modify
label value  Rac8ca Rac8ca
tab Rac11caAll Rac8ca, miss


**Rac7ca
 recode Rac11caAll(7/10=6)(6=5)(-4/-1=.), gen(Rac7ca)
 label var Rac8ca "Aggregated Race/Ethnicity using most identify/rarest group (with MENA combined with White; includes missing codes)"

label define Rac7calab ///
0 "AIAN" ///
1 "Asian" ///
2 "Black/AfrAm" ///
3 "Latino/a/x/e" ///
4 "NHPI"  ///
5 "White/MENA" ///
6 "Multi/other" , modify
label value Rac7ca Rac7calab
tab Rac11caAll Rac7ca, miss

egen float RaceTotAll= rownonmiss(  ReAmInd ReAlaskNat  ReLatInd ReAIANLeg ///
ReAsianLeg ReAsianInd ReCambodian ReChinese ReFilipino ReHmong ReJapanese ReKorean ReLaotian ReMyanmar ReSoAsian ///
ReVietnamese ReAsianOth ReAfrAm ReSomali ReEthiopian ReBlackLeg  ReCaribbean ReBlackOth ReAfrican ///
ReNatHaw   ReCham ReMarshallese  ReCOFA  ReSamoan ReNHPIoth  ReNHPILeg ///
ReHisMex ReHisCen ReHisSou ReHisOth    ///
ReSlavic ReMidEast ReNoAfr ReMENALeg ReEastEur ReWestEur ReWhiteLeg ReOthwhite  ReMulti ReRaceOth) 
label var RaceTotAll "Total r/e identities including multi, other race"



egen float RaceTotB= rownonmiss(ReAmInd ReAlaskNat  ReLatInd ReAIANLeg ///
ReAsianLeg ReAsianInd ReCambodian ReChinese ReFilipino ReHmong ReJapanese ReKorean ReLaotian ReMyanmar ReSoAsian ///
ReVietnamese ReAsianOth ReAfrAm ReSomali ReEthiopian ReBlackLeg  ReCaribbean ReBlackOth ReAfrican ///
ReNatHaw  ReCham ReMarshallese  ReCOFA ReSamoan  ReNHPIoth  ReNHPILeg ///
ReHisMex ReHisCen ReHisSou ReHisOth    ///
ReSlavic ReMidEast ReNoAfr ReMENALeg ReEastEur ReWestEur ReWhiteLeg ReOthwhite ) 

 
replace  ReMENALeg=. if ReNoAfr ==1
replace  ReMENALeg=. if ReMidEast ==1

drop ReAIANG ReMENAG ReWhiteG ReBlackG ReHispG ReNHPIG ReAsianG 
label var RaceTotB "Total r/e identities sans multi, other race, decline, unknown"

****************************************************************************** 
*45. New Agg RE vars
****************************************************************************** 
egen float ReAIANG= rownonmiss(ReAIANLeg ReAmInd ReAlaskNat  ReLatInd ) 
egen float ReMENAG= rownonmiss(ReNoAfr ReMidEast ReMENALeg)
egen float ReWhiteG= rownonmiss(ReWhiteLeg ReSlavic ReWestEur ReEastEur ReOthwhite)  
egen float ReBlackG= rownonmiss(ReBlackLeg ReAfrAm   ReCaribbean ReEthiopian ReSomali ReBlackOth ReAfrican)
egen float ReHispG = rownonmiss( ReHisMex ReHisOth ReHisCen ReHisSou)
egen float ReNHPIG = rownonmiss( ReNHPILeg  ReCham ReMarshallese ReCOFA ReNatHaw ReSamoan  ReNHPIoth )
egen float ReAsianG = rownonmiss(ReAsianLeg ReAsianInd ReCambodian ReChinese ReFilipino ReHmong ReJapanese ReKorean ReLaotian ReMyanmar ReVietnamese ReSoAsian ReAsianOth) 
foreach var of varlist ReAIANG ReMENAG ReWhiteG ReBlackG ReHispG ReNHPIG ReAsianG  { 
replace `var'= 1 if `var'>=1 & `var'!=.
replace `var'= . if `var'==0 
           } 
		   
		   
label var ReBlackG "Black or African rolled up grouping to Black and African American category"
label var ReWhiteG "White rolled up grouping to White category"
label var ReNHPIG "Native Hawaiian Pacific Islander rolled up grouping to NHPI category"
label var ReAIANG "American Indian Alaskan Native rolled up grouping to AIAN category"
label var ReAsianG "Asian rolled up grouping to Asian category"
label var ReHispG "Hispanic rolled up grouping to Hispanic category"
label var ReMENAG "MENA rolled up grouping to MENA category"

*issues: ReNHPIGS ReBlackGS
*************************************************************
* RaceMainN vars (prep for AOIC vars
 *************************************************************
*AIAN Asian Black Hispanic NHPI MENA WhiteNoMena Multi ReUN ReRaceOth

drop RaceMainN
egen float RaceMainN = rownonmiss(ReAIANG ReMENAG ReWhiteG ReBlackG ReHispG ReNHPIG ReAsianG )  
tab RaceTotAll RaceMainN , miss
replace  RaceMainN=1 if ReMulti==1 & 	RaceMainN<=0	 	  
replace  RaceMainN=1 if ReRaceOth==1 & 	RaceMainN<=0
replace  RaceMainN=1 if Rac11caAll>=7  	& Rac11caAll<=10 &  RaceMainN<=0 

tab RaceTotAll RaceMainN , miss


  ****************************************************************************** 
*58 OMBrace
  ****************************************************************************** 

gen OMBrace=0 if ReAIANG==1  & RaceMainN==1 
replace OMBrace=1 if ReAsianG==1 &    RaceMainN==1  & OMBrace==.
replace OMBrace=2 if ReBlackG==1  &   RaceMainN==1  & OMBrace==.
replace OMBrace=3 if ReNHPIG==1 &   RaceMainN==1  & OMBrace==.
replace OMBrace=4 if ReMENAG==1 &    RaceMainN==1 & OMBrace==.
replace OMBrace=4 if ReWhiteG==1   &  RaceMainN==1  & OMBrace==.
replace OMBrace=5  if OMBrace==. & ReRaceOth==1 & ReMulti==. 
replace OMBrace=5  if OMBrace==. & RareRace==53  
replace OMBrace=5  if  ReHispG==1  & OMBrace  
replace OMBrace=6  if  OMBrace==. & RaceMainN>=2  & RaceMainN!=.
replace OMBrace=6  if  OMBrace==. & ReMulti==1
tab OMBrace

tab OMBrace
label define OMBrace ///
0 "AIAN" ///
1 "Asian" ///
2 "Black" ///
3 "NHPI"  ///
4 "White" /// 
5 "Some other race" /// 
6 "Multi", modify
label value OMBrace OMBrace
 label var OMBrace "OMB race" 
 
 tab Rac11caAll OMBrace, miss
 

****************************************************************************** 
*60 OMBeth
****************************************************************************** 
gen OMBeth=1 if ReHispG==1
replace OMBeth=1 if HISPdi==1
replace OMBeth=0 if OMBeth==. &  RaceTotAll>=1 & RaceTotAll!=.
label define OMBeth 0 "Not Hispanic" 1 "Hispanic", modify
label value OMBeth OMBeth
 label var OMBeth "OMB ethnicity" 
 
tab OMBrace  OMBeth, miss
****************************************************************************** 
*61 OMBrace2 
****************************************************************************** 
gen OMBrace2=.
replace OMBrace2=3 if ReNHPIG==1 & OMBrace2==.
replace OMBrace2=2 if ReBlackG==1 & OMBrace2==.
replace OMBrace2=0 if ReAIANG==1 & OMBrace2==.
replace OMBrace2=1 if ReAsianG==1 & OMBrace2==.
replace OMBrace2=5 if ReHispG==1 & OMBrace2==.
replace OMBrace2=4 if ReWhiteG==1 & OMBrace2==.
replace OMBrace2=4 if ReMENAG==1 & OMBrace2==.
replace OMBrace2=5 if ReRaceOth==1 & OMBrace2==.
replace OMBrace2=5 if OMBrace==5 & OMBrace2==.

replace OMBrace2=6 if ReMulti==1 & OMBrace2==.
*replace OMBrace2=6 if RePriMulti==1 & OMBrace2==.
label value OMBrace2 OMBrace
tab OMBrace2 OMBrace, miss
label var OMBrace2 "OMB race using most/rarest" 

tab Rac11caAll  OMBrace2, miss



*************************************************************
*62 Race AOIC label define
 *************************************************************
 label define AOIC ///
  0 "This identity only" ///
  1 "2+  identities w/in grp" ///
  2 "2+  identities across grps/within grp", modify

*note ReMulti is missing
	   

*************************************************************
*56 REOIC
 *************************************************************

 gen REOIC=.
replace REOIC=0 if  RaceTotB==1 & RaceMainN==1 
replace REOIC=0 if  ReRaceOth==1 &  RaceTotB<=0
replace REOIC=0 if  ReMulti==1 & RaceTotB<=0
replace REOIC=1 if RaceTotB>=2 & RaceMainN==1 & REOIC==.
replace REOIC=2 if RaceMainN>=2 & REOIC==.  
label var REOIC "Three categorical var for each granular race/ethnicity identity"
label define REOIC 0 "Single identity" 1 "Multi within grp" 2 "Within &/or between grps", modify
label value REOIC REOIC
tab Rac11caAll REOIC , miss
tab RaceTotAll REOIC , miss
tab RaceTotB REOIC , miss
tab RaceTotAll REOIC , miss

tab ReOthwhite  REOIC , miss
tab ReWestEur  REOIC , miss
tab RareRace  REOIC , miss


 foreach var of varlist Re*G RAC* {
tab  `var' if ReOthwhite ==1
 }
 

 
*filling zeros back in
foreach var of varlist Re* ReAIANG ReMENAG ReWhiteG ReBlackG ReHispG ReNHPIG ReAsianG   { 
replace `var'= 0 if `var'==. 
label value `var' no0yes1
           } 
		   
**RareRace**RareRaceAdj
label var RareRace "Primary Race (Most Identify/Rarest Group)"
label var RareRaceAdj "Primary Race  (Most Identify/Rarest Group with the legacy values rolled up into the 'other' categories and all multi reponses rolled up also"



gen ACSRace = 0 if RAC1P==3 //AAm Indian alone
replace ACSRace = 0 if RAC1P==4 //Alaska Native alone
replace ACSRace = 0 if RAC1P==5 //Alaska Native alone	
replace ACSRace = 0 if RACAIAN==1 & RACNUM==1 //Alaska Native alone	
replace ACSRace=1 if RAC1P==6 //ReAsianG alone
replace ACSRace=2 if RAC1P==2 //Black alone
replace ACSRace=4 if RAC1P==7 //ReNHPIG
replace ACSRace=3 if  HISPdi==1 & ACSRace==.

replace ACSRace=5 if RAC1P==1  & ACSRace==. //White alone
replace ACSRace=6 if RAC1P==8  & ACSRace==. // Other
replace ACSRace=6 if RAC1P==9  & ACSRace==. // Two or More Races	


label define ACSRacelab ///
0 "AIAN" ///
1 "Asian" ///
2 "Black" ///
3 "Latinx" ///
4 "NHPI" ///
5 "White" ///
6 "Other/Multi"  , modify
label value ACSRace ACSRacelab
tab ACSRace RAC1P, miss

label var ACSRace "OMB Race w/ Latinx b4 White/SOR"

tab  OMBrace  ACSRace, miss

******************************
save "TempFile6v2.dta", replace
******************************
*59 save file
******************************
use "TempFile6v2.dta", replace



/*ReAIANG ReAsianG ReBlackG ReHispG ReNHPIG ReMENAG ReWhiteG ReMulti RacUnkn ReRaceOth
egen float RaceMainN = rownonmiss(ReAIANG ReAsianG ReBlackG ReHispG ReNHPIG ReMENAG ReWhiteG)  */

drop RaceMainN
 egen float RaceMainN = rownonmiss(ReWhiteG   ReMENAG ReAIANG ReAsianG ReBlackG ReHispG ReNHPIG )

****************************************************************************
*66 creating r/e AOIC vars  
*************************************************************
 *ReMENAG  ReWhiteG ReAIANG ReAsianG BlackAfr ReHispG ReNHPIG
 label define AOIC ///
  0 "1 R/E identity only" ///
  1 "2+ identities w/in grp" ///
  2 "2+ identities w/in &/or across", modify

*************************************************************
foreach var of varlist  ReAlaskNat ReLatInd ReAmInd ReAsianInd ReCambodian ///
ReChinese ReFilipino ReHmong ReJapanese ReKorean ReLaotian ReMyanmar ///
ReVietnamese ReSoAsian   ReAsianSE ReAsianE ReAsianC ReAsianOth ReAfrAm ReAfrican  ///
ReCaribbean ReEthiopian ReSomali  ReBlackOth ReHisMex ReHisCen ReHisOth ReHisSou ReCham  ///
ReMarshallese ReCOFA ReNatHaw ReSamoan  ReNHPIoth ReMidEast ReNoAfr ///
ReWestEur ReEastEur ReSlavic ReOthwhite   *Leg   Re*G ReRaceOth {
gen `var'OIC =.
replace `var'OIC =0 if `var'==1 & REOIC ==0 
replace `var'OIC =1 if `var' ==1 & REOIC ==1  &  `var'OIC==.
replace `var'OIC =2 if `var' ==1 & REOIC ==2  &  `var'OIC==.
label value `var'OIC  AOIC 
tab `var'OIC 
 }  
foreach var of varlist ReLatInd Re*Leg Re*G {
 tab REOIC `var'
 
  }  
*ReLagInd - won't have single r/e due to Hispanic Ethnicity and how this was collected
tab REOIC ReLatInd, miss

*Leg vars won't have multi within gorup due to Legacy being eliminated if the Re*G var ==1
tab REOIC ReAIANLeg, miss
tab REOIC ReAsianLeg, miss
tab REOIC ReBlackLeg, miss
tab REOIC ReWhiteLeg, miss
tab REOIC ReNHPILeg, miss




****************************************************************************
*67**label for r/e AOIC vars 
****************************************************************************
*label var OthwhiteOIC "Other White AOIC"
label var ReNoAfrOIC "North ReAfrican AOIC"
label var ReNatHawOIC "Native Hawaiian AOIC"

label var ReNHPIothOIC "Other Pacific Isldr AOIC"
label var ReNHPILegOIC "NHPI (Legacy)) AOIC"
label var ReMyanmarOIC "Communities of Myanmar AOIC"

label var ReMidEastOIC "Middle Eastern AOIC"
label var ReMarshalleseOIC "Marshallese AOIC"
label var ReMENALegOIC "MENA (Legacy) AOIC"

label var ReLatIndOIC "Indigenous Mexican, Central or South American AOIC"
label var ReLaotianOIC "Laotian AOIC"
label var ReKoreanOIC "Korean AOIC"
label var ReJapaneseOIC "Japanese AOIC"
label var ReHmongOIC "Hmong AOIC"
*label var HispLegOIC "Latinx(Legacy) AOIC"

label var ReHisSouOIC "Latinx So American AOIC"
label var ReHisOthOIC "Other Latinx AOIC"
label var ReHisMexOIC "Latinx Mexican AOIC"

label var ReHisCenOIC "Latinx Cen American AOIC"
*label var GuamOIC "Guamanian AOIC(inputed)"
*label var GuamChamOIC "Guam/CHamorro AOIC(inputed)"
label var ReChamOIC "CHamorro AOIC (inputed)"

label var ReWhiteLegOIC "White (Legacy) AOIC"

label var ReAsianLegOIC "Asian (Legacy) AOIC"
label var ReAIANLegOIC "AIAN(Legacy) AOIC"
*label var ReHispLegOIC "Latinx(Legacy) AOIC"

label var ReWestEurOIC "Western European AOIC"
label var ReEastEurOIC "Eastern European AOIC"
label var ReFilipinoOIC "Filipino AOIC"
label var ReHmongOIC "Hmong AOIC"
label var ReEthiopianOIC "Ethiopian AOIC"
label var ReChineseOIC "Chinese AOIC"

label var ReCaribbeanOIC "Afro-Caribbean AOIC"
*label var CanIndOIC "Candian Indian/First Nation AOIC"
label var ReCambodianOIC "Cambodian AOIC"
label var ReCOFAOIC "Communities of Myanmar AOIC"
label var ReBlackOthOIC "Other Black AOIC"

label var ReAsianOthOIC "Other Asian AOIC"

label var ReAsianIndOIC "Asian Indian AOIC"
label var ReAmIndOIC "American Indian AOIC"
label var ReAlaskNatOIC "Alaska Native AOIC"
label var ReAfrAmOIC "African American AOIC"
label var ReVietnameseOIC "Vietnamese AOIC"
*label var TonganOIC "ReTongan AOIC"

label var ReSomaliOIC "Somali AOIC(inputed)"
label var ReSoAsianOIC "South Asian AOIC"
label var ReSlavicOIC "Slavic AOIC"
label var ReSamoanOIC "Samoan AOIC"


label var ReAsianSEOIC "South East ReAsianG(Thai/Singapore/Malay/Iu Mien)(AOIC)"
label var ReAsianEOIC  "East ReAsianG(ReChinese/ReJapanese/ReKorean/Mongolian/Okinawan/Taiwanese)(AOIC)"
label var ReAsianCOIC  "Central ReAsianG(Uzbek/Kazak/Turkmen/Tajik)(AOIC)"
label var ReOthwhiteOIC  "Other white(AOIC)"



label var ReAIANGOIC  "AIAN (all;1=aoic)"
label var ReBlackGOIC  "Black (all;1=aoic)"
label var ReWhiteGOIC  "White (all;1=aoic)"
label var ReNHPIGOIC  "NHPI (all;1=aoic)"
label var ReAsianGOIC  "Asian (all;1=aoic)"
label var  ReMENAGOIC	"MENA (all;1=aoic)"
label var ReHispGOIC "Latinx (all;1=aoic)"

label var ReAfricanOIC "Other African AOIC"
label var ReCOFAOIC "Communities of Micronesian Region AOIC"
label var ReBlackLegOIC "Black (Legacy) AOIC"

*checking   
foreach var of varlist Re*OIC    {
tab `var'
       }  
	   
 egen float ReWhiteMENAG = rownonmiss(ReWhiteLeg ReWestEur ReEastEur ReSlavic ReOthwhite ReMidEast ReNoAfr ReMENALeg) 
 
 order RaceTot* REOIC ReAIANLeg ReAlaskNat ReLatInd ReAmInd ///
ReAsianLeg ReAsianInd ReCambodian ReChinese ReFilipino ReHmong ReJapanese ReKorean ReLaotian ///
ReMyanmar ReVietnamese ReSoAsian   ReAsianSE ReAsianE ReAsianC ReAsianOth ///
ReBlackLeg ReAfrAm ReAfrican   ReCaribbean ReEthiopian ReSomali ReBlackOth ///
ReHisMex ReHisCen ReHisSou ReHisOth ///
ReNHPILeg  ReCham  ReMarshallese ReCOFA ReNatHaw ReSamoan  ReNHPIoth  ///
ReMENALeg  ReMidEast ReNoAfr  ReWhiteMENAG  ReWhiteLeg ReWestEur ReEastEur ReSlavic ReOthwhite  ReRaceOth ReMulti 
 
 foreach var of varlist ReAIANLeg ReAlaskNat ReLatInd ReAmInd ///
ReAsianInd ReCambodian ReChinese ReFilipino ReHmong ReJapanese ReKorean ReLaotian ///
ReMyanmar ReVietnamese ReSoAsian   ReAsianSE ReAsianE ReAsianC ReAsianOth ///
ReBlackLeg ReAfrAm ReAfrican   ReCaribbean ReEthiopian ReSomali ReBlackOth ///
ReHisMex ReHisCen ReHisSou ReHisOth ///
ReNHPILeg  ReCham   ReMarshallese ReCOFA* ReNatHaw ReSamoan  ReNHPIoth  ///
ReMidEast ReNoAfr   ReWhiteLeg ReWestEur ReEastEur ReSlavic ReOthwhite  ///
ReAIANG ReAsianG ReBlackG ReHispG ReMENAG ReNHPIG ReWhiteG *Leg  ReWhiteMENAG ReRaceOth ReMulti {
replace `var'=. if `var' ==0 
label value  `var'  no0yes1
       }  
for var RaceTotAll : tab  X ReWhiteG[fw=PWGTP]  if ST ==41 


*****************************************************************************
* 68 DISABILITY *********************************
*****************************************************************************
recode DIS (2=0), gen(DISDi)
tab DISDi, miss
label value DISDi no0yes1
label var DISDi "Has disability?"
tab DISDi



recode DOUT (2=0), gen(DOUTDi)
recode DPHY (2=0), gen(DPHYDi)
recode DREM (2=0), gen(DREMDi)
recode DEYE (2=0), gen(DEYEDi)
recode DEAR (2=0), gen(DEARDi)
recode DDRS (2=0), gen(DDRSDi)

label var DPHY "Mobility limitation"
label var DEYE "Vision limitation"
label var DEAR "Hearing limitaiton"
label var DDRS "Self-Care limitaiton"
label var DOUT "Indep. liv limitaiton"
label var DREM "Cognitive/memory limitation"

 
label var DPHYDi "Have physical limitation?"
label var DEYEDi "Have vision limitation?"
label var DEARDi "Have hearing limitation?"
label var DDRSDi "Have self-care limitation?"
label var DOUTDi "Have indep.liv limitation?"
label var DREMDi "Have cognitive/memory limitation?"



label var DISDi "Disabled?"
label variable DIS "Disability"

*****************************************************************************
* 72  DisN  nbr of functional limiations
*****************************************************************************
egen float DisN = rowtotal(DEARDi DEYEDi  DPHYDi  DREMDi  DDRSDi  DOUTDi )
tab  DisN

replace DisN=0 if  DIS==0
label var DisN "Number of functional limitations"


**labeling for DA7compACS
label define DA7compACSlab  ///
0 "Non-disabled" ///
1 "Hearing limitation only" ///
2 "Vision limitation only" ///
3 "Mobility limitation only" ///
4 "Cognitive/Memory limitation only" ///
5  "2+ limitations(excluding IL/SC)" ///
6 "IndLiv/SelfCare (IL/SC)" ///
-7 "NA/other reason" -4 "Missing" -3 "Declined" ///
-2 "Don't Understand"	-1 "Unknown" , modify

gen DA7compACSall=. 
replace DA7compACSall=6 if DDRSDi==1 
replace DA7compACSall=6 if DOUTDi==1  
replace DA7compACSall=0 if DISDi==0  & DA7compACSall==. 
replace DA7compACSall=1 if DEARDi==1 & DisN==1   & DA7compACSall==. 
replace DA7compACSall=2 if DEYEDi==1 & DisN==1   & DA7compACSall==. 
replace DA7compACSall=3 if DPHYDi==1 & DisN==1   & DA7compACSall==.  
replace DA7compACSall=4 if DREMDi==1 & DisN==1   & DA7compACSall==.  
replace DA7compACSall=5 if DA7compACSall==. &  DisN>=2 & DisN!=. 
replace DA7compACSall=-4 if   DA7compACSall==. 

label var DA7compACSall "Seven Category ACS Disability with missing codes" 
label value DA7compACSall DA7compACSlab
tab DisN  DA7compACSall, miss


label define DA4cat ///
3 "Indep.Liv/Self-Care/PermDA/SSI/LTC" ///
2 "All others with 2+ limitations"  ///
1 "1 Limitation" ///
0 "Non-disabled", modify  


gen DA4cat=.
replace DA4cat=0 if DisN==0 
replace DA4cat=1 if DisN==1 & DEARDi==1
replace DA4cat=1 if DisN==1 & DEYEDi==1
replace DA4cat=1 if DisN==1 & DREMDi==1
replace DA4cat=1 if DisN==1 & DPHYDi==1
replace DA4cat=2 if DisN>=2 & DisN!=. & DA4cat==.

replace DA4cat=3 if DOUTDi==1
replace DA4cat=3 if DDRSDi==1
label value DA4cat DA4cat
label var DA4cat "Four Category Disability (by # & severity)"
tab DA7compACSall  DA4cat, miss


*****************************************************************************
* 74  **Dis  OIC vars
*****************************************************************************
 
 label define DAOIC ///
  0 "Non-disabled" ///
  1 "This limitation only" ///
  2 "2+ limitations", modify
 
 foreach var of varlist  DEARDi DEYEDi DREMDi DPHYDi DDRSDi DOUTDi  { 
gen `var'OIC = 0 if DIS==2
replace `var'OIC =1 if `var' ==1 & DisN==1
replace `var'OIC =2 if `var' ==1 & DisN>=2
label value `var'OIC DAOIC 
           }  

label var DEARDiOIC "Hearing limaitation OIC"
label var DEYEDiOIC "Vision limaitation OIC"
label var DPHYDiOIC "Mobiity limaitation OIC"
label var DREMDiOIC "Cognitive limaitation OIC"
label var DDRSDiOIC "Self-Care limaitation OIC"
label var DOUTDiOIC "Indep living limaitation OIC"


label define DAOICv2 ///
  0 "Does not have this limitation" ///
  1 "This limitation only" ///
  2 "2+ limitations", modify
 
 foreach var of varlist  DEAR DEYE DREM DPHY DDRS DOUT { 
gen `var'OICv2 = 0 if `var' ==2
replace `var'OICv2 =1 if `var' ==1 & DisN==1
replace `var'OICv2 =2 if `var' ==1 & DisN>=2
label value `var'OICv2 DAOICv2 
label var `var'OICv2 "`var' OIC"
           }  
tab  DEAROICv2  if NonInsCil==1, miss	

label var DEAROICv2 "Hearing limaitation OIC"
label var DEYEOICv2 "Vision limaitation OIC"
label var DPHYOICv2 "Mobiity limaitation OIC"
label var DREMOICv2 "Cognitive limaitation OIC"
label var DDRSOICv2 "Self-Care limaitation OIC"
label var DOUTOICv2 "Indep living limaitation OIC"
/*	   
svy: tab  DEAROICv2  if LEPdi==1, count  format(%-10.0g)  csepwidth(10) stubwidth(30) 
svy: tab  DEAROICv2 LEPdi, count  format(%-10.0g)  csepwidth(10) stubwidth(30) 
svy: tab  DEAROICv2  if LEPdi==1, percent  format(%-10.0g)  csepwidth(10) stubwidth(30) 
svy: tab  DEAROICv2 LEPdi, percent col format(%-10.0g)  csepwidth(10) stubwidth(30) 
	*/	   


*****************************************************************************
*93***RacDis*****INTERESETIONAL VARS
*****************************************************************************

gen RacDis=.

replace RacDis=0 if DISDi==0 & BIPOCdi==0
replace RacDis=1 if DISDi==0 & BIPOCdi==1
replace RacDis=2 if DISDi==1 & BIPOCdi==0
replace RacDis=3 if DISDi==1 & BIPOCdi==1
    label define RacDis   ///
   0 "ND White" ///
   1 "ND BIPOC" ///
   2 "DA White" ///
   3 "DA BIPOC" , modify
label value RacDis RacDis
label var RacDis "Race X Disab 4 cat"

tab BIPOCdi RacDis, miss

*****************************************************************************
*94***SexDis*****INTERESETIONAL VARS
*****************************************************************************
gen SexDis=.
replace SexDis=0 if DISDi==0 & SexDi==0
replace SexDis=1 if DISDi==0 & SexDi==1
replace SexDis=2 if DISDi==1 & SexDi==0
replace SexDis=3 if DISDi==1 & SexDi==1
    label define SexDis   ///
   0 "ND Male" ///
   1 "ND Female" ///
   2 "DA Male" ///
   3 "DA Female" , modify
label value SexDis SexDis
label var SexDis "Disability X Sex 4 cat"
tab SexDi SexDis, miss
tab BIPOCdi SexDis, miss



*****************************************************************************
*99***RacSexDA*****INTERESETIONAL VARS
*****************************************************************************
 
gen RacSexDA=.
replace RacSexDA=0 if SexDi==1 & DISDi==0 & BIPOCdi==0
replace RacSexDA=1 if SexDi==0 & DISDi==0 & BIPOCdi==0

replace RacSexDA=2 if SexDi==1 & DISDi==0 & BIPOCdi==1
replace RacSexDA=3 if SexDi==0 & DISDi==0 & BIPOCdi==1

replace RacSexDA=4 if SexDi==1 & DISDi==1 & BIPOCdi==0
replace RacSexDA=5 if SexDi==0 & DISDi==1 & BIPOCdi==0

replace RacSexDA=6 if SexDi==1 & DISDi==1 & BIPOCdi==1
replace RacSexDA=7 if SexDi==0 & DISDi==1 & BIPOCdi==1
label define RacSexDA ///
0 "ND White Female" ///
1 "ND White Male" ///
2 "ND BIPOC Female" ///
3 "ND BIPOC Male" ///
4 "DA White Female" ///
5 "DA White Male" ///
6 "DA BIPOC Female" ///
7 "DA BIPOC Male" , modify
label value RacSexDA RacSexDA
label var RacSexDA "DA x Sex x Race"
tab RacSexDA BIPOCdi, miss


order SERIALNO RT SPORDER AGEP RacSexDA  Sex* DISDi BIPOC


*******************************************************************************
*108 DeafGrp (for Chad)
*******************************************************************************
label define DeafGrp ///
0 "Non-disabled" ///
1 "Disabled" ///
2 "Deafonly" ///
3 "DeafBlind+" ///
4 "Deaf&DA+", modify

gen DeafGrp =.
replace DeafGrp =0 if  DISDi==0
replace DeafGrp =1 if  DISDi==1 & DEARDi!=1 & DEYEDi!=1 &  DeafGrp==. 
replace DeafGrp =2 if  DISDi==1 & DEARDi==1 & DisN==1 &  DeafGrp==. 
replace DeafGrp =3 if  DISDi==1 & DEARDi==1 & DEYEDi==1 &  DeafGrp==. 
replace DeafGrp =4 if  DISDi==1 & DEARDi==1 & DisN>=2 &  DeafGrp==. 
replace DeafGrp =1 if  DISDi==1 & DEARDi!=1 &  DeafGrp==. 

label value DeafGrp DeafGrp
tab DA7compACSall  DeafGrp, miss
label var DeafGrp "Deaf/Hard of Hearing by other limitations"


 foreach var of varlist  DEARDi DEYEDi DREMDi DPHYDi DDRSDi DOUTDi  { 
label value `var'  no0yes1
           } 
		   
		   
*******************************************************************************
*109 Geo/PUMAs
*******************************************************************************
rename ST State
 label define State 41 "Oregon" 53 "Washington"
 label value State State
 
 /*reminders 0 see 1v5 do file for details
label var OHAeeoc "Tri Co., Marion, Lane, Linn/Benton, Yamhill/Polk"
label var  EastOR	"Umatilla, Union, Baker & Wallowa Counties"
label var WashCo "Wash Co"
label var MultCo "Mult Co"
label var YamPolkCo	"Yamhill & Polk Counties"
*/
*******************************************************************************
*110 "I-5 Corridor + Clark Co" =  OHAeeoWa
*******************************************************************************

gen OHAeeoWa=.
replace OHAeeoWa=1 if OHAeeoc==1
replace OHAeeoWa=1 if ClarkCo==1
label var OHAeeoWa "I-5 Corridor + Clark Co"
label value  OHAeeoWa no0yes1

*******************************************************************************
gen ClarkUmaI5=OHAeeoWa
replace ClarkUmaI5=1 if EastOR==1
label var ClarkUmaI5 "I-5 Corridor+ClarkCo+ E OR(Umatilla/Baker/Wallowa/Union)"
label value  ClarkUmaI5 no0yes1
tab ClarkUmaI5 OHAeeoWa, miss
*******************************************************************************
*111 label clean up
*******************************************************************************
label var DisN "# of functional limitations"
label var NonInstDi "Non-Institutionalized"


label var DEAR "Hearing Limitation"
label var DEYE "Vision Limitation"
label var DOUT "Indep Living Limitation"
label var DREM "Cogn/Memory Limitation"
label var DDRS "Self-Care Limitation"
label var DPHY "Mobility Limitation"


label var DPHYDiOIC "Mobility limitation AOIC" 
label var RaceMainN "Nbr of main race categoegories" 
label var MULTIS "Multi-original" 
label var RaceOthS "Some other race - orig" 
label var ReMENAG "Middle Eastern/North ReAfrican"
label var ReSamoan "ReSamoan"
labe var  HISP "ReHispG(orig)"


label var DREMDiOIC  "Cogn/Memory -AOIC" 
label var DOUTDiOIC "Indep Living AOIC"


label var ENG "English Porificiency"
label var LANX "Speak lang other than English?"
label var Region "Regions in Oregon"

label var ReNoAfr "North African"
label var ReOthwhite "Other White"

label var  RACPI "Census Flag-Pacific Islander"
label var RACWHT"Census Flag-White"
label var RACBLK "Census Flag-Black"
label var RACASN "Census Flag-Asian"
label var RACAIAN "Census Flag-AIAN"
label var RACNH "Census Flag-Native Hawaiian"
label var RACSOR "Census Flag-Some other race"
label var RACNUM "Nbr of r/e categories by Census"
label var  RAC1P  "RAC1P - numeric format"
label var RAC1PS  "RAC1P - string format"
label var RAC2P  "RAC2P - numeric format"
label var  RAC2PS   "RAC2P - string format"

label var RAC3PS  "RAC3P - string format"
label var RAC3P   "RAC3P - numeric format"
label var HISP "Orig PUMS Ethnicity Var" 

label var ANC1P "Orig PUMS Ancestry (1st response) var" 
label var ANC2P "Orig PUMS Ancestry (2nd response) var" 

label var ReAIANLeg "American Indian/Alaska Native"
label var ReAsianLeg "Asian"
label var ReBlackLeg "Black/African American"
*label var ReHispLeg "Hispanic"
label var ReNHPILeg "Native Hawaiian / Pacific Islander"
label var ReWhiteLeg "White"
label var ReMENALeg "Middle Eastern / North African"
label var ReAlaskNat "Alaska Native"
label var 	ReAmInd			"American Indian"
*label var 	ReCanInd		"Canadian Inuit, Metis, or First Nation"
label var 	ReLatInd		"Indigenous Mexican, Central American, or South American"
label var 	ReCambodian 	"Cambodian"
label var 	ReAsianInd 		"Asian Indian"
label var 	ReAsianOth		"Other Asian"
label var 	ReChinese		"Chinese"
label var 	ReFilipino 		"Filipino/a"
label var 	ReHmong			"Hmong"
label var 	ReJapanese 		"Japanese"
label var 	ReKorean		"Korean"
label var 	ReLaotian	"Laotian"
label var 	ReMyanmar 		"Communities of Myanmar"
label var 	ReSoAsian		"South Asian"
label var 	ReVietnamese	"Vietnamese"
label var 	ReAfrAm			"African American"
label var 	ReAfrican		"Other African"
label var 	ReBlackOth		"Other Black"
label var 	ReCaribbean		"Afro-Caribbean"
label var 	ReEthiopian 	"Ethiopian"	
label var 	ReSomali 		"Somali"
label var 	ReHisSou		"Latinx South American"
label var 	ReHisCen		"Latinx Central American"
label var 	ReHisMex		"Latinx Mexican"
label var 	ReHisOth		"Other Hispanic or Latino/a/x/e"
label var 	ReMidEast		"Middle Eastern"
label var 	ReNoAfr			"North African"
label var 	ReCOFA			"Communities of the Micronesian Region"
label var 	ReMarshallese	"Marshallese"
label var 	ReNatHaw		"Native Hawaiian"
label var 	ReCham			"CHamoru (Chamorro)"
label var 	ReNHPIoth		"Other Pacific Islander"
label var 	ReSamoan		"Samoan"
label var 	ReEastEur		"Eastern European "
label var 	ReOthwhite		 "Other White"
label var 	ReSlavic		"Slavic"
label var 	ReWestEur		"Western European"
label var 	ReRaceOth	 	"Other Race"
label var ReAsianSE "Southeast Asian; SE Asian (Intermediate aggregated variable))"
label var ReAsianE "East Asian (Intermediate aggregated variable)"
label var ReAsianC "Central Asian (Intermediate aggregated variable)"
*label var ReAsianS "South Asian (Intermediate aggregated variable)" 

****************************************
label var ReAIANG "American Indian Alaskan Native rolled up grouping to AIAN category"
label var ReAsianG "Asian rolled up grouping to Asian category"
label var ReBlackG "Black or African rolled up grouping to Black and African American category"
label var ReHispG "Hispanic rolled up grouping to Hispanic category"
label var ReMENAG "Middle Eastern North African rolled up grouping to MENA category"
label var ReNHPIG "Native Hawaiian Pacific Islander rolled up grouping to NHPI category"
label var ReWhiteG "White rolled up grouping to White category"
label var ReMulti "Multi"

label var ReRaceOth "Other Race"
label var ReRaceOthOIC "Other Race AOIC"

label var 		AGEP   "Age"

*label var 		ANC   "Ancestry recode - number of ancestries reported"
label var 		ANC1P   "Ancestry recode - first entry"
label var 		ANC2P   "Ancestry recode - second entry"
*label var 		CIT   "Citizenship status"
*label var 		CITWP   "Year of naturalization write-in"
*label var 		COW   "Class of worker"
*label var 		DECADE   "Decade of entry"
*label var 		DIVISION   "Division code based on 2010 Census definitions"
*label var 		DRAT   "Veteran service connected disability rating (percentage)"
*label var 		DRATX   "Veteran service connected disability rating (checkbox)"
*label var 		FENGP   "Ability to speak English allocation flag"
*label var 		FER   "Gave birth to child within the past 12 months"
*label var 		FHICOVP   "Health insurance coverage recode allocation flag"

*label var 		FHINS1P   "Insurance through a current or former employer or union allocation flag"
*label var 		FHINS2P   "Insurance purchased directly from an insurance company allocation flag"
*label var 		FHINS3C   "Medicare coverage given through the eligibility coverage edit"
*label var 		FHINS3P   "Medicare, for people 65 or older, or people with certain disabilities allocation flag"
*label var 		FHINS4C   "Medicaid coverage given through the eligibility coverage edit"
*label var 		FHINS4P   "Medicaid, medical assistance, or any kind of government-assistance plan for people with low incomes or a disability allocation flag"
*label var 		FHINS5C   "TRICARE coverage given through the eligibility coverage edit"
*label var 		FHINS5P   "TRICARE or other military health care allocation flag"
*label var 		FHINS6P   "VA (Health Insurance through VA Health Care) allocation flag"
*label var 		FHINS7P   "Indian health service allocation flag"
*label var 		FHISP   "Detailed Hispanic origin allocation flag"

*label var 		FMARHDP   "Divorced in the past 12 months allocation flag"
*label var 		FMARHMP   "Married in the past 12 months allocation flag"
*label var 		FMARHTP   "Times married allocation flag"
*label var 		FMARHWP   "Widowed in the past 12 months allocation flag"
*label var 		FMARHYP   "Year last married allocation flag"
*label var 		FMARP   "Marital status allocation flag"

*label var 		FMIGP   "Mobility status allocation flag"
*label var 		FMIGSP   "Migration state allocation flag"
*label var 		FMILPP   "Military periods of service allocation flag"
*label var 		FMILSP   "Military service allocation flag"
label var 		GCL   "Grandparents living with grandchildren"
*label var 		GCM   "Length of time responsible for grandchildren"
label var 		GCR   "Grandparents responsible for grandchildren"
label var 		HICOV   "Health insurance coverage recode"

label var 		HINS1   "Insurance through a current or former employer or union"
label var 		HINS2   "Insurance purchased directly from an insurance company"
label var 		HINS3   "Medicare, for people 65 and older, or people with certain disabilities"
label var 		HINS4   "Medicaid, Medical Assistance, or any kind of government-assistance plan for those with low incomes or a disability"
label var 		HINS5   "TRICARE or other military health care"
label var 		HINS6   "VA (Health Insurance through VA Health Care)"
label var 		HINS7   "Indian Health Service"
label var 		HISP   "Recoded detailed Hispanic origin"
*label var 		MAR   "Marital status"
*label var 		MARHD   "Divorced in the past 12 months"
*label var 		MARHM   "Married in the past 12 months"
*label var 		MARHT   "Number of times married"
*label var 		MARHW   "Widowed in the past 12 months"
*label var 		MARHYP   "Year last married"

*label var 		MIG   "Mobility status (lived here 1 year ago)"
*label var 		MIGPUMA   "Migration PUMA based on 2010 Census definition"
label var 		MIGSP   "Migration recode - State or foreign country code"
label var 		MIL   "Military service"
*label var 		MLPA   "Served September 2001 or later"
*label var 		MLPB   "Served August 1990 - August 2001 (including Persian Gulf War)"
*label var 		MLPCD   "Served May 1975 - July 1990"
*label var 		MLPE   "Served Vietnam era (August 1964 - April 1975)"
*label var 		MLPFG   "Served February 1955 - July 1964"
*label var 		MLPH   "Served Korean War (July 1950 - January 1955)"
*label var 		MLPIK   "Peacetime service before July 1950"
*label var 		MLPJ   "Served World War II (December 1941 - December 1946)"
label var 		POBP   "Place of birth (Recode)"
label var 		POVPIP   "Income-to-poverty ratio recode"
*label var 		POWPUMA   "Place of work PUMA based on 2010 Census definitions"
*label var 		POWSP   "Place of work - State or foreign country recode"
label var 		PRIVCOV   "Private health insurance coverage recode"
label var 		PUBCOV   "Public health coverage recode"
label var 		PUMA   "Public use microdata area code (PUMA) based on 2010 Census definition (areas with population of 100,000 or more, use with ST for unique code)"
label var 		PWGTP   "Person weight"
label var 		PWGTP1   "Person Weight replicate 1"
label var 		PWGTP10   "Person Weight replicate 10"
label var 		PWGTP11   "Person Weight replicate 11"
label var 		PWGTP12   "Person Weight replicate 12"
label var 		PWGTP13   "Person Weight replicate 13"
label var 		PWGTP14   "Person Weight replicate 14"
label var 		PWGTP15   "Person Weight replicate 15"
label var 		PWGTP16   "Person Weight replicate 16"
label var 		PWGTP17   "Person Weight replicate 17"
label var 		PWGTP18   "Person Weight replicate 18"
label var 		PWGTP19   "Person Weight replicate 19"
label var 		PWGTP2   "Person Weight replicate 2"
label var 		PWGTP20   "Person Weight replicate 20"
label var 		PWGTP21   "Person Weight replicate 21"
label var 		PWGTP22   "Person Weight replicate 22"
label var 		PWGTP23   "Person Weight replicate 23"
label var 		PWGTP24   "Person Weight replicate 24"
label var 		PWGTP25   "Person Weight replicate 25"
label var 		PWGTP26   "Person Weight replicate 26"
label var 		PWGTP27   "Person Weight replicate 27"
label var 		PWGTP28   "Person Weight replicate 28"
label var 		PWGTP29   "Person Weight replicate 29"
label var 		PWGTP3   "Person Weight replicate 3"
label var 		PWGTP30   "Person Weight replicate 30"
label var 		PWGTP31   "Person Weight replicate 31"
label var 		PWGTP32   "Person Weight replicate 32"
label var 		PWGTP33   "Person Weight replicate 33"
label var 		PWGTP34   "Person Weight replicate 34"
label var 		PWGTP35   "Person Weight replicate 35"
label var 		PWGTP36   "Person Weight replicate 36"
label var 		PWGTP37   "Person Weight replicate 37"
label var 		PWGTP38   "Person Weight replicate 38"
label var 		PWGTP39   "Person Weight replicate 39"
label var 		PWGTP4   "Person Weight replicate 4"
label var 		PWGTP40   "Person Weight replicate 40"
label var 		PWGTP41   "Person Weight replicate 41"
label var 		PWGTP42   "Person Weight replicate 42"
label var 		PWGTP43   "Person Weight replicate 43"
label var 		PWGTP44   "Person Weight replicate 44"
label var 		PWGTP45   "Person Weight replicate 45"
label var 		PWGTP46   "Person Weight replicate 46"
label var 		PWGTP47   "Person Weight replicate 47"
label var 		PWGTP48   "Person Weight replicate 48"
label var 		PWGTP49   "Person Weight replicate 49"
label var 		PWGTP5   "Person Weight replicate 5"
label var 		PWGTP50   "Person Weight replicate 50"
label var 		PWGTP51   "Person Weight replicate 51"
label var 		PWGTP52   "Person Weight replicate 52"
label var 		PWGTP53   "Person Weight replicate 53"
label var 		PWGTP54   "Person Weight replicate 54"
label var 		PWGTP55   "Person Weight replicate 55"
label var 		PWGTP56   "Person Weight replicate 56"
label var 		PWGTP57   "Person Weight replicate 57"
label var 		PWGTP58   "Person Weight replicate 58"
label var 		PWGTP59   "Person Weight replicate 59"
label var 		PWGTP6   "Person Weight replicate 6"
label var 		PWGTP60   "Person Weight replicate 60"
label var 		PWGTP61   "Person Weight replicate 61"
label var 		PWGTP62   "Person Weight replicate 62"
label var 		PWGTP63   "Person Weight replicate 63"
label var 		PWGTP64   "Person Weight replicate 64"
label var 		PWGTP65   "Person Weight replicate 65"
label var 		PWGTP66   "Person Weight replicate 66"
label var 		PWGTP67   "Person Weight replicate 67"
label var 		PWGTP68   "Person Weight replicate 68"
label var 		PWGTP69   "Person Weight replicate 69"
label var 		PWGTP7   "Person Weight replicate 7"
label var 		PWGTP70   "Person Weight replicate 70"
label var 		PWGTP71   "Person Weight replicate 71"
label var 		PWGTP72   "Person Weight replicate 72"
label var 		PWGTP73   "Person Weight replicate 73"
label var 		PWGTP74   "Person Weight replicate 74"
label var 		PWGTP75   "Person Weight replicate 75"
label var 		PWGTP76   "Person Weight replicate 76"
label var 		PWGTP77   "Person Weight replicate 77"
label var 		PWGTP78   "Person Weight replicate 78"
label var 		PWGTP79   "Person Weight replicate 79"
label var 		PWGTP8   "Person Weight replicate 8"
label var 		PWGTP80   "Person Weight replicate 80"
label var 		PWGTP9   "Person Weight replicate 9"
*label var 		REGION   "Region code based on 2010 Census definitions"
label var 		RELSHIPP   "Relationship to reference person"
label var 		RT   "Record Type"
*label var 		SCH   "School enrollment"
*label var 		SCHG   "Grade level attending"
*label var 		SCHL   "Educational attainment"
label var 		SERIALNO   "Housing unit/GQ person serial number"
label var 		SEX   "Sex"
label var 		SPORDER   "Person number"
*label var 		YOEP   "Year of entry"

label variable RareRaceAdj "Primary Race (rarest grp; legacy collapsed in'other' categories)"
 label variable RaceMainN "Nbr of 'parent/agg' r/e identities"
label variable RacSexDA "Rac x Sex x Disability"
label var LANX "Language other than English spoken at home? (age 5+)"


*******************************************************************************
*checking and clean up
*******************************************************************************
		  	  
 foreach var of varlist ReAIANLeg ReAlaskNat ReLatInd ReAmInd ///
 ReAsianLeg ReAsianInd ReCambodian ReChinese ReFilipino ReHmong ReJapanese ReKorean ReLaotian ///
 ReMyanmar ReVietnamese ReSoAsian   ReAsianSE ReAsianE ReAsianC ReAsianOth ///
ReAfrAm ReAfrican   ReCaribbean ReEthiopian ReSomali ReBlackOth ///
 ReHisMex ReHisCen ReHisSou ReHisOth ReNHPILeg  ReCham   ReMarshallese ReCOFA ReNatHaw ReSamoan  ReNHPIoth  ///
ReMidEast ReNoAfr  ReMENALeg ReWhiteLeg ReWestEur ReEastEur ReSlavic ReOthwhite ///
ReAIANG ReAsianG ReBlackG ReHispG ReMENAG ReNHPIG ReWhiteG *Leg  Re*G  ReRaceOth ReMulti TribePlus AmTribe ANTribe{
replace `var'=0 if `var' ==. 
label value  `var'  no0yes1
       }  

label variable ReAIANLeg "American Indian/Alaska Native (Legacy)"
label variable ReAsianLeg "Asian (Legacy)"
label variable ReBlackLeg "Black/African American (Legacy)"
label variable ReNHPILeg "Native Hawaiian / Pacific Islander (Legacy)"
label variable ReMENALeg "Middle Eastern / North African (Legacy)"
label variable ReWhiteLeg "White (Legacy)"
label value RareRace RareRacelab

*******************************************************************************
*save file
*******************************************************************************
 order SERIALNO SPORDER
sort  SERIALNO SPORDER

 quietly compress
  notes: "ACS201721_Setup_2v11RELD_ORandWA using 201721ORWA_Indiv2v2"
  label data "ACS201721_Setup_2v10RELD_ORandWA using 201721ORWA_Indiv2v2.dta"
  datasignature set, reset
 
** removed save 
 
  svy:  tab  Rac8ca if State==41 & HINS4di==1, count ci format(%-12.0g)  csepwidth(10) stubwidth(30)	  
  svy:  tab  Rac8ca if State==41 , count ci format(%-12.0g)  csepwidth(10) stubwidth(30)	  
