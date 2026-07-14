library(tidyverse)
library(haven)
library(dplyr)

setwd("C:/Users/lgriv/Downloads/HRS/Data")

# Importing Longitudinal File 
#randhrs1992_2022 = read_sas("randhrs1992_2022v1_SAS/randhrs1992_2022v1.sas7bdat", NULL)
randhrs1992_2022 = read_sas("randhrs1992_2022v1.sas7bdat")


# 1) high blood pressure or hypertension; 2) diabetes or high blood sugar; 3) cancer or a malignant tumor of any kind
# except skin cancer; 4) chronic lung disease except asthma such as chronic bronchitis or emphysema; 5) heart attack, coronary heart
# disease, angina, congestive heart failure, or other heart problems; 6) stroke or transient ischemic attack (TIA); 7) emotional, nervous, or
# psychiatric problems; and 8) arthritis or rheumatism

# Variable List of interest (identifies, weights, demographics, outcomes), waves 9 - 16, 2008 - 2022
longitudinal_variables = c('HHIDPN',
                           'RAVETRN', 
                           
                           # Interview Status and Weights
                           'R9AGEY_B', 'R10AGEY_B', 'R11AGEY_B', 'R12AGEY_B', 'R13AGEY_B', 'R14AGEY_B', 'R15AGEY_B', 'R16AGEY_B',
                           'INW9', 'INW10', 'INW11', 'INW12', 'INW13', 'INW14', 'INW15', 'INW16',
                           'R9IWSTAT', 'R10IWSTAT', 'R11IWSTAT', 'R12IWSTAT', 'R13IWSTAT', 'R14IWSTAT', 'R15IWSTAT', 'R16IWSTAT',
                           'RAWTSAMP',
                           'R9WTRESP', 'R10WTRESP', 'R11WTRESP', 'R12WTRESP', 'R13WTRESP', 'R14WTRESP', 'R15WTRESP', 'R16WTRESP',  # person-level weight
                           'R9WTHH', 'R10WTHH','R11WTHH', 'R12WTHH', 'R13WTHH', 'R14WTHH', 'R15WTHH', 'R16WTHH',    # household-level weight
                           # Demographics
                           'RACOHBYR', 'RABYEAR', 'RADYEAR', 'RAGENDER', 'RARACEM', 
                           'RAHISPAN', 'RAEDYRS', 'RAEDEGRM', 'RAMEDUC', 'RAFEDUC', 
                           
                           # Outcomes
                           'R9SHLT', 'R10SHLT', 'R11SHLT', 'R12SHLT', 'R13SHLT', 'R14SHLT', 'R15SHLT', 'R16SHLT',
                           'R9HOSP', 'R10HOSP', 'R11HOSP', 'R12HOSP', 'R13HOSP', 'R14HOSP', 'R15HOSP', 'R16HOSP',
                           'R9HSPNIT', 'R10HSPNIT', 'R11HSPNIT', 'R12HSPNIT', 'R13HSPNIT', 'R14HSPNIT', 'R15HSPNIT', 'R16HSPNIT',
                           'R9DOCTOR', 'R10DOCTOR', 'R11DOCTOR', 'R12DOCTOR', 'R13DOCTOR', 'R14DOCTOR', 'R15DOCTOR', 'R16DOCTOR',
                           'R9DOCTIM', 'R10DOCTIM', 'R11DOCTIM', 'R12DOCTIM', 'R13DOCTIM', 'R14DOCTIM', 'R15DOCTIM', 'R16DOCTIM',
                           'R9DEPRES', 'R10DEPRES', 'R11DEPRES', 'R12DEPRES', 'R13DEPRES', 'R14DEPRES', 'R15DEPRES', 'R16DEPRES',
                           'R9SLEEPR', 'R10SLEEPR', 'R11SLEEPR', 'R12SLEEPR', 'R13SLEEPR', 'R14SLEEPR', 'R15SLEEPR', 'R16SLEEPR',
                           'R9HIBP', 'R10HIBP', 'R11HIBP', 'R12HIBP', 'R13HIBP', 'R14HIBP', 'R15HIBP', 'R16HIBP',
                           'R9DIAB', 'R10DIAB', 'R11DIAB', 'R12DIAB', 'R13DIAB', 'R14DIAB', 'R15DIAB', 'R16DIAB',
                           'R9CANCR', 'R10CANCR', 'R11CANCR', 'R12CANCR', 'R13CANCR', 'R14CANCR', 'R15CANCR', 'R16CANCR',
                           'R9LUNG', 'R10LUNG', 'R11LUNG', 'R12LUNG', 'R13LUNG', 'R14LUNG', 'R15LUNG', 'R16LUNG', 
                           'R9HEART', 'R10HEART', 'R11HEART', 'R12HEART', 'R13HEART', 'R14HEART', 'R15HEART', 'R16HEART', 
                           'R9STROK', 'R10STROK', 'R11STROK', 'R12STROK', 'R13STROK', 'R14STROK', 'R15STROK', 'R16STROK',
                           'R9PSYCH', 'R10PSYCH', 'R11PSYCH', 'R12PSYCH', 'R13PSYCH', 'R14PSYCH', 'R15PSYCH', 'R16PSYCH',
                           'R9ARTHR', 'R10ARTHR', 'R11ARTHR', 'R12ARTHR', 'R13ARTHR', 'R14ARTHR', 'R15ARTHR', 'R16ARTHR',
                           'R9SLFMEM', 'R10SLFMEM', 'R11SLFMEM', 'R12SLFMEM', 'R13SLFMEM', 'R14SLFMEM', 'R15SLFMEM', #'R16SLFMEM', no slfmem in wv 16
                           'R9MEMRYE', # Memory issues, then gets split up to alzheimer/dementia
                           'R10ALZHE', 'R11ALZHE', 'R12ALZHE', 'R13ALZHE', 'R14ALZHE', 'R15ALZHE', 'R16ALZHE',  #Alzheimer
                           'R10DEMEN', 'R11DEMEN', 'R12DEMEN', 'R13DEMEN', 'R14DEMEN', 'R15DEMEN', 'R16DEMEN', # Dementia
                           'R9HLTHLM', 'R10HLTHLM', 'R11HLTHLM', 'R12HLTHLM', 'R13HLTHLM', 'R14HLTHLM', 'R15HLTHLM', 'R16HLTHLM',
                           'R9DRINK', 'R10DRINK', 'R11DRINK', 'R12DRINK', 'R13DRINK', 'R14DRINK', 'R15DRINK', 'R16DRINK',
                           
                           # Wealth and Income
                           'H9ATOTB', 'H10ATOTB', 'H11ATOTB', 'H12ATOTB', 'H13ATOTB', 'H14ATOTB', 'H15ATOTB', 'H16ATOTB',  # total of all assets
                           'H9ATOTH', 'H10ATOTH', 'H11ATOTH', 'H12ATOTH', 'H13ATOTH', 'H14ATOTH', 'H15ATOTH', 'H16ATOTH',  # net value primary residence *
                           'H9ARLES', 'H10ARLES', 'H11ARLES', 'H12ARLES', 'H13ARLES', 'H14ARLES', 'H15ARLES', 'H16ARLES',  # net value other residence *
                           'H9ATOTF', 'H10ATOTF', 'H11ATOTF', 'H12ATOTF', 'H13ATOTF', 'H14ATOTF', 'H15ATOTF', 'H16ATOTF',  # net value non-housing financial wealth
                           'R9IEARN', 'R10IEARN', 'R11IEARN', 'R12IEARN', 'R13IEARN', 'R14IEARN', 'R15IEARN', 'R16IEARN',  # individual earnings
                           'R9DSSAMT', 'R10DSSAMT', 'R11DSSAMT', 'R12DSSAMT', 'R13DSSAMT', 'R14DSSAMT', 'R15DSSAMT', 'R16DSSAMT',  # SSDI and SSI amount received
                           'H9ITOT', 'H10ITOT', 'H11ITOT', 'H12ITOT', 'H13ITOT', 'H14ITOT', 'H15ITOT', 'H16ITOT',  # Total HH income from last calendar yr
                           'RASSRECV', 'RASSAGEB',
                           'R9HIGOV', 'R10HIGOV', 'R11HIGOV', 'R12HIGOV', 'R13HIGOV', 'R14HIGOV', 'R15HIGOV', 'R16HIGOV',
                           'R9LIV75', 'R10LIV75', 'R11LIV75', 'R12LIV75', 'R13LIV75', 'R14LIV75', 'R15LIV75', 'R16LIV75',
                           'R9LIV10', 'R10LIV10', 'R11LIV10', 'R12LIV10', 'R13LIV10', 'R14LIV10', 'R15LIV10', 'R16LIV10',
                           
                           # Additional Health Variables (non-core conditions / impairments)
                           'R9BACK', 'R10BACK', 'R11BACK', 'R12BACK', 'R13BACK', 'R14BACK', 'R15BACK', 'R16BACK',                                 # back problems
                           'R9MOBILA', 'R10MOBILA', 'R11MOBILA', 'R12MOBILA', 'R13MOBILA', 'R14MOBILA', 'R15MOBILA', 'R16MOBILA',                 # mobility limitations (summary index)
                           'R9LGMUSA', 'R10LGMUSA', 'R11LGMUSA', 'R12LGMUSA', 'R13LGMUSA', 'R14LGMUSA', 'R15LGMUSA', 'R16LGMUSA',                 # large muscle limitations
                           'R9GROSSA', 'R10GROSSA', 'R11GROSSA', 'R12GROSSA', 'R13GROSSA', 'R14GROSSA', 'R15GROSSA', 'R16GROSSA',                 # gross motor limitations
                           'R9FINEA', 'R10FINEA', 'R11FINEA', 'R12FINEA', 'R13FINEA', 'R14FINEA', 'R15FINEA', 'R16FINEA',                         # fine motor limitations
                           'R9SLEEPFAL', 'R10SLEEPFAL', 'R11SLEEPFAL', 'R12SLEEPFAL', 'R13SLEEPFAL', 'R14SLEEPFAL', 'R15SLEEPFAL', 'R16SLEEPFAL', # trouble falling asleep
                           'R9BMI', 'R10BMI', 'R11BMI', 'R12BMI', 'R13BMI', 'R14BMI', 'R15BMI', 'R16BMI',                                         # body mass index

)

