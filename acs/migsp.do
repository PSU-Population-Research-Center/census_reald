#delimit;
lab def MIGSP
1 "Alabama/AL"
2 "Alaska/AK"
4 "Arizona/AZ"
5 "Arkansas/AR"
6 "California/CA"
8 "Colorado/CO"
9 "Connecticut/CT"
10 "Delaware/DE"
11 "District of Columbia/DC"
12 "Florida/FL"
13 "Georgia/GA"
15 "Hawaii/HI"
16 "Idaho/ID"
17 "Illinois/IL"
18 "Indiana/IN"
19 "Iowa/IA"
20 "Kansas/KS"
21 "Kentucky/KY"
22 "Louisiana/LA"
23 "Maine/ME"
24 "Maryland/MD"
25 "Massachusetts/MA"
26 "Michigan/MI"
27 "Minnesota/MN"
28 "Mississippi/MS"
29 "Missouri/MO"
30 "Montana/MT"
31 "Nebraska/NE"
32 "Nevada/NV"
33 "New Hampshire/NH"
34 "New Jersey/NJ"
35 "New Mexico/NM"
36 "New York/NY"
37 "North Carolina/NC"
38 "North Dakota/ND"
39 "Ohio/OH"
40 "Oklahoma/OK"
41 "Oregon/OR"
42 "Pennsylvania/PA"
44 "Rhode Island/RI"
45 "South Carolina/SC"
46 "South Dakota/SD"
47 "Tennessee/TN"
48 "Texas/TX"
49 "Utah/UT"
50 "Vermont/VT"
51 "Virginia/VA"
53 "Washington/WA"
54 "West Virginia/WV"
55 "Wisconsin/WI"
56 "Wyoming/WY"
72 "Puerto Rico"
109 "France"
110 "Germany"
111 "Northern Europe, Not Specified"
113 "Eastern Europe, Not Specified"
114 "Western Europe or Other Europe, Not Specified"
120 "Italy"
134 "Spain"
138 "United Kingdom, Excluding England"
139 "England"
163 "Russia"
164 "Ukraine (2017 or later)"
200 "Afghanistan"
207 "China, Hong Kong, Macau and Paracel Islands"
210 "India"
213 "Iraq (2016 or earlier)"
214 "Israel (2017 or later)"
215 "Japan"
217 "Korea"
229 "Nepal"
231 "Pakistan"
233 "Philippines"
235 "Saudi Arabia"
240 "Taiwan"
242 "Thailand"
243 "Turkey"
245 "United Arab Emirates (2017 or later)"
247 "Vietnam"
251 "Eastern Asia, Not Specified"
252 "Western Asia, Not Specified"
253 "South Central Asia or Asia, Not Specified"
301 "Canada"
303 "Mexico"
312 "El Salvador"
313 "Guatemala"
314 "Honduras"
317 "Central America, Not Specified"
327 "Cuba"
329 "Dominican Republic"
332 "Haiti"
333 "Jamaica"
344 "Caribbean and North America, Not Specified"
362 "Brazil"
364 "Colombia"
365 "Ecuador (2017 or later)"
370 "Peru (2017 or later)"
373 "Venezuela (2017 or later)"
374 "South America, Not Specified"
414 "Egypt"
416 "Ethiopia (2017 or later)"
427 "Kenya (2017 or later)"
440 "Nigeria"
467 "Western Africa, Not Specified"
468 "Northern Africa or Other Africa, Not Specified"
469 "Eastern Africa, Not Specified"
501 "Australia"
555 "Other US Island Areas, Oceania, Not Specified, or At Sea", replace
;
#delimit cr
replace MIGSP=. if MIGSP<1 | MIGSP>555
lab var MIGSP "Migration recode"
lab val MIGSP MIGSP
