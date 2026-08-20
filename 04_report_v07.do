// v07: added a3 tables for disability series. added health insurance tables. replace ISO lang codes in table.
// v06: updating to work with 3-way age groups also (tabs A11 for full detail, A3 for broad) ~ tbd: A3 tabs for disability
// v05: updated to work with REALD20 and REALD24 
// v04: (WIP) formatting suppressed tables
// v03: converting to export excel and completed suppression flags.
// v02: adding suppression/data quality flags (WIP); outsheet to csv.
// v01: browse and copy-paste to excel

/* setup (here or in controlled_analysis.do)
clear
clear matrix
clear mata
set maxvar 32767 // required for fillReport
*/

cap prog drop doPutHead
prog def doPutHead
	args year expdate defs
	putexcel A1 = "County-level Population Estimates by REALD (`defs' definitions)"
	putexcel A2 = "Source: 5-year ACS `year'; analysis by Population Research Center, PSU (askprc@pdx.edu)"
	putexcel A3 = "Last model export: `expdate'"
end
* syntax doPutHead YYYY lastrundate (2020,2024)

cap prog drop fillReport
prog def fillReport

	// prep (args 1 year 2 suppress)
	*cap mkdir report_`1'
	*local lastrun: di %tdCY-N-D date("$S_DATE","DMY")
	local lastrun="2026-08-18"
	local defs=2024
	local fname	 ="prc_for_oha_realdcountydata_acs`1'_v`lastrun'"
	cap restore, not
	nois di "Reporting into `fname'.xlsx..."
	
	// A, A_S
	qui{
	nois di ". Age, Age/Sex"
	use stcofips sex agecat b flag using results/results_agesex_`1'.dta, clear
	reshape wide b flag, i(stcofips agecat) j(sex)
	ren *0 *tot
	ren *1 *mal
	ren *2 *fem
	replace agecat=99 if agecat==-1
	replace agecat=100 if agecat==-2
	replace agecat=101 if agecat==-3
	reshape wide b* flag*, i(stcofips) j(agecat)
	order stcofips bmal* bfem* btot* 
	format b* %7.0f
	** export
	if "`2'"=="" {
		putexcel set "`fname'_nosup.xlsx", modify sheet(A11) // A11
		doPutHead `1' `lastrun' `defs'
		export excel btot0-btot65 btot99 using "`fname'_nosup.xlsx", cell(B9) sheet("A11") firstrow(var) sheetmodify keepcellfmt 	
		putexcel set "`fname'_nosup.xlsx", modify sheet(A3) // A3
		doPutHead `1' `lastrun' `defs'
		export excel btot100 btot101 btot65 btot99 using "`fname'_nosup.xlsx", cell(B9) sheet("A3") firstrow(var) sheetmodify keepcellfmt 	
		putexcel set "`fname'_nosup.xlsx", modify sheet(A11_S) // A11_S
		doPutHead `1' `lastrun' `defs'
		export excel bmal0-bmal65 bfem0-bfem65 btot99 using "`fname'_nosup.xlsx", cell(B9) sheet("A11_S") firstrow(var) sheetmodify keepcellfmt 
		putexcel set "`fname'_nosup.xlsx", modify sheet(A3_S) // A3_S
		doPutHead `1' `lastrun' `defs'
		export excel bmal100 bmal101 bmal65 bfem100 bfem101 bfem65 btot99 using "`fname'_nosup.xlsx", cell(B9) sheet("A3_S") firstrow(var) sheetmodify keepcellfmt 
		nois di  " ... OK (unsuppressed)"
	}
	** suppression
	if "`2'"=="suppress" {
		foreach a in "0" "5" "15" "18" "20" "25" "30" "40" "50" "60" "65" "99" "100" "101" {
			foreach s in "mal" "fem" "tot" {
				replace b`s'`a'=. if flag`s'`a'>=3
				tostring b`s'`a', replace force usedisplayformat
				replace b`s'`a'=b`s'`a'+"*" if flag`s'`a'==2
			}
		}
		putexcel set "`fname'_sup.xlsx", modify sheet(A11) // A11
		doPutHead `1' `lastrun' `defs'
		export excel btot0-btot65 btot99 using "`fname'_sup.xlsx", cell(B9) sheet("A11") firstrow(var) sheetmodify keepcellfmt 	
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		putexcel set "`fname'_sup.xlsx", modify sheet(A3) // A3
		doPutHead `1' `lastrun' `defs'
		export excel btot100 btot101 btot65 btot99 using "`fname'_sup.xlsx", cell(B9) sheet("A3") firstrow(var) sheetmodify keepcellfmt 	
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		putexcel set "`fname'_sup.xlsx", modify sheet(A11_S) // A11_S
		doPutHead `1' `lastrun' `defs'
		export excel bmal0-bmal65 bfem0-bfem65 btot99 using "`fname'_sup.xlsx", cell(B9) sheet("A11_S") firstrow(var) sheetmodify keepcellfmt 
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		putexcel set "`fname'_sup.xlsx", modify sheet(A3_S) // A3_S
		doPutHead `1' `lastrun' `defs'
		export excel bmal100 bmal101 bmal65 bfem100 bfem101 bfem65 btot99 using "`fname'_sup.xlsx", cell(B9) sheet("A3_S") firstrow(var) sheetmodify keepcellfmt
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		nois di "... OK (suppressed)"
	}
	}
	** final step: ConvertXLS to delete the varname row, and shift the results up by one cell 
	** !!!

	// R, R_S, A_R_S (OMB-RR)
	qui {
	nois di ". Race, Race/Sex, Age/Race/Sex (OMB)" 
	use stcofips sex agecat ombrr b flag using results/results_agesex_ombrr_`1'.dta, clear
	reshape wide b flag, i(stcofips agecat ombrr) j(sex)
	ren *0 *tot
	ren *1 *mal 
	ren *2 *fem
	replace agecat=99 if agecat==-1		// total
	replace agecat=100 if agecat==-2	// <18
	replace agecat=101 if agecat==-3	// 18-64
	reshape wide b* flag*, i(stcofips ombrr) j(agecat)
	reshape wide b* flag*, i(stcofips) j(ombrr) string
	qui for var b*: replace X=0 if X==. 
	qui for var flag*: replace X=3 if X==.
	order stcofips bmal* bfem* btot*
	*format b* %7.2g
	format b* %7.0f
	** export
	if "`2'"=="" {
		*preserve
		putexcel set "`fname'_nosup.xlsx", modify sheet(R)  // R
		doPutHead `1' `lastrun' `defs'
		cap confirm var btot99white
		if !_rc order btot99total, after(btot99white)
		cap confirm var btot99unassigned
		if !_rc order btot99total, after(btot99unassigned)
		export excel btot99* using "`fname'_nosup.xlsx", cell(B9) sheet("R") firstrow(var) sheetmodify keepcellfmt
		putexcel set "`fname'_nosup.xlsx", modify sheet(R_S) // RS
		doPutHead `1' `lastrun' `defs'
		for any "bmal*otal" "bfem*otal": cap drop X
		export excel bmal99* bfem99* btot99total using "`fname'_nosup.xlsx", cell(B9) sheet("R_S") firstrow(var) sheetmodify keepcellfmt 
		putexcel set "`fname'_nosup.xlsx", modify sheet(A3_R_S) // A3_RS
		doPutHead `1' `lastrun' `defs'
		export excel ///
			bmal100aian bmal101aian bmal65aian ///
			bmal100asian bmal101asian bmal65asian ///
			bmal100black bmal101black bmal65black ///
			bmal100hispanic bmal101hispanic bmal65hispanic ///
			bmal100nhpi bmal101nhpi bmal65nhpi ///
			bmal100white bmal101white bmal65white ///
			bmal100other bmal101other bmal65other ///	
			bfem100aian bfem101aian bfem65aian ///
			bfem100asian bfem101asian bfem65asian ///
			bfem100black bfem101black bfem65black ///
			bfem100hispanic bfem101hispanic bfem65hispanic ///
			bfem100nhpi bfem101nhpi bfem65nhpi ///
			bfem100white bfem101white bfem65white ///
			bfem100other bfem101other bfem65other ///	
			btot99total using "`fname'_nosup.xlsx", cell(B9) sheet("A3_R_S") firstrow(var) sheetmodify keepcellfmt 
		drop b*100* b*101*
		putexcel set "`fname'_nosup.xlsx", modify sheet(A11_R_S) // A11_RS
		doPutHead `1' `lastrun' `defs'
		drop bmal99* bfem99*
		export excel bmal* bfem* btot99total using "`fname'_nosup.xlsx", cell(B9) sheet("A11_R_S") firstrow(var) sheetmodify keepcellfmt 
		*restore
		nois di "... OK (unsuppressed)"
	}
	** suppression
	if "`2'"=="suppress" {
		foreach a in "0" "5" "15" "18" "20" "25" "30" "40" "50" "60" "65" "99" "100" "101" {
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
		doPutHead `1' `lastrun' `defs'
		cap confirm var btot99white
		if !_rc order btot99total, after(btot99white)
		cap confirm var btot99unassigned
		if !_rc order btot99total, after(btot99unassigned)
		export excel btot99* using "`fname'_sup.xlsx", cell(B9) sheet("R") firstrow(var) sheetmodify keepcellfmt 
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		putexcel set "`fname'_sup.xlsx", modify sheet(R_S) // RS
		doPutHead `1' `lastrun' `defs'
		for any "bmal*otal" "bfem*otal": cap drop X
		export excel bmal99* bfem99* btot99total using "`fname'_sup.xlsx", cell(B9) sheet("R_S") firstrow(var) sheetmodify keepcellfmt 
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		putexcel set "`fname'_sup.xlsx", modify sheet(A3_R_S) // A3_RS
		doPutHead `1' `lastrun' `defs'
		export excel ///
			bmal100aian bmal101aian bmal65aian ///
			bmal100asian bmal101asian bmal65asian ///
			bmal100black bmal101black bmal65black ///
			bmal100hispanic bmal101hispanic bmal65hispanic ///
			bmal100nhpi bmal101nhpi bmal65nhpi ///
			bmal100white bmal101white bmal65white ///
			bmal100other bmal101other bmal65other ///	
			bfem100aian bfem101aian bfem65aian ///
			bfem100asian bfem101asian bfem65asian ///
			bfem100black bfem101black bfem65black ///
			bfem100hispanic bfem101hispanic bfem65hispanic ///
			bfem100nhpi bfem101nhpi bfem65nhpi ///
			bfem100white bfem101white bfem65white ///
			bfem100other bfem101other bfem65other ///	
			btot99total using "`fname'_nosup.xlsx", cell(B9) sheet("A3_R_S") firstrow(var) sheetmodify keepcellfmt 
		drop b*100* b*101*
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		putexcel set "`fname'_sup.xlsx", modify sheet(A11_R_S) // A11_RS
		doPutHead `1' `lastrun' `defs'
		drop bmal99* bfem99*
		export excel bmal* bfem* btot99total using "`fname'_nosup.xlsx", cell(B9) sheet("A11_R_S") firstrow(var) sheetmodify keepcellfmt 
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		nois di "... OK (suppressed)"
	}
	}
	** final step: ConvertXLS to delete the varname row, and shift the results up by one cell 
	** !!!	
	
	// RE, RE_S, A_RE_S (REALD-RR)
	qui {
	nois di ". REALD, REALD/sex, REALD/age/sex"
	use stcofips sex agecat reldpri b flag using results/results_agesex_reldpri_`1'.dta, clear
	reshape wide b flag, i(stcofips agecat reldpri) j(sex)
	ren *0 *tot
	ren *1 *mal
	ren *2 *fem
	replace agecat=99 if agecat==-1 // total
	replace agecat=63 if agecat==-2 // <18
	replace agecat=64 if agecat==-3 // 18-64
	reshape wide b* flag*, i(stcofips reldpri) j(agecat)
	levelsof reldpri, local(races)
	reshape wide b* flag*, i(stcofips) j(reldpri) string
	qui for var b*: replace X=0 if X==. 
	qui for var flag*: replace X=3 if X==. 
	order stcofips bmal* bfem* btot*
	*format b* %10.2g
	format b* %7.0f
	** export
	if "`2'"=="" {
		*preserve
		putexcel set "`fname'_nosup.xlsx", modify sheet(RE)  // RE
		doPutHead `1' `lastrun' `defs'
		egen btot99Total=rowtotal(btot99*)
		order btot99Total, last
		export excel btot99* using "`fname'_nosup.xlsx", cell(B9) sheet("RE") firstrow(var) sheetmodify keepcellfmt
		putexcel set "`fname'_nosup.xlsx", modify sheet(RE_S) // RES
		doPutHead `1' `lastrun' `defs'
		for any "bmal*otal" "bfem*otal": cap drop X
		export excel bmal99* bfem99* btot99Total using "`fname'_nosup.xlsx", cell(B9) sheet("RE_S") firstrow(var) sheetmodify keepcellfmt 
		putexcel set "`fname'_nosup.xlsx", modify sheet(A11_RE_S) // ARES
		doPutHead `1' `lastrun' `defs'
		drop bmal99* bfem99*
		for num 63/64: renpfix bmalX cmalX \\ renpfix bfemX cfemX
		export excel bmal* bfem* btot99Total using "`fname'_nosup.xlsx", cell(B9) sheet("A11_RE_S") firstrow(var) sheetmodify keepcellfmt 
		for num 63/64: renpfix cmalX bmalX \\ renpfix cfemX bfemX
		putexcel set "`fname'_nosup.xlsx", modify sheet(A3_RE_S) // ARES
		doPutHead `1' `lastrun' `defs'
		for any "0" "5" "15" "18" "20" "25" "30" "40" "60": drop bmalX* bfemX*
		export excel bmal* bfem* btot99Total using "`fname'_nosup.xlsx", cell(B9) sheet("A3_RE_S") firstrow(var) sheetmodify keepcellfmt 
		*restore
		nois di "... OK (unsuppressed)"
	}
	** suppression
	if "`2'"=="suppress" {
		foreach a in "0" "5" "15" "18" "20" "25" "30" "40" "50" "60" "65" "99" "100" "101" {
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
		doPutHead `1' `lastrun' `defs'
		egen btot99Total=rowtotal(btot99*)
		order btot99Total, last
		export excel btot99* using "`fname'_sup.xlsx", cell(B9) sheet("RE") firstrow(var) sheetmodify keepcellfmt 
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		putexcel set "`fname'_sup.xlsx", modify sheet(RE_S) // RES
		doPutHead `1' `lastrun' `defs'
		for any "bmal*otal" "bfem*otal": cap drop X
		export excel bmal99* bfem99* btot99Total using "`fname'_sup.xlsx", cell(B9) sheet("RE_S") firstrow(var) sheetmodify keepcellfmt 
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		putexcel set "`fname'_sup.xlsx", modify sheet(A11_RE_S) // ARES
		doPutHead `1' `lastrun' `defs'
		drop bmal99* bfem99*
		for num 63/64: renpfix bmalX cmalX \\ renpfix bfemX cfemX
		export excel bmal* bfem* btot99Total using "`fname'_sup.xlsx", cell(B9) sheet("A11_RE_S") firstrow(var) sheetmodify keepcellfmt 
		for num 63/64: renpfix cmalX bmalX \\ renpfix cfemX bfemX
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		putexcel set "`fname'_nosup.xlsx", modify sheet(A3_RE_S) // ARES
		doPutHead `1' `lastrun' `defs'
		for any "0" "5" "15" "18" "20" "25" "30" "40" "60": drop bmalX* bfemX*
		export excel bmal* bfem* btot99Total using "`fname'_sup.xlsx", cell(B9) sheet("A3_RE_S") firstrow(var) sheetmodify keepcellfmt 
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		nois di "... OK (suppressed)"
	}
	}
	** final step: ConvertXLS to delete the varname row, and shift the results up by one cell 
	** !!!	
	
	// DA, D4A, D7A
	qui {
	nois di ". Disability"
	foreach d in "disdi" "da4cat" "da7compacsall" {
		nois di ". `d'"
		use stcofips agecat `d' b flag sex if sex==0 using results/results_`d'_`1'.dta, clear
		drop sex
		replace agecat=99 if agecat==-1 // recode total
		replace agecat=63 if agecat==-2 // <18
		replace agecat=64 if agecat==-3 // 18-64
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
			local t="D"
			order stcofips b*_0 b*_1 total
		}
		else if "`d'"=="da4cat" {
			local t="D4"
			order stcofips b*_0 b*_1 b*_2 b*_3 total
		}
		else if "`d'"=="da7compacsall" {
			local t="D7" 
			order stcofips b*_0 b*_1 b*_2 b*_3 b*_4 b*_5 b*_6 total
		}
		putexcel set "`fname'_nosup.xlsx", modify sheet(`t'_A11) // D_A11 D4_A11 D7_A11
		doPutHead `1' `lastrun' `defs'
		for num 63/64: renpfix bX cX 
		export excel b*_* total using "`fname'_nosup.xlsx", cell(B9) sheet(`t'_A11) firstrow(var) sheetmodify keepcellfmt
		for num 65: renpfix bX cX 
		putexcel set "`fname'_nosup.xlsx", modify sheet(`t'_A3) // D_A3 D4_A3 D7_A3
		doPutHead `1' `lastrun' `defs'
		export excel c*_* total using "`fname'_nosup.xlsx", cell(B9) sheet(`t'_A3) firstrow(var) sheetmodify keepcellfmt 
		nois di "... OK (unsuppressed)"
		** suppression
		if "`2'"=="suppress" {
			foreach a in "0" "5" "15" "18" "20" "25" "30" "40" "50" "60" "63" "64" "65" "99" {
				forvalues v=0/6 {
					cap confirm var b`a'_`v'
					if !_rc {
						replace b`a'_`v'=. if flag`a'_`v'>=3
						tostring b`a'_`v', replace force usedisplayformat
						replace b`a'_`v'=b`a'_`v'+"*" if flag`a'_`v'==2
					}
					cap confirm var c`a'_`v'
					if !_rc {
						replace c`a'_`v'=. if flag`a'_`v'>=3
						tostring c`a'_`v', replace force usedisplayformat
						replace c`a'_`v'=c`a'_`v'+"*" if flag`a'_`v'==2
					}
				}
			}
			putexcel set "`fname'_sup.xlsx", modify sheet(`t'_A11)
			doPutHead `1' `lastrun' `defs'
			putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
			export excel b*_* total using "`fname'_sup.xlsx", cell(B9) sheet(`t'_A11) firstrow(var) sheetmodify keepcellfmt
			putexcel set "`fname'_sup.xlsx", modify sheet(`t'_A3)
			doPutHead `1' `lastrun' `defs'
			putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
			export excel c*_* total using "`fname'_sup.xlsx", cell(B9) sheet(`t'_A3) firstrow(var) sheetmodify keepcellfmt
			nois di "... OK (suppressed)"
		}
	}
	}
	** final step: ConvertXLS to delete the varname row, and shift the results up by one cell 
	** !!!	
	
	// DSA
	qui foreach d in "drs" "ear" "eye" "out" "phy" "rem" {
		nois di ". `d'"
		use stcofips agecat d`d'oicv2 b flag sex if sex==0 using results/results_d`d'oicv2_`1'.dta, clear
		drop sex
		replace agecat=99 if agecat==-1 // recode total
		replace agecat=63 if agecat==-2 // <18
		replace agecat=64 if agecat==-3 // 18-64
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
		putexcel set "`fname'_nosup.xlsx", modify sheet("DS_A11") // DS_A11
		doPutHead `1' `lastrun' `defs'
		for num 63/64: renpfix bX cX 
		if "`d'"=="drs" export excel b* total using "`fname'_nosup.xlsx", cell(B9) sheet("DS_A11") firstrow(var) sheetmodify keepcellfmt
		if "`d'"=="ear" export excel b* total using "`fname'_nosup.xlsx", cell(B50) sheet("DS_A11") firstrow(var) sheetmodify keepcellfmt
		if "`d'"=="eye" export excel b* total using "`fname'_nosup.xlsx", cell(B91) sheet("DS_A11") firstrow(var) sheetmodify keepcellfmt
		if "`d'"=="out" export excel b* total using "`fname'_nosup.xlsx", cell(B132) sheet("DS_A11") firstrow(var) sheetmodify keepcellfmt
		if "`d'"=="phy" export excel b* total using "`fname'_nosup.xlsx", cell(B173) sheet("DS_A11") firstrow(var) sheetmodify keepcellfmt
		if "`d'"=="rem" export excel b* total using "`fname'_nosup.xlsx", cell(B214) sheet("DS_A11") firstrow(var) sheetmodify keepcellfmt
		for num 65: renpfix bX cX 
		putexcel set "`fname'_nosup.xlsx", modify sheet("DS_A3") // DS_A3
		doPutHead `1' `lastrun' `defs'
		if "`d'"=="drs" export excel c* total using "`fname'_nosup.xlsx", cell(B9) sheet("DS_A3") firstrow(var) sheetmodify keepcellfmt
		if "`d'"=="ear" export excel c* total using "`fname'_nosup.xlsx", cell(B50) sheet("DS_A3") firstrow(var) sheetmodify keepcellfmt
		if "`d'"=="eye" export excel c* total using "`fname'_nosup.xlsx", cell(B91) sheet("DS_A3") firstrow(var) sheetmodify keepcellfmt
		if "`d'"=="out" export excel c* total using "`fname'_nosup.xlsx", cell(B132) sheet("DS_A3") firstrow(var) sheetmodify keepcellfmt
		if "`d'"=="phy" export excel c* total using "`fname'_nosup.xlsx", cell(B173) sheet("DS_A3") firstrow(var) sheetmodify keepcellfmt
		if "`d'"=="rem" export excel c* total using "`fname'_nosup.xlsx", cell(B214) sheet("DS_A3") firstrow(var) sheetmodify keepcellfmt
		nois di "... OK (unsuppressed)"
		** suppression
		if "`2'"=="suppress" {
			foreach a in "0" "5" "15" "18" "20" "25" "30" "40" "50" "60" "63" "64" "65" {
				forvalues v=0/2 {
					cap confirm var b`a'_`v' 
					if !_rc {
						replace b`a'_`v'=. if flag`a'_`v'>=3
						tostring b`a'_`v', replace force usedisplayformat
						replace b`a'_`v'=b`a'_`v'+"*" if flag`a'_`v'==2
					}
					cap confirm var c`a'_`v'
					if !_rc {
						replace c`a'_`v'=. if flag`a'_`v'>=3
						tostring c`a'_`v', replace force usedisplayformat
						replace c`a'_`v'=c`a'_`v'+"*" if flag`a'_`v'==2
					}
				}
			}
			putexcel set "`fname'_sup.xlsx", modify sheet(DS_A11)
			doPutHead `1' `lastrun' `defs'
			putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
			if "`d'"=="drs" export excel b* total using "`fname'_sup.xlsx", cell(B9) sheet("DS_A11") firstrow(var) sheetmodify keepcellfmt
			if "`d'"=="ear" export excel b* total using "`fname'_sup.xlsx", cell(B50) sheet("DS_A11") firstrow(var) sheetmodify keepcellfmt
			if "`d'"=="eye" export excel b* total using "`fname'_sup.xlsx", cell(B91) sheet("DS_A11") firstrow(var) sheetmodify keepcellfmt
			if "`d'"=="out" export excel b* total using "`fname'_sup.xlsx", cell(B132) sheet("DS_A11") firstrow(var) sheetmodify keepcellfmt
			if "`d'"=="phy" export excel b* total using "`fname'_sup.xlsx", cell(B173) sheet("DS_A11") firstrow(var) sheetmodify keepcellfmt
			if "`d'"=="rem" export excel b* total using "`fname'_sup.xlsx", cell(B214) sheet("DS_A11") firstrow(var) sheetmodify keepcellfmt
			putexcel set "`fname'_sup.xlsx", modify sheet(DS_A3)
			doPutHead `1' `lastrun' `defs'
			putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
			if "`d'"=="drs" export excel c* total using "`fname'_sup.xlsx", cell(B9) sheet("DS_A3") firstrow(var) sheetmodify keepcellfmt
			if "`d'"=="ear" export excel c* total using "`fname'_sup.xlsx", cell(B50) sheet("DS_A3") firstrow(var) sheetmodify keepcellfmt
			if "`d'"=="eye" export excel c* total using "`fname'_sup.xlsx", cell(B91) sheet("DS_A3") firstrow(var) sheetmodify keepcellfmt
			if "`d'"=="out" export excel c* total using "`fname'_sup.xlsx", cell(B132) sheet("DS_A3") firstrow(var) sheetmodify keepcellfmt
			if "`d'"=="phy" export excel c* total using "`fname'_sup.xlsx", cell(B173) sheet("DS_A3") firstrow(var) sheetmodify keepcellfmt
			if "`d'"=="rem" export excel c* total using "`fname'_sup.xlsx", cell(B214) sheet("DS_A3") firstrow(var) sheetmodify keepcellfmt
			nois di "... OK (suppressed)"
		}
	}
	
	// H_A, H_R_A (health insurance)
	qui {
	nois di ". Medicaid, Medicaid/Race, Medicaid/Race/Age" 
	use stcofips maid ombrr agecat b flag sex if sex==0 using results/results_maid_ombrr_`1'.dta, clear
	drop sex
	replace agecat=99 if agecat==-1 // recode total
	replace agecat=63 if agecat==-4 // <19
	replace agecat=64 if agecat==-5 // 19-64
	assert inlist(agecat,63,64,65,99)
	reshape wide b flag, i(stcofips maid ombrr) j(agecat)
	reshape wide b* flag*, i(stcofips maid) j(ombrr) string
	reshape wide b* flag*, i(stcofips) j(maid) 
	for var b*: replace X=0 if X==.
	for var flag*: replace X=3 if X==.
	order stcofips b*aian* b*asian* b*black* b*hispanic* b*nhpi* b*other* b*white* b*total* 
	*format b* %10.3g
	format b* %7.0f
	** export
	putexcel set "`fname'_nosup.xlsx", modify sheet("H_A3") // HA
	doPutHead `1' `lastrun' `defs'
	export excel b6*total1 using "`fname'_nosup.xlsx", cell(B9) sheet("H_A3") firstrow(var) sheetmodify keepcellfmt
	putexcel set "`fname'_nosup.xlsx", modify sheet("H_R_A3") // HRA
	doPutHead `1' `lastrun' `defs'
	export excel b*1 using "`fname'_nosup.xlsx", cell(B9) sheet("H_R_A3") firstrow(var) sheetmodify keepcellfmt
	nois di "... OK (suppressed)"
	** suppression
	if "`2'"=="suppress" {
		foreach a in "63" "64" "65" "99" {
			foreach r in "aian" "asian" "black" "hispanic" "nhpi" "other" "white" "total" {
				forvalues v=0/1 {
					replace b`a'`r'`v'=. if flag`a'`r'`v'>=3
					tostring b`a'`r'`v', replace force usedisplayformat
					replace b`a'`r'`v'=b`a'`r'`v'+"*" if flag`a'`r'`v'==2
				}
			}
		}
		putexcel set "`fname'_sup.xlsx", modify sheet("H_A3") // HA
		doPutHead `1' `lastrun' `defs'
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)."
		export excel b6*total1 using "`fname'_sup.xlsx", cell(B9) sheet("H_A3") firstrow(var) sheetmodify keepcellfmt
		putexcel set "`fname'_sup.xlsx", modify sheet("H_R_A3") // HRA
		doPutHead `1' `lastrun' `defs'
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)."
		export excel b*1 using "`fname'_sup.xlsx", cell(B9) sheet("H_R_A3") firstrow(var) sheetmodify keepcellfmt
		nois di "... OK (unsuppressed)"
	}
	}
	
	// L, LA, LEP, LEPA (STATE) 
	qui {
	nois di ". Language, Language/Age, LEP, LEP/Age (State-level)" 
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
		0	"eng"	1	"qaa"	2	"arb"	3	"hye"	4	"ben"	5	"qca"	6	"zho"	8	"fra"	9	"deu"	10	"ell"
		11	"guj"	12	"hat"	13	"heb"	14	"hin"	15	"hmn"	16	"ita"	17	"jpn"	18	"khm"	19	"kor"	20	"qdr"
		21	"nav"	22	"qas"	23	"qie"	24	"qin"	25	"qna"	26	"qau"	27	"qsl"	28	"und"	29	"pan"	30	"fas"
		31	"pol"	32	"por"	33	"rus"	34	"hbs"	35	"spa"	36	"tam"	37	"tel"	38	"qtf"	39	"qtl"	40	"ukr"
		41	"urd"	42	"vie"	43	"qwg"	44	"qwa", replace;
	#delimit cr
	label values langoha langiso
	decode langoha, gen(langstr)
	putexcel set "`fname'_nosup.xlsx", modify sheet("L_State") // L_State
	doPutHead `1' `lastrun' `defs'
	export excel langstr b*_99 using "`fname'_nosup.xlsx", cell(B9) sheet("L_State") firstrow(var) sheetmodify keepcellfmt
	putexcel set "`fname'_nosup.xlsx", modify sheet("LEP_State") // LEP
	doPutHead `1' `lastrun' `defs'
	export excel langstr b*_1 using "`fname'_nosup.xlsx", cell(B9) sheet("LEP_State") firstrow(var) sheetmodify keepcellfmt
	nois di "... OK (suppressed)"
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
		doPutHead `1' `lastrun' `defs'
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		export excel langstr b*_99 using "`fname'_sup.xlsx", cell(B9) sheet("L_State") firstrow(var) sheetmodify keepcellfmt
		putexcel set "`fname'_sup.xlsx", modify sheet("LEP_State") // LEP
		doPutHead `1' `lastrun' `defs'
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		export excel langstr b*_1 using "`fname'_sup.xlsx", cell(B9) sheet("LEP_State") firstrow(var) sheetmodify keepcellfmt
		nois di "... OK (unsuppressed)"
	}
	}
	
	// L, LA, LEP, LEPA (COUNTY)
	qui {
	nois di ". Language, Language/Age, LEP, LEP/Age (County-level)" 
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
		0	"eng"	1	"qaa"	2	"arb"	3	"hye"	4	"ben"	5	"qca"	6	"zho"	8	"fra"	9	"deu"	10	"ell"
		11	"guj"	12	"hat"	13	"heb"	14	"hin"	15	"hmn"	16	"ita"	17	"jpn"	18	"khm"	19	"kor"	20	"qdr"
		21	"nav"	22	"qas"	23	"qie"	24	"qin"	25	"qna"	26	"qau"	27	"qsl"	28	"und"	29	"pan"	30	"fas"
		31	"pol"	32	"por"	33	"rus"	34	"hbs"	35	"spa"	36	"tam"	37	"tel"	38	"qtf"	39	"qtl"	40	"ukr"
		41	"urd"	42	"vie"	43	"qwg"	44	"qwa", replace;
	#delimit cr
	label values langoha langiso
	decode langoha, gen(langstr)
	replace langstr="Total" if langstr=="0"
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
	if "`2'"=="" {
		preserve
		putexcel set "`fname'_nosup.xlsx", modify sheet("L") // L
		doPutHead `1' `lastrun' `defs'
		export excel b99_99* total using "`fname'_nosup.xlsx", cell(B9) sheet("L") firstrow(var) sheetmodify keepcellfmt
		putexcel set "`fname'_nosup.xlsx", modify sheet("LEP") // LEP
		doPutHead `1' `lastrun' `defs'
		export excel b99_1* leptot using "`fname'_nosup.xlsx", cell(B9) sheet("LEP") firstrow(var) sheetmodify keepcellfmt
		drop b99_* // drop totals by age
		putexcel set "`fname'_nosup.xlsx", modify sheet("L_A3") // LA
		doPutHead `1' `lastrun' `defs'
		export excel b*_99* total using "`fname'_nosup.xlsx", cell(B9) sheet("L_A3") firstrow(var) sheetmodify keepcellfmt
		putexcel set "`fname'_nosup.xlsx", modify sheet("LEP_A3") // LEP_A
		doPutHead `1' `lastrun' `defs'
		export excel b*_1* leptot using "`fname'_nosup.xlsx", cell(B9) sheet("LEP_A3") firstrow(var) sheetmodify keepcellfmt
		*restore
		nois di "... OK (unsuppressed)"
	}
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
		doPutHead `1' `lastrun' `defs'
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		export excel b99_99* total using "`fname'_sup.xlsx", cell(B9) sheet("L") firstrow(var) sheetmodify keepcellfmt
		putexcel set "`fname'_sup.xlsx", modify sheet("LEP") // LEP
		doPutHead `1' `lastrun' `defs'
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		export excel b99_1* leptot using "`fname'_sup.xlsx", cell(B9) sheet("LEP") firstrow(var) sheetmodify keepcellfmt
		drop b99_* // drop totals by age
		putexcel set "`fname'_sup.xlsx", modify sheet("L_A3") // LA
		doPutHead `1' `lastrun' `defs'
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		export excel b*_99* total ///
			using "`fname'_sup.xlsx", cell(B9) sheet("L_A3") firstrow(var) sheetmodify keepcellfmt
		putexcel set "`fname'_sup.xlsx", modify sheet("LEP_A3") // LEP_A
		doPutHead `1' `lastrun' `defs'
		putexcel A4 = "Note: Suppression applied (results with RSE>30% noted with asterisk; results with RSE>50% suppressed)"
		export excel b*_1* leptot ///
			using "`fname'_sup.xlsx", cell(B9) sheet("LEP_A3") firstrow(var) sheetmodify keepcellfmt
		nois di "... OK (suppressed)"
	}
	}

end
* fillReport YYYY suppress
