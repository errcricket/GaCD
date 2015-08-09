# Coursera: Getting and Cleaning Data Course Project (making untidy data -- tidy)

# Input Date
1. Original source data came from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

2. Within unziped directory are the following files:

*--------------------Feature/Activity Labels
* `UCI_HAR_Dataset/activity_labels.txt` (contains 6 descriptive activities w/ numeric values)
* `UCI_HAR_Dataset/features.txt` (contains 561 variable names in X_t*.txt)

*--------------------Training Data (these files should have the same nuber of rows)
* `UCI_HAR_Dataset/train/subject_train.txt` (contains subject order)
* `UCI_HAR_Dataset/train/y_train.txt` (contains activity order)
* `UCI_HAR_Dataset/train/X_train.txt` (contains feature variable values)

*--------------------Testing Data (these files should have the same number of rows)
* `UCI_HAR_Dataset/test/subject_test.txt` (contains subject order)
* `UCI_HAR_Dataset/test/y_test.txt` (contains activity order)
* `UCI_HAR_Dataset/test/X_test.txt` (contains feature variable values)

# Running Script
* Run the R script, `run_analysis_R` to tidy up the data.

# Output Date 
* tidy_project_data.txt 

#Additional info
* The `UCI_HAR_Dataset/README.txt`, contains experiment information
* `Inertial Signals` folder is not used in this analysis.
* `code_book.md` contains additional info on `run_analysis_R` script
