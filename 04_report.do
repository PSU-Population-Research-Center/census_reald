// v04: (WIP) formatting suppressed tables
// v03: converting to export excel and completed suppression flags.
// v02: adding suppression/data quality flags (WIP); outsheet to csv.
// v01: browse and copy-paste to excel

cap prog drop doPutHead
prog def doPutHead
	putexcel A1 = "County-level Population Estimates by REALD (pre-2024 definitions)"
	putexcel A2 = "Source: 5-year ACS `1'; analysis by Population Research Center, PSU (askprc@pdx.edu)"
	putexcel A3 = "Last model export: `2'"
end
* syntax doPutHead YYYY lastrundate

cap prog drop fillReport
prog def fillReport
	
	// prep (args 1 year 2 sup)
	*cap mkdir report_`1'
	*local lastrun: di %tdCY-N-D date("$S_DATE","DMY")
	local lastrun="2025-04-16"
	local fname	 ="prc_for_oha_realdcountydata_v`lastrun'"
	cap restore, not
	
	// A, A_S
	use stcofips sex agecat b flag using results/results_agesex_`1'.dta, clear
	reshape wide b flag, i(stcofips agecat) j(sex)
	ren *0 *tot
	ren *1 *mal
	ren *2 *fem
	replace agecat=99 if agecat==-1
	reshape wide b* flag*, i(stcofips) j(agecat)
	order stcofips bmal* bfem* btot* 
	format b* %7.0f
	** export
	putexcel set "`fname'_nosup.xlsx", modify sheet(A) // A
	doPutHead `1' `lastrun'
	export excel btot0-btot65 btot99 using "`fname'_nosup.xlsx", cell(B9) sheet("A") firstrow(var) sheetmodify keepcellfmt 	
	putexcel set "`fname'_nosup.xlsx", modify sheet(A_S) // AS
	doPutHead `1' `lastrun'
	export excel bmal0-bmal65 bfem0-bfem65 btot99 using "`fname'_nosup.xlsx", cell(B9) sheet("A_S") firstrow(var) sheetmodify keepcellfmt 
	** suppression
	if "`2'"=="suppress" {
		foreach a in "0" "5" "15" "18" "20" "25" "30" "40" "50" "60" "65" "99" {
			foreach s in "mal" "fem" "tot" {
				replace b`s'`a'=. if flag`s'`a'>=3
				tostring b`s'`a', replace force usedisplayformat
				replace b`s'`a'=b`s'`a'+"*" if flag`s'`a'==2
			}
		}
		putexcel set "`fname'_sup.xlsx", modify sheet(A)  // A	
		doPutHead `1' `lastrun'
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		export excel btot0-btot65 btot99 using "`fname'_sup.xlsx", cell(B9) sheet("A") sheetmodify firstrow(var) 
		putexcel set "`fname'_sup.xlsx", modify sheet(A_S) // AS	
		doPutHead `1' `lastrun'
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		export excel bmal0-bmal65 bfem0-bfem65 btot99 using "`fname'_sup.xlsx", cell(B9) sheet("A_S") sheetmodify firstrow(var) 
	}
	** final step: ConvertXLS to delete the varname row, and shift the results up by one cell 
	** !!!

	// R, R_S, A_R_S (OMB-RR)
	use stcofips sex agecat ombrr b flag using results/results_agesex_ombrr_`1'.dta, clear
	reshape wide b flag, i(stcofips agecat ombrr) j(sex)
	ren *0 *tot
	ren *1 *mal 
	ren *2 *fem
	replace agecat=99 if agecat==-1
	reshape wide b* flag*, i(stcofips ombrr) j(agecat)
	reshape wide b* flag*, i(stcofips) j(ombrr) string
	qui for var b*: replace X=0 if X==. 
	qui for var flag*: replace X=3 if X==.
	order stcofips bmal* bfem* btot*
	*format b* %7.2g
	format b* %7.0f
	** export
	preserve
	putexcel set "`fname'_nosup.xlsx", modify sheet(R)  // R
	doPutHead `1' `lastrun'
	order btot99total, after(btot99white)
	export excel btot99* using "`fname'_nosup.xlsx", cell(B9) sheet("R") firstrow(var) sheetmodify keepcellfmt
	putexcel set "`fname'_nosup.xlsx", modify sheet(R_S) // RS
	doPutHead `1' `lastrun'
	drop bmal*total bfem*total
	export excel bmal99* bfem99* btot99total using "`fname'_nosup.xlsx", cell(B9) sheet("R_S") firstrow(var) sheetmodify keepcellfmt 
	putexcel set "`fname'_nosup.xlsx", modify sheet(A_R_S) // ARS
	doPutHead `1' `lastrun'
	drop bmal99* bfem99*
	export excel bmal* bfem* btot99total using "`fname'_nosup.xlsx", cell(B9) sheet("A_R_S") firstrow(var) sheetmodify keepcellfmt 
	restore
	** suppression
	if "`2'"=="suppress" {
		foreach a in "0" "5" "15" "18" "20" "25" "30" "40" "50" "60" "65" "99" {
			foreach s in "mal" "fem" "tot" {
				foreach r in "aian" "asian" "black" "hispanic" "nhpi" "other" "white" "total" {
					cap confirm var b`s'`a'`r'
					if !_rc {
						replace b`s'`a'`r'=. if flag`s'`a'`r'>=3
						tostring b`s'`a'`r', replace force usedisplayformat
						replace b`s'`a'`r'=b`s'`a'`r'+"*" if flag`s'`a'`r'==2
					}
				}
			}
		}
		putexcel set "`fname'_sup.xlsx", modify sheet(R) // R
		doPutHead `1' `lastrun'
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		order btot99total, after(btot99white)
		export excel btot99* using "`fname'_sup.xlsx", cell(B9) sheet("R") firstrow(var) sheetmodify keepcellfmt 
		putexcel set "`fname'_sup.xlsx", modify sheet(R_S) // RS
		doPutHead `1' `lastrun'
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		drop bmal*total bfem*total
		export excel bmal99* bfem99* btot99total using "`fname'_sup.xlsx", cell(B9) sheet("R_S") firstrow(var) sheetmodify keepcellfmt 
		putexcel set "`fname'_sup.xlsx", modify sheet(A_R_S) // ARS
		doPutHead `1' `lastrun'
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		drop bmal99* bfem99*
		export excel bmal* bfem* btot99total using "`fname'_sup.xlsx", cell(B9) sheet("A_R_S") firstrow(var) sheetmodify keepcellfmt 
	}
	** final step: ConvertXLS to delete the varname row, and shift the results up by one cell 
	** !!!	
	
	// RE, RE_S, A_RE_S (REALD-RR)
	use stcofips sex agecat reldpri b flag using results/results_agesex_reldpri_`1'.dta, clear
	reshape wide b flag, i(stcofips agecat reldpri) j(sex)
	ren *0 *tot
	ren *1 *mal
	ren *2 *fem
	replace agecat=99 if agecat==-1
	reshape wide b* flag*, i(stcofips reldpri) j(agecat)
	levelsof reldpri, local(races)
	reshape wide b* flag*, i(stcofips) j(reldpri) string
	qui for var b*: replace X=0 if X==. 
	qui for var flag*: replace X=3 if X==. 
	order stcofips bmal* bfem* btot*
	*format b* %10.2g
	format b* %7.0f
	** export
	preserve
	putexcel set "`fname'_nosup.xlsx", modify sheet(RE)  // RE
	doPutHead `1' `lastrun'
	order btot99Total, after(btot99WhiteOth)
	export excel btot99* using "`fname'_nosup.xlsx", cell(B9) sheet("RE") firstrow(var) sheetmodify keepcellfmt
	putexcel set "`fname'_nosup.xlsx", modify sheet(RE_S) // RES
	doPutHead `1' `lastrun'
	drop bmal*Total bfem*Total
	export excel bmal99* bfem99* btot99Total using "`fname'_nosup.xlsx", cell(B9) sheet("RE_S") firstrow(var) sheetmodify keepcellfmt 
	putexcel set "`fname'_nosup.xlsx", modify sheet(A_RE_S) // ARES
	doPutHead `1' `lastrun'
	drop bmal99* bfem99*
	export excel bmal* bfem* btot99Total using "`fname'_nosup.xlsx", cell(B9) sheet("A_RE_S") firstrow(var) sheetmodify keepcellfmt 
	restore
	** suppression
	if "`2'"=="suppress" {
		foreach a in "0" "5" "15" "18" "20" "25" "30" "40" "50" "60" "65" "99" {
			foreach s in "mal" "fem" "tot" {
				foreach r of local races {
					cap confirm var b`s'`a'`r'
					if !_rc {
						replace b`s'`a'`r'=. if flag`s'`a'`r'>=3
						tostring b`s'`a'`r', replace force usedisplayformat
						replace b`s'`a'`r'=b`s'`a'`r'+"*" if flag`s'`a'`r'==2
					}
				}
			}
		}
		putexcel set "`fname'_sup.xlsx", modify sheet(RE) // RE
		doPutHead `1' `lastrun'
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		order btot99Total, after(btot99WhiteOth)
		export excel btot99* using "`fname'_sup.xlsx", cell(B9) sheet("RE") firstrow(var) sheetmodify keepcellfmt 
		putexcel set "`fname'_sup.xlsx", modify sheet(RE_S) // RES
		doPutHead `1' `lastrun'
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		drop bmal*Total bfem*Total
		export excel bmal99* bfem99* btot99Total using "`fname'_sup.xlsx", cell(B9) sheet("RE_S") firstrow(var) sheetmodify keepcellfmt 
		putexcel set "`fname'_sup.xlsx", modify sheet(A_RE_S) // ARES
		doPutHead `1' `lastrun'
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		drop bmal99* bfem99*
		export excel bmal* bfem* btot99Total using "`fname'_sup.xlsx", cell(B9) sheet("A_RE_S") firstrow(var) sheetmodify keepcellfmt 
	}
	** final step: ConvertXLS to delete the varname row, and shift the results up by one cell 
	** !!!	
	
	// DA, D4A, D7A
	foreach d in "disdi" "da4cat" "da7compacsall" {
		use stcofips agecat `d' b flag sex if sex==0 using results/results_`d'_`1'.dta, clear
		drop sex
		replace agecat=99 if agecat==-1 // recode total
		reshape wide b flag, i(stcofips `d') j(agecat) 
		replace `d'=99 if `d'==-1 // recode total
		tostring `d', replace force
		replace `d'="_"+`d'
		reshape wide b* flag*, i(stcofips) j(`d') string
		for var b*: replace X=0 if X==.
		for var flag*: replace X=3 if X==.
		*format b* %10.2g
		format b* %7.0f
		** export
		ren b99_99 total
		drop b*_99 b99_* // drop subtotals across ages by condition
		if "`d'"=="disdi" {
			local t="D_A"
			order stcofips b*_0 b*_1 total
		}
		else if "`d'"=="da4cat" {
			local t="D4_A"
			order stcofips b*_0 b*_1 b*_2 b*_3 total
		}
		else if "`d'"=="da7compacsall" {
			local t="D7_A" 
			order stcofips b*_0 b*_1 b*_2 b*_3 b*_4 b*_5 b*_6 total
		}
		putexcel set "`fname'_nosup.xlsx", modify sheet(`t') // D_A D4_A D7_A
		doPutHead `1' `lastrun'
		export excel b*_* total using "`fname'_nosup.xlsx", cell(B9) sheet(`t') firstrow(var) sheetmodify keepcellfmt
		** suppression
		if "`2'"=="suppress" {
			foreach a in "0" "5" "15" "18" "20" "25" "30" "40" "50" "60" "65" "99" {
				forvalues v=0/6 {
					cap confirm var b`a'_`v'
					if !_rc {
						replace b`a'_`v'=. if flag`a'_`v'>=3
						tostring b`a'_`v', replace force usedisplayformat
						replace b`a'_`v'=b`a'_`v'+"*" if flag`a'_`v'==2
					}
				}
			}
			putexcel set "`fname'_sup.xlsx", modify sheet(`t')
			doPutHead `1' `lastrun'
			putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
			export excel b*_* total using "`fname'_sup.xlsx", cell(B9) sheet(`t') firstrow(var) sheetmodify keepcellfmt
		}
	}
	** final step: ConvertXLS to delete the varname row, and shift the results up by one cell 
	** !!!	
	
	// DSA
	foreach d in "drs" "ear" "eye" "out" "phy" "rem" {
		use stcofips agecat d`d'oicv2 b flag sex if sex==0 using results/results_d`d'oicv2_`1'.dta, clear
		drop sex
		replace agecat=99 if agecat==-1 // recode total
		reshape wide b flag, i(stcofips d`d'oicv2) j(agecat)
		tostring d`d'oicv2, replace force
		replace d`d'oicv2="_"+d`d'oicv2
		reshape wide b* flag*, i(stcofips) j(d`d'oicv2) string
		for var b*: replace X=0 if X==.
		for var flag*: replace X=3 if X==.
		*format b* %10.2g
		format b* %7.0f
		** export
		egen total=rowtotal(b99*)
		drop b99* // drop subtotals across ages by condition
		order stcofips b*_0 b*_1 b*_2 total
		putexcel set "`fname'_nosup.xlsx", modify sheet("DS_A") // DS_A
		doPutHead `1' `lastrun'
		if "`d'"=="drs" export excel b* total using "`fname'_nosup.xlsx", cell(B9) sheet("DS_A") firstrow(var) sheetmodify keepcellfmt
		if "`d'"=="ear" export excel b* total using "`fname'_nosup.xlsx", cell(B50) sheet("DS_A") firstrow(var) sheetmodify keepcellfmt
		if "`d'"=="eye" export excel b* total using "`fname'_nosup.xlsx", cell(B91) sheet("DS_A") firstrow(var) sheetmodify keepcellfmt
		if "`d'"=="out" export excel b* total using "`fname'_nosup.xlsx", cell(B132) sheet("DS_A") firstrow(var) sheetmodify keepcellfmt
		if "`d'"=="phy" export excel b* total using "`fname'_nosup.xlsx", cell(B173) sheet("DS_A") firstrow(var) sheetmodify keepcellfmt
		if "`d'"=="rem" export excel b* total using "`fname'_nosup.xlsx", cell(B214) sheet("DS_A") firstrow(var) sheetmodify keepcellfmt
		** suppression
		if "`2'"=="suppress" {
			foreach a in "0" "5" "15" "18" "20" "25" "30" "40" "50" "60" "65" {
				forvalues v=0/2 {
					replace b`a'_`v'=. if flag`a'_`v'>=3
					tostring b`a'_`v', replace force usedisplayformat
					replace b`a'_`v'=b`a'_`v'+"*" if flag`a'_`v'==2
				}
			}
			putexcel set "`fname'_sup.xlsx", modify sheet(`t')
			doPutHead `1' `lastrun'
			putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
			if "`d'"=="drs" export excel b* total using "`fname'_sup.xlsx", cell(B9) sheet("DS_A") firstrow(var) sheetmodify keepcellfmt
			if "`d'"=="ear" export excel b* total using "`fname'_sup.xlsx", cell(B50) sheet("DS_A") firstrow(var) sheetmodify keepcellfmt
			if "`d'"=="eye" export excel b* total using "`fname'_sup.xlsx", cell(B91) sheet("DS_A") firstrow(var) sheetmodify keepcellfmt
			if "`d'"=="out" export excel b* total using "`fname'_sup.xlsx", cell(B132) sheet("DS_A") firstrow(var) sheetmodify keepcellfmt
			if "`d'"=="phy" export excel b* total using "`fname'_sup.xlsx", cell(B173) sheet("DS_A") firstrow(var) sheetmodify keepcellfmt
			if "`d'"=="rem" export excel b* total using "`fname'_sup.xlsx", cell(B214) sheet("DS_A") firstrow(var) sheetmodify keepcellfmt
		}
	}
	
	// L, LA, LEP, LEPA (STATE) 
	use stfips langoha lep agecat b flag sex if sex==0 using results/results_langst_`1'.dta, clear
	drop sex
	replace agecat=99 if agecat==-1 // recode total
	reshape wide b flag, i(stfips langoha lep) j(agecat)
	replace lep=99 if lep==-1 // recode total
	tostring lep, replace force
	replace lep="_"+lep
	reshape wide b* flag*, i(stfips langoha) j(lep) string
	for var b*: replace X=0 if X==.
	for var flag*: replace X=3 if X==.
	order stfips langoha b*_99 b*_0 b*_1 
	*format b* %10.3g
	format b* %7.0f
	** export
	#delimit ;
	lab def langiso
		1	"afa"	2	"ara"	3	"arm"	4	"ben"	5	"swa"	6	"chn"	7	"eng"	8	"fre"	9	"ger"	10	"gre"
		11	"guj"	12	"hat"	13	"heb"	14	"hin"	15	"hmn"	16	"ita"	17	"jpn"	18	"khm"	19	"kor"	20	"mal"
		21	"nav"	22	"qas"	23	"qie"	24	"nep"	25	"qna"	26	"map"	27	"qsl"	28	"und"	29	"pan"	30	"per"
		31	"pol"	32	"por"	33	"rus"	34	"hbs"	35	"spa"	36	"tam"	37	"tel"	38	"tgl"	39	"tha"	40	"ukr"
		41	"urd"	42	"vie"	43	"yid"	44	"yor", replace;
	#delimit cr
	label values langoha langiso
	decode langoha, gen(langstr)
	putexcel set "`fname'_nosup.xlsx", modify sheet("L_State") // L_State
	doPutHead `1' `lastrun'
	export excel b*_99 using "`fname'_nosup.xlsx", cell(C9) sheet("L_State") firstrow(var) sheetmodify keepcellfmt
	putexcel set "`fname'_nosup.xlsx", modify sheet("LEP_State") // LEP
	doPutHead `1' `lastrun'
	export excel b*_1 using "`fname'_nosup.xlsx", cell(C9) sheet("LEP_State") firstrow(var) sheetmodify keepcellfmt
	** suppression
	if "`2'"=="suppress" {
		foreach a in "0" "5" "15" "18" "20" "25" "30" "40" "50" "60" "65" "99" {
			foreach v in "0" "1" "99" {
				replace b`a'_`v'=. if flag`a'_`v'>=3
				tostring b`a'_`v', replace force usedisplayformat
				replace b`a'_`v'=b`a'_`v'+"*" if flag`a'_`v'==2
			}
		}
		putexcel set "`fname'_sup.xlsx", modify sheet("L_State") // L
		doPutHead `1' `lastrun'
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		export excel b*_99 using "`fname'_sup.xlsx", cell(C9) sheet("L_State") firstrow(var) sheetmodify keepcellfmt
		putexcel set "`fname'_sup.xlsx", modify sheet("LEP_State") // LEP
		doPutHead `1' `lastrun'
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		export excel b*_1 using "`fname'_sup.xlsx", cell(C9) sheet("LEP_State") firstrow(var) sheetmodify keepcellfmt
	}
	
	// L, LA, LEP, LEPA (COUNTY)
	use stcofips langoha lep agecat3 b flag sex if sex==0 using results/results_lang_`1'.dta, clear
	drop sex
	replace agecat3=99 if agecat3==-1 // recode total
	reshape wide b flag, i(stcofips langoha lep) j(agecat3)
	for var b*: replace X=0 if X==.
	for var flag*: replace X=3 if X==.
	replace lep=99 if lep==-1 // recode total
	tostring lep, replace force
	replace lep="_"+lep
	reshape wide b* flag*, i(stcofips langoha) j(lep) string
	#delimit ;
	lab def langiso
		1	"afa"	2	"ara"	3	"arm"	4	"ben"	5	"swa"	6	"chn"	7	"eng"	8	"fre"	9	"ger"	10	"gre"
		11	"guj"	12	"hat"	13	"heb"	14	"hin"	15	"hmn"	16	"ita"	17	"jpn"	18	"khm"	19	"kor"	20	"mal"
		21	"nav"	22	"qas"	23	"qie"	24	"nep"	25	"qna"	26	"map"	27	"qsl"	28	"und"	29	"pan"	30	"per"
		31	"pol"	32	"por"	33	"rus"	34	"hbs"	35	"spa"	36	"tam"	37	"tel"	38	"tgl"	39	"tha"	40	"ukr"
		41	"urd"	42	"vie"	43	"yid"	44	"yor", replace;
	#delimit cr
	label values langoha langiso
	decode langoha, gen(langstr)
	levelsof langstr, local(langs)
	drop langoha
	reshape wide b* flag*, i(stcofips) j(langstr) string
	qui for varlist b*: replace X=0 if X==.
	qui for varlist flag*: replace X=3 if X==.
	*format b* %11.2g
	format b* %7.0f
	** export
	egen total=rowtotal(b99_99*)
	egen leptot=rowtotal(b99_1*)
	replace total=round(total)
	preserve
	putexcel set "`fname'_nosup.xlsx", modify sheet("L") // L
	doPutHead `1' `lastrun'
	export excel b99_99* total using "`fname'_nosup.xlsx", cell(C9) sheet("L") firstrow(var) sheetmodify keepcellfmt
	putexcel set "`fname'_nosup.xlsx", modify sheet("LEP") // LEP
	doPutHead `1' `lastrun'
	export excel b99_1* leptot using "`fname'_nosup.xlsx", cell(C9) sheet("LEP") firstrow(var) sheetmodify keepcellfmt
	drop b99_* // drop totals by age
	putexcel set "`fname'_nosup.xlsx", modify sheet("L_A") // LA
	doPutHead `1' `lastrun'
	export excel b*99afa b*99ara b*99arm b*99ben b*99chn b*99eng b*99fre b*99ger b*99gre b*99guj b*99hat b*99hbs b*99heb b*99hin b*99hmn b*99ita ///
		b*99jpn b*99khm b*99kor b*99mal b*99map b*99nav b*99nep b*99pan b*99per b*99pol b*99por b*99qas b*99qie b*99qna b*99qsl b*99rus b*99spa b*99swa ///
		b*99tam b*99tel b*99tgl b*99tha b*99ukr b*99und b*99urd b*99vie b*99yid b*99yor total ///
		using "`fname'_nosup.xlsx", cell(C9) sheet("L_A") firstrow(var) sheetmodify keepcellfmt
	putexcel set "`fname'_nosup.xlsx", modify sheet("LEP_A") // LEP_A
	doPutHead `1' `lastrun'
	export excel b*1afa b*1ara b*1arm b*1ben b*1chn b*1eng b*1fre b*1ger b*1gre b*1guj b*1hat b*1hbs b*1heb b*1hin b*1hmn b*1ita ///
		b*1jpn b*1khm b*1kor b*1mal b*1map b*1nav b*1nep b*1pan b*1per b*1pol b*1por b*1qas b*1qie b*1qna b*1qsl b*1rus b*1spa b*1swa ///
		b*1tam b*1tel b*1tgl b*1tha b*1ukr b*1und b*1urd b*1vie b*1yid b*1yor leptot ///
		using "`fname'_nosup.xlsx", cell(C9) sheet("LEP_A") firstrow(var) sheetmodify keepcellfmt
	restore
	** suppression
	if "`2'"=="suppress" {
		foreach l of local langs {
			foreach a in "5" "19" "65" "99" {
				foreach v in "0" "1" "99" {
					replace b`a'_`v'`l'=. if flag`a'_`v'`l'>=3
					tostring b`a'_`v'`l', replace force usedisplayformat
					replace b`a'_`v'`l'=b`a'_`v'`l'+"*" if flag`a'_`v'`l'==2
				}
			}
		}
		putexcel set "`fname'_sup.xlsx", modify sheet("L") // L
		doPutHead `1' `lastrun'
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		export excel b99_99* total using "`fname'_sup.xlsx", cell(C9) sheet("L") firstrow(var) sheetmodify keepcellfmt
		putexcel set "`fname'_sup.xlsx", modify sheet("LEP") // LEP
		doPutHead `1' `lastrun'
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		export excel b99_1* leptot using "`fname'_sup.xlsx", cell(C9) sheet("LEP") firstrow(var) sheetmodify keepcellfmt
		drop b99_* // drop totals by age
		putexcel set "`fname'_sup.xlsx", modify sheet("L_A") // LA
		doPutHead `1' `lastrun'
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		export excel b*99afa b*99ara b*99arm b*99ben b*99chn b*99eng b*99fre b*99ger b*99gre b*99guj b*99hat b*99hbs b*99heb b*99hin b*99hmn b*99ita ///
			b*99jpn b*99khm b*99kor b*99mal b*99map b*99nav b*99nep b*99pan b*99per b*99pol b*99por b*99qas b*99qie b*99qna b*99qsl b*99rus b*99spa b*99swa ///
			b*99tam b*99tel b*99tgl b*99tha b*99ukr b*99und b*99urd b*99vie b*99yid b*99yor total ///
			using "`fname'_sup.xlsx", cell(C9) sheet("L_A") firstrow(var) sheetmodify keepcellfmt
		putexcel set "`fname'_sup.xlsx", modify sheet("LEP_A") // LEP_A
		doPutHead `1' `lastrun'
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		export excel b*1afa b*1ara b*1arm b*1ben b*1chn b*1eng b*1fre b*1ger b*1gre b*1guj b*1hat b*1hbs b*1heb b*1hin b*1hmn b*1ita ///
			b*1jpn b*1khm b*1kor b*1mal b*1map b*1nav b*1nep b*1pan b*1per b*1pol b*1por b*1qas b*1qie b*1qna b*1qsl b*1rus b*1spa b*1swa ///
			b*1tam b*1tel b*1tgl b*1tha b*1ukr b*1und b*1urd b*1vie b*1yid b*1yor leptot ///
			using "`fname'_sup.xlsx", cell(C9) sheet("LEP_A") firstrow(var) sheetmodify keepcellfmt
	}
end
* fillReport YYYY suppress
