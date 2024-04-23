/* Race and ethnicity (5ACS19) */

#delimit ;
lab def RAC1P
1 "White alone"
2 "Black or African American alone"
3 "American Indian alone"
4 "Alaska Native alone"
5 "American Indian and Alaska Native tribes specified; or American Indian or Alaska Native, not specified and no other races"
6 "Asian alone"
7 "Native Hawaiian and Other Pacific Islander alone"
8 "Some Other Race alone"
9 "Two or More Races", replace
;
#delimit cr
replace RAC1P=. if RAC1P<1
replace RAC1P=. if 9<RAC1P 
lab var RAC1P "Race/Ethnicity"
lab val RAC1P RAC1P

#delimit ;
lab def RAC2P
1 "White alone"
2 "Black or African American alone"
3 "Apache alone"
4 "Blackfeet alone"
5 "Cherokee alone"
6 "Cheyenne alone"
7 "Chickasaw alone"
8 "Chippewa alone"
9 "Choctaw alone"
10 "Comanche alone"
11 "Creek alone"
12 "Crow alone"
13 "Hopi alone"
14 "Iroquois alone"
15 "Lumbee alone"
16 "Mexican American Indian alone"
17 "Navajo alone"
18 "Pima alone"
19 "Potawatomi alone"
20 "Pueblo alone"
21 "Puget Sound Salish alone"
22 "Seminole alone"
23 "Sioux alone"
24 "South American Indian alone"
25 "Tohono O'Odham alone"
26 "Yaqui alone"
27 "Other specified American Indian tribes alone"
28 "All other specified American Indian tribe combinations"
29 "American Indian, tribe not specified"
30 "Alaskan Athabascan alone"
31 "Tlingit-Haida alone"
32 "Inupiat alone"
33 "Yup'ik alone"
34 "Aleut alone"
35 "Other Alaska Native"
36 "Other American Indian and Alaska Native specified"
37 "American Indian and Alaska Native, not specified"
38 "Asian Indian alone"
39 "Bangladeshi alone"
40 "Bhutanese alone"
41 "Burmese alone"
42 "Cambodian alone"
43 "Chinese, except Taiwanese, alone"
44 "Taiwanese alone"
45 "Filipino alone"
46 "Hmong alone"
47 "Indonesian alone"
48 "Japanese alone"
49 "Korean alone"
50 "Laotian alone"
51 "Malaysian alone"
52 "Mongolian alone"
53 "Nepalese alone"
54 "Pakistani alone"
55 "Sri Lankan alone"
56 "Thai alone"
57 "Vietnamese alone"
58 "Other Asian alone"
59 "All combinations of Asian races only"
60 "Native Hawaiian alone"
61 "Samoan alone"
62 "Tongan alone"
63 "Guamanian or Chamorro alone"
64 "Marshallese alone"
65 "Fijian alone"
66 "Other Native Hawaiian and Other Pacific Islander"
67 "Some Other Race alone"
68 "Two or More Races", replace
;
#delimit cr
replace RAC2P=. if RAC2P<1
replace RAC2P=. if 68<RAC2P
lab var RAC2P "Race/Ethnicity recode"
lab val RAC2P RAC2P

