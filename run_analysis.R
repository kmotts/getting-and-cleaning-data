# The purpose of this project is to demonstrate your ability to collect, work with, 
# and clean a data set. The goal is to prepare tidy data that can be used for later 
# analysis. You will be graded by your peers on a series of yes/no questions related 
# to the project. You will be required to submit: 
# 1) a tidy data set as described below, 
# 2) a link to a Github repository with your script for performing the analysis, and 
# 3) a code book that describes the variables, the data, and any transformations or 
# work that you performed to clean up the data called CodeBook.md. You should also 
# include a README.md in the repo with your scripts. This repo explains how all of 
# the scripts work and how they are connected.

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



# set up R environment ####
# clear environment #
rm(list=ls())  # Clears all variables
cat('\014')    # Clears console

setwd('c:\\users\\kmatsumura\\dropbox\\data\\R\\Getting and Cleaning Data')


# merge training and test sets ####

# load two data sets 
train_data <- read.table('./data/UCI HAR Dataset/train/X_train.txt', header=F)
test_data <- read.table('./data/UCI HAR Dataset/test/X_test.txt', header=F)

# label columns by feature
features <- read.table('./data/UCI HAR Dataset/features.txt', header=F)
names(train_data) <- features[,2]
names(test_data) <- features[,2]

# add column for activity
activity <- read.table('./data/UCI HAR Dataset/activity_labels.txt', header=F)

train_labels <- read.table('./data/UCI HAR Dataset/train/y_train.txt', header=F)
train_data['activity'] <- activity[train_labels[,1],2]

test_labels <- read.table('./data/UCI HAR Dataset/test/y_test.txt', header=F)
test_data['activity'] <- activity[test_labels[,1],2]


# add column for subject
train_subject <- read.table('./data/UCI HAR Dataset/train/subject_train.txt', header=F)
train_data['subject'] <- train_subject

test_subject <- read.table('./data/UCI HAR Dataset/test/subject_test.txt', header=F)
test_data['subject'] <- test_subject

# remove label (features), activity, and subject data
rm(list=c('features', 'activity', 'train_subject', 'test_subject', 'train_labels', 'test_labels'))

# combine data sets and sort by subject
data <- rbind(train_data, test_data)
data <- data[order(data$subject),]
table(data$subject)


# get means and standard deviations by measurement ####

headings.mean <- grep('mean[(]', names(data), value=T)
headings.std <- grep('std[(]', names(data), value=T)

data.mean <- data[,headings.mean]
data.std <- data[,headings.std]

names(data.mean) <- gsub('-mean[(][)]', '', names(data.mean))
names(data.std) <- gsub('-std[(][)]', '', names(data.std))


# name activities ###############
# we did this in the test and train data sets already

# get average values by activity and subject

activity <- levels(data$activity)
tidydata <- {}

pdf('mean_parameter_by_activity.pdf', w=11, h=8.5)
layout(matrix(c(1:7, 7), ncol=4, byrow=T))
for(i in 1:(dim(data)[2]-2)){
    
    subdata <- split(data[,i], list(data$subject, data$activity))
    m <- sapply(subdata, mean)
    for(j in 1:6){
        a <- m[grep(activity[j], names(m))]
        min <- min(m)
        max <- max(m)
        main <- activity[j]
        ylab <- paste('mean', names(data)[i])
        plot(c(1:30), a[1:30], pch=20, xlab='subject', ylab=ylab, main=main, ylim=c(min,max))
        
        activitydata <- data.frame(subject=1:30, activity=main, parameter=names(data)[i], mean=a)
        rownames(activitydata) <- c()
        tidydata <- rbind(tidydata, activitydata)
    }
    
    boxplot(split(m, gsub('[0-9]+.', '', names(m))), range=0, main=names(data)[i])
    
}
dev.off()
write.csv(tidydata, './data/UCI HAR Dataset/mean_by_subject_activity_parameter.csv', quote=F, row.names=F)