# Re-code gender variable, add age variable, save smaller longitudinal file for outcome cleaning
randhrs1992_2022 = randhrs1992_2022 |>
  select(all_of(longitudinal_variables)) |>
  mutate(
    GENDER = case_when(
      RAGENDER == 1 ~ 1,  # Male
      RAGENDER == 2 ~ 0   # Female
    ),
    # NOTE: This age calculation is only valid if interview year = 2010.
    # Replace later with wave-specific interview year if you need exact age.
    AGE_2010 = 2010 - RABYEAR
  ) #|>
  # Keep RAGENDER for now; safer to drop at the very end
  #filter(GENDER == 1)  # Sample restricted to males

setwd("C:/Users/lgriv/Downloads/HRS/Flores_Dataset_Material")
saveRDS(randhrs1992_2022, 'Longitudinal_RAW.rds')

# Free up memory after saving
rm(randhrs1992_2022)
gc()

# ----------------------  
# Future Runs
# ----------------------
  

setwd("C:/Users/lgriv/Downloads/HRS/Flores_Dataset_Material")
randhrs1992_2022 = readRDS('Longitudinal_RAW.rds')

setwd("C:/Users/lgriv/Downloads/HRS/Data")

# Importing FAT Files
# Reasoning for use: Pulling Year Military Begin, Year Military End, and Military Related Disability

randhrs2002 = read_sas("h02f2c.sas7bdat", NULL) |> 
  select(HHIDPN, HB036, HB037, HB038)

randhrs2004 = read_sas("h04f1c.sas7bdat", NULL) |> 
  select(HHIDPN, JB036, JB037, JB038)

randhrs2006 = read_sas("h06f4b.sas7bdat", NULL) |> 
  select(HHIDPN, KB036, KB037, KB038)

randhrs2008 = read_sas("h08f3b.sas7bdat", NULL) |> 
  select(HHIDPN, LB019, LB020, LB099:LB120, LB122:LB124, LB036, LB037, LB038, LB096, LB097)

randhrs2010 = read_sas("hd10f6b.sas7bdat", NULL) |> 
  select(HHIDPN, MB019, MB020, MB099:MB120, MB122:MB124, MB036, MB037, MB038, MB096, MB097)

randhrs2012 = read_sas("h12f3a.sas7bdat", NULL) |> 
  select(HHIDPN, NB019, NB020, NB099:NB120, NB122:NB124, NB036, NB037, NB038, NB096, NB097)

randhrs2014 = read_sas("h14f2b.sas7bdat", NULL) |> 
  select(HHIDPN, OB019, OB020, OB099:OB120, OB122:OB124, OB036, OB037, OB038, OB096, OB097)

randhrs2016 = read_sas("h16f2c.sas7bdat", NULL) |> 
  select(HHIDPN, PB019, PB020, PB099:PB120, PB122:PB124, PB036, PB037, PB038, PB096, PB097)

randhrs2018 = read_sas("h18f2c.sas7bdat", NULL) |> 
  select(HHIDPN, QB019, QB020, QB099:QB120, QB122:QB124, QB036, QB037, QB038, QB096, QB097)

randhrs2020 = read_sas("h20f1b.sas7bdat", NULL) |> 
  select(HHIDPN, RB019, RB020, RB099:RB120, RB122:RB124, RB036, RB037, RB038, RB096, RB097)

randhrs2022 = read_sas("h22e3a.sas7bdat", NULL) |> 
  select(HHIDPN, SB020, SB036, SB037, SB038, SB096, SB097)

# Merge wave-specific FAT files (2002–2022) into the longitudinal dataset
# Left join each wave's FAT file by HHIDPN. Preserves full longitudinal sample
# while adding childhood and military service variables from each wave. Respondents not 
# interviewed in a given wave will simply have NAs for that wave's variables.

randhrs_merged = randhrs1992_2022 %>%
  left_join(randhrs2002, by = "HHIDPN") %>%
  left_join(randhrs2004, by = "HHIDPN") %>%
  left_join(randhrs2006, by = "HHIDPN") %>%
  left_join(randhrs2008, by = "HHIDPN") %>%
  left_join(randhrs2010, by = "HHIDPN") %>%
  left_join(randhrs2012, by = "HHIDPN") %>%
  left_join(randhrs2014, by = "HHIDPN") %>%
  left_join(randhrs2016, by = "HHIDPN") %>%
  left_join(randhrs2018, by = "HHIDPN") %>%
  left_join(randhrs2020, by = "HHIDPN") %>%
  left_join(randhrs2022, by = "HHIDPN")

#-------------------------
# CHECKING HOUSEHOLD ID CHANGES
# Create HHIDPN in tracker from HHID and PN (current/new ID)
#tracker = tracker |>
#  mutate(HHIDPN = as.numeric(paste0(HHID, PN)))

# Check what OVHHID and OVPN look like
#tracker |>
#  select(HHID, PN, OVHHID, OVPN) |>
#  filter(OVHHID != HHID) |>  # people whose household changed
#  head(20)

#tracker |>
#  filter(OVHHID != "000000") |>
#  nrow()

#tracker |>
#  filter(OVHHID != "000000") |>
#  select(HHID, PN, OVHHID, OVPN) |>
#  head(20)

# Only 116 people out of 45,234 had their household ID change; (0.26%) of the sample.
#-------------------------

# Helper function to clean HRS health condition variables across waves ----
clean_hrs_condition = function(df, var_stub, waves = 9:16) { # parameters are the dataframe, variable, wave
  for (i in seq_along(waves)) {
    wave     = waves[i]
    cur_var  = paste0("R", wave, var_stub) # Current wave variable (e.g., R9DIAB, R10DIAB, ...)
    prev_var = if (i == 1) NULL else paste0("R", waves[i - 1], var_stub) # Baseline wave has no prior observation, else look at previous wave
    
    df = df %>%
      mutate(
        !!cur_var := case_when(
          .data[[cur_var]] == 0          ~ 0,        # no
          .data[[cur_var]] == 1          ~ 1,        # yes
          .data[[cur_var]] == 3          ~ 1,        # carry-forward yes
          .data[[cur_var]] == 4          ~ 0,        # carry-forward no
          .data[[cur_var]] %in% c(5, 6) ~ (if (is.null(prev_var)) NA_real_ else .data[[prev_var]]),  # backfill from prior wave or NA at baseline
          TRUE                           ~ NA_real_
        )
      )
  }
  df
}

# Health Outcome Cleaning: High Blood Pressure (HIBP) ----
randhrs1992_2022 = clean_hrs_condition(randhrs1992_2022, "HIBP")

# Health Outcome Cleaning: Diabetes (DIAB) ----
randhrs1992_2022 = clean_hrs_condition(randhrs1992_2022, "DIAB")

# Health Outcome Cleaning: Cancer (CANCR) ----
randhrs1992_2022 = clean_hrs_condition(randhrs1992_2022, "CANCR")

# Health Outcome Cleaning: Lung Disease (LUNG) ----
randhrs1992_2022 = clean_hrs_condition(randhrs1992_2022, "LUNG")

# Health Outcome Cleaning: Heart Condition (HEART) ----
randhrs1992_2022 = clean_hrs_condition(randhrs1992_2022, "HEART")

# Health Outcome Cleaning: Stroke (STROK) ----
randhrs1992_2022 = clean_hrs_condition(randhrs1992_2022, "STROK")

# Health Outcome Cleaning: Psychological Problems (PSYCH) ----
randhrs1992_2022 = clean_hrs_condition(randhrs1992_2022, "PSYCH")

# Health Outcome Cleaning: Arthritis (ARTHR) ----
randhrs1992_2022 = clean_hrs_condition(randhrs1992_2022, "ARTHR")

# TO ADD ANOTHER CONDITION, DO randhrs1992_2022 = clean_hrs_condition(randhrs1992_2022, "CONDITION CODENAME")
# MUST HAVE SIMILAR ENTRIES OF 0,1,2,3,4,5,6. 

# Health Outcome Cleaning: Back Problems (BACK) ----
randhrs1992_2022 = clean_hrs_condition(randhrs1992_2022, "BACK")

# Health Outcome Cleaning: Mobility Limitations (MOBILA) ----
mobila_vars = paste0("R", 9:16, "MOBILA")
for (v in mobila_vars) {
  val = randhrs1992_2022[[v]]
  randhrs1992_2022[[v]] = ifelse(val %in% 0:5, as.integer(val > 0), NA)
}

# Health Outcome Cleaning: Large Muscle Limitations (LGMUSA) ----
lgmusa_vars = paste0("R", 9:16, "LGMUSA")
for (v in lgmusa_vars) {
  val = randhrs1992_2022[[v]]
  randhrs1992_2022[[v]] = ifelse(val %in% 0:4, as.integer(val > 0), NA)
}

# Health Outcome Cleaning: Gross Motor Limitations (GROSSA) ----
grossa_vars = paste0("R", 9:16, "GROSSA")
for (v in grossa_vars) {
  val = randhrs1992_2022[[v]]
  randhrs1992_2022[[v]] = ifelse(val %in% 0:5, as.integer(val > 0), NA)
}

# Health Outcome Cleaning: Fine Motor Limitations (FINEA) ----
finea_vars = paste0("R", 9:16, "FINEA")
for (v in finea_vars) {
  val = randhrs1992_2022[[v]]
  randhrs1992_2022[[v]] = ifelse(val %in% 0:3, as.integer(val > 0), NA)
}

# Health Outcome Cleaning: Trouble Falling Asleep (SLEEPFAL) ----
sleepfal_vars = paste0("R", 9:16, "SLEEPFAL")
for (v in sleepfal_vars) {
  val = as.numeric(haven::zap_labels(randhrs1992_2022[[v]]))
  randhrs1992_2022[[v]] = ifelse(val == 1, 1,        # Most of the time → yes
                                 ifelse(val == 2, 1,  # Sometimes → yes
                                        ifelse(val == 3, 0, NA)))  # Rarely/never → no
}

