options(width=9999)
library(plyr)

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
	print(names(dataframe))
}

# Get only the mean and standard deviation features from feature.txt file
#grep mean ../UCI_HAR_Dataset/features.txt | awk '{print $2}' > mean.txt
#grep std ../UCI_HAR_Dataset/features.txt | awk '{print $2}' > std.txt
#cat std.txt mean.txt > features.txt
desired_features <- read.table('features.txt', header=F)
names(desired_features) <- 'saved_features'
kept_features <- factor(unique(unlist(desired_features$saved_features, use.names = FALSE)))

# Loading activity labels and setting name of object to df_name 
activity_labels <- read.csv('../UCI_HAR_Dataset/activity_labels.txt', header=F, sep=' ')
names(activity_labels) <- c('ActivityID', 'Activity')
attr(activity_labels, 'df_name') <- 'activity_labels'
#activity_labels

# Loading feature labels  Note: there are 561 features (columns)
feature_labels <- read.csv('../UCI_HAR_Dataset/features.txt', header=F, sep=' ')
attr(feature_labels, 'df_name') <- 'feature_labels'

############## TRAINING #######################
# Loading subjects. There are 7532 observations 
subjects <- read.csv('../UCI_HAR_Dataset/train/subject_train.txt', header=F, sep=' ')
names(subjects) <- 'subjects'
attr(subjects, 'df_name') <- 'subjects'

# Loading training activities. There are 7532 observations 
training_y <- read.csv('../UCI_HAR_Dataset/train/y_train.txt', header=F, sep=' ')
names(training_y) <- 'activity'
attr(training_y, 'df_name') <- 'training_y'

# Using mathing function (pgs. 47-48 Hadley Advanced R) to marry activity description names to file of activity numbers
info <- data.frame(activity_id = activity_labels$ActivityID, activity_desc = activity_labels$Activity)
id <- match(training_y$activity, info$activity_id) #info[id, 2] will give me the column with activity description names only

# Creating dataframe that will hold all training information. 
complete_training <- data.frame(subject_id = subjects$subjects, activity = info[id,2])
complete_training$phase[1:7352] <- 'training'

# Load training data
#training_X <- read.table('../UCI_HAR_Dataset/train/temp.txt', header=F) #must not use sep = (' ', ',') or the # of rows/columns will be messed up.
training_X <- read.table('../UCI_HAR_Dataset/train/X_train_original.txt', header=F) #must not use sep = (' ', ',') or the # of rows/columns will be messed up.
feature_list <- as.character(feature_labels$V2)
names(training_X) <- feature_list

# Select columns from dataframe that are related to mean and standard deviation
col.num <- which(colnames(training_X) %in% kept_features)
training_X <- training_X[,col.num]

#combining mean and std features with subject id and activity
complete_training <- cbind(complete_training, training_X)
attr(complete_training, 'df_name') <- 'complete_training' #must do this after each r/c(bind)
#print_col_row(complete_training)

############## TESTING #######################
# Loading testing subjects. There are 7532 observations 
subjects_testing <- read.csv('../UCI_HAR_Dataset/test/subject_test.txt', header=F, sep=' ') #number of rows: 2947
names(subjects_testing) <- 'subjects'
attr(subjects_testing, 'df_name') <- 'subjects_testing'
#print_col_row(subjects_testing)

# Loading testing activities. There are 2947 observations 
testing_y <- read.csv('../UCI_HAR_Dataset/test/y_test.txt', header=F, sep=' ')
names(testing_y) <- 'activity'
attr(testing_y, 'df_name') <- 'testing_y'
#print_col_row(testing_y)

# Using mathing function (pgs. 47-48 Hadley Advanced R) to marry activity description names to file of activity numbers
info_testing <- data.frame(activity_id_testing = activity_labels$ActivityID, activity_desc = activity_labels$Activity)
id_testing <- match(testing_y$activity, info_testing$activity_id_testing) #info_testing[id_testing, 2] will give me the column with activity description names only

# Creating dataframe that will hold all testing info 
complete_testing <- data.frame(subject_id = subjects_testing$subjects, activity = info_testing[id_testing,2])
complete_testing$phase[1:ncol(subjects_testing)] <- 'testing'
#print_col_row(complete_testing)

# Load testing data
testing_X <- read.table('../UCI_HAR_Dataset/test/X_test.txt', header=F) #must not use sep = (' ', ',') or the # of rows/columns will be messed up.
#testing_X <- read.table('../UCI_HAR_Dataset/test/temp.txt', header=F) #must not use sep = (' ', ',') or the # of rows/columns will be messed up.
feature_list <- as.character(feature_labels$V2)
names(testing_X) <- feature_list

# Select columns from dataframe that are related to mean and standard deviation
col.num <- which(colnames(testing_X) %in% kept_features)
testing_X <- testing_X[,col.num]
#names(testing_X)

#combining mean and std features with subject id and activity
complete_testing <- cbind(complete_testing, testing_X)
attr(complete_testing, 'df_name') <- 'complete_testing' #must do this after each r/c(bind)
#print_col_row(complete_testing)

complete_df <- rbind(complete_testing, complete_training)
attr(complete_df, 'df_name') <- 'complete_df' #must do this after each r/c(bind)
#print_col_row(complete_df)
complete_mean <- data.frame()

for (i in 1:30)
{
	for (a in factor(unique(unlist(activity_labels$Activity, use.names = FALSE))))
	{
		temp <- data.frame()
		temp <- complete_df[complete_df$subject_id == i & complete_df$activity == a, ]
		temp2 <- data.frame()
		temp2 <- ddply(temp, .(activity), numcolwise(mean))
		complete_mean <- rbind(complete_mean, temp2)
	}
}
	
complete_mean[] <- lapply(complete_mean, function(x) {if (is.numeric(x)) round(x, 4) else x}) #round values to 4 digits IF numeric
write.table(complete_mean, file='tidy_project_data.txt', row.name=F, sep=' ', na='NA') #print(temp)
