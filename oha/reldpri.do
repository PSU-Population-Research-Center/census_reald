gen reldpri=""    
replace reldpri="AmInd" if rareraceadj==1
replace reldpri="AlaskNat" if rareraceadj==2
replace reldpri="CanInd" if rareraceadj==3
replace reldpri="LatInd" if rareraceadj==4
replace reldpri="AIANAgg" if rareraceadj==5
replace reldpri="AsianInd" if rareraceadj==6
replace reldpri="Cambodian" if rareraceadj==7
replace reldpri="Chinese" if rareraceadj==8
replace reldpri="Myanmar" if rareraceadj==9
replace reldpri="Filipino" if rareraceadj==10
replace reldpri="Hmong" if rareraceadj==11
replace reldpri="Japanese" if rareraceadj==12
replace reldpri="Korean" if rareraceadj==13
replace reldpri="Laotian" if rareraceadj==14
replace reldpri="SoAsian" if rareraceadj==15
replace reldpri="Vietnamese" if rareraceadj==16
replace reldpri="AsianOth" if rareraceadj==17
replace reldpri="AsianAgg" if rareraceadj==18
replace reldpri="AfrAm" if rareraceadj==19
replace reldpri="Caribbean" if rareraceadj==20
replace reldpri="Ethiopian" if rareraceadj==21
replace reldpri="Somali" if rareraceadj==22
replace reldpri="African" if rareraceadj==23
replace reldpri="BlackOth" if rareraceadj==24
replace reldpri="BlackAgg" if rareraceadj==25
replace reldpri="HisMex" if rareraceadj==26
replace reldpri="HisCen" if rareraceadj==27
replace reldpri="HisSou" if rareraceadj==28
replace reldpri="HisOth" if rareraceadj==29
replace reldpri="HisAgg" if rareraceadj==30
replace reldpri="MidEast" if rareraceadj==31
replace reldpri="NoAfr" if rareraceadj==32
replace reldpri="MENAAgg" if rareraceadj==33
replace reldpri="Cham" if rareraceadj==34
replace reldpri="Cham" if rareraceadj==35
replace reldpri="Cham" if rareraceadj==36
replace reldpri="COFA" if rareraceadj==37
replace reldpri="Marshall" if rareraceadj==38
replace reldpri="Samoan" if rareraceadj==39
replace reldpri="Tongan" if rareraceadj==40
replace reldpri="NatHaw" if rareraceadj==41
replace reldpri="NHPIoth" if rareraceadj==42
replace reldpri="NHPIAgg" if rareraceadj==43
replace reldpri="EastEur" if rareraceadj==44
replace reldpri="Slavic" if rareraceadj==45
replace reldpri="WestEur" if rareraceadj==46
replace reldpri="WhiteOth" if rareraceadj==47
replace reldpri="WhiteAgg" if rareraceadj==48
replace reldpri="RaceOth" if rareraceadj==50
replace reldpri="RaceOth" if rareraceadj==51
replace reldpri="RaceOth" if rareraceadj==52
replace reldpri="RaceOth" if rareraceadj==53
replace reldpri="RaceOth" if rareraceadj==98
replace reldpri="RaceOth" if rareraceadj==99
replace reldpri="" if rareraceadj==100
replace reldpri=trim(reldpri)   
assert reldpri!="" // confirm no missings   