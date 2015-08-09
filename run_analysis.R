options(width=9999)
library(plyr)
library(reshape2)


# Get only the mean and standard deviation features from feature.txt file
#grep mean ../UCI_HAR_Dataset/features.txt | awk '{print $2}' > mean.txt
#grep std ../UCI_HAR_Dataset/features.txt | awk '{print $2}' > std.txt
#cat std.txt mean.txt > features.txt
desired_features <- read.table('features.txt', header=F)
names(desired_features) <- 'saved_features'
kept_features <- factor(unique(unlist(desired_features$saved_features, use.names = FALSE)))
#names(kept_features)

features_2 <- read.table('../UCI_HAR_Dataset/features.txt', header=F)
#features_2
kept_features2 <- grep('.*mean.* | .*std.*', names(features_2$V2))

# Loading activity labels and setting name of object to df_name 
grep(c('mean', 'std'), names(
activity_labels <- read.csv('../UCI_HAR_Dataset/activity_labels.txt', header=F, sep=' ')
names(activity_labels) <- c('ActivityID', 'Activity')

# Loading feature labels  Note: there are 561 features (columns)
feature_labels <- read.csv('../UCI_HAR_Dataset/features.txt', header=F, sep=' ')

# Loading subjects. There are 7532 observations 
subjects_training <- read.csv('../UCI_HAR_Dataset/train/subject_train.txt', header=F, sep=' ')
subjects_testing <- read.csv('../UCI_HAR_Dataset/test/subject_test.txt', header=F, sep=' ') #number of rows: 2947
names(subjects_training) <- 'subjects'
names(subjects_testing) <- 'subjects'

# Loading training activities. 
training_y <- read.csv('../UCI_HAR_Dataset/train/y_train.txt', header=F, sep=' ') # Thare 7532 observations 
testing_y <- read.csv('../UCI_HAR_Dataset/test/y_test.txt', header=F, sep=' ') # There are 2947 observations 
names(training_y) <- 'activity'
names(testing_y) <- 'activity'

#4. Appropriately labels the data set with descriptive variable names & loading training/testing data
training_X <- read.table('../UCI_HAR_Dataset/train/X_train_original.txt', header=F) #must not use sep = (' ', ',') or the # of rows/columns will be messed up.
testing_X <- read.table('../UCI_HAR_Dataset/test/X_test.txt', header=F) #must not use sep = (' ', ',') or the # of rows/columns will be messed up.
feature_list <- as.character(feature_labels$V2)
names(training_X) <- feature_list
names(testing_X) <- feature_list

#3. Uses descriptive activity names to name the activities in the data set # Using matching function (pgs. 47-48 Hadley Advanced R) to marry activity description names to file of activity numbers
info_training <- data.frame(activity_id = activity_labels$ActivityID, activity_desc = activity_labels$Activity)
info_testing <- data.frame(activity_id_testing = activity_labels$ActivityID, activity_desc = activity_labels$Activity)
id_training <- match(training_y$activity, info_training$activity_id) #info[id, 2] will give me the column with activity description names only
id_testing <- match(testing_y$activity, info_testing$activity_id_testing) #info_testing[id_testing, 2] will give me the column with activity description names only

# Creating dataframe that will hold all training/testing information. 
complete_training <- data.frame(subject_id = subjects_training$subjects, activity = info_training[id_training,2])
complete_testing <- data.frame(subject_id = subjects_testing$subjects, activity = info_testing[id_testing,2])

#2. Extracts only the measurements on the mean and standard deviation for each measurement. # Select columns from dataframe that are related to mean and standard deviation
col.num <- which(colnames(training_X) %in% kept_features)
training_X <- training_X[,col.num]
col.num <- which(colnames(testing_X) %in% kept_features) #in theory, this should be identical to previous col.num
testing_X <- testing_X[,col.num]

#combining mean and std features with subject id and activity
complete_training <- cbind(complete_training, training_X)
complete_testing <- cbind(complete_testing, testing_X)

#1. Merges the training and the test sets to create one data set. 
complete_df <- rbind(complete_testing, complete_training)

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
complete_melt <- melt(complete_df, id=c('subject_id', 'activity'))
complete_mean <- dcast(complete_melt, subject_id+activity ~ variable, mean) #c('subject_id', 'activity') does not appear to work
complete_mean[] <- lapply(complete_mean, function(x) {if (is.numeric(x)) round(x, 4) else x}) #round values to 4 digits IF numeric
write.table(complete_mean, file='tidy_project_data.txt', row.name=F, sep=' ', na='NA') #print(temp)
