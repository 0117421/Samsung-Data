## Local Functions to make the script more readable ##

# load test and train data and union them
# I'm adding column names from features.txt file, 
# activity info from y_XXXX.txt files, 
# and subject from subject_XXXX.txt files,
# and adding them to the data, to make easierlater operations
.mergedata <- function() {
    #get column names
    colnames <- read.table("features.txt")$V2
    
    #get test data
    X_test <- read.table("test/X_test.txt")
    #get activities for test data
    y_test <- read.table("test/y_test.txt")
    #get subjects for test data
    subject_test <- read.table("test/subject_test.txt")
    #set column names
    colnames(X_test) <- colnames
    #add activities and subject to test data
    X_test$activity <- y_test$V1
    X_test$subject <- subject_test$V1
    
    #get train data
    X_train <- read.table("train/X_train.txt")
    #get activities for train data
    y_train <- read.table("train/y_train.txt")
    #get subjects for train data
    subject_train <- read.table("train/subject_train.txt")
    #set column names
    colnames(X_train) <- colnames
    #add activities and subjects to train data
    X_train$activity <- y_train$V1
    X_train$subject <- subject_train$V1
    
    #put together test and train data
    dataset <- rbind(X_test,X_train)
    
    #return combined data
    dataset
}

#keep means and stds columns from dataset
.getmeanandstd <- function(dataset) {
    #get mean() columns
    means <- dataset[,grep("mean\\(\\)",colnames(dataset))]
    #get std() columns
    stds <- dataset[,grep("std\\(\\)",colnames(dataset))]
    #return binding of activity, subject, mean() columns and std() columns
    cbind("activity" = dataset$activity,"subject"= as.factor(dataset$subject),means,stds)
}

#replace activity ids with their names
.putactivitynames <- function(dataset) {
    #get labels from activity_labels.txt file
    activitylabels <- read.table("activity_labels.txt")
    #change column names to make the merge
    colnames(activitylabels) <- c("activity","activity_name")
    
    #merge dataset with activity_labels dataset
    md <- merge(dataset,activitylabels,by.x="activity",by.y="activity")
    
    #remove column that contains activity ids (used for the merge)
    md <- subset(md,select=-c(activity))
    
    #rename activity_name column just to activity
    colnames(md)[colnames(md) == "activity_name"] <- "activity"
    
    #return merged dataset with activity column containing the activity labels instead the ids
    md
}

#compose the tidy dataset from clean dataset
.createdataset <- function(raw_dataset) {
    #melt down dataset from subject and activity
    md <- melt(raw_dataset,id.vars=c("subject","activity"))
    #summarize dataset obtaining the mean of measure columns by subject and activity
    dmd <- dmd <- dcast(md,subject + activity ~ variable, mean)
    
    #rename columns to add _ave() suffix to all measure columns
    colnames(dmd) <- paste(colnames(dmd),"ave()",sep="_")
    colnames(dmd)[colnames(dmd) == "activity_ave()"] <- "activity"
    colnames(dmd)[colnames(dmd) == "subject_ave()"] <- "subject"
    
    #return tidy dataset
    dmd
}

## Script to create tidy_dataset following this steps:
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with
#    the average of each variable for each activity and each subject.

#import reshape2 library
library("reshape2")

# Step 1: Merge the training and the test sets to create one data set.
.raw_data <- .mergedata()

# Step 2: Extract only the measurements on the mean and standard deviation for each measurement.
.filtered_data <- .getmeanandstd(.raw_data)

# Steps 3 & 4: Use descriptive activity names to name the activities in the data set
#              Appropriately label the data set with descriptive variable names.
.named_data <- .putactivitynames(.filtered_data)

#Step 5: From the data set in step 4, creates a second, independent tidy data set with
#        the average of each variable for each activity and each subject.
tidy_dataset <- .createdataset(.named_data)

#Display the info message of operation completed.
cat("INFO: tidy_dataset created")