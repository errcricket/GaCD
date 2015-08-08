options(width=9999)

#Download zip file. The contents of the directory will be used for this project, & downloading needs to be done only once.
downloadFILE <- function()
{
	fileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2F../UCI%20HAR%20Dataset.zip'
	download.file(fileURL, destfile='smartPhoneData.csv.zip', method='curl')
	dataDownloaded <- date()
}

#downloadFILE()
download_date <- file.info('../UCI_HAR_Dataset/activity_labels.txt')$ctime

#Quick function to print the name of the dataframe and the number of columns and rows
print_col_row <- function(dataframe)
{
	print(paste('Data frame name:', attr(dataframe, 'df_name'), 'Number of columns:', ncol(dataframe), 'number of rows:', nrow(dataframe), sep=' '))
}

# Loading activity labels and setting name of object to df_name 
activity_labels <- read.csv('../UCI_HAR_Dataset/activity_labels.txt', header=F, sep=' ')
names(activity_labels) <- c('ActivityID', 'Activity')
attr(activity_labels, 'df_name') <- 'activity_labels'

# Loading feature labels  Note: there are 561 features (columns)
feature_labels <- read.csv('../UCI_HAR_Dataset/features.txt', header=F, sep=' ')
attr(feature_labels, 'df_name') <- 'feature_labels'

# Loading subjects. There are 7532 observations 
subjects <- read.csv('../UCI_HAR_Dataset/train/subject_train.txt', header=F, sep=' ')
names(subjects) <- 'subjects'
attr(subjects, 'df_name') <- 'subjects'

# Loading training activities. There are 7532 observations 
training_y <- read.csv('../UCI_HAR_Dataset/train/y_train.txt', header=F, sep=' ')
names(training_y) <- 'activity'
attr(training_y, 'df_name') <- 'training_y'

info <- data.frame(activity_id = activity_labels$ActivityID, activity_desc = activity_labels$Activity)
id <- match(training_y$activity, info$activity_id) #info[id, 2] will give me the column with activity description names only

# Creating dataframe to hold subject order and activity
complete_df <- data.frame(subject_id = subjects$subjects, activity = info[id,2])

# Load training data
###training_X <- read.table('temp', header=F)
training_X <- read.table('../UCI_HAR_Dataset/train/X_train_original.txt', header=F) #, sep=' ', fill=F) # Error in scan(file, what, nmax, sep, dec, quote, skip, nlines, na.strings,  : line 2 did not have 662 elements
feature_list <- as.character(feature_labels$V2)
names(training_X) <- feature_list
#names(training_X)

complete_df <- cbind(complete_df, training_X)
attr(complete_df, 'df_name') <- 'complete_df'
#complete_df <- cbind(complete_df, training_X[-2])
print_col_row(complete_df)
#complete
##training <- training[-c(1:7352,2)]
#write.table(training, file='tidy_project_data.txt', row.name=FALSE)
###for (t in 1:training_X[, 
###print(c('number of columns', ncol(training_X)))
###print(c('number of rows', nrow(training_X)))
