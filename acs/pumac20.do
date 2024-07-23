** title pumac20.do
** purpose: convert 2020 pumas to larger of county/puma (15 unique in Oregon)
** to prep: rename "PUMA" in ACS PUMS (2012-2019 use 2010 PUMAs) to puma20
** author: sharygin@pdx.edu
#delimit ;    
cap drop pumac; 
gen pumac=.;    
replace pumac=1  if state==41 & puma20==5901;
replace pumac=2  if state==41 & puma20==6501;
replace pumac=3  if state==41 & puma20==9200;
replace pumac=4  if state==41 & puma20==1701;
replace pumac=4  if state==41 & puma20==1702;
replace pumac=5  if state==41 & puma20==9000;
replace pumac=6  if state==41 & puma20==301; 
replace pumac=6  if state==41 & puma20==4301;
replace pumac=7  if state==41 & puma20==3903;
replace pumac=7  if state==41 & puma20==3904;
replace pumac=7  if state==41 & puma20==3905;
replace pumac=8  if state==41 & puma20==9100;
replace pumac=9  if state==41 & puma20==2901;
replace pumac=9  if state==41 & puma20==2902;
replace pumac=10 if state==41 & puma20==1900;
replace pumac=11 if state==41 & puma20==4703;
replace pumac=11 if state==41 & puma20==4704;
replace pumac=11 if state==41 & puma20==4705;
replace pumac=12 if state==41 & puma20==9300;
replace pumac=13 if state==41 & puma20==5101;
replace pumac=13 if state==41 & puma20==5102;
replace pumac=13 if state==41 & puma20==5103;
replace pumac=13 if state==41 & puma20==5105;
replace pumac=13 if state==41 & puma20==5114;
replace pumac=13 if state==41 & puma20==5116;
replace pumac=14 if state==41 & puma20==501;
replace pumac=14 if state==41 & puma20==502;
replace pumac=14 if state==41 & puma20==503;
replace pumac=14 if state==41 & puma20==0504;
replace pumac=15 if state==41 & puma20==6720;
replace pumac=15 if state==41 & puma20==6721;
replace pumac=15 if state==41 & puma20==6722;
replace pumac=15 if state==41 & puma20==6723;
replace pumac=15 if state==41 & puma20==6724;
replace pumac=16 if state==41 & puma20==7100;
cap lab drop pumac20_lbl;    
lab def pumac20_lbl    
	1 "BAKER,UMATILLA,UNION,WALLOWA" // -1x Umatilla tract
	2 "GILLIAM,GRANT,HOOD RIVER,MORROW,SHERMAN,WASCO,WHEELER" // +1x Umatilla tract
	3 "HARNEY,KLAMATH,LAKE,MALHEUR"   
	4 "DESCHUTES,CROOK,JEFFERSON"   
	5 "CLATSOP,COLUMBIA,TILLAMOOK"   
	6 "BENTON,LINN"   
	7 "LANE"
	8 "COOS,CURRY,JOSEPHINE"   
	9 "JACKSON"   
	10 "DOUGLAS"   
	11 "MARION"   
	12 "LINCOLN,POLK"  
	13 "MULTNOMAH"   
	14 "CLACKAMAS"   
	15 "WASHINGTON"
	16 "YAMHILL", replace;   
lab val pumac pumac20_lbl;
#delimit cr    