# Health Outcome Cleaning: Memory (MEMORY) ----

# Clean Alzheimer's and Dementia variables
randhrs1992_2022 = clean_hrs_condition(randhrs1992_2022, "ALZHE")
randhrs1992_2022 = clean_hrs_condition(randhrs1992_2022, "DEMEN")

# Wave 9: memory disease
randhrs1992_2022$R9MEMORY = randhrs1992_2022$R9MEMRYE #doing this to get this as 1 variable

# Waves 10-16: Alzheimer's OR Dementia
for (wave in 10:16) {
  
  alz = paste0("R", wave, "ALZHE")
  dem = paste0("R", wave, "DEMEN")
  mem = paste0("R", wave, "MEMORY")
  
  randhrs1992_2022[[mem]] = ifelse(
    is.na(randhrs1992_2022[[alz]]) &
      is.na(randhrs1992_2022[[dem]]),
    NA,
    as.integer(
      randhrs1992_2022[[alz]] == 1 |
        randhrs1992_2022[[dem]] == 1
    )
  )
}


# Health Outcome Cleaning: Respondent is obese (BMI > 30) ----
# NOTE: We are referencing the BMI column to construct this column. Use i+8 to 
OBESE = paste0("R", 9:16, "OBESE")
for (i in seq_along(OBESE)) {
  wave = i + 8  # i goes 1:8, wave goes 9:16
  randhrs_merged[[OBESE[i]]] = ifelse(
    is.na(randhrs_merged[[paste0("R", wave, "BMI")]]),
    NA,
    as.integer(randhrs_merged[[paste0("R", wave, "BMI")]] >= 30)
  )
}


# ===== Summary Check for Chronic Condition Cleaning =====
# Conditions cleaned on randhrs1992_2022
conditions_on_1992 = c(
  paste0("R", 9:16, "HIBP"),
  paste0("R", 9:16, "DIAB"),
  paste0("R", 9:16, "CANCR"),
  paste0("R", 9:16, "LUNG"),
  paste0("R", 9:16, "HEART"),
  paste0("R", 9:16, "STROK"),
  paste0("R", 9:16, "PSYCH"),
  paste0("R", 9:16, "ARTHR"),
  paste0("R", 9:16, "BACK"),
  paste0("R", 9:16, "MOBILA"),
  paste0("R", 9:16, "LGMUSA"),
  paste0("R", 9:16, "GROSSA"),
  paste0("R", 9:16, "FINEA"),
  paste0("R", 9:16, "SLEEPFAL")
)
check_cleaned_conditions(randhrs1992_2022, conditions_on_1992)

# Conditions cleaned on randhrs_merged
conditions_on_merged = c(
  paste0("R", 9:16, "OBESE")
)
check_cleaned_conditions(randhrs_merged, conditions_on_merged)

# ADJUSTING MONETARY VALUES TO ACCOUNT FOR INFLATION
# CPI-U adjustment factors (2008 base)
# Numbers are from https://www.minneapolisfed.org/about-us/monetary-policy/inflation-calculator/consumer-price-index-1913-
# Recall that w9 = 2008, w10 = 2010..
cpi_adjustment = c(
  "9"  = 215.3 / 215.3,
  "10" = 215.3 / 218.1,
  "11" = 215.3 / 229.6,
  "12" = 215.3 / 236.7,
  "13" = 215.3 / 240.0,
  "14" = 215.3 / 251.1,
  "15" = 215.3 / 258.8,
  "16" = 215.3 / 292.7
)

# COLUMN OF MONETARY
h_stubs = c("ATOTB", "ATOTH", "ARLES", "ATOTF", "ATOTH", "ITOT")

for (wave in 9:16) {
  factor = cpi_adjustment[as.character(wave)] # CPI adjustment factor for this wave
  
  for (stub in h_stubs) { # Apply to each HH Financial variable 
    randhrs_merged[[paste0("H", wave, stub, "_adj")]] =   
      randhrs_merged[[paste0("H", wave, stub)]] * factor
    }
  
  for (stub in c("DSSAMT", "IEARN")) { # Apply to each Respondent Financial variable
    randhrs_merged[[paste0("R", wave, stub, "_adj")]] =   # 
      randhrs_merged[[paste0("R", wave, stub)]] * factor
  }
}

# Checking work
# Pick first non-NA observation for wave 10 total wealth
# test = randhrs1992_2022 |> 
#   filter(!is.na(H10ATOTB)) |> 
#   slice(100) |> # Change the #just to check 
#   select(HHIDPN, H10ATOTB, H10ATOTB_adj)
# 
# print(test)
# # Manually verify: H10ATOTB * (216.3/218.1) should equal H10ATOTB_adj
# test$H10ATOTB * (216.3/218.1)
# 
# all.equal(randhrs1992_2022$H9ATOTB, randhrs1992_2022$H9ATOTB_adj)
# all.equal(randhrs1992_2022$R9IEARN, randhrs1992_2022$R9IEARN_adj)

# IT WORKS :)

# Joining Childhood Demographics (wave specific starting in 2008) and Military Service Questions (wave specific, START BEFORE 2008) ----
# Importing Wave Specific Fat Files
# Childhood demographics and 'Fire Weapon' and 'Military Rank when Left'  started in 2008 
# Year Military Begin and Year Military End and Military Related Disability go back further than 2008...

# xB019 RATE HEALTH AS CHILD
# xB020 RATE FAMILY FINANCIAL SITUATION - SES
# xB099 Childhood - Missed School
# xB100 Measles Before Age 16
# xB101 Mumps Before Age 16
# xB102 Chicken Pox Before Age 16
# xB103 Difficulty Seeing Before Age 16
# xB104 Parents/Guardians Smoke
# xB105 Asthma Before Age 16
# xB106 Diabetes Before Age 16
# xB107 Respiratory Disorder Before Age 16
# xB108 Speech Impairment Before Age 16
# xB109 Allergic Condition Before Age 16
# xB110 Heart Trouble Before Age 16
# xB111 Ear Problems Before Age 16
# xB112 Epilepsy or Seizures Before Age 16
# xB113 Headaches or Migraines Before Age 16
# xB114 Stomach Problems Before Age 16
# xB116 High BP Before Age 16
# xB116 Depression Before Age 16
# xB117 Drugs/Alcohol Problems Before Age 16
# xB118 Other Psych Problems Before Age 16
# xB119 Childhood- Concussion or Severe Head Injury
# xB120 Childhood- Disability
# xB122 Childhood-Smoking
# xB123 Childhood-Learning Problems
# xB124 Childhood-Any Other Conditions

# xB036 YEAR MILITARY BEGIN
# xB037 YEAR MILITARY END
# xB038 MILITARY RELATED DISABILITY
# xB096 MILITARY RANK WHEN LEFT
# xB097 EVER FIRE WEAPON


# CLEAN CHILDHOOD AND MILITARY VARIABLES VARIABLES ----

# Create condensed childhood_health variable by selecting first valid value (1-5) from wave-specific xB019 vars
# 1 - EXCELLENT, 2 - VERY GOOD, 3 - GOOD, 4 - FAIR, 5 - POOR
randhrs_merged = randhrs_merged |> 
  mutate(childhood_health = coalesce(
    if_else(LB019 %in% 1:5, LB019, NA_integer_),
    if_else(MB019 %in% 1:5, MB019, NA_integer_),
    if_else(NB019 %in% 1:5, NB019, NA_integer_),
    if_else(OB019 %in% 1:5, OB019, NA_integer_),
    if_else(PB019 %in% 1:5, PB019, NA_integer_),
    if_else(QB019 %in% 1:5, QB019, NA_integer_),
    if_else(RB019 %in% 1:5, RB019, NA_integer_)
    #if_else(SB019 %in% 1:5, SB019, NA_integer_)
  ))


# Create condensed childhood_financial_situation variable by selecting first valid value (1, 3, or 5) from wave-specific xB020 vars
# 1 - PRETTY WELL OFF FINANCIALLY, 3 - ABOUT AVERAGE, 5 - POOR
randhrs_merged = randhrs_merged |>
  mutate(childhood_financial_situation = coalesce(
    if_else(LB020 %in% c(1, 3, 5), LB020, NA_integer_),
    if_else(MB020 %in% c(1, 3, 5), MB020, NA_integer_),
    if_else(NB020 %in% c(1, 3, 5), NB020, NA_integer_),
    if_else(OB020 %in% c(1, 3, 5), OB020, NA_integer_),
    if_else(PB020 %in% c(1, 3, 5), PB020, NA_integer_),
    if_else(QB020 %in% c(1, 3, 5), QB020, NA_integer_),
    if_else(RB020 %in% c(1, 3, 5), RB020, NA_integer_)
    #if_else(SB020 %in% c(1, 3, 5), SB020, NA_integer_)
  ))

randhrs_merged = randhrs_merged |>  
  mutate(childhood_financial_situation = case_when(
    childhood_financial_situation == 1 ~ 1,   # Pretty well off
    childhood_financial_situation == 3 ~ 2,   # About average
    childhood_financial_situation == 5 ~ 3,   # Poor
    TRUE ~ NA_integer_
  ))

# Create condensed childhood_missed_school variable by selecting first valid value (1 or 5) from wave-specific xB099 vars  
# 1 - YES, 5 - NO  
randhrs_merged = randhrs_merged |>  
  mutate(childhood_missed_school = coalesce(  
    if_else(LB099 %in% c(1, 5), LB099, NA_integer_),  
    if_else(MB099 %in% c(1, 5), MB099, NA_integer_),  
    if_else(NB099 %in% c(1, 5), NB099, NA_integer_),  
    if_else(OB099 %in% c(1, 5), OB099, NA_integer_),  
    if_else(PB099 %in% c(1, 5), PB099, NA_integer_),  
    if_else(QB099 %in% c(1, 5), QB099, NA_integer_),  
    if_else(RB099 %in% c(1, 5), RB099, NA_integer_)
    #if_else(SB099 %in% c(1, 5), SB099, NA_integer_)
  ))  

