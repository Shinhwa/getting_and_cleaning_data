## Getting and Clearning Data Course Project

## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

######## Step 1 -- Merges the training and the test sets to create one data set  ########

# reading from train folder

x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# reading from test folder

x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# reading features and acitivity lables

features <- read.table("./UCI HAR Dataset/features.txt")
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")

# merging data

x <- rbind(x_train, x_test) # 10299 * 561
y <- rbind(y_train, y_test) # 10299 * 1
subject <- rbind(subject_train, subject_test) # 10299 * 1
mergedData <- x
mergedData$y <- y
mergedData$subject <- subject
dim(mergedData)
names(mergedData)

######## Step 2 -- Extracts only the measurements on the mean and stdev for each measurement  ########

names(features) <- c("column", "Measure")
isMeanSTD <- grep("mean\\(\\)|std\\(\\)", features$Measure)
extractedData <- mergedData[isMeanSTD]
extractedData$y <- as.matrix(y)
extractedData$subject <- as.matrix(subject)
names(extractedData)


######## Step 3 -- Uses descriptive activity names to name the activities in the data set  ########

activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity[, 2] <- tolower(gsub("_", ".", activity[, 2]))
activityLabel <- activity[y[, 1], 2]    # 10299 * 1
extractedData$y <- activityLabel


######## Step 4 -- Appropriately labels the data set with descriptive variable names  ########

labeledData <- extractedData
colnames(labeledData) <- c(gsub("[-\\(\\)]", "", features[["Measure"]][isMeanSTD]), "Activity.Label", "subject")
names(labeledData) <- gsub("mean", "Mean", names(labeledData))
names(labeledData) <- gsub("std", "Std", names(labeledData))

dim(labeledData)  # 10299 * 68
names(labeledData)
head(labeledData)

write.csv(labeledData, "./UCI HAR Dataset/labeled_Data.txt")

######## Step 5 -- creates a second, independent tidy data set with the average of each variable for each activity and each subject  ########

tidyData <- labeledData
tidyData$category <- interaction(labeledData$subject, labeledData$Activity.Label)

fac <- factor(tidyData$category)
as.factor(tidyData$category)
tapply(tidyData, tidyData$category, mean)

result <- data.frame(t(rep(NA, length(colnames(tidyData)))))
names(result) <- colnames(tidyData)
result <- result[-1, ]
tmp <- data.frame()

for (f in levels(tidyData$category)) {
    tmp <- subset(tidyData, as.character(tidyData$category) == as.character(f))
    newRow <- data.frame(t(apply(tmp[, 1:66], 2, mean)))
    newRow <- cbind(tmp[1, 67:68], newRow[1, 1:66])
    result <- rbind(result, newRow)
}

write.table(result, sep = ",", "./UCI HAR Dataset/tidy_data.txt", row.names = FALSE)
