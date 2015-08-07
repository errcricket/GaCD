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
names(activity_labels) <- c('ActivityID', 'Activity')
print(activity_labels)

subjects <- read.csv('../UCI_HAR_Dataset/train/subject_train.txt', header=F, sep=' ')
names(subjects) <- 'subjects'
print(subjects)
#print(nrow(subjects))
#print(ncol(subjects))

training_y <- read.csv('../UCI_HAR_Dataset/train/y_train.txt', header=F, sep=' ')
names(training_y) <- 'activity'
print(names(training_y))
#print(c('col', ncol(training_y)))
#print(c('row', nrow(training_y)))


info <- data.frame(activity_id = 1:6, desc = c('WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 'SITTING', 'STANDING', 'LAYING'))
id <- match(training_y$activity, info$activity_id)

training <- data.frame(subject_id = subjects$subjects, activity = info[id,])
names(training) <- c('subject_id', 'activity_id', 'activity_desc')
#ncol(training)
#nrow(training)
#names(training)

# Load training data
training_X <- read.table('../UCI_HAR_Dataset/train/X_train_original.txt', header=F) #, sep=' ', fill=F) # Error in scan(file, what, nmax, sep, dec, quote, skip, nlines, na.strings,  : line 2 did not have 662 elements
print(c('number of columns', ncol(training_X)))
print(c('number of rows', nrow(training_X)))
#print(training_X)
#print(class(training_X[1, ]))
#ncol(training_X[1, ])

num_obs = 1 #7352
num_columns = 662
temp <- data.frame(x = as.character())
#print(temp)
#print(names(training_X))
# function to split alleles of one observation (one row)
#split_allele <- function(allele) 
#{
#    unlist(strsplit(allele, split = " "))
#}
#
#for (i in 1:num_obs) {
#    temp[i, ] = split_allele(training_X[i, ])
#}


split_rows <- function()
{
	for (n in nrow(training_X))
	{
		s <- strsplit(as.character(training_X[n, ]), ' ')
		count = 1
		for (i in s)
		{
			temp[n, count] <- as.numeric(i)
			count = count+1
		#	print(s)
	#		print(n)
		}
	}
}
#split_rows()

temp
#for (i in s)
#{
#	#print(i) #	temp$X[, count] <- i
#	temp[1, count] <- as.numeric(i)
#	count = count+1
#}

#split_allele(training_X[1,])
# Load testing data
#testing <- read.csv('../UCI_HAR_Dataset/test/X_test.txt', header=F, sep=' ')
#print(length(testing))

	########Read in csv file
#	myDF_ <- read.csv('americanCommunitySurvey.csv', header=TRUE, sep=',')

	########Determine how many properties are worth $1,000,000 or more. This corresponds to an int value of 24 in the VAL column
	#print(class(myDF_1$VAL)) #verify class of VAL column

#j	complete <- myDF_1[complete.cases(myDF_1$VAL),]
#	millionPlus <- complete[complete$VAL == 24, ]
#	print(millionPlus$VAL)
#	length(millionPlus$VAL)
#}


#Question 2: Use the data you loaded from Question 1. Consider the variable FES in the code book. Which of the 'tidy data' principles does this variable violate

Q2 <- function()
{
	myDF_2 <- read.csv('americanCommunitySurvey.csv', header=TRUE, sep=',')
	print(myDF_2$FES)
	#I think the issue is that .N/A represents missing values as per pdf instructions, but there are NAs as missing values (,,) so it is not consistent.
#	print(class(myDF_2$FES))
#	print(typeof(myDF_2$FES))
#	print(str(myDF_2$FES))
}
#Q2()
	
#Question 3 Read rows 18-23 and columns 7-15 into R and assign the result to a variable called: dat.  What is the value of:  sum(dat$Zip*dat$Ext,na.rm=T) #Download the Excel spreadsheet on Natural Gas Aquisition Program here: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx

Q3 <- function()
{
	library(xlsx)
	fileURL_3 <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx'
	download.file(fileURL_3, destfile='naturalGasAquisition.xlsx', method='curl')
	rowIndex <- 18:23
	colIndex <- 7:15
	dat <- read.xlsx('naturalGasAquisition.xlsx', sheetIndex=1, colIndex=colIndex, rowIndex=rowIndex)
	#names(dat)
	print(sum(dat$Zip*dat$Ext,na.rm=T))
	#dat
}

#Q3()

#Question 4: Read the XML data on Baltimore restaurants from here: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml
#How many restaurants have zipcode 21231? 

Q4 <- function()
{
	library(XML)

	downloadFile_4 <- function()
	{
		fileURL_4 <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml'
		download.file(fileURL_4, destfile='baltimoreRestaurants.xml', method='curl')
		dataDownloaded <- date()
	}
	
#	downloadFile_4()
	
	doc <- xmlTreeParse('baltimoreRestaurants.xml', useInternal=TRUE)
	rootNode <- xmlRoot(doc)
	xmlName(rootNode)
#	print(length(names(rootNode)))

	#print(rootNode[1])
#	print(xmlSApply(rootNode, xmlValue))
	zipC <- xpathSApply(rootNode, '//zipcode', xmlValue)
	matchingC <- zipC[zipC=='21231']
	print(length(matchingC))
}

#Q4()

#Question 5: The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv

#using the fread() command load the data into an R object DT 

#Which of the following is the fastest way to calculate the average value of the variable pwgtp15 

Q5 <- function()
{
	library(data.table)

	########Download file and time of download
	downloadFILE_5 <- function()
	{
		fileURL_5 <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv'
		download.file(fileURL_5, destfile='idahoHousing.csv', method='curl')
		dataDownloaded <- date()
	}

	#downloadFILE_5()

	########Read in csv file
	DT <- fread('idahoHousing.csv', header=TRUE, sep=',')
#	print(names(DT))
#	system.time(rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2])
	system.time(print(sapply(split(DT$pwgtp15,DT$SEX),mean)))
	#system.time(mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15))
	#system.time(mean(DT$pwgtp15,by=DT$SEX))
	#system.time(DT[,mean(pwgtp15),by=SEX])
	system.time(print(tapply(DT$pwgtp15,DT$SEX,mean)))
	#print(DT$pwgtp15)
	print(DT[,mean(pwgtp15),by=SEX])
	system.time(DT[,mean(pwgtp15),by=SEX])
#
#	########Determine how many properties are worth $1,000,000 or more. This corresponds to an int value of 24 in the VAL column
#	#print(class(myDF_1$VAL)) #verify class of VAL column
#
#	complete <- myDF_1[complete.cases(myDF_1$VAL),]
#	millionPlus <- complete[complete$VAL == 24, ]
##	print(millionPlus$VAL)
#	length(millionPlus$VAL)
}

#Q5()