# Step 2: Recode to binary (1=Yes, 0=No) # DONT RUN MULTIPLE TIMES
randhrs_merged = randhrs_merged |>  
  mutate(childhood_missed_school = case_when(
    childhood_missed_school == 1 ~ 1,
    childhood_missed_school == 5 ~ 0,
    TRUE ~ NA_integer_
  ))

# Create condensed childhood_measles variable by selecting first valid value (1 or 5) from wave-specific xB100 vars
# 1 - YES, 5 - NO
randhrs_merged = randhrs_merged |>
  mutate(childhood_measles = coalesce(
    if_else(LB100 %in% c(1, 5), LB100, NA_integer_),
    if_else(MB100 %in% c(1, 5), MB100, NA_integer_),
    if_else(NB100 %in% c(1, 5), NB100, NA_integer_),
    if_else(OB100 %in% c(1, 5), OB100, NA_integer_),
    if_else(PB100 %in% c(1, 5), PB100, NA_integer_),
    if_else(QB100 %in% c(1, 5), QB100, NA_integer_),
    if_else(RB100 %in% c(1, 5), RB100, NA_integer_)
    #if_else(SB100 %in% c(1, 5), SB100, NA_integer_)
  ))

# Step 2: Recode to binary (1=Yes, 0=No) # DONT RUN MULTIPLE TIMES
randhrs_merged = randhrs_merged |>  
  mutate(childhood_measles = case_when(
    childhood_measles == 1 ~ 1,
    childhood_measles == 5 ~ 0,
    TRUE ~ NA_integer_
  ))

# Create condensed childhood_mumps variable by selecting first valid value (1 or 5) from wave-specific xB101 vars  
# 1 - YES, 5 - NO  
randhrs_merged = randhrs_merged |>  
  mutate(childhood_mumps = coalesce(  
    if_else(LB101 %in% c(1, 5), LB101, NA_integer_),  
    if_else(MB101 %in% c(1, 5), MB101, NA_integer_),  
    if_else(NB101 %in% c(1, 5), NB101, NA_integer_),  
    if_else(OB101 %in% c(1, 5), OB101, NA_integer_),  
    if_else(PB101 %in% c(1, 5), PB101, NA_integer_),  
    if_else(QB101 %in% c(1, 5), QB101, NA_integer_),  
    if_else(RB101 %in% c(1, 5), RB101, NA_integer_)
    #if_else(SB101 %in% c(1, 5), SB101, NA_integer_) 
  ))

# Step 2: Recode to binary (1=Yes, 0=No) # DONT RUN MULTIPLE TIMES
randhrs_merged = randhrs_merged |>  
  mutate(childhood_mumps = case_when(
    childhood_mumps == 1 ~ 1,
    childhood_mumps == 5 ~ 0,
    TRUE ~ NA_integer_
  ))

# Create condensed childhood_chicken_pox variable by selecting first valid value (1 or 5) from wave-specific xB102 vars
# 1 - YES, 5 - NO
randhrs_merged = randhrs_merged |>
  mutate(childhood_chicken_pox = coalesce(
    if_else(LB102 %in% c(1, 5), LB102, NA_integer_),
    if_else(MB102 %in% c(1, 5), MB102, NA_integer_),
    if_else(NB102 %in% c(1, 5), NB102, NA_integer_),
    if_else(OB102 %in% c(1, 5), OB102, NA_integer_),
    if_else(PB102 %in% c(1, 5), PB102, NA_integer_),
    if_else(QB102 %in% c(1, 5), QB102, NA_integer_),
    if_else(RB102 %in% c(1, 5), RB102, NA_integer_)
    #if_else(SB102 %in% c(1, 5), SB102, NA_integer_)
  ))

# Step 2: Recode to binary (1=Yes, 0=No) # DONT RUN MULTIPLE TIMES
randhrs_merged = randhrs_merged |>  
  mutate(childhood_chicken_pox = case_when(
    childhood_chicken_pox == 1 ~ 1,
    childhood_chicken_pox == 5 ~ 0,
    TRUE ~ NA_integer_
  ))

# Create condensed childhood_sight_problem variable by selecting first valid value (1 or 5) from wave-specific xB103 vars  
# 1 - YES, 5 - NO  
randhrs_merged = randhrs_merged |>  
  mutate(childhood_sight_problems = coalesce(  
    if_else(LB103 %in% c(1, 5), LB103, NA_integer_),  
    if_else(MB103 %in% c(1, 5), MB103, NA_integer_),  
    if_else(NB103 %in% c(1, 5), NB103, NA_integer_),  
    if_else(OB103 %in% c(1, 5), OB103, NA_integer_),  
    if_else(PB103 %in% c(1, 5), PB103, NA_integer_),  
    if_else(QB103 %in% c(1, 5), QB103, NA_integer_),  
    if_else(RB103 %in% c(1, 5), RB103, NA_integer_)
    #if_else(SB103 %in% c(1, 5), SB103, NA_integer_)
  ))

# Step 2: Recode to binary (1=Yes, 0=No) # DONT RUN MULTIPLE TIMES
randhrs_merged = randhrs_merged |>  
  mutate(childhood_sight_problems = case_when(
    childhood_sight_problems == 1 ~ 1,
    childhood_sight_problems == 5 ~ 0,
    TRUE ~ NA_integer_
  ))

# Create condensed childhood_guardians_smoke variable by selecting first valid value (1, 2, or 5) from wave-specific xB104 vars
# 1 - YES (one of them), 2 - YES (both), 5 - NO
randhrs_merged = randhrs_merged |> 
  mutate(childhood_guardians_smoke = coalesce(
    if_else(LB104 %in% c(1, 2, 5), LB104, NA_integer_),
    if_else(MB104 %in% c(1, 2, 5), MB104, NA_integer_),
    if_else(NB104 %in% c(1, 2, 5), NB104, NA_integer_),
    if_else(OB104 %in% c(1, 2, 5), OB104, NA_integer_),
    if_else(PB104 %in% c(1, 2, 5), PB104, NA_integer_),
    if_else(QB104 %in% c(1, 2, 5), QB104, NA_integer_),
    if_else(RB104 %in% c(1, 2, 5), RB104, NA_integer_)
    #if_else(SB104 %in% c(1, 2, 5), SB104, NA_integer_)
  ))

# Step 2: Recode guardians smoking into binary (1/2 = Yes, 0 = No)
randhrs_merged = randhrs_merged |> 
  mutate(childhood_guardians_smoke = case_when(
    childhood_guardians_smoke %in% c(1, 2) ~ 1,   # Yes (either one or both)
    childhood_guardians_smoke == 5 ~ 0,           # No
    TRUE ~ NA_real_                               # DK/Refused/Missing
  ))

# Create condensed childhood_asthma variable by selecting first valid value (1 or 5) from wave-specific xB105 vars
# 1 - YES, 5 - NO
randhrs_merged = randhrs_merged |>
  mutate(childhood_asthma = coalesce(
    if_else(LB105 %in% c(1, 5), LB105, NA_integer_),
    if_else(MB105 %in% c(1, 5), MB105, NA_integer_),
    if_else(NB105 %in% c(1, 5), NB105, NA_integer_),
    if_else(OB105 %in% c(1, 5), OB105, NA_integer_),
    if_else(PB105 %in% c(1, 5), PB105, NA_integer_),
    if_else(QB105 %in% c(1, 5), QB105, NA_integer_),
    if_else(RB105 %in% c(1, 5), RB105, NA_integer_)
    #if_else(SB105 %in% c(1, 5), SB105, NA_integer_)
  ))

# Step 2: Recode to binary (1=Yes, 0=No) # DONT RUN MULTIPLE TIMES
randhrs_merged = randhrs_merged |>  
  mutate(childhood_asthma = case_when(
    childhood_asthma == 1 ~ 1,
    childhood_asthma == 5 ~ 0,
    TRUE ~ NA_integer_
  ))

# Create condensed childhood_diabetes variable by selecting first valid value (1 or 5) from wave-specific xB106 vars
# 1 - YES, 5 - NO
randhrs_merged = randhrs_merged |>
  mutate(childhood_diabetes = coalesce(
    if_else(LB106 %in% c(1, 5), LB106, NA_integer_),
    if_else(MB106 %in% c(1, 5), MB106, NA_integer_),
    if_else(NB106 %in% c(1, 5), NB106, NA_integer_),
    if_else(OB106 %in% c(1, 5), OB106, NA_integer_),
    if_else(PB106 %in% c(1, 5), PB106, NA_integer_),
    if_else(QB106 %in% c(1, 5), QB106, NA_integer_),
    if_else(RB106 %in% c(1, 5), RB106, NA_integer_)
    #if_else(SB106 %in% c(1, 5), SB106, NA_integer_)
  ))

# Step 2: Recode to binary (1=Yes, 0=No) # DONT RUN MULTIPLE TIMES
randhrs_merged = randhrs_merged |>  
  mutate(childhood_diabetes = case_when(
    childhood_diabetes == 1 ~ 1,
    childhood_diabetes == 5 ~ 0,
    TRUE ~ NA_integer_
  ))

# Create condensed childhood_respiratory_disorder variable by selecting first valid value (1 or 5) from wave-specific xB107 vars
# 1 - YES, 5 - NO
randhrs_merged = randhrs_merged |>
  mutate(childhood_respiratory_disorder = coalesce(
    if_else(LB107 %in% c(1, 5), LB107, NA_integer_),
    if_else(MB107 %in% c(1, 5), MB107, NA_integer_),
    if_else(NB107 %in% c(1, 5), NB107, NA_integer_),
    if_else(OB107 %in% c(1, 5), OB107, NA_integer_),
    if_else(PB107 %in% c(1, 5), PB107, NA_integer_),
    if_else(QB107 %in% c(1, 5), QB107, NA_integer_),
    if_else(RB107 %in% c(1, 5), RB107, NA_integer_)
    #if_else(SB107 %in% c(1, 5), SB107, NA_integer_)
  ))

