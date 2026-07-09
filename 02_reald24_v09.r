# notes: intended to be run non-interactively (e.g. Rscript 02_reald_v08.r <year>)
# v09: updated with AfroLatino override
# v08: modified to work with 2023 or 2024.
# v07: updated to merge in J imputations, add Clark WA, and keep var 'state'.

# clear workspace
rm(list = ls())
setwd('I:/Research/Shares/population_research/_PROJECTS/_OHA_REALD24_ACS') 

# read census api key
ckey<-trimws(readLines("_censuskey.txt", warn = FALSE))

# parse and validate command-line argument
args = commandArgs(trailingOnly = TRUE)
if (length(args) < 1) stop("Must specify a year: Rscript 02_reald_v08.r <year>", call. = FALSE)
year = suppressWarnings(as.integer(args[1]))
if (is.na(year) || year < 2023) {
  stop("Must specify an integer year >= 2023", call. = FALSE)
}

# load packages
using<-function(...) {
    libs<-unlist(list(...))
    req<-unlist(lapply(libs,require,character.only=TRUE))
    need<-libs[req==FALSE]
    if(length(need)>0){ 
        install.packages(need)
        lapply(need,require,character.only=TRUE)
    }
}
using("censusapi","dplyr","tidyr","purrr","readstata13")

# set global option to suppress message from summarise()
options(dplyr.summarise.inform = FALSE)

# List of variables needed from PUMS
if (year %in% 2023) {
  pums_vars = c(
      "STATE", "SERIALNO", "SPORDER", "RT", "PUMA", "PWGTP", "SEX", "AGEP", "HISP",
      "POBP", "WAOB", "ANC1P", "ANC2P", "RAC1P", "RAC2P19", "RAC2P23", "RAC3P", 
      "RACAIAN","RACASN","RACBLK","RACNH","RACNUM","RACPI","RACSOR","RACWHT",
      "ENG","LANX","LANP")
} else if (year %in% 2024) {
  pums_vars = c(
      "STATE", "SERIALNO", "SPORDER", "RT", "PUMA", "PWGTP", "SEX", "AGEP", "HISP",
      "POBP", "WAOB", "ANC1P", "ANC2P", "RAC1P", "RAC2P19", "RAC2P24", "RAC3P", 
      "RACAIAN","RACASN","RACBLK","RACNH","RACNUM","RACPI","RACSOR","RACWHT",
      "ENG","LANX","LANP")
}

# Read pums for OR and Clark Co, WA.
pums_or = getCensus(
  name    = "acs/acs5/pums",
  vintage = as.character(year),
  vars    = pums_vars,
  region  = "state:41",
  key     = ckey
)
pums_wa = getCensus(
  name     = "acs/acs5/pums",
  vintage  = as.character(year),
  vars     = pums_vars,
  region   = "public use microdata area:21101,21102,21103,21104",
  regionin = "state:53",
  key     = ckey
) 
pums_raw = bind_rows(pums_or, pums_wa) |>
  select(
    STATE, SERIALNO, SPORDER, PUMA, PWGTP,
    matches('^RAC'), matches('^ANC.'), LANP, HISP, POBP
  ) |>
    rename_with(tolower)

# Get the names of the PUMS data dictionary files
grep(paste0('pums_data_dictionary_',year-4,'-', year), dir('acs/'), value = TRUE) |>
  # name each list element after the table (extracted from the filename)
  set_names(nm = \(fn) gsub('.+\\_([a-z0-9]+)\\.txt$', '\\1', fn)) |>
  # Read in CSVs
  map(.f = \(fn) read.table(paste0('acs/', fn), sep = '.', quote = "")) |>
  # Add in the column names (they aren't in the dictionary files)
  imap(.f = \(df, tabname) set_names(df, nm = c(tabname, paste0(tabname, '_str')))) |>
  # # Rename the rac2p frames (only) to facilitate merging
  # map(.f = \(df) rename_with(df, ~ gsub('2p\\d{2}', '2p', .))) |>
  # Change everything to lowercase
  map(.f = \(df) df |> mutate(across(where(is.character), tolower))) |>
  # create an object for each of these (I'm not sure this is working...)
  iwalk(.f = \(df, tabname) assign(x = paste0(tabname, '_dict'), value = df, envir = .GlobalEnv))

# collect whichever dicts were created above
all_dicts <- mget(
  ls(pattern = '_dict$', envir = .GlobalEnv),
  envir = .GlobalEnv
)

# clone the pums data but use strings for value labels, for regex (special handling for rac2p)
pums_str = pums_raw |>
  (\(df) reduce(
    all_dicts,
    \(acc, dict) {
      key <- names(dict)[1]
      if (key %in% names(acc)) merge(acc, dict, all.x = TRUE) else acc
    },
    .init = df
  ))() |>
  mutate(
    rac2p     = do.call(coalesce, pick(matches('^rac2p(\\d+)?$'))),
    rac2p_str = do.call(coalesce, pick(matches('^rac2p(\\d+)?_str$')))
  ) |>
  select(-matches('rac2p\\d')) |>
  merge(rac3p_dict) |>
  mutate(across(c(racaian, racasn, racblk, racnh, racpi, racsor, racwht), as.logical)) |>
  mutate(hisplog = hisp > 1) |>
  select(state, serialno, sporder, puma, pwgtp, where(is.numeric), where(is.character), where(is.logical))

# single object for dictionary (useful for querying)
# all_dicts = mget(grep('\\_dict$', ls(), value = TRUE))
# dict_query = (\(x) lapply(all_dicts, \(df) df |> filter(if_any(ends_with('str'), ~ grepl(x, .)))))

# new data frame for assignment
pums_out = pums_str
pums_out[, c(
  ### American Indian and Alaska Native
  "AIANInd", "AIANAlask", "AIANCan", "AIANLat",
  ### Asian groups
  "AsnAfghan", "AsnInd", "AsnCambod", "AsnChinese", "AsnMyan", "AsnFilipino",
  "AsnHmong", "AsnIndones", "AsnJapanese", "AsnKorean", "AsnLao", "AsnPakistani", 
  "AsnSouth", "AsnTaiwanese", "AsnThai", "AsnViet", "AsnOther",
  ### Black and African groups
  "AfrAm", "AfrCarib", "AfrEthiopian", "AfrHaitian", "AfrJamaican", "AfrNigerian",
  "AfrSomali", "AfrOther",
  ### Latin groups
  "LatAfr", "LatCen", "LatCub", "LatDom", "LatGuat", "LatMex", "LatPR", 
  "LatSalv", "LatSou", "LatOther",
  ### Middle Eastern/North African groups
  "MENAEgypt", "MENAIraq", "MENAIran", "MENAIsr", "MENALeban", "MENAPalest", "MENASyr",
  "MENATurkish", "MENAOther",
  ### Pacific Islander groups
  "NHPICham", "NHPIMarshall", "NHPICOFA", "NHPISamoan", "NHPIHawaii", "NHPIFijian", 
  "NHPITongan", "NHPIOther",
  ### White groups
  "WhtEng", "WhtGer", "WhtIre", "WhtItal", "WhtPol", "WhtRom", "WhtRus",
  "WhtSco", "WhtSlav", "WhtUkr", "WhtOther",
  ### Other groups
  "OtherUnspec"
)] = NA

