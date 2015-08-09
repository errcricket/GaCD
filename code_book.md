# Code Book for run_analysis.R

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. 

## Dataset
Obtained datasets from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip -- which contains test and training data. 

## Goals
The goal of R script is to create one tidy data set for the average of each variable for each subject.

## Files

The following files were read into R.

*--------------------Feature/Activity Labels
* `UCI_HAR_Dataset/activity_labels.txt` (contains 6 descriptive activities w/ numeric values)
* `UCI_HAR_Dataset/features.txt` (contains 561 variable names in X_t*.txt)

*--------------------Training Data (these files should have the 7352 rows of observations)
* `UCI_HAR_Dataset/train/subject_train.txt` (contains subject order)
* `UCI_HAR_Dataset/train/y_train.txt` (contains activity order -- numeric activity values)
* `UCI_HAR_Dataset/train/X_train.txt` (contains feature variable values)

*--------------------Testing Data (these files should have the 2947 rows of observations)
* `UCI_HAR_Dataset/test/subject_test.txt` (contains subject order)
* `UCI_HAR_Dataset/test/y_test.txt` (contains activity order -- numeric activity values)
* `UCI_HAR_Dataset/test/X_test.txt` (contains feature variable values)


## Steps 
You should create one R script called run_analysis.R that does the following. 

1. Merges the training and the test sets to create one data set.
	* files are read into r using read.table. Not including sep=' ' will allow X_t*.txt to be loaded with the correct number of columns and rows.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
	* uses grep to look for features with `mean` or `std` in the feature list
3. Uses descriptive activity names to name the activities in the data set
	* uses `match` to marry activity number to activity descriptive name
4. Appropriately labels the data set with descriptive variable names. 
	* uses label names obtained from `UCI_HAR_Dataset/features.txt` file
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
	* uses melt & dcast to find the mean values for selected columns (step 4). `reshape2` package required
6. Write tidy dataset to file 
	* uses write.table to save output of step 5 to file
Note: Output file (`tidy_project_data.txt`) has been rounded for more readability