# Step 2: Recode to binary (1=Yes, 0=No) # DONT RUN MULTIPLE TIMES
randhrs_merged = randhrs_merged |>  
  mutate(childhood_respiratory_disorder = case_when(
    childhood_respiratory_disorder == 1 ~ 1,
    childhood_respiratory_disorder == 5 ~ 0,
    TRUE ~ NA_integer_
  ))

# Create condensed childhood_speech_impairment variable by selecting first valid value (1 or 5) from wave-specific xB108 vars
# 1 - YES, 5 - NO
randhrs_merged = randhrs_merged |>
  mutate(childhood_speech_impairment = coalesce(
    if_else(LB108 %in% c(1, 5), LB108, NA_integer_),
    if_else(MB108 %in% c(1, 5), MB108, NA_integer_),
    if_else(NB108 %in% c(1, 5), NB108, NA_integer_),
    if_else(OB108 %in% c(1, 5), OB108, NA_integer_),
    if_else(PB108 %in% c(1, 5), PB108, NA_integer_),
    if_else(QB108 %in% c(1, 5), QB108, NA_integer_),
    if_else(RB108 %in% c(1, 5), RB108, NA_integer_)
    #if_else(SB108 %in% c(1, 5), SB108, NA_integer_)
  ))

# Step 2: Recode to binary (1=Yes, 0=No) # DONT RUN MULTIPLE TIMES
randhrs_merged = randhrs_merged |>  
  mutate(childhood_speech_impairment = case_when(
    childhood_speech_impairment == 1 ~ 1,
    childhood_speech_impairment == 5 ~ 0,
    TRUE ~ NA_integer_
  ))

# Create condensed childhood_allergic variable by selecting first valid value (1 or 5) from wave-specific xB109 vars
# 1 - YES, 5 - NO
randhrs_merged = randhrs_merged |>
  mutate(childhood_allergic = coalesce(
    if_else(LB109 %in% c(1, 5), LB109, NA_integer_),
    if_else(MB109 %in% c(1, 5), MB109, NA_integer_),
    if_else(NB109 %in% c(1, 5), NB109, NA_integer_),
    if_else(OB109 %in% c(1, 5), OB109, NA_integer_),
    if_else(PB109 %in% c(1, 5), PB109, NA_integer_),
    if_else(QB109 %in% c(1, 5), QB109, NA_integer_),
    if_else(RB109 %in% c(1, 5), RB109, NA_integer_)
    #if_else(SB109 %in% c(1, 5), SB109, NA_integer_)
  ))

# Step 2: Recode to binary (1=Yes, 0=No) # DONT RUN MULTIPLE TIMES
randhrs_merged = randhrs_merged |>  
  mutate(childhood_allergic = case_when(
    childhood_allergic == 1 ~ 1,
    childhood_allergic == 5 ~ 0,
    TRUE ~ NA_integer_
  ))

# Create condensed childhood_heart_trouble variable by selecting first valid value (1 or 5) from wave-specific xB110 vars
# 1 - YES, 5 - NO
randhrs_merged = randhrs_merged |>
  mutate(childhood_heart_trouble = coalesce(
    if_else(LB110 %in% c(1, 5), LB110, NA_integer_),
    if_else(MB110 %in% c(1, 5), MB110, NA_integer_),
    if_else(NB110 %in% c(1, 5), NB110, NA_integer_),
    if_else(OB110 %in% c(1, 5), OB110, NA_integer_),
    if_else(PB110 %in% c(1, 5), PB110, NA_integer_),
    if_else(QB110 %in% c(1, 5), QB110, NA_integer_),
    if_else(RB110 %in% c(1, 5), RB110, NA_integer_)
    #if_else(SB110 %in% c(1, 5), SB110, NA_integer_)
  ))

# Step 2: Recode to binary (1=Yes, 0=No) # DONT RUN MULTIPLE TIMES
randhrs_merged = randhrs_merged |>  
  mutate(childhood_heart_trouble = case_when(
    childhood_heart_trouble == 1 ~ 1,
    childhood_heart_trouble == 5 ~ 0,
    TRUE ~ NA_integer_
  ))

# Create condensed childhood_ear_problems variable by selecting first valid value (1 or 5) from wave-specific xB111 vars
# 1 - YES, 5 - NO
randhrs_merged = randhrs_merged |>
  mutate(childhood_ear_problems = coalesce(
    if_else(LB111 %in% c(1, 5), LB111, NA_integer_),
    if_else(MB111 %in% c(1, 5), MB111, NA_integer_),
    if_else(NB111 %in% c(1, 5), NB111, NA_integer_),
    if_else(OB111 %in% c(1, 5), OB111, NA_integer_),
    if_else(PB111 %in% c(1, 5), PB111, NA_integer_),
    if_else(QB111 %in% c(1, 5), QB111, NA_integer_),
    if_else(RB111 %in% c(1, 5), RB111, NA_integer_)
    #if_else(SB111 %in% c(1, 5), SB111, NA_integer_)
  ))

# Step 2: Recode to binary (1=Yes, 0=No) # DONT RUN MULTIPLE TIMES
randhrs_merged = randhrs_merged |>  
  mutate(childhood_ear_problems = case_when(
    childhood_ear_problems == 1 ~ 1,
    childhood_ear_problems == 5 ~ 0,
    TRUE ~ NA_integer_
  ))

# Create condensed childhood_epilepsy_seizures variable by selecting first valid value (1 or 5) from wave-specific xB112 vars
# 1 - YES, 5 - NO
randhrs_merged = randhrs_merged |>
  mutate(childhood_epilepsy_seizures = coalesce(
    if_else(LB112 %in% c(1, 5), LB112, NA_integer_),
    if_else(MB112 %in% c(1, 5), MB112, NA_integer_),
    if_else(NB112 %in% c(1, 5), NB112, NA_integer_),
    if_else(OB112 %in% c(1, 5), OB112, NA_integer_),
    if_else(PB112 %in% c(1, 5), PB112, NA_integer_),
    if_else(QB112 %in% c(1, 5), QB112, NA_integer_),
    if_else(RB112 %in% c(1, 5), RB112, NA_integer_)
    #if_else(SB112 %in% c(1, 5), SB112, NA_integer_)
  ))

# Step 2: Recode to binary (1=Yes, 0=No) # DONT RUN MULTIPLE TIMES
randhrs_merged = randhrs_merged |>  
  mutate(childhood_epilepsy_seizures = case_when(
    childhood_epilepsy_seizures == 1 ~ 1,
    childhood_epilepsy_seizures == 5 ~ 0,
    TRUE ~ NA_integer_
  ))

# Create condensed childhood_migraines variable by selecting first valid value (1 or 5) from wave-specific xB113 vars
# 1 - YES, 5 - NO
randhrs_merged = randhrs_merged |>
  mutate(childhood_migraines = coalesce(
    if_else(LB113 %in% c(1, 5), LB113, NA_integer_),
    if_else(MB113 %in% c(1, 5), MB113, NA_integer_),
    if_else(NB113 %in% c(1, 5), NB113, NA_integer_),
    if_else(OB113 %in% c(1, 5), OB113, NA_integer_),
    if_else(PB113 %in% c(1, 5), PB113, NA_integer_),
    if_else(QB113 %in% c(1, 5), QB113, NA_integer_),
    if_else(RB113 %in% c(1, 5), RB113, NA_integer_)
    #if_else(SB113 %in% c(1, 5), SB113, NA_integer_)
  ))

# Step 2: Recode to binary (1=Yes, 0=No) # DONT RUN MULTIPLE TIMES
randhrs_merged = randhrs_merged |>  
  mutate(childhood_migraines = case_when(
    childhood_migraines == 1 ~ 1,
    childhood_migraines == 5 ~ 0,
    TRUE ~ NA_integer_
  ))

# Create condensed childhood_stomach_problems variable by selecting first valid value (1 or 5) from wave-specific xB114 vars
# 1 - YES, 5 - NO
randhrs_merged = randhrs_merged |>
  mutate(childhood_stomach_problems = coalesce(
    if_else(LB114 %in% c(1, 5), LB114, NA_integer_),
    if_else(MB114 %in% c(1, 5), MB114, NA_integer_),
    if_else(NB114 %in% c(1, 5), NB114, NA_integer_),
    if_else(OB114 %in% c(1, 5), OB114, NA_integer_),
    if_else(PB114 %in% c(1, 5), PB114, NA_integer_),
    if_else(QB114 %in% c(1, 5), QB114, NA_integer_),
    if_else(RB114 %in% c(1, 5), RB114, NA_integer_)
    #if_else(SB114 %in% c(1, 5), SB114, NA_integer_)
  ))

# Step 2: Recode to binary (1=Yes, 0=No) # DONT RUN MULTIPLE TIMES
randhrs_merged = randhrs_merged |>  
  mutate(childhood_stomach_problems = case_when(
    childhood_stomach_problems == 1 ~ 1,
    childhood_stomach_problems == 5 ~ 0,
    TRUE ~ NA_integer_
  ))

# Create condensed childhood_high_BP variable by selecting first valid value (1 or 5) from wave-specific xB116 vars
# 1 - YES, 5 - NO
randhrs_merged = randhrs_merged |>
  mutate(childhood_high_BP = coalesce(
    if_else(LB116 %in% c(1, 5), LB116, NA_integer_),
    if_else(MB116 %in% c(1, 5), MB116, NA_integer_),
    if_else(NB116 %in% c(1, 5), NB116, NA_integer_),
    if_else(OB116 %in% c(1, 5), OB116, NA_integer_),
    if_else(PB116 %in% c(1, 5), PB116, NA_integer_),
    if_else(QB116 %in% c(1, 5), QB116, NA_integer_),
    if_else(RB116 %in% c(1, 5), RB116, NA_integer_)
    #if_else(SB116 %in% c(1, 5), SB116, NA_integer_)
  ))

# Step 2: Recode to binary (1=Yes, 0=No) # DONT RUN MULTIPLE TIMES
randhrs_merged = randhrs_merged |>  
  mutate(childhood_high_BP = case_when(
    childhood_high_BP == 1 ~ 1,
    childhood_high_BP == 5 ~ 0,
    TRUE ~ NA_integer_
  ))

