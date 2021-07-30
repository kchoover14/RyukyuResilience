# RyukyuResilience

## START HERE
A PDF summary of the project can be found here: https://rpubs.com/kchoover14/RyukyuResilience

## R SCRIPTS
### The scripts contain the full code used in the study (includes code not found in markdown).
script1a-data cleaning-dental.R
script1b-data cleaning-cribra orbitalia.R
script2-exploration.R
script3-outlier removal.R
script4-analysis.R

## DATA
### Raw data collected by MJH in Excel format with a tab for each site.
data-ryukyu-raw-cribra orbitalia-MJH.xlsx
data-ryukyu-raw-dental-MJH.xlsx

### CSV files of Excel tabs from raw data collected by MJH (conversion to UTF to eliminate character coding issues from Japanese to English)
data-ryukyu-raw-cribra orbitalia-kanna.csv
data-ryukyu-raw-cribra orbitalia-nagabaka.csv
data-ryukyu-raw-cribra orbitalia-yatchi.csv
data-ryukyu-raw-dental-kanna.csv
data-ryukyu-raw-dental-nagabaka.csv
data-ryukyu-raw-dental-yatchi.csv

### Data after cleaning and simplified to variables of interest for analysis
data-ryukyu-clean-dental.csv (a clean dataset containing all variables)
data-ryukyu-final-cribra orbitalia.csv (a simplified dataset containing only variables used for model building)
data-ryukyu-final-dental.csv (a simplified dataset containing only variables used for model building)
data-ryukyu-final-dental out.csv (a simplified dataset containing only variables used for model building and duplicates of hypo and calc but without outliers)