#delimit ;
lab def RAC3P
1 "White alone"
2 "Black or African American alone"
3 "American Indian and Alaska Native alone"
4 "Asian Indian alone"
5 "Chinese alone"
6 "Filipino alone"
7 "Japanese alone"
8 "Korean alone"
9 "Vietnamese alone"
10 "Other Asian alone"
11 "Native Hawaiian alone"
12 "Guamanian or Chamorro alone"
13 "Samoan alone"
14 "Other Pacific Islander alone"
15 "Some Other Race alone"
16 "White; Black or African American"
17 "White; American Indian and Alaska Native"
18 "White; Asian Indian"
19 "White; Chinese"
20 "White; Filipino"
21 "White; Japanese"
22 "White; Korean"
23 "White; Vietnamese"
24 "White; Other Asian"
25 "White; Native Hawaiian"
26 "White; Guamanian or Chamorro"
27 "White; Samoan"
28 "White; Other Pacific Islander"
29 "White; Some Other Race"
30 "Black or African American; American Indian and Alaska Native"
31 "Black or African American; Asian Indian"
32 "Black or African American; Chinese"
33 "Black or African American; Filipino"
34 "Black or African American; Japanese"
35 "Black or African American; Korean"
36 "Black or African American; Other Asian"
37 "Black or African American; Other Pacific Islander"
38 "Black or African American; Some Other Race"
39 "American Indian and Alaska Native; Asian Indian"
40 "American Indian and Alaska Native; Filipino"
41 "American Indian and Alaska Native; Some Other Race"
42 "Asian Indian; Other Asian"
43 "Asian Indian; Some Other Race"
44 "Chinese; Filipino"
45 "Chinese; Japanese"
46 "Chinese; Korean"
47 "Chinese; Vietnamese"
48 "Chinese; Other Asian"
49 "Chinese; Native Hawaiian"
50 "Filipino; Japanese"
51 "Filipino; Native Hawaiian"
52 "Filipino; Other Pacific Islander"
53 "Filipino; Some Other Race"
54 "Japanese; Korean"
55 "Japanese; Native Hawaiian"
56 "Vietnamese; Other Asian"
57 "Other Asian; Other Pacific Islander"
58 "Other Asian; Some Other Race"
59 "Other Pacific Islander; Some Other Race"
60 "White; Black or African American; American Indian and Alaska Native"
61 "White; Black or African American; Filipino"
62 "White; Black or African American; Some Other Race"
63 "White; American Indian and Alaska Native; Filipino"
64 "White; American Indian and Alaska Native; Some Other Race"
65 "White; Chinese; Filipino"
66 "White; Chinese; Japanese"
67 "White; Chinese; Native Hawaiian"
68 "White; Filipino; Native Hawaiian"
69 "White; Japanese; Native Hawaiian"
70 "White; Other Asian; Some Other Race"
71 "Chinese; Filipino; Native Hawaiian"
72 "White; Chinese; Filipino; Native Hawaiian"
73 "White; Chinese; Japanese; Native Hawaiian"
74 "Black or African American; Asian groups"
75 "Black or African American; Native Hawaiian and Other Pacific Islander groups"
76 "Asian Indian; Asian groups"
77 "Filipino; Asian groups"
78 "White; Black or African American; Asian groups"
79 "White; American Indian and Alaska Native; Asian groups"
80 "White; Native Hawaiian and Other Pacific Islander groups; and/or Some Other Race"
81 "White; Black or African American; American Indian and Alaska Native; Asian groups"
82 "White; Black or African American; American Indian and Alaska Native; and/or Native Hawaiian and Other Pacific Islander groups; and/or Some Other Race"
83 "White; Black or African American; and/or Asian groups; and/or Native Hawaiian and Other Pacific Islander groups; and/or Some Other Race"
84 "White; American Indian and Alaska Native; and/or Asian groups; and/or Native Hawaiian and Other Pacific Islander groups"
85 "White; Chinese; Filipino; and/or Asian groups; and/or Native Hawaiian and Other Pacific Islander groups; and/or Some Other Race"
86 "White; Chinese; and/or Asian groups; and/or Native Hawaiian and Other Pacific Islander groups; and/or Some Other Race"
87 "White; Filipino; and/or Native Hawaiian and Other Pacific Islander groups; and/or Some Other Race"
88 "White; Japanese; and/or Asian groups; and/or Native Hawaiian and Other Pacific Islander groups; and/or Some Other Race"
89 "White; Asian groups; and/or Native Hawaiian and Other Pacific Islander groups; and/or Some Other Race"
90 "Black or African American; American Indian and Alaska Native; and/or Asian groups; and/or Native Hawaiian and Other Pacific Islander groups; and/or Some Other Race"
91 "Black or African American; Asian groups; and/or Native Hawaiian and Other Pacific Islander groups; and/or Some Other Race"
92 "American Indian and Alaska Native; Asian groups; and/or Native Hawaiian and Other Pacific Islander groups; and/or Some Other Race"
93 "Asian Indian; and/or White; and/or Asian groups; and/or Native Hawaiian and Other Pacific Islander groups; and/or Some Other Race"
94 "Chinese; Japanese; Native Hawaiian; and/or other Asian and/or Pacific Islander groups"
95 "Chinese; and/or Asian groups; and/or Native Hawaiian and Other Pacific Islander groups; and/or Some Other Race"
96 "Filipino; and/or Asian groups; and/or Native Hawaiian and Other Pacific Islander groups; and/or Some Other Race"
97 "Japanese; and/or Asian groups; and/or Native Hawaiian and Other Pacific Islander groups; and/or Some Other Race"
98 "Korean; and/or Vietnamese; and/or Other Asian; and/or Native Hawaiian and Other Pacific Islander groups; and/or Some Other Race"
99 "Native Hawaiian; and/or Pacific Islander groups; and/or Some Other Race"
100 "White; and/or Black or African American; and/or American Indian and Alaska Native; and/or Asian groups; and/or Native Hawaiian and Other Pacific Islander groups; and/or Some Other Race", replace
;
#delimit cr
lab var RAC3P "Race/Ethnicity recode alt"
lab val RAC3P RAC3P


#delimit;
lab def HISP
1 "Not Spanish/Hispanic/Latino"
2 "Mexican"
3 "Puerto Rican"
4 "Cuban"
5 "Dominican"
6 "Costa Rican"
7 "Guatemalan"
8 "Honduran"
9 "Nicaraguan"
10 "Panamanian"
11 "Salvadoran"
12 "Other Central American"
13 "Argentinean"
14 "Bolivian"
15 "Chilean"
16 "Colombian"
17 "Ecuadorian"
18 "Paraguayan"
19 "Peruvian"
20 "Uruguayan"
21 "Venezuelan"
22 "Other South American"
23 "Spaniard"
24 "All Other Spanish/Hispanic/Latino", replace
;
#delimit cr
lab var HISP "Hispanic, Detailed"
lab val HISP HISP