# Create condensed childhood_depression variable by selecting first valid value (1 or 5) from wave-specific xB116 vars
# 1 - YES, 5 - NO
randhrs_merged = randhrs_merged |>
  mutate(childhood_depression = coalesce(
    if_else(LB116 %in% c(1, 5), LB116, NA_integer_),
    if_else(MB116 %in% c(1, 5), MB116, NA_integer_),
    if_else(NB116 %in% c(1, 5), NB116, NA_integer_),
    if_else(OB116 %in% c(1, 5), OB116, NA_integer_),
    if_else(PB116 %in% c(1, 5), PB116, NA_integer_),
    if_else(QB116 %in% c(1, 5), QB116, NA_integer_),
    if_else(RB116 %in% c(1, 5), RB116, NA_integer_)
    #if_else(SB116 %in% c(1, 5), SB116, NA_integer_)
  ))

# Step 2: Recode to binary (1=Yes, 0=No) # DONT RUN MULTIPLE TIMES
randhrs_merged = randhrs_merged |>  
  mutate(childhood_depression = case_when(
    childhood_depression == 1 ~ 1,
    childhood_depression == 5 ~ 0,
    TRUE ~ NA_integer_
  ))

# Create condensed childhood_drug_alcohol_problems variable by selecting first valid value (1 or 5) from wave-specific xB117 vars  
# 1 - YES, 5 - NO  
randhrs_merged = randhrs_merged |>  
  mutate(childhood_drug_alcohol_problems = coalesce(  
    if_else(LB117 %in% c(1, 5), LB117, NA_integer_),  
    if_else(MB117 %in% c(1, 5), MB117, NA_integer_),  
    if_else(NB117 %in% c(1, 5), NB117, NA_integer_),  
    if_else(OB117 %in% c(1, 5), OB117, NA_integer_),  
    if_else(PB117 %in% c(1, 5), PB117, NA_integer_),  
    if_else(QB117 %in% c(1, 5), QB117, NA_integer_),  
    if_else(RB117 %in% c(1, 5), RB117, NA_integer_)
    #if_else(SB117 %in% c(1, 5), SB117, NA_integer_) 
  ))

# Step 2: Recode to binary (1=Yes, 0=No) # DONT RUN MULTIPLE TIMES
randhrs_merged = randhrs_merged |>  
  mutate(childhood_drug_alcohol_problems = case_when(
    childhood_drug_alcohol_problems == 1 ~ 1,
    childhood_drug_alcohol_problems == 5 ~ 0,
    TRUE ~ NA_integer_
  ))

# Create condensed childhood_psych_problems variable by selecting first valid value (1 or 5) from wave-specific xB118 vars  
# 1 - YES, 5 - NO  
randhrs_merged = randhrs_merged |>  
  mutate(childhood_psych_problems = coalesce(  
    if_else(LB118 %in% c(1, 5), LB118, NA_integer_),  
    if_else(MB118 %in% c(1, 5), MB118, NA_integer_),  
    if_else(NB118 %in% c(1, 5), NB118, NA_integer_),  
    if_else(OB118 %in% c(1, 5), OB118, NA_integer_),  
    if_else(PB118 %in% c(1, 5), PB118, NA_integer_),  
    if_else(QB118 %in% c(1, 5), QB118, NA_integer_),  
    if_else(RB118 %in% c(1, 5), RB118, NA_integer_)
    #if_else(SB118 %in% c(1, 5), SB118, NA_integer_) 
  ))

# Step 2: Recode to binary (1=Yes, 0=No) # DONT RUN MULTIPLE TIMES
randhrs_merged = randhrs_merged |>  
  mutate(childhood_psych_problems = case_when(
    childhood_psych_problems == 1 ~ 1,
    childhood_psych_problems == 5 ~ 0,
    TRUE ~ NA_integer_
  ))

# Create condensed childhood_concussion_head_injury variable by selecting first valid value (1 or 5) from wave-specific xB119 vars  
# 1 - YES, 5 - NO  
randhrs_merged = randhrs_merged |>  
  mutate(childhood_concussion_head_injury = coalesce(  
    if_else(LB119 %in% c(1, 5), LB119, NA_integer_),  
    if_else(MB119 %in% c(1, 5), MB119, NA_integer_),  
    if_else(NB119 %in% c(1, 5), NB119, NA_integer_),  
    if_else(OB119 %in% c(1, 5), OB119, NA_integer_),  
    if_else(PB119 %in% c(1, 5), PB119, NA_integer_),  
    if_else(QB119 %in% c(1, 5), QB119, NA_integer_),  
    if_else(RB119 %in% c(1, 5), RB119, NA_integer_)
    #if_else(SB119 %in% c(1, 5), SB119, NA_integer_) 
  ))

# Step 2: Recode to binary (1=Yes, 0=No) # DONT RUN MULTIPLE TIMES
randhrs_merged = randhrs_merged |>  
  mutate(childhood_concussion_head_injury = case_when(
    childhood_concussion_head_injury == 1 ~ 1,
    childhood_concussion_head_injury == 5 ~ 0,
    TRUE ~ NA_integer_
  ))

# Create condensed childhood_disability variable by selecting first valid value (1 or 5) from wave-specific xB120 vars  
# 1 - YES, 5 - NO  
randhrs_merged = randhrs_merged |>  
  mutate(childhood_disability = coalesce(  
    if_else(LB120 %in% c(1, 5), LB120, NA_integer_),  
    if_else(MB120 %in% c(1, 5), MB120, NA_integer_),  
    if_else(NB120 %in% c(1, 5), NB120, NA_integer_),  
    if_else(OB120 %in% c(1, 5), OB120, NA_integer_),  
    if_else(PB120 %in% c(1, 5), PB120, NA_integer_),  
    if_else(QB120 %in% c(1, 5), QB120, NA_integer_),  
    if_else(RB120 %in% c(1, 5), RB120, NA_integer_)
    #if_else(SB120 %in% c(1, 5), SB120, NA_integer_) 
  ))

# Step 2: Recode to binary (1=Yes, 0=No) # DONT RUN MULTIPLE TIMES
randhrs_merged = randhrs_merged |>  
  mutate(childhood_disability = case_when(
    childhood_disability == 1 ~ 1,
    childhood_disability == 5 ~ 0,
    TRUE ~ NA_integer_
  ))

# Create condensed childhood_smoking variable by selecting first valid value (1 or 5) from wave-specific xB122 vars
# 1 - YES, 5 - NO
randhrs_merged = randhrs_merged |>
  mutate(childhood_smoking = coalesce(
    if_else(LB122 %in% c(1, 5), LB122, NA_integer_),
    if_else(MB122 %in% c(1, 5), MB122, NA_integer_),
    if_else(NB122 %in% c(1, 5), NB122, NA_integer_),
    if_else(OB122 %in% c(1, 5), OB122, NA_integer_),
    if_else(PB122 %in% c(1, 5), PB122, NA_integer_),
    if_else(QB122 %in% c(1, 5), QB122, NA_integer_),
    if_else(RB122 %in% c(1, 5), RB122, NA_integer_)
    #if_else(SB122 %in% c(1, 5), SB122, NA_integer_)
  ))

# Step 2: Recode to binary (1=Yes, 0=No) # DONT RUN MULTIPLE TIMES
randhrs_merged = randhrs_merged |>  
  mutate(childhood_smoking = case_when(
    childhood_smoking == 1 ~ 1,
    childhood_smoking == 5 ~ 0,
    TRUE ~ NA_integer_
  ))

# Create condensed childhood_learning_problems variable by selecting first valid value (1 or 5) from wave-specific xB122 vars
# 1 - YES, 5 - NO
randhrs_merged = randhrs_merged |>
  mutate(childhood_learning_problems = coalesce(
    if_else(LB123 %in% c(1, 5), LB123, NA_integer_),
    if_else(MB123 %in% c(1, 5), MB123, NA_integer_),
    if_else(NB123 %in% c(1, 5), NB123, NA_integer_),
    if_else(OB123 %in% c(1, 5), OB123, NA_integer_),
    if_else(PB123 %in% c(1, 5), PB123, NA_integer_),
    if_else(QB123 %in% c(1, 5), QB123, NA_integer_),
    if_else(RB123 %in% c(1, 5), RB123, NA_integer_)
    #if_else(SB123 %in% c(1, 5), SB123, NA_integer_)
  ))

# Step 2: Recode to binary (1=Yes, 0=No) # DONT RUN MULTIPLE TIMES
randhrs_merged = randhrs_merged |>  
  mutate(childhood_learning_problems = case_when(
    childhood_learning_problems == 1 ~ 1,
    childhood_learning_problems == 5 ~ 0,
    TRUE ~ NA_integer_
  ))

# Create condensed childhood_other_serious_conditions variable by selecting first valid value (1 or 5) from wave-specific xB124 vars
# 1 - YES, 5 - NO
randhrs_merged = randhrs_merged |>
  mutate(childhood_other_serious_conditions = coalesce(
    if_else(LB124 %in% c(1, 5), LB124, NA_integer_),
    if_else(MB124 %in% c(1, 5), MB124, NA_integer_),
    if_else(NB124 %in% c(1, 5), NB124, NA_integer_),
    if_else(OB124 %in% c(1, 5), OB124, NA_integer_),
    if_else(PB124 %in% c(1, 5), PB124, NA_integer_),
    if_else(QB124 %in% c(1, 5), QB124, NA_integer_),
    if_else(RB124 %in% c(1, 5), RB124, NA_integer_)
    #if_else(SB124 %in% c(1, 5), RB124, NA_integer_)
  ))

# Step 2: Recode to binary (1=Yes, 0=No) # DONT RUN MULTIPLE TIMES
randhrs_merged = randhrs_merged |>  
  mutate(childhood_other_serious_conditions = case_when(
    childhood_other_serious_conditions == 1 ~ 1,
    childhood_other_serious_conditions == 5 ~ 0,
    TRUE ~ NA_integer_
  ))

# Military Service Questions (wave specific, START BEFORE 2008 for some!)

