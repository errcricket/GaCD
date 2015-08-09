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
###training_X <- read.table('temp', header=F)
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

#write.table(complete_training, file='tidy_project_data.txt', row.name=FALSE, sep=',', na='NA')

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
print_col_row(complete_df)
#write.table(complete_df, file='tidy_project_data.txt', row.name=F, sep=' ', na='NA')
#attach(complete_df)
#col.keep <- which(colnames(complete_df) %in% kept_features)
complete_mean <- data.frame()

#kept_features <- factor(unique(unlist(desired_features$saved_features, use.names = FALSE)))
#  ActivityID           Activity
#1          1            WALKING
#2          2   WALKING_UPSTAIRS
#3          3 WALKING_DOWNSTAIRS
#4          4            SITTING
#5          5           STANDING
#6          6             LAYING

start = 0
end = 0
for (i in 1:30)
{
	for (a in factor(unique(unlist(activity_labels$Activity, use.names = FALSE))))
	{
		temp <- data.frame()
		print(a)
		#temp <- complete_df[complete_df$subject_id == i & complete_df$activity == a]
		#print(temp)
		#complete_mean <- rbind(complete_mean, temp)
	}
	#print(temp)
	#print(ddply(temp, .(activity), numcolwise(mean)))
	#print(str(ddply(temp, .(activity), numcolwise(mean))))
#	start <- end + 1
#	end <- ncol(activity_labels) + start - 1 #ncol(activity_labels) = 6
#	complete_mean[start:end, ] <- ddply(temp, .(activity), numcolwise(mean))
	#print(sapply(temp[, 4:82], mean, na.rm=TRUE))
	#print(ddply(complete_df, .(activity), summarize))
}
	
#complete_mean
#write.table(complete_mean, file='tidy_project_data.txt', row.name=F, sep=' ', na='NA') #print(temp)
#ddply(complete_df, .(subject_id, activity), summarize)
#write.table(split(complete_df, list(complete_df$subject_id, complete_df$activity)), file='split_data.txt', row.name=F, sep=' ', na='NA')
#by(complete_df[, 4:82], subject_id, activity, colMeans)
#complete_subjects <- data.frame()
#complete_subjects <- split(complete_df, as.factor(complete_df$activity), drop = FALSE)
#names(complete_subjects) #[1] "LAYING"             "SITTING"            "STANDING"           "WALKING"            "WALKING_DOWNSTAIRS" "WALKING_UPSTAIRS"  
#by(complete_subjects[, 4:82], activity, colMeans)
#by(complete_df[, 4:82], subject_id, colMeans)
#"subject_id"                      "activity"                        "phase"

#complete_df

#write.table(complete_training, file='tidy_project_data.txt', row.name=FALSE, sep=',', na='NA')
#write.table(split(complete_df, as.factor(complete_df$subject_id), drop = FALSE), file='tidy_project_data.txt', row.name=F, sep=' ', na='NA')
#complete_subjects <- data.frame()
#complete_subjects <- split(complete_df, as.factor(complete_df$subject_id), drop = FALSE)
#complete_activities <- split(complete_df, as.factor(complete_df$activity), drop = FALSE)
#write.table(complete_activities, file='tidy_project_data.txt', row.name=F, sep=' ', na='NA')
#complete_activities
#complete_subjects
#mean_df <- lapply(complete_df[, 4:82], FUN=mean, na.rm=T)
#print_col_row(complete_df)

#"subject_id"                      "activity"                        "phase" 
#selected <- names(complete_df)
#selected <- selected[-c(1, 2, 3)]
#selected
#selected <- selected[, 4:82]
#selected

#complete_avg <- sapply(complete_df[,4:79],mean, na.rm=TRUE)
#complete_avg
#complete_avg <- ddply(complete_df, .(subject_id, activity, phase), summarize, MeanGC=mean(GC, na.rm=TRUE) )
#write.table(complete_training, file='tidy_project_data.txt', row.name=FALSE, sep=',', na='NA')
