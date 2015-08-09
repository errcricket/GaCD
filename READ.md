# Coursera: Getting and Cleaning Data Course Project (making untidy data -- tidy)

# Input Date
1. Original source data came from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

2. Within unziped directory are the following files:

*--------------------Feature/Activity Labels
* `activity_labels.txt` (contains 6 descriptive activities w/ numeric values)
* `features.txt` (contains 561 variable names in X_t*.txt)

*--------------------Training Data (these files should have the same nuber of rows)
* `subject_train.txt` (contains subject order)
* `y_train.txt` (contains activity order)
* `X_train.txt` (contains feature variable values)

*--------------------Testing Data (these files should have the same number of rows)
* `subject_test.txt` (contains subject order)
* `y_test.txt` (contains activity order)
* `X_test.txt` (contains feature variable values)

# Running Script
* Run the R script, `run_analysis_R` to tidy up the data.

# Output Date 
* tidy_project_data.txt 

#Additional info
* The `README.txt` from the zipped directory contains experiment information
* `Inertial Signals` folder is not used in this analysis.
* `code_book.md` contains additional info on `run_analysis_R` script
