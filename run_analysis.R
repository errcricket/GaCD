options(width=9999)

#Download zip file. The contents of the directory will be used for this project, & downloading needs to be done only once.
downloadFILE <- function()
{
	fileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2F../UCI%20HAR%20Dataset.zip'
	download.file(fileURL, destfile='smartPhoneData.csv.zip', method='curl')
	dataDownloaded <- date()
}

#downloadFILE()

# Loading activity labels
activity_labels <- read.csv('../UCI_HAR_Dataset/activity_labels.txt', header=F, sep=' ')
#names(activity_labels) <- c('ActivityID', 'Activity')
#print(activity_labels)

feature_labels <- read.csv('../UCI_HAR_Dataset/features.txt', header=F, sep=' ')
#feature_labels
#features <- unique(unlist(feature_labels$V2, use.names = FALSE))
#features

subjects <- read.csv('../UCI_HAR_Dataset/train/subject_train.txt', header=F, sep=' ')
names(subjects) <- 'subjects'
#print(subjects)
#print(nrow(subjects))
#print(ncol(subjects))

training_y <- read.csv('../UCI_HAR_Dataset/train/y_train.txt', header=F, sep=' ')
names(training_y) <- 'activity'
#print(names(training_y))
#print(c('col', ncol(training_y)))
#print(c('row', nrow(training_y)))


info <- data.frame(activity_id = 1:6, desc = c('WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 'SITTING', 'STANDING', 'LAYING'))
id <- match(training_y$activity, info$activity_id)

training <- data.frame(subject_id = subjects$subjects, activity = info[id,])
names(training) <- c('subject_id', 'activity_id', 'activity_desc')
#ncol(training)
#nrow(training)
#names(training)
#training

# Load training data
training_X <- read.table('temp', header=F)
#training_X <- read.table('../UCI_HAR_Dataset/train/X_train_original.txt', header=F) #, sep=' ', fill=F) # Error in scan(file, what, nmax, sep, dec, quote, skip, nlines, na.strings,  : line 2 did not have 662 elements
#feature_list <- as.list(feature_labels$V2)
feature_list <- as.character(feature_labels$V2)
#as.character(feature_list[1,])
#feature_list

#names(training_X)

#for (i in 1:nrow(feature_labels))
#{
#	#print(feature_labels$V2[[i]])
#	names(training_X[, i]) <- feature_labels$V2[[i]]
#	#print(i)
#}
#
names(training_X) <- feature_list
names(training_X)


#for (t in 1:training_X[, 
#print(c('number of columns', ncol(training_X)))
#print(c('number of rows', nrow(training_X)))
#pr

#count = 1
#for (f in feature_labels$V2)
#{
#	#print(f)
#	f
	
#}
#print(training_X)
#print(class(training_X[1, ]))
#ncol(training_X[1, ])