# put assignments for all except J into pums_out
pums_out = pums_out |>
  mutate(
    ##### == LATIN GROUPS == #####
    ### - Afro-Latino
    # Identifies as Black and 
    # Latino or identifying with a Latin American (Spain, Mexican, Cent. Am.,
    # South. Am., PR, Cuba, DR; 200-295) or Brazilian (360) ancestry 
    LatAfr = racblk & (hisplog | anc1p %in% c(200:296, 360) | anc2p %in% c(200:296, 360)),
    ### = Hispanic (Central American)
    LatCen =  (hisplog | racsor) & (
      # Ancestry or Hispanic Identifier includes: Costa Rican, Honduran, Nicaraguan, Panamanian, 
      # Belize, "Central American Other" (includes Central American Indian)
      if_any(
        c(anc1p_str, anc2p_str, hisp_str), 
        ~ grepl('costa|hondur|nicarag|panama|beliz', .)  | grepl('(other )?central american( oth)?', .)
      ) | (
        # or, lists birthplace as Belize, Costa Rica , Honduras, Nicaragua, Panama 
        # AND has "other" detailed Hispanic ID (498)
        # AND ancestry Latin American (250), Hispanic (290), Uncoded (996) or not given (999)
        (grepl('beliz|costa|hondur|nicarag|panam', pobp_str)) & 
          (hisp %in% 24) &
          (anc1p %in% c(250:252, 290, 996:999) | anc2p %in% c(250:252, 290))
      )
    ),
    ### - Cuban
    LatCub = (hisplog | racsor) & (
      # Ancestry or specific Hispanic ancestry includes Cuba
      if_any(c(anc1p_str, anc2p_str, hisp_str), ~ grepl('cuba', .)) |
        # or, lists birthplace as Cuba AND has "other" detailed Hispanic ID (24) 
        # and ancestry Latin American (250), Hispanic (290), Uncoded (996) or not given (999)
        (
          grepl('cuba', pobp_str) & (hisp %in% 24) &
            (anc1p %in% c(250:252, 290, 996:999) | anc2p %in% c(250:252, 290))
        )
    ),
    ### - Dominican
    LatDom = (hisplog | racsor) & (
      # Ancestry or specific Hispanic ancestry includes Dominican
      if_any(c(anc1p_str, anc2p_str, hisp_str), ~ grepl('dominican', .)) |
        # or, lists detailed birthplace as DR AND has "other" detailed Hispanic ID (24) 
        # and ancestry Latin American (250), Hispanic (290), Uncoded (996) or not given (999)
        (
          grepl('dominican', pobp_str) & (hisp %in% 24) &
            (anc1p %in% c(250:252, 290, 996:999) | anc2p %in% c(250:252, 290))
        )
    ),
    ### - Guatemalan
    LatGuat = (hisplog | racsor) & (
      # Ancestry or specific Hispanic ancestry includes Guatemala
      if_any(c(anc1p_str, anc2p_str, hisp_str), ~ grepl('guatemal', .)) |
        # or, lists detailed birthplace as Guatemala AND has "other" detailed Hispanic ID (24) 
        # and ancestry Latin American (250), Hispanic (290), Uncoded (996) or not given (999)
        (
          grepl('guatemal', pobp_str) & (hisp %in% 24) &
            (anc1p %in% c(250:252, 290, 996:999) | anc2p %in% c(250:252, 290))
        )
    ),
    ### - Mexican
    LatMex = (hisplog | racsor) & (
      # Ancestry or Hispanic ancestry is mexican or chicana/o
      if_any(c(anc1p_str, anc2p_str, hisp_str), ~ grepl('mex|chica', .)) |
        # or born in Mexico but listed as Hispanic, other (24) and has 
        # Latin American (250) Hispanic (290) or uncodable/unknown ancestry (996-999)
        (
          grepl('^mex', pobp_str) & (hisp %in% 24) &
            (anc1p %in% c(250:252, 290, 996:999) | anc2p %in% c(250:252, 290))
        )
    ),
    ### - Puerto Rican
    LatPR = (hisplog | racsor) & (
      # Ancestry includes Puerto Rican (261) or Hispanic flag specifies PR
      if_any(c(anc1p_str, anc2p_str, hisp_str), ~ grepl('puerto', .)) |
        # or born in Puerto Rico but listed as Hispanic, other (24) and has 
        # Latin American (250) Hispanic (290) or uncodable/unknown ancestry (996-999) 
        (
          grepl('puerto', pobp_str) & (hisp %in% 24) &
            (anc1p %in% c(250:252, 290, 996:999) | anc2p %in% c(250:252, 290))
        )
    ),
    ### - Salvadorean
    LatSalv = (hisplog | racsor) & (
      # Ancestry includes El Salvador or Hispanic flag specifies El Salvador
      if_any(c(anc1p_str, anc2p_str, hisp_str), ~ grepl('salva', .)) |
        # or born in El Salvador but listed as Hispanic, other (24) and has 
        # Latin American (250) Hispanic (290) or uncodable/unknown ancestry (996-999) 
        (
          grepl('salva', pobp_str) & (hisp %in% 24) &
            (anc1p %in% c(250:252, 290, 996:999) | anc2p %in% c(250:252, 290))
        )
    ),
    ### - South American
    LatSou =  (hisplog | racsor) & (
      # Lists ancestry or Hispanic identity as: Argentinian, Bolivian, Chilean, 
      # Colombian, Ecuadorian, Paraguayan, Peruvian, Uruguayan, Venezuelan, 
      # South American other, Brazilian
      if_any(
        c(anc1p_str, anc2p_str, hisp_str), 
        ~ grepl('argent|boliv|chile|colomb|ecuad|parag|peruv?|urugu|venez', .) | 
          grepl('bra[sz]il', .) | grepl('(other )?south american( oth)?', .)
          # NOTE: above is a code snippet that includes south american indian
      ) |
        # or born in South America (360-375) and Hispanic ID other (498) or has
        # Latin American (250) Hispanic (290) or uncodable/unknown ancestry (996-999) 
        (
          pobp %in% 360:374 & (hisp %in% 24) &
            (anc1p %in% c(250:252, 290, 996:999) | anc2p %in% c(250:252, 290))
        )
    ),
    ### = Hispanic (Other)
    # Hispanic flag or race "other" plus Hispanic ancestry AND not captured by the other categories
    LatOther = (hisplog | (racsor & (anc1p %in% c(200:296, 360) | anc2p %in% c(200:296, 360)))) & 
      !(LatAfr | LatCen | LatCub | LatDom | LatGuat | LatMex | LatPR | LatSalv | LatSou),
    
    ##### == INDIGENOUS GROUPS == #####
    ### - Alaska Native
    # Not born in Canada, AND
    AIANAlask = (racaian | racsor) & !grepl('canad', pobp_str) & (
      # Ancestry, race, or language includes Aleut, Eskimo, Inuit, Tlingit, 
      # Alaska Athabaskan, Athab(/p)ascan, Inupiat, Yupik, or other Alaska Native tribes
      if_any(
        c(anc1p_str, anc2p_str, rac2p_str, rac3p_str, lanp_str), 
        ~ grepl('aleut|eskim|inuit|^alask|tling|atha[bp]|inupia|yup\'', .) |
          grepl("^(other )?alaska native", .)
      )
      # NOTE: in new version, can add flag for rac1p == 5 (alaska native alone)
    ),
    ### - Canadian Indian, First Nations, Metis
    # Is race "other" or First Nations AND 
    AIANCan = (racaian | racsor) & 
      # born in Canada or having Canadian ancestry AND
      if_any(c(anc1p_str, anc2p_str, pobp_str), ~ grepl('canad', .)) & (
        # Ancestry, detailed race, or language matches northern North American Indigenous IDs
        if_any(
          c(anc1p_str, anc2p_str, rac2p_str, rac3p_str, lanp_str), 
          ~ grepl('eskim|inuit|tling|atha[bp]|inupia|algonq|chipp|blackf', .) |
            grepl("yup\'|ojib|salish|iroqu|colvil|akota|siou(x)?|potaw|penuti", .) |
            grepl('([^(central)|(south)|(mexican)|(latin)|(\\/or)] |^)american indian', .) | 
            grepl('native (north )?american', .)
        )
      ),
    ### - Latin American Indian/Indigenous
    AIANLat = (racaian | racsor) & (
      # Have race/language/ancestry matching specific (mex/centr/south) american indian or
      # some specific tribal affiliations
      # NOTE: will probably want to go in here in a future version and add more tribes
      if_any(
        c(anc1p_str, anc2p_str, rac2p_str, rac3p_str, lanp_str),
        # NOTE: original version has a bug that does not catch Mexican (American) Indian
        ~ grepl('((central)|(south)|(mexican)|(latin)) (american )?indian', .) |
          # grepl('((central)|(south)|(latin)) american indian', .) |
          grepl('mexican indian', .) |
          grepl('aztec|inca|maya|mixtec|taino|tarasc|yaqui', .)
      ) | (
        # OR
        # detailed race specifies American Indian and born in Caribbean or Latin American
        grepl('american indian', rac2p_str) & pobp %in% c(72:78, 300:374)
      )
    ),
    ### - American Indian
    # Not born elsewhere in India AND not Latin or Alaska Native AND
    AIANInd = (racaian) & !grepl('^india$', pobp_str) & !(AIANLat | AIANAlask) & (
      # Ancestry listed as American Indian
      # ((ANCESTR1 %in% 920 | ANCESTR2 %in% 920)) | 
      # NOTE: there's a rac3 item that gets flagged here but not in the old script...
      if_any(
        c(anc1p_str, anc2p_str, rac2p_str, rac3p_str, lanp_str),
        ~ grepl('([^((central)|(south)|(mexican)|(latin)|(\\/or))] |^)american indian', .) |
          grepl('native american', .) |
          grepl('apache|blackf|cherok|cheyen|creek|chickas|choct|comanch|crow|iroqu|kiowa', .) | 
          grepl('lumbee|navaj|osage|p(a)?iute|pima|pot(t)?[ao]w|seminol|chipp|siou(x)?', .) | 
          grepl('tling|tohono|pueblo|hopi|delaw|salish|yak[ai]ma|colvil|houma', .) | 
          grepl('menom[io]n|yuma|trib[ae]|atha[bp]|algon|flathead|hokan|mus[kc]og', .) | 
          grepl('oglal|penuti|zuni|caddoan|shosho|papago|tanoan', .)
      ) # |
        # or, specific lower 48 tribe listed 
        # Apache (302), Blackfoot (303), Cherokee (304), Cheyenne (305), Chickasaw (306),
        # Chippewa (307), Choctaw (308), Comanche (309), Creek (310), Crow (311), Iroquois (312),
        # Kiowa (313), Lumbee (314), Navajo (315), Osage (316), Paiute (317), Pima (318),
        # Potawotomi (319), Pueblo (320), Seminole (321), Shoshone (322), Sioux (323),
        # Tlingit (324), Tohono O'Odham (325), Hopi (328), Delaware (350), 
        # Puget Sound Salish (352), Yakama (353), Colvile (355), Houma (356), Menominee (357),
        # Yuman (358), Other specified tribe (361), Two more tribes (362), AN and AI (398), not specified (363-4, 399)
        # RACED %in% c(302:325, 328, 350, 352:353, 355:358, 361:363, 398:399) |
        # or, language is American Indian (all) (70), Algonquian (72), Salish/Flathead (73), 
        # Athapascan (74), Navajo (75), Penutian-Sahaptin (76), Other Penutian (77), Zuni (78), Yuman (79), 
        # Other Hokan (80), Siouan langs. (81), Muskogean (82), Keres (83), Caddoan (85), Shoshonean/Hopi (86), 
        # Pima/Papago (87), Tanoan (90), American Indian n.s. (93)
        # LANGUAGE %in% c(70, 72:83, 85:87, 90, 93) |
        # or, multiple races listed, including American Indian (AIAN) or tribe and not born in Latin America or India
        # (RACED > 800 & (grepl('AIAN', raced.char) | grepl('[Aa]merican\\s[Ii]ndian', raced.char)) & !(BPL %in% c(110:300, 521)))
        # ((grepl('specified', rac2p_str) | grepl('american indian', rac3p_str)) & !(pobp %in% c(210, 300:399)))
    ),
    
    ##### == BLACK GROUPS == #####
    ### - African American
    # Identifies as Black AND
    AfrAm = racblk & (
      # has "Afro-American" or "African American" ancestry, 
      # or is born in the 50 states + Guam + Samoa + N. Mariana Islands
      if_any(
        c(anc1p_str, anc2p_str), 
        ~ grepl('^(afr.+)?american$', .) | grepl('united states|black|afro$', .) | pobp < 70
      )
    ),
    ### - Afro-Caribbean
    # IDs as Black AND non-Spanish Caribbean.
    AfrCarib = racblk & (
      if_any(
        c(anc1p_str, anc2p_str, pobp_str),
        ~ grepl('baham|barb[au]d|dominica$', .) |
          grepl('beliz|bermud|cayman|trinidad|tobag|arub|kitts|croix|maart', .) |
          grepl('west indi[ae]|caic|anguil|virgin isl|grenad|lucia|guade|cayen|guyan', .) 
      )
    ),
    ### - Ethiopian
    # Ancestry, language, or birthplace is Ethiopian, Eritrean, Amharic/Ethiopian language
    AfrEthiopian = racblk & (
      if_any(
        c(anc1p_str, anc2p_str, pobp_str, lanp_str), 
        ~ grepl('ethio|eritr|amhar|tigrin|oromo', .)
      )
    ),
    ### - Haitian
    # IDs as Black and has Haitian ancestry or birthplace
    AfrHaitian = racblk & if_any(c(anc1p_str, anc2p_str, pobp_str, lanp_str), ~ grepl('haiti', .)),
    ### - Jamaican
    # IDs as Black and ancestry, language, or birthplace includes Jamaica
    AfrJamaican = racblk & if_any(c(anc1p_str, anc2p_str, pobp_str, lanp_str), ~ grepl('jamaic', .)),
    ### - Nigerian
    # IDs as Black and ancestry or birthplace includes Nigeria
    AfrNigerian = racblk & if_any(c(anc1p_str, anc2p_str, pobp_str), ~ grepl('nigeria', .)),
    ### - Somalian
    # IDs as Black and ancestry or birthplace includes Somali
    AfrSomali = racblk & if_any(c(anc1p_str, anc2p_str, pobp_str), ~ grepl('somali', .)),
    ### = Other
    # Identifies as Black but isn't classified elsewhere
    AfrOther = racblk & !(
      AfrAm | AfrCarib | AfrEthiopian | AfrHaitian | AfrJamaican | AfrNigerian | AfrSomali
    ),
    
    ##### == ASIAN GROUPS == #####
    ### - Afghan
    # (n.b., NOT requiring individuals to ID as Asian)
    # Ancestry is Afghan OR
    AsnAfghan = if_any(c(anc1p_str, anc2p_str), ~ grepl('afgh', .)) | (
      # Born in Afghanistan and speaks Persian language/dialect
      grepl('afgh', pobp_str) & grepl('persia|^dari$|pasht|farsi', lanp_str)
    ),
    ### - Asian Indian
    # Identifies as Asian (or identifies as "American Indian" but born in India)
    AsnInd = (racasn | rac1p %in% 8 | (racaian & pobp_str %in% 'india')) & (
      # Ancestry includes Asian Indian, Bengali, East Indies, Punjabi, Karnatakan, Assamese, Gujarati
      if_any(
        c(anc1p_str, anc2p_str),
        ~ grepl('asian india|bengal|east indi[ea]|punjab|karna|assam|gujar', .)
      ) | (
        # OR specifies "Asian indian" in race
        if_any(c(rac2p_str, rac3p_str), ~ grepl('asian indian($|( alone)|(; [a-z]+[^\\/][$ ]))', .)) 
      ) | (
        # OR  born in India and speaking Indian language
        (pobp_str %in% 'india') & (
          grepl('hindi|urdu|other indo|sanskr|bengal|p[ua]njab|marath|gujara|konkan|tamil', lanp_str) |
            grepl('bihari|rajasth|oriya|assam|kashmi|kannad|dravid|tel[ue]g|malaya|^indi', lanp_str)
        ) | 
          grepl('other asian alone', rac2p_str) | grepl('other asian($|; [^(\\and/or)]| [^(alone)])', rac3p_str)
      )
    ),
    ### = Cambodian
    # Identifies as Asian/other AND
    AsnCambod = (racasn | rac1p %in% 8) & (
      # ancestry, language, race includes Cambodian or Khmer
      if_any(c(anc1p_str, anc2p_str, rac2p_str, lanp_str), ~ grepl('khmer|cambod', .)) | (
        # Or, born in Cambodia, and have no other reported ancestry, race includes some other Asian
        grepl('cambod', pobp_str) & (
          grepl('other asian alone', rac2p_str) | grepl('other asian($|; [^(\\and/or)]| [^(alone)])', rac3p_str)      
        )
      )
    ),
    ### = Chinese
    # Asian and *not Taiwanese* and
    AsnChinese = (racasn | rac1p %in% 8) & !(rac2p_str %in% 'taiwanese alone') & (
      # Ancestry includes Chinese, Cantonese, Mandarin, Hong Kong (NOT Taiwan)
      if_any(
        c(anc1p_str, anc2p_str, rac2p_str), 
        ~ grepl('chin[ae]|canton|mandar|hong kong', .)
      ) | (
        # or detailed race includes Chinese but not uninformative and/or
        grepl('chinese', rac3p_str) & !grepl('and\\/or', rac3p_str)
      ) | (
        # OR birthplace is China or Hong Kong or speaks Chinese language 
        if_any(c(lanp_str, pobp_str), ~ grepl('chin[ae]|canton|mandar|hong kong', .)) & (
          grepl('other asian alone', rac2p_str) | grepl('other asian($|; [^(\\and/or)]| [^(alone)])', rac3p_str)      
        )
      )
    ),
    ### - Myanmar
    # Identifies as Asian AND
    AsnMyan = (racasn | rac1p %in% 8) & (
      # ancestry, race, or language includes Myanmar, Burma, Lisu, Lolo, Kachin
      if_any(
        c(anc1p_str, anc2p_str, rac2p_str, rac3p_str, lanp_str),
        ~ grepl('myanm|burm[ae]|lisu|lolo|kachin|karen|chin[^ae]', .)
      ) | (
        # Or, born in Myanmar and have no other reported ancestry
        # (this is a good example of a case where birthplace alone is not sufficient!)
        # NOTE: "other asian" could include specific non-laotian groups e.g. Bhutan (see also AsnLao below)
        grepl('myanm', pobp_str) & (
          grepl('other asian alone', rac2p_str) | grepl('other asian($|; [^(\\and/or)]| [^(alone)])', rac3p_str)      
        )
      )
    ),
    ### - Filipino
    # Asian and
    AsnFilipino = (racasn | rac1p %in% 8) & (
      # with ancestry or race including Filipino
      if_any(
        c(anc1p_str, anc2p_str, rac2p_str, rac3p_str), 
        # (below string is to exclude some rac3p clunkers; rac3p (85, 87, 96)
        ~ grepl('filipino($|( alone)|;( \\w+[^\\/]($|\\w+ )))', .)
      ) | (
        # Or, born in Philippines or speaks Filipino language (incl. tagalog,
        # ilocano, cebuano) 
        # AND is non-specific Asian in detailed race
        if_any(c(lanp_str, pobp_str), ~ grepl('((ph)|f)ilip|tagal|ilocan|[cs]ebua', .)) & (
          grepl('other asian alone', rac2p_str) | 
            grepl('some other race', rac3p_str) |
            grepl('other asian($|; [^(\\and/or)]| [^(alone)])', rac3p_str)
        )
      )
    ),
    ### - Hmong
    # Asian and
    AsnHmong = (racasn | rac1p %in% 8) & (
      # Hmong ancestry (768) or Mien (656) or Hmong (661) as detailed race or 
      # language is Miao/Hmong (4420) or Iu Mien (4430)
      if_any(
        c(anc1p_str, anc2p_str, lanp_str, rac2p_str, rac3p_str), 
        ~ grepl('hmong|mien|miao', .)
      )
    ),
    ### - Indonesian
    # IDs as Asian or other and
    AsnIndones = (racasn | rac1p %in% 8) & (
      # ancestry or race includes Indonesian
      if_any(c(anc1p_str, anc2p_str, rac2p_str, rac3p_str), ~ grepl('indones', .)) | (
        # OR, born in Indonesia and have no other reported ancestry
        if_any(c(lanp_str, pobp_str), ~ grepl('indones', .)) & (
          grepl('other asian alone', rac2p_str) | 
            grepl('some other race', rac3p_str) |
            grepl('other asian($|; [^(\\and/or)]| [^(alone)])', rac3p_str)      
        )
      )
    ),
    ### - Japanese
    # IDs as Asian or other race alone and
    AsnJapanese = (racasn | rac1p %in% 8) & (
      # Ancestry includes Japanese or Okinawan
      if_any(c(anc1p_str, anc2p_str, rac2p_str), ~ grepl('japan|okinaw', .)) | (
        # Special flag for Japanese (handling the abnoxious and/or cases)
        grepl('japanese', rac3p_str) & !grepl('and\\/or', rac3p_str) 
      ) | (
        # OR born in Japan or speaks Japanese and no specific Asian race
        if_any(c(lanp_str, pobp_str), ~ grepl('japan', .)) & (
          grepl('other asian alone', rac2p_str) | grepl('other asian($|; [^(\\and/or)]| [^(alone)])', rac3p_str)      
        )
      )
    ),
    ### - Korean
    # IDs as Asian or other race alone and
    AsnKorean = (racasn | rac1p %in% 8) & (
      # Ancestry or race includes Korea
      if_any(
        c(anc1p_str, anc2p_str, rac2p_str, rac3p_str), 
        # doing this because there's something funny going on with one of the rac3p codes
        # ~ grepl('(^|(^| )[^j]\\w+; )korean($| alone|; \\w+\\;($| ))', .)
        ~ grepl('([^(\\/or)] |^)korean?[^\\/]*$', .)
      ) | (
        # Or, born in Korea or speaks Korean AND
        # race2 is "other asian alone"
        # (race3 'other asian alone' includes a bunch of other Asian groups, e.g., Malaysian, Bhutanese...)
        if_any(c(lanp_str, pobp_str), ~ grepl('korea', .)) & (
          grepl('other asian alone', rac2p_str) | grepl('other asian($|; [^(\\and/or)]| [^(alone)])', rac3p_str)      
        )
      )
    ),
    ### - Laotian
    # Asian or other race alone and
    AsnLao = (racasn | rac1p %in% 8) & (
      # Ancestry or race include Lao
      if_any(c(anc1p_str, anc2p_str, rac2p_str, rac3p_str), ~ grepl('lao', .)) | (
        # OR speaks Laotian and race includes "other Asian" or "write in"
        # NOTE: "other asian" could include specific non-laotian groups e.g. Thailand...
        if_any(c(lanp_str, pobp_str), ~ grepl('lao', .)) & (
          grepl('other asian alone', rac2p_str) | grepl('other asian($|; [^(\\and/or)]| [^(alone)])', rac3p_str)      
        )
      )
    ),
    ### - Pakistani
    # Asian or other race alone and
    AsnPakistani = (racasn | rac1p %in% 8) & (
      # and ancestry or race includes Pakistani
      if_any(c(anc1p_str, anc2p_str, rac2p_str, rac3p_str), ~ grepl('pakis', .)) | (
        # or born in Pakistan (52410) and speaks Urdu (3103)
        # NOTE: expand this to include Punjabi ancestry
        grepl('pakis', pobp_str) & (
          if_any(c(anc1p_str, anc2p_str, lanp_str), ~ grepl('urdu|punjab|pasht', .))
        )
      )
    ),
    ### - South Asian
    # Identifies as Asian and not born in India and:
    AsnSouth = (racasn | rac1p %in% 8) & !(pobp_str %in% 'india') & (
      # has ancestry matching south asian nationalities/ethnic groups
      if_any(
        c(anc1p_str, anc2p_str, rac2p_str, rac3p_str, lanp_str),
        ~ grepl('nepal|maldiv|bhutan|lanka|bangla|tamil|sing?ha|^shan|sindh|benga', .)
      ) | (
        # born in Bangladesh, Bhutan, Sri Lanka, Maldives, Nepal
        # or, detailed race specifies Asian Indian or Other Asian 
        grepl('bangla|bhutan|lanka|maldiv|nepal', pobp_str) & 
          if_any(c(rac2p_str, rac3p_str), ~ grepl('asian indian|([^(\\/or)] |^)other asian', .)) 
      )
    ),
    ### - Taiwanese
    # Identifies as Asian, and
    AsnTaiwanese = (racasn | rac1p %in% 8) & (
      # Ancestry or race includes Taiwan, *or*
      if_any(c(anc1p_str, anc2p_str, rac2p_str, rac3p_str), ~ grepl('^taiwan', .)) | (
        # or, was born in Taiwan and speaks Chinese or English
        pobp_str %in% 'taiwan' & (
          grepl('other asian alone', rac2p_str) | grepl('other asian($|; [^(\\and/or)]| [^(alone)])', rac3p_str)      
        )      
      )
    ),
    ### - Thai
    # Identifies as Asian and
    AsnThai = (racasn | rac1p %in% 8) & (
      # Ancestry, race, language, or birthplace includes Thai/Thailand
      if_any(c(anc1p_str, anc2p_str, pobp_str, lanp_str, rac2p_str, rac3p_str), ~ grepl('thai', .))
    ),
    ### - Vietnamese
    # Asian and
    AsnViet = (racasn | rac1p %in% 8) & (
      # ancestry or race includes vietnamese (excluding the and/or vietnamese rac3)
      if_any(c(anc1p_str, anc2p_str, rac2p_str, rac3p_str), ~ grepl('(^|[^(\\/or)] )vietna', .)) | (
        # or detailed race includes "other asian" and birthplace or language is vietnam(ese)
        # NOTE: same issue with 'other asian alone' noted above
        if_any(c(lanp_str, pobp_str), ~ grepl('vietna', .)) & (
          grepl('other asian alone', rac2p_str) | grepl('other asian($|; [^(\\and/or)]| [^(alone)])', rac3p_str)      
        )
      )
    ),
    ### - Other Asian
    # Asian or
    AsnOther = (racasn | (
      # race is "some other race alone" AND
      rac1p %in% 8 & (
        # born in Asia, including Central Asia, not including Middle East (Iran and east)
        grepl('afghan|bangl|bhut|myan|camb|china|hong|india$|indon|jap|kor|laos', pobp_str) |
          grepl('malay|mongol|nepal|philippi|singa|sri|taiw|thai|vietn|asia|stan$', pobp_str)
        # Language includes India NEC (1340), Hindi (1350), Urdu (1360), Bengali (1380), Punjabi (1420), 
        # Marathi (1440), Gujarathi (1450), Nepalese (1500), Sinhalese (1530), Other Indo-European (1564), 
        # Telegu (1730), Kannada (1737), Malayalam (1750), Tamil (1765), Khmer (1900), Vietnamese (1960),
        # Chinese (1970), Mandarin (2000), Min Nan Chinese (2030), Cantonese (2050), Tibetan (2100), 
        # Iu Mien (2525), Hmong (2535), Japanese (2560), Korean (2575), Malay (2715), Indonesian (2770),
        # Other languages of Asia (2850), Filipino (2910), Tagalog (2920), Cebuano (2950), Ilocano (3150),
        # Other Philippine Languages (3190)
        # NOTE: may want to add some others in here (e.g., Farsi)
        ) & lanp %in% c(1340:1420, 1440:1530, 1564, 1730:3190)
      )
    ) & !(
      # and not in any other category
      AsnAfghan | AsnInd | AsnCambod | AsnChinese | AsnMyan | AsnFilipino | AsnHmong | AsnIndones | 
        AsnJapanese | AsnKorean | AsnLao | AsnPakistani | AsnSouth | AsnThai | AsnViet | AsnTaiwanese
    ),
    
    ##### == PAC ISLANDER GROUPS == #####
    ### - Chamorro
    # Identifies as Pacific Islander or other race alone, and
    NHPICham = (racpi | racnh | rac1p %in% 8) & (
      # Ancestry, language, race, or birthplace includes Guam, Chamorro, N. Mariana Islands
      if_any(
        c(anc1p_str, anc2p_str, lanp_str, rac2p_str, rac3p_str, pobp_str), 
        ~ grepl('chamo|guam|mariana', .)
      ) 
    ),
    ### - COFA (Confederated States of Micronesia)
    # IDs as Pacific Islander (or native hawaiian?), and
    NHPICOFA = (racpi | racnh | rac1p %in% 8) & (
      # Race, ancestry, language, birthplace includes Micronesian states and islands
      if_any(
        c(anc1p_str, anc2p_str, lanp_str, rac2p_str, rac3p_str, pobp_str), 
        ~ grepl('micrones|palau|kosra|ponape|chuuk|yap|truk', .)
      )
    ),
    ### - Fijian
    # IDs as Pacific Islander, and
    NHPIFijian = (racpi | racnh | rac1p %in% 8) & (
      # Ancestry includes Fijian (841) or detailed race includes Fijian
      if_any(c(anc1p_str, anc2p_str, rac2p_str, rac3p_str), ~ grepl('fiji', .)) | (
        # or, detailed race specifies other PI and born in Fiji
        # NOTE: (needs to incldue rac2p *and* rac3p)
        grepl('fiji', pobp_str) & (
          grepl('[^(\\/or)]( native hawaiian sand )?other pacific', rac3p_str) |
            grepl('^other pacific', rac3p_str)
        )
      )
    ),
    ### - Native Hawai'ian
    # NOTE: update to only use racnh (current code is just to match)
    NHPIHawaii = (racnh | racpi | rac1p %in% 8) & (
      # Language or ancestry includes Hawaiian
      if_any(c(anc1p_str, anc2p_str, lanp_str), ~ grepl('hawai', .)) |
        # or race includes native hawaiian (but not the uninformative "and/or" NH) 
        if_any(c(rac2p_str, rac3p_str), ~ grepl('([^(\\/or)] |^)native hawaiian', .))
    ),
    ### - Marshallese
    # IDs as Pacific Islander and
    NHPIMarshall = (racpi | racnh | rac1p %in% 8) & (
      # Ancestry, race, birthplace, or language includes Marshallese
      if_any(c(anc1p_str, anc2p_str, lanp_str, rac2p_str, rac3p_str, pobp_str), ~ grepl('marshall', .))
    ),
    ### - Samoan
    # NOTE: estimate currently under-estimating
    # IDs as Pacific Islander AND 
    NHPISamoan = (racpi | racnh | rac1p %in% 8) & (
      # Ancestry, race, birthplace, or language includes Samoa
      if_any(c(anc1p_str, anc2p_str, lanp_str, rac2p_str, rac3p_str, pobp_str), ~ grepl('samoa', .))
    ),
    ### - Tongan
    # IDs as Pacific Islander AND
    NHPITongan = (racpi | racnh | rac1p %in% 8) & (
      # Ancestry, race, birthplace, or language includes Tonga
      if_any(c(anc1p_str, anc2p_str, lanp_str, rac2p_str, rac3p_str, pobp_str), ~ grepl('tonga', .))
    ),
    ### - Other Pacific Islander
    # Pacific Islander or other race alone and language in Chamorro (3220),
    # Marshallese (3270), Chuukese (3350), Samoan (3420), Tongan (3500), Hawaiian
    # (3570) or other eastern malayo-polynesian languages (3600)
    # birthplace in Fiji (508), Marshall Islands (511), Micronesia (512), Tonga (523), or Samoa (527)
    # OR detailed race includes "pacific islander"
    # AND not matching any other PI groups
    # NOTE: should include Australia/NZ in future version
    NHPIOther = (
      racpi | racnh |
        (rac1p %in% 8 & (lanp %in% 3220:3600 | pobp %in% setdiff(c(60, 500:528), c(501, 515)))) |
        (grepl('pacific island', rac3p_str) & !grepl('and\\/or', rac3p_str))
    ) &
      !(NHPICham | NHPIMarshall | NHPICOFA | NHPISamoan | NHPIHawaii | NHPITongan | NHPIFijian),
    
    ##### == MIDDLE EASTERN GROUPS == #####
    ### - Egyptian
    MENAEgypt = (
      # Ancestry is Egyptian 
      if_any(c(anc1p_str, anc2p_str), ~ grepl('egypt', .)) | 
        # OR born in Egypt and ancestry is Middle Eastern or Arab/other Arab
        # (not including language here to avoid catching African Arabic speakers)
        grepl('egypt', pobp_str) & if_any(c(anc1p_str, anc2p_str), ~ grepl('^arab|mideast', .))
    ),
    ### - Iraqi
    MENAIraq = (
      # Ancestry includes Iraqi 
      if_any(c(anc1p_str, anc2p_str), ~ grepl('iraq', .)) | (
        # OR born in Iraq AND 
        # ancestry is Middle Eastern/Arab or speaks Aramaic/Arabic
          grepl('iraq', pobp_str) & (
            grepl('(arab|arama)ic', lanp_str) | 
            if_any(c(anc1p_str, anc2p_str), ~ grepl('^arab|mideast', .)) 
          )
        )
    ),
    ### - Iranian
    # Has Iranian ancestry
    MENAIran = if_any(c(anc1p_str, anc2p_str), ~ grepl('iran', .)) | 
      # or was born in Iran and speaks Farsi or Dari
      (grepl('iran', pobp_str) & (
        grepl('^dari|farsi', lanp_str) | 
          if_any(c(anc1p_str, anc2p_str), ~ grepl('^arab|mideast', .))
      )
    ),
    ### - Israeli
    # Has Israeli ancestry
    MENAIsr = if_any(c(anc1p_str, anc2p_str), ~ grepl('israel', .)) | 
      # OR born in Israel/Palestine and speaks Hebrew or Yiddish
      (grepl('israel', pobp_str) & grepl('hebrew|yidd', lanp_str)),
    ### - Lebanese
    # Has Lebanese ancestry
    MENALeban = if_any(c(anc1p_str, anc2p_str), ~ grepl('leban', .)) | (
      # OR born in Lebanon AND 
      grepl('leban', pobp_str) & (
        # either speaks Arabic/Neo-Aramaic or has MidEast/Arab ancestry
        if_any(c(anc1p_str, anc2p_str), ~ grepl('^arab|mideast', .)) | 
          grepl('(arab|arama)ic', lanp_str)
      )
    ),
    ### - Palestinian
    # Has Palestinian ancestry
    MENAPalest = if_any(c(anc1p_str, anc2p_str), ~ grepl('palest', .)) | (
      # OR born in Palestine/Israel AND 
      (grepl('israel|palest', pobp_str)) & (
        # either speaks Arabic/Neo-Aramaic or has MidEast/Arab ancestry
        if_any(c(anc1p_str, anc2p_str), ~ grepl('^arab|mideast', .)) | 
          grepl('(arab|arama)ic', lanp_str)
      )
    ),
    ### - Syrian
    # Has Syrian ancestry (429)
    MENASyr = if_any(c(anc1p_str, anc2p_str), ~ grepl('^syria', .)) | (
      # or was born in Syria AND
      grepl('syria', pobp_str) & (
        # has MidEast/Arab, Assyrian, or Kurdish ancestry or speaks Arabic/Neo-Aramaic
        if_any(c(anc1p_str, anc2p_str), ~ grepl('^arab|mideast', .)) |
          grepl('(arab|arama)ic', lanp_str)
      )
    ),
    ### - Turkish
    # Has Turkish ancestry or speaks Turkish
    # (Turkish language flag may be too generous alone, but it gets us to the ACS counts)
    MENATurkish = if_any(c(anc1p_str, anc2p_str, lanp_str), ~ grepl('turkis', .)) | (
      pobp_str %in% 'turkey' & if_any(c(anc1p_str, anc2p_str), ~ grepl('^mideast', .))
    ),
    ### - MENA Other
    # NOTE: in next version, should also exclude all other MENA groups
    MENAOther = (
      if_any(
        c(anc1p_str, anc2p_str),
        ~ grepl('alger|liby|moroc|tunis|north afr|kuwai|saudi|yemen|kurd', .) | 
          grepl('^oman|qatar|jordan|emirat|assyr|chald|mideast|arab(ic)?$', .)
      ) | (
        # OR
        # or, speaks Arabic/Neo-Aramaic (57-58) or Farsi/Dari (29-30) AND
        (
          grepl('arabic|aramaic|farsi|^dari|kurd', lanp_str)
        ) & (
          # was born in Algeria (60011), Libya (60013), Morocco (60014),
          # Tunisia (60016), Western Sahara (60019), Bahrain (530), Cypress (531),
          # Jordan (535), Kuwait (536), Oman (538), Qatar (539), Saudi Arabia (540),
          # UAE (543), Yemen (544-545), Persian Gulf States n.s. (546), Middle East n.s. (547),
          # Southwest Asia n.s.. (548), Asia Minor n.s. (549), South Asia nec (550)
          grepl('alger|liby|moroc|tunis|bahra|cypr|jordan|kuwai|^oman', pobp_str) | 
            grepl('qata|saudi|emira|yemen', pobp_str)
        )
      )
    ),
    
    ##### == WHITE GROUPS == #####
    ### - English
    # White AND
    WhtEng = (racwht | (anc1p < 210 & (anc2p < 210 | anc2p %in% 999) & rac1p %in% 8)) & (
      # has English ancestry OR 
      if_any(c(anc1p_str, anc2p_str), ~ grepl('^engl', .)) | (
        # Ancestry includes British Isles without specifying welsh, scotish/scots irish
        if_any(c(anc1p_str, anc2p_str), ~ grepl('^brit', .)) &
          !if_any(c(anc1p_str, anc2p_str), ~ grepl('^scot|wels', .))
      ) | (
        # OR speaks English, born in England, and ancestry is non-descript n/w Euro, Euro, or not given
        grepl('engl', pobp_str) & lanp %in% 'N' & (
          grepl('(^[nw].+|^)euro', anc1p_str) | anc1p %in% c(924, 996, 998:999)
        )
      )
    ),
    ### - German
    # White AND
    WhtGer = (racwht | (anc1p < 210 & (anc2p < 210 | anc2p %in% 999) & rac1p %in% 8)) & (
      # ancestry includes German (not German Russian) or Prussian, OR
      if_any(c(anc1p_str, anc2p_str), ~ grepl('^german(ic)?$|pruss', .)) | (
        # was born in Germany and speaks German
        if_all(c(pobp_str, lanp_str), ~ grepl('^german', .)) & (
          grepl('^(n.+)?euro', anc1p_str) | anc1p %in% c(924, 996, 998:999)
        )
      )
    ),
    ### - Irish
    # White and 
    WhtIre = (racwht | (anc1p < 210 & (anc2p < 210 | anc2p %in% 999) & rac1p %in% 8)) & (
      # ancestry includes Irish or Celtic (not Scots-Irish)
      if_any(c(anc1p_str, anc2p_str), ~ grepl('^iri|^celt', .)) | (
        # OR or born in Ireland, speaks English or Irish, and no ancestry or non-descript European
        grepl('^ire', pobp_str) & (lanp %in% 'N' | grepl('^iri', lanp_str)) & (
          grepl('^([nw].+)?euro', anc1p_str) | anc1p %in% c(924, 996, 998:999)
        )
      )
    ),
    ### - Italian
    # White, and
    WhtItal = (racwht | (anc1p < 210 & (anc2p < 210 | anc2p %in% 999) & rac1p %in% 8)) & (
      # ancestry includes Italian or Sicilian
      if_any(c(anc1p_str, anc2p_str), ~ grepl('ital|sicil', .)) | (
        # OR born In Italy and having only Southern European or no ancestry
        if_all(c(lanp_str, pobp_str), ~ grepl('ital', .)) & (
          grepl('^(s.+)?euro', anc1p_str) | (anc1p %in% c(924, 996, 998:999))
        )
      )
    ),
    ### - Polish
    # White, and 
    WhtPol = (racwht | (anc1p < 210 & (anc2p < 210 | anc2p %in% 999) & rac1p %in% 8)) & (
      # ancestry includes Polish, OR
      if_any(c(anc1p_str, anc2p_str), ~ grepl('polish', .)) | (
        # born in Poland or speaking Polish and ancestry is nec (East) European or NA (996, 999)
        if_all(c(lanp_str, pobp_str), ~ grepl('pol(ish|and)', .)) & 
          (grepl('^(e.+)?euro', anc1p_str) | (anc1p %in% c(924, 996, 998:999)))
      )
    ),
    ### - Romanian
    # White, and 
    WhtRom = (racwht | (anc1p < 210 & (anc2p < 210 | anc2p %in% 999) & rac1p %in% 8)) & (
      # ancestry includes Rom or Romanian OR
      if_any(c(anc1p_str, anc2p_str), ~ grepl('^rom', .)) | (
        # or born in Romania or speaks Rumanian and Eastern/nondescript European or no ancestry (999)
        if_all(c(lanp_str, pobp_str), ~ grepl('^r[ou]m', .)) & 
          (grepl('^(e.+)?euro', anc1p_str) | (anc1p %in% c(924, 996, 998:999)))
      )
    ),
    ### - Russian
    # White, and
    WhtRus = (racwht | (anc1p < 210 & (anc2p < 210 | anc2p %in% 999) & rac1p %in% 8)) & (
      # includes Russian ancestry, OR
      if_any(c(anc1p_str, anc2p_str), ~ grepl('^russ', .)) | (
        # speaks Russian and
        grepl('^russ', lanp_str) & (
          # has Cossack ancestry (in our recoding it's turkestani only? no cossack)
          if_any(c(anc1p_str, anc2p_str), ~ grepl('^turk.+stan', .)) | (
            # or born in Russia or former USSR and nondescript (E) Euro or no ancestry reported (996-9)
            (
              grepl('rus|ussr|georgia$|^azerb|moldov|^armen|kazakh|kyrg|turkmen|uzbek|ukrai', pobp_str) 
            ) & ((grepl('^(e.+)?euro', anc1p_str) | (anc1p %in% c(924, 996, 998:999))))
            # NOTE: in update, aove line should probably include anc2 for e/european
          )
        )
      )
    ),
    ### - Scottish
    # White, and
    WhtSco = (racwht | (anc1p < 210 & (anc2p < 210 | anc2p %in% 999) & rac1p %in% 8)) & (
      # Ancestry includes Scottish and Scots-Irish, 
      # or born in Scotland and having Euro nec or un-reported ancestry and speaking English
      if_any(c(anc1p_str, anc2p_str), ~ grepl('^scot', .)) | (
        grepl('^scot', pobp_str) & lanp %in% 'N' & (
          (grepl('^([nw].+)?euro', anc1p_str) | (anc1p %in% c(924, 996, 998:999)))
        )
      )
    ),
    ### - Ukrainian
    # White, and
    WhtUkr = (racwht | (anc1p < 210 & (anc2p < 210 | anc2p %in% 999) & rac1p %in% 8)) & (
      # includes Ukrainian ancestry OR
      if_any(c(anc1p_str, anc2p_str), ~ grepl('^ukra', .)) | 
        # speaks Ukrainian and
        grepl('^ukra', lanp_str) & grepl('^ukra|ussr', pobp_str) & ( 
          (grepl('^(e.+)?euro', anc1p_str) | (anc1p %in% c(924, 996, 998:999)))
        )
    ),
    ### - Slavic
    # White, and
    WhtSlav = (racwht | (anc1p < 210 & (anc2p < 210 | anc2p %in% 999) & rac1p %in% 8)) & (
      if_any(
        # Ancestry includes Bulgarian, Belorussian, Czech, Croatian, Bohemian,
        # Serbian, Macedonian, Montenegran, Bosnian, Slovakian, Slovenian, Yugoslavian,
        # Slav
        c(anc1p_str, anc2p_str),
        ~ grepl('bulga|bel[ao]r|czech|croat|^bohe|serb|maced|monten|bosni|slov[ae]|yugos|slav', .)
      ) | grepl('czech|slov[ea]|croat|serb|bosn', lanp_str) | (
        # or, born in Bulgaria, Czechoslovakia, Yugoslavia (+bosnia, serbia, montenegro, croatia) 
        # and un-listed/non-descript ancestry
        grepl('bulga|czech|sl[oa]v|bosn|serb|monten|croat|kosov', pobp_str) &
          ((grepl('^([es].+)?euro', anc1p_str) | (anc1p %in% c(924, 996, 998:999))))
      )
    ),
    ### - White, other
    # IDs as white or has *both* ancestries from Europe, non-Hispanic, other
    WhtOther = (racwht | (anc1p < 210 & (anc2p < 210 | anc2p %in% 999) & rac1p %in% 8 & !hisplog)) & !(
      WhtEng | WhtGer | WhtIre | WhtItal | WhtPol | WhtRom | WhtRus | WhtSco | WhtUkr | WhtSlav
    ),
    
    ##### == OTHER == #####
    OtherUnspec = !if_any(
      starts_with(c('MENA', 'Wht', 'Asn', 'Afr', 'Lat', 'AIAN', 'NHPI')), 
      ~ .
    ) & (rac1p %in% 8)
  )

