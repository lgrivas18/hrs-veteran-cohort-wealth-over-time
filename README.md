# Flores HRS Dataset Construction

This repository contains an R script (`Flores_Dataset_2_0.R`) that builds an analysis-ready
longitudinal dataset from the **Health and Retirement Study (HRS)**, using the RAND HRS
Longitudinal File merged with wave-specific "FAT" (Family, Assets, and Transfers... / core
supplement) files.

The script covers HRS waves 9–16 (2008–2022) and produces a single cleaned CSV with
demographics, health outcomes, wealth/income (CPI-adjusted), childhood health/SES history,
and interview status/weights for each respondent-wave.

**Note:** The raw HRS data is **not included** in this repository, per HRS/RAND data use
terms. See [Getting the data](#getting-the-data) below for how to obtain it and reproduce
the output yourself.

## What the script does

1. **Imports** the RAND HRS longitudinal file (`randhrs1992_2022v1.sas7bdat`) and selects a
   defined set of variables: IDs, interview status/weights, demographics, self-reported
   health outcomes, chronic conditions, wealth/income, and additional health/impairment
   variables (waves 9–16).
2. **Merges in** wave-specific HRS "FAT" files (2002–2022) to pull in childhood health/SES
   variables and military service variables (year began/ended service, disability, etc.),
   joined on `HHIDPN`.
3. **Recodes chronic condition variables** (hypertension, diabetes, cancer, lung disease,
   heart disease, stroke, psychiatric problems, arthritis, back problems, and several
   functional-limitation indices) using a helper function that collapses HRS's raw response
   codes (yes/no/carry-forward/refused-backfill) into clean 0/1 indicators, carrying forward
   from the prior wave where appropriate.
4. **Adjusts monetary variables for inflation** (assets, income, earnings, Social
   Security/SSI/SSDI amounts) to real 2008 dollars using CPI-U factors.
5. **Filters** to respondents observed in at least one of waves 10–16.
6. **Writes** the final analysis file to `Flores_RandHRS_Dataset_v2.csv`.

## Requirements

- R (4.x recommended)
- R packages: `tidyverse`, `haven`, `dplyr`

```r
install.packages(c("tidyverse", "haven", "dplyr"))
```

## Getting the data

This script requires two types of restricted-access HRS files that must be requested
directly from HRS — they cannot be redistributed here:

1. **RAND HRS Longitudinal File 1992–2022 (v1)** — available from the
   [RAND HRS Data Products page](https://hrsdata.isr.umich.edu/data-products/rand).
2. **HRS core "FAT" files** for 2002, 2004, 2006, 2008, 2010, 2012, 2014, 2016, 2018, 2020,
   and 2022 (e.g. `h08f3b.sas7bdat`, `hd10f6b.sas7bdat`, etc.) — available from the
   [HRS Core Data page](https://hrsdata.isr.umich.edu/data-products/2008-hrs-core).

Both require a free HRS data use account/agreement (via the University of Michigan). Once
approved, download the `.sas7bdat` files listed above.

## Reproducing the output

1. Request and download the files listed above.
2. Update the two `setwd()` calls near the top of the script (and wherever a file is read
   with `read_sas(...)`) to point at the folder(s) where you saved the raw `.sas7bdat`
   files, and to a folder where you'd like intermediate/output files saved.
3. Run the script top to bottom in R (or RStudio). It will:
   - Save an intermediate `Longitudinal_RAW.rds` (so you don't have to re-read the large
     SAS file every run),
   - Merge, recode, and adjust the variables described above,
   - Write the final `Flores_RandHRS_Dataset_v2.csv`.

> The hardcoded `setwd()` paths in the script are specific to the original author's machine
> (`C:/Users/lgriv/Downloads/HRS/...`) and will need to be changed to your own local paths
> before running.

## Variable documentation

Variable codebooks/definitions for RAND HRS and core HRS variables are available from the
HRS website alongside each data product (RAND HRS codebook and wave-specific core
codebooks). Key derived variables created by this script:

- `GENDER` — recoded from `RAGENDER` (1 = Male, 0 = Female)
- `AGE_2010` — age as of 2010, derived from birth year (approximate; wave-specific age
  variables like `R#AGEY_B` should be preferred for exact per-wave age)
- `*_adj` suffix — dollar variables adjusted to real 2008 dollars using CPI-U
- Chronic condition variables (`R#HIBP`, `R#DIAB`, `R#CANCR`, `R#LUNG`, `R#HEART`,
  `R#STROK`, `R#PSYCH`, `R#ARTHR`, `R#BACK`) — recoded to clean 0/1 indicators
- `R#OBESE` — derived from `R#BMI` (BMI ≥ 30)

## Repository contents

| File | Description |
|---|---|
| `Flores_Dataset_2_0.R` | Full data-cleaning pipeline (this repo's main script) |

## License / data use

This code is shared for transparency and reproducibility. Use of HRS data itself is subject
to the [HRS Data Use Agreement](https://hrsdata.isr.umich.edu) terms set by the Health and
Retirement Study / University of Michigan.
