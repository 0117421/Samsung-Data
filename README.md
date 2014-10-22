---
title: "run_analysis"
author: "Hector Martin Ardanaz"
date: "Tuesday, October 21, 2014"
output: html_document
---

## Steps to obtain tidy data set
All the data in contained in the working directory, including subfolders for test and train data.

### Step 1: Merge the training and the test sets to create one data set.
Read test data file "test/X_test.txt" and add column names from "features.txt" file.
Read activities, for test data, from "test/y_test.txt" and add them to test data.
Read subjects, for test data, from "test/subject_test.txt" and add them to test data.

Read train data file "train/X_train.txt" and add column names from "features.txt" file.
Read activities, for train data, from "train/y_train.txt" and add them to train data.
Read subjects, for train data, from "train/subject_train.txt" and add them to train data.

Merge both test and train data into a unique data.frame containing the also the activities and subjects columns.

### Step 2: Extract only the measurements on the mean and standard deviation for each measurement.
Subset by name, keeping all colums containing mean() and std() in their name. Also keep actibvities and subjects columns.

### Steps 3 & 4: Use descriptive activity names to name the activities in the data set. Appropriately label the data set with descriptive variable names.
Read activity labels from "activity_labels.txt" file and merge them with the dataset to replace activity ids with the labels.

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Melt the dataset by subject and activity, and then dcast it again calculating the mean of the measure vars. Rename the columns properly to reflect that the value contained in them is the average.

## Run the script
In order to obtain the tidy dataset you have to run run\_analysis.R script through the source command: source('run\_analysis.R')
A variable named tidy_dataset is created in the workspace containing the expected dataset, and an INFO message is displayed in the console when the operation finish successfully.