# Military Service Questions (wave-specific, going back to 2002)

# Create condensed year_military_begin variable (valid years: 1900–2022)
randhrs_merged = randhrs_merged |>  
  mutate(year_military_begin = coalesce(  
    if_else(HB036 >= 1900 & HB036 <= 2022, HB036, NA_integer_),  # 2002  
    if_else(JB036 >= 1900 & JB036 <= 2022, JB036, NA_integer_),  # 2004  
    if_else(KB036 >= 1900 & KB036 <= 2022, KB036, NA_integer_),  # 2006  
    if_else(LB036 >= 1900 & LB036 <= 2022, LB036, NA_integer_),  # 2008  
    if_else(MB036 >= 1900 & MB036 <= 2022, MB036, NA_integer_),  # 2010  
    if_else(NB036 >= 1900 & NB036 <= 2022, NB036, NA_integer_),  # 2012  
    if_else(OB036 >= 1900 & OB036 <= 2022, OB036, NA_integer_),  # 2014  
    if_else(PB036 >= 1900 & PB036 <= 2022, PB036, NA_integer_),  # 2016  
    if_else(QB036 >= 1900 & QB036 <= 2022, QB036, NA_integer_),  # 2018  
    if_else(RB036 >= 1900 & RB036 <= 2022, RB036, NA_integer_)   # 2020
    #if_else(SB036 >= 1900 & SB036 <= 2022, SB036, NA_integer_)   # 2022
  ))  

# Create condensed year_military_end variable (valid years: 1900–2022)
randhrs_merged = randhrs_merged |>  
  mutate(year_military_end = coalesce(  
    if_else(HB037 >= 1900 & HB037 <= 2022, HB037, NA_integer_),  
    if_else(JB037 >= 1900 & JB037 <= 2022, JB037, NA_integer_),  
    if_else(KB037 >= 1900 & KB037 <= 2022, KB037, NA_integer_),  
    if_else(LB037 >= 1900 & LB037 <= 2022, LB037, NA_integer_),  
    if_else(MB037 >= 1900 & MB037 <= 2022, MB037, NA_integer_),  
    if_else(NB037 >= 1900 & NB037 <= 2022, NB037, NA_integer_),  
    if_else(OB037 >= 1900 & OB037 <= 2022, OB037, NA_integer_),  
    if_else(PB037 >= 1900 & PB037 <= 2022, PB037, NA_integer_),  
    if_else(QB037 >= 1900 & QB037 <= 2022, QB037, NA_integer_),  
    if_else(RB037 >= 1900 & RB037 <= 2022, RB037, NA_integer_)
    #if_else(SB037 >= 1900 & SB037 <= 2022, SB037, NA_integer_) 
  ))  

# Create military service length variable (in years)
randhrs_merged = randhrs_merged |>
  mutate(
    military_service_length = case_when(
      !is.na(year_military_begin) & !is.na(year_military_end) &
        year_military_begin >= 1900 & year_military_begin <= 2022 &
        year_military_end   >= 1900 & year_military_end   <= 2022 ~
        year_military_end - year_military_begin,
      TRUE ~ NA_integer_
    )
  )

# Adjust military_service_length so that cases with the same start and end year 
# (calculated length = 0) are recoded to 0.5 years. 
# This accounts for respondents who served less than a full year but not zero time.
randhrs_merged = randhrs_merged |>
  mutate(
    military_service_length = if_else(
      military_service_length == 0,
      0.5,
      as.numeric(military_service_length)
    )
  )

# Create condensed military_related_disability variable (1=Yes, 5=No)
randhrs_merged = randhrs_merged |>  
  mutate(military_related_disability = coalesce(  
    if_else(HB038 %in% c(1, 5), HB038, NA_integer_),  # 2002  
    if_else(JB038 %in% c(1, 5), JB038, NA_integer_),  # 2004  
    if_else(KB038 %in% c(1, 5), KB038, NA_integer_),  # 2006  
    if_else(LB038 %in% c(1, 5), LB038, NA_integer_),  # 2008  
    if_else(MB038 %in% c(1, 5), MB038, NA_integer_),  # 2010  
    if_else(NB038 %in% c(1, 5), NB038, NA_integer_),  # 2012  
    if_else(OB038 %in% c(1, 5), OB038, NA_integer_),  # 2014  
    if_else(PB038 %in% c(1, 5), PB038, NA_integer_),  # 2016  
    if_else(QB038 %in% c(1, 5), QB038, NA_integer_),  # 2018  
    if_else(RB038 %in% c(1, 5), RB038, NA_integer_)  # 2020 
    #if_else(SB038 %in% c(1, 5), SB038, NA_integer_)   # 2022
  ))

randhrs_merged = randhrs_merged |>  
  mutate(military_related_disability = case_when(
    military_related_disability == 1 ~ 1,   # Yes
    military_related_disability == 5 ~ 0,   # No
    TRUE ~ NA_integer_                       
  ))

# Create condensed military_rank_end variable by selecting first valid value (1, 2, or 3) from wave-specific xB096 vars  
# 1 - COMMISSIONED OFFICER, 2 - WARRANT OFFICER, 3 - ENLISTED PERSONNEL  
randhrs_merged = randhrs_merged |>  
  mutate(military_rank_end = coalesce(  
    if_else(LB096 %in% c(1, 2, 3), LB096, NA_integer_),  
    if_else(MB096 %in% c(1, 2, 3), MB096, NA_integer_),  
    if_else(NB096 %in% c(1, 2, 3), NB096, NA_integer_),  
    if_else(OB096 %in% c(1, 2, 3), OB096, NA_integer_),  
    if_else(PB096 %in% c(1, 2, 3), PB096, NA_integer_),  
    if_else(QB096 %in% c(1, 2, 3), QB096, NA_integer_),  
    if_else(RB096 %in% c(1, 2, 3), RB096, NA_integer_)
    #if_else(SB096 %in% c(1, 2, 3), SB096, NA_integer_)
  ))  

# Create condensed fire_weapon variable by selecting first valid value (1 or 5) from wave-specific xB097 vars  
# 1 - YES, 5 - NO  
randhrs_merged = randhrs_merged |>  
  mutate(fire_weapon = coalesce(  
    if_else(LB097 %in% c(1, 5), LB097, NA_integer_),  
    if_else(MB097 %in% c(1, 5), MB097, NA_integer_),  
    if_else(NB097 %in% c(1, 5), NB097, NA_integer_),  
    if_else(OB097 %in% c(1, 5), OB097, NA_integer_),  
    if_else(PB097 %in% c(1, 5), PB097, NA_integer_),  
    if_else(QB097 %in% c(1, 5), QB097, NA_integer_),  
    if_else(RB097 %in% c(1, 5), RB097, NA_integer_)
    #if_else(SB097 %in% c(1, 5), SB097, NA_integer_)
  ))

# Step 2: Recode fire_weapon into binary (1=Yes, 0=No)
randhrs_merged = randhrs_merged |>  
  mutate(fire_weapon = case_when(
    fire_weapon == 1 ~ 1,     # Yes
    fire_weapon == 5 ~ 0,     # No
    TRUE ~ NA_integer_        # Missing, DK, Refused
  ))



