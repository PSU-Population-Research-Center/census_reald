** title pumac10.do
** purpose: convert 2010 pumas to larger of county/puma (15 unique in Oregon)
** to prep: rename "PUMA" in ACS PUMS (2012-2019 use 2010 PUMAs) to puma10
** author: sharygin@pdx.edu
#delimit ;    
cap drop pumac;    
gen pumac=.;    
replace pumac=1  if puma10==100;
replace pumac=2  if puma10==200;
replace pumac=3  if puma10==300;
replace pumac=4  if puma10==400;
replace pumac=5  if puma10==500;
replace pumac=6  if puma10==600;
replace pumac=7  if puma10==703;
replace pumac=7  if puma10==704;
replace pumac=7  if puma10==705;
replace pumac=8  if puma10==800;
replace pumac=9  if puma10==901;
replace pumac=9  if puma10==902;
replace pumac=10 if puma10==1000;
replace pumac=11 if puma10==1103;
replace pumac=11 if puma10==1104;
replace pumac=11 if puma10==1105;
replace pumac=12 if puma10==1200;
replace pumac=13 if puma10==1301;
replace pumac=13 if puma10==1302;
replace pumac=13 if puma10==1303;
replace pumac=13 if puma10==1305;
replace pumac=13 if puma10==1314;
replace pumac=13 if puma10==1316;
replace pumac=14 if puma10==1317;
replace pumac=14 if puma10==1318;
replace pumac=14 if puma10==1319;
replace pumac=15 if puma10==1320;
replace pumac=15 if puma10==1321;
replace pumac=15 if puma10==1322;
replace pumac=15 if puma10==1323;
replace pumac=15 if puma10==1324;
cap lab drop pumac_lbl;    
lab def pumac_lbl    
	1 "BAKER,UMATILLA,UNION,WALLOWA"   
	2 "CROOK,GILLIAM,GRANT,HOOD RIVER,JEFFERSON,MORROW,SHERMAN,WASCO,WHEELER"   
	3 "HARNEY,KLAMATH,LAKE,MALHEUR"   
	4 "DESCHUTES"   
	5 "CLATSOP,COLUMBIA,LINCOLN,TILLAMOOK"   
	6 "BENTON,LINN"   
	7 "LANE"   
	8 "COOS,CURRY,JOSEPHINE"   
	9 "JACKSON"   
	10 "DOUGLAS"   
	11 "MARION"   
	12 "POLK,YAMHILL"   
	13 "MULTNOMAH"   
	14 "CLACKAMAS"   
	15 "WASHINGTON", replace;   
lab val pumac pumac_lbl;
#delimit cr    
