# Getting and cleaning data course project






This repo includes run_analysis.R and CodeBook.md which are required documents for the Coursera Getting and cleaning data course project. The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. 



* Dataset used in this project is downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip, then unzipped into a folder called "UCI HAR Dataset". 


* A full description is available at the site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 




### run_analysis.R 

It is the R script that does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Make sure you have the entire "./UCI HAR Dataset/" folder in your working directory before running the script in R. The output of the script will also be generated in "./UCI HAR Dataset/" folder.

### CodeBook.md

It is the code book that describes all variables used in each step of run_analysis.R