# merge external results to add J fields to pums_out
pums_jet<-read.dta13(paste0('jet/jet_5acs',year %% 100,'_i.dta'),select.cols=c("state","serialno","sporder","ethgrpi"))
stopifnot(length(pums_out$state)==length(pums_jet$state)) # assert same length
pums_out<-merge(pums_out,pums_jet) # add ethgrpi, which is a labeled factor variable.
pums_out$JAsh <- as.integer(pums_out$ethgrpi) %in% 1
pums_out$JSep <- as.integer(pums_out$ethgrpi) %in% 2
pums_out$JOth <- as.integer(pums_out$ethgrpi) %in% 3

# intermediate totals AOIC
pums_out |>
  select(pwgtp, starts_with(c('J', 'MENA', 'Wht', 'Asn', 'Afr', 'Lat', 'AIAN', 'NHPI'))) |> 
  mutate(across(-pwgtp, ~ . * pwgtp)) |> 
  apply(2, sum)

# Initialize a data frame for storing the primary (rarest) race assignment
pums_rarest = pums_out |> 
  # add a 'primary' column to store the primary
  mutate(primary = 'unassigned')

# estimate frequency of top-level groups
re_grp_totals = pums_rarest |>
  mutate(
    j    = if_any(starts_with('J'),    ~ .),
    nhpi = if_any(starts_with('NHPI'), ~ .),
    asn  = if_any(starts_with('Asn') , ~ .),
    aian = if_any(starts_with('AIAN'), ~ .),
    wht  = if_any(starts_with('Wht') , ~ .),
    afr  = if_any(starts_with('Afr') , ~ .),
    lat  = if_any(starts_with('Lat'),  ~ .),
    mena = if_any(starts_with('MENA'), ~ .)
  ) |>
  select(pwgtp, j, nhpi, asn, aian, wht, afr, lat, mena) |>
  # Get sums (number of people) identifying as each group
  mutate(across(where(is.logical), ~ pwgtp * .)) |>
  # Remove person weight colum (population total) because it isn't needed
  select(-pwgtp) |>
  apply(2, sum) |>
  # sort from rarest to most common
  sort()