# Create final data set ----
final_variables = c('HHIDPN',
                    'RAVETRN',
                    
                    # Military Service Specific
                    'year_military_begin',
                    'year_military_end',
                    'military_service_length',
                    'military_related_disability',
                    'military_rank_end',
                    'fire_weapon',
                    
                    # Outcomes
                    'R9SHLT', 'R10SHLT', 'R11SHLT', 'R12SHLT', 'R13SHLT', 'R14SHLT', 'R15SHLT', 'R16SHLT',
                    'R9HOSP', 'R10HOSP', 'R11HOSP', 'R12HOSP', 'R13HOSP', 'R14HOSP', 'R15HOSP', 'R16HOSP',
                    'R9HSPNIT', 'R10HSPNIT', 'R11HSPNIT', 'R12HSPNIT', 'R13HSPNIT', 'R14HSPNIT', 'R15HSPNIT', 'R16HSPNIT',
                    'R9DOCTOR', 'R10DOCTOR', 'R11DOCTOR', 'R12DOCTOR', 'R13DOCTOR', 'R14DOCTOR', 'R15DOCTOR', 'R16DOCTOR',
                    'R9DOCTIM', 'R10DOCTIM', 'R11DOCTIM', 'R12DOCTIM', 'R13DOCTIM', 'R14DOCTIM', 'R15DOCTIM', 'R16DOCTIM',
                    'R9DEPRES', 'R10DEPRES', 'R11DEPRES', 'R12DEPRES', 'R13DEPRES', 'R14DEPRES', 'R15DEPRES', 'R16DEPRES',
                    'R9SLEEPR', 'R10SLEEPR', 'R11SLEEPR', 'R12SLEEPR', 'R13SLEEPR', 'R14SLEEPR', 'R15SLEEPR', 'R16SLEEPR',
                    'R9HIBP', 'R10HIBP', 'R11HIBP', 'R12HIBP', 'R13HIBP', 'R14HIBP', 'R15HIBP', 'R16HIBP',
                    'R9DIAB', 'R10DIAB', 'R11DIAB', 'R12DIAB', 'R13DIAB', 'R14DIAB', 'R15DIAB', 'R16DIAB',
                    'R9CANCR', 'R10CANCR', 'R11CANCR', 'R12CANCR', 'R13CANCR', 'R14CANCR', 'R15CANCR', 'R16CANCR',
                    'R9LUNG', 'R10LUNG', 'R11LUNG', 'R12LUNG', 'R13LUNG', 'R14LUNG', 'R15LUNG', 'R16LUNG',
                    'R9HEART', 'R10HEART', 'R11HEART', 'R12HEART', 'R13HEART', 'R14HEART', 'R15HEART', 'R16HEART',
                    'R9STROK', 'R10STROK', 'R11STROK', 'R12STROK', 'R13STROK', 'R14STROK', 'R15STROK', 'R16STROK',
                    'R9PSYCH', 'R10PSYCH', 'R11PSYCH', 'R12PSYCH', 'R13PSYCH', 'R14PSYCH', 'R15PSYCH', 'R16PSYCH',
                    'R9ARTHR', 'R10ARTHR', 'R11ARTHR', 'R12ARTHR', 'R13ARTHR', 'R14ARTHR', 'R15ARTHR', 'R16ARTHR',
                    'R9SLFMEM', 'R10SLFMEM', 'R11SLFMEM', 'R12SLFMEM', 'R13SLFMEM', 'R14SLFMEM', 'R15SLFMEM', # R16SLFMEM does not exist in wave 16
                    'R9MEMRYE',
                    'R10ALZHE', 'R11ALZHE', 'R12ALZHE', 'R13ALZHE', 'R14ALZHE', 'R15ALZHE', 'R16ALZHE',
                    'R10DEMEN', 'R11DEMEN', 'R12DEMEN', 'R13DEMEN', 'R14DEMEN', 'R15DEMEN', 'R16DEMEN',
                    'R9HLTHLM', 'R10HLTHLM', 'R11HLTHLM', 'R12HLTHLM', 'R13HLTHLM', 'R14HLTHLM', 'R15HLTHLM', 'R16HLTHLM',
                    'R9DRINK', 'R10DRINK', 'R11DRINK', 'R12DRINK', 'R13DRINK', 'R14DRINK', 'R15DRINK', 'R16DRINK',
                    
                    # Wealth and Income (CPI adjusted to 2008 dollars)
                    'H9ATOTB_adj', 'H10ATOTB_adj', 'H11ATOTB_adj', 'H12ATOTB_adj', 'H13ATOTB_adj', 'H14ATOTB_adj', 'H15ATOTB_adj', 'H16ATOTB_adj', # ADJ Total wealth
                    'H9ATOTH_adj', 'H10ATOTH_adj', 'H11ATOTH_adj', 'H12ATOTH_adj', 'H13ATOTH_adj', 'H14ATOTH_adj', 'H15ATOTH_adj', 'H16ATOTH_adj', # ADJ Net value primary
                    'H9ARLES_adj', 'H10ARLES_adj', 'H11ARLES_adj', 'H12ARLES_adj', 'H13ARLES_adj', 'H14ARLES_adj', 'H15ARLES_adj', 'H16ARLES_adj', # ADJ value other residence
                    'H9ATOTF_adj', 'H10ATOTF_adj', 'H11ATOTF_adj', 'H12ATOTF_adj', 'H13ATOTF_adj', 'H14ATOTF_adj', 'H15ATOTF_adj', 'H16ATOTF_adj', # ADJ value of non-housing wealth
                    'R9IEARN_adj', 'R10IEARN_adj', 'R11IEARN_adj', 'R12IEARN_adj', 'R13IEARN_adj', 'R14IEARN_adj', 'R15IEARN_adj', 'R16IEARN_adj', # ADJ Income
                    'R9DSSAMT_adj', 'R10DSSAMT_adj', 'R11DSSAMT_adj', 'R12DSSAMT_adj', 'R13DSSAMT_adj', 'R14DSSAMT_adj', 'R15DSSAMT_adj', 'R16DSSAMT_adj', # ADJ SSDI and SSI  
                    'H9ITOT_adj', 'H10ITOT_adj', 'H11ITOT_adj', 'H12ITOT_adj', 'H13ITOT_adj', 'H14ITOT_adj', 'H15ITOT_adj', 'H16ITOT_adj',  # ADJ Household income
                    
                    # Social Security
                    'RASSRECV',  # R Receives SocSec (1 = Yes, 0 = No)
                    'RASSAGEB',  # Age R Started Receiving SocSec
                    'R9HIGOV', 'R10HIGOV', 'R11HIGOV', 'R12HIGOV', 'R13HIGOV', 'R14HIGOV', 'R15HIGOV', 'R16HIGOV',  # R is covered by Gov plan (1 = Yes, 0 = No)
                    'R9LIV75', 'R10LIV75', 'R11LIV75', 'R12LIV75', 'R13LIV75', 'R14LIV75', 'R15LIV75', 'R16LIV75',  # Probability to live 75+, self-reported probability of living to age 75
                    'R9LIV10', 'R10LIV10', 'R11LIV10', 'R12LIV10', 'R13LIV10', 'R14LIV10', 'R15LIV10', 'R16LIV10',  # Probability to live 80-100, self-reported
                    
                    # Childhood
                    'childhood_health',
                    'childhood_financial_situation',
                    'childhood_missed_school', 'childhood_measles',
                    'childhood_mumps', 'childhood_chicken_pox',
                    'childhood_sight_problems', 'childhood_guardians_smoke',
                    'childhood_asthma', 'childhood_diabetes',
                    'childhood_respiratory_disorder', 'childhood_speech_impairment',
                    'childhood_allergic', 'childhood_heart_trouble',
                    'childhood_ear_problems', 'childhood_epilepsy_seizures',
                    'childhood_migraines', 'childhood_stomach_problems',
                    'childhood_high_BP', 'childhood_depression',
                    'childhood_drug_alcohol_problems', 'childhood_psych_problems',
                    'childhood_concussion_head_injury', 'childhood_disability',
                    'childhood_smoking', 'childhood_learning_problems',
                    'childhood_other_serious_conditions',
                    
                    # Interview Status and Weights
                    'R9AGEY_B', 'R10AGEY_B', 'R11AGEY_B', 'R12AGEY_B', 'R13AGEY_B', 'R14AGEY_B', 'R15AGEY_B', 'R16AGEY_B', # Age at beginning of interview
                    'INW9', 'INW10', 'INW11', 'INW12', 'INW13', 'INW14', 'INW15', 'INW16',                                 # Responded/Participated in this wave (1=Yes, 0=No)
                    'R9IWSTAT', 'R10IWSTAT', 'R11IWSTAT', 'R12IWSTAT', 'R13IWSTAT', 'R14IWSTAT', 'R15IWSTAT', 'R16IWSTAT', # Respondent Status
                    'RAWTSAMP',                                                                                            # Sampling Weight
                    'R9WTRESP', 'R10WTRESP', 'R11WTRESP', 'R12WTRESP', 'R13WTRESP', 'R14WTRESP', 'R15WTRESP', 'R16WTRESP', # Person-Level Analysis Weight
                    'R9WTHH', 'R10WTHH', 'R11WTHH', 'R12WTHH', 'R13WTHH', 'R14WTHH', 'R15WTHH', 'R16WTHH',                 # Household-Level Analysis Weight
                   
                    # Demographics
                    'RACOHBYR', # Cohort based on birth yr (RABYEAR), 0 = not in cohort, 1 = ahead [born before 1924], 2 = coda [1924 – 1930], 3 = hrs [1931 – 1941], 4 = warbabies [1942 – 1947], 5 = early babyboomers [1948 – 1953], 6 = mid babyboomers [1954 -1959], 7 = late babyboomers [1960 to 1965]
                    'RABYEAR',  # R birth year
                    'RADYEAR',  # R death year
                    'GENDER',   # Male = 1, Female = 0
                    'RARACEM',  # R Race-masked, 1 = White/Caucasian, 2 = Black/African American, 3 = Other
                    'RAHISPAN', # R Hispanic, 0 = Not Hispanic, 1 = Hispanic
                    'RAEDYRS',  # R Years of Education
                    'RAEDEGRM', # R Highest Degree-masked, 0 = No degree, 1 = GED, 2 = HS, 3 = AA/Lt BA, 5 = BA, 6 = MA/MBA, 7 = Law/MD/PHD, 8 = Other
                    'RAMEDUC',  # R Mother's Years Education
                    'RAFEDUC',   # R Father's Years Education
                    
                    # Additional Health Variables
                    'R9BACK', 'R10BACK', 'R11BACK', 'R12BACK', 'R13BACK', 'R14BACK', 'R15BACK', 'R16BACK',
                    'R9MOBILA', 'R10MOBILA', 'R11MOBILA', 'R12MOBILA', 'R13MOBILA', 'R14MOBILA', 'R15MOBILA', 'R16MOBILA',
                    'R9LGMUSA', 'R10LGMUSA', 'R11LGMUSA', 'R12LGMUSA', 'R13LGMUSA', 'R14LGMUSA', 'R15LGMUSA', 'R16LGMUSA',  # [KEEP?]
                    'R9GROSSA', 'R10GROSSA', 'R11GROSSA', 'R12GROSSA', 'R13GROSSA', 'R14GROSSA', 'R15GROSSA', 'R16GROSSA',  # [KEEP?]
                    'R9FINEA', 'R10FINEA', 'R11FINEA', 'R12FINEA', 'R13FINEA', 'R14FINEA', 'R15FINEA', 'R16FINEA',          # [KEEP?]
                    'R9SLEEPFAL', 'R10SLEEPFAL', 'R11SLEEPFAL', 'R12SLEEPFAL', 'R13SLEEPFAL', 'R14SLEEPFAL', 'R15SLEEPFAL', 'R16SLEEPFAL',
                    'R9BMI', 'R10BMI', 'R11BMI', 'R12BMI', 'R13BMI', 'R14BMI', 'R15BMI', 'R16BMI',
                    'R9OBESE', 'R10OBESE', 'R11OBESE', 'R12OBESE', 'R13OBESE', 'R14OBESE', 'R15OBESE', 'R16OBESE',
                    'R9MEMORY', 'R10MEMORY', 'R11MEMORY', 'R12MEMORY', 'R13MEMORY', 'R14MEMORY', 'R15MEMORY', 'R16MEMORY'
                    
                 
)

randhrs_final = randhrs_merged |> 
  select(all_of(final_variables))

randhrs_final = randhrs_final |>
  filter(INW10 == 1 | INW11 == 1 | INW12 == 1 | 
           INW13 == 1 | INW14 == 1 | INW16 == 1)

dim(randhrs_final)
head(randhrs_final)

setwd("C:/Users/lgriv/Downloads/HRS/Flores_Dataset_Material")
write_csv(randhrs_final, 'Flores_RandHRS_Dataset_v2.csv')

# Test
xqe = read.csv('Flores_RandHRS_Dataset_v2.csv')