re_grp_totals

# Iterate over the RE groups to find the first (rarest) match
# (already sorted, so iterating from smallest to largest)
for (i in 1:length(re_grp_totals)) {
  
  # Get the name of current race group
  this_re_grp = names(re_grp_totals)[i]
  
  # Get the totals within this race group
  grp_re_totals = pums_rarest %>%
    # filter out individuals without a primary race assigned
    filter(primary %in% 'unassigned') %>%
    # Estimate the number of people counting within each race
    # (usually I hate the ignore.case arg but here it's helpful!)
    select(pwgtp, starts_with(this_re_grp, ignore.case = TRUE)) %>%
    # select(-c(matches('[Oo]th'))) %>%
    mutate(across(where(is.logical), ~ pwgtp * as.numeric(.))) %>%
    apply(2, sum)
  
  # Now, assign rarest within this group
  # (the grp_re_totals vector will have one column, 'pwgtp', when all have been assigned)
  while (length(grp_re_totals) > 1) {
    
    (cur_rarest = names(which.min(grp_re_totals[!names(grp_re_totals) %in% 'pwgtp'])))
    print(grp_re_totals[cur_rarest])
    
    pums_rarest$primary = ifelse(
      pums_rarest[,cur_rarest] & pums_rarest$primary %in% 'unassigned',
      cur_rarest,
      pums_rarest$primary
    )
    pums_rarest[, cur_rarest] = NULL
    
    grp_re_totals = pums_rarest %>%
      # filter out individuals without a primary race assigned
      filter(primary %in% 'unassigned') %>%
      # Estimate the number of people counting within each race
      select(pwgtp, starts_with(this_re_grp, ignore.case = TRUE)) %>%
      # select(-c(matches('[Oo]th'))) %>%
      mutate(across(where(is.logical), ~ pwgtp * as.numeric(.))) %>%
      apply(2, sum)
    
    print(grp_re_totals)
    
  }

}

# Set seed for random assignment of LatAfr below
set.seed(2211556)

### Final steps:
pums_rarest = pums_rarest |>
  ### Change "unassigned" primary label to "OtherUnassigned"
  mutate(primary = ifelse(primary %in% 'unassigned', 'OtherUnspec', primary)) |>
  ### Manually reset the primary of 8% of people IDing as LatAfr to LatAfr
  # (for structural reasons related to the assignment procedure for rarest race,
  # LatAfr will be assigned zero individuals and these individuals are assigned
  # instead to an African group; the 8% figure is based on OHA internal
  # repository data from May 2026)
  # (this involves merging back in the LatAfr column from pums_rarest, which is
  # removed in the assignment procedure above - this step is not very elegant,
  # but suffices for now!)
  merge(pums_out |> select(serialno, sporder, LatAfr)) |>
  mutate(primary = ifelse(LatAfr & runif(nrow(pums_rarest)) < 0.08, 'LatAfr', primary)) |>
  select(-LatAfr) |>
  # Change state to integer
  mutate(state = as.integer(state))


# Export only the identifying info and the primary REALD for subquent usage
#write.csv(
#  pums_rarest %>% select(state, serialno, sporder, realdpri = primary), row.names = FALSE,
#  paste0('prc_reldpri24_5acs', year %% 100, '.csv')
#)
save.dta13(pums_rarest |> select(state,serialno,sporder,realdpri=primary),
   paste0('prc_reldpri24_5acs', year %% 100, '.dta'))
