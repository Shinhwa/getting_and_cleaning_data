
CodeBook for run_analysis.R
========================================================

## Files used in run_analysis.R
* ./UCI HAR Dataset/train/X_train.txt
* ./UCI HAR Dataset/train/y_train.txt
* ./UCI HAR Dataset/train/subject_train.txt
* ./UCI HAR Dataset/test/X_test.txt
* ./UCI HAR Dataset/test/y_test.txt
* ./UCI HAR Dataset/test/subject_test.txt
* ./UCI HAR Dataset/features.txt
* ./UCI HAR Dataset/activity_labels.txt

## Files generated in run_analysis.R
* ./UCI HAR Dataset/tidy_data.txt



## Step 1 Merge the training and the test sets to create one data set

### Variables in Step 1

* x_train, y_train, subject_train, x_test, y_test_, subject_test: directly read from txt files
* x (10299 * 561), y (10299 * 1) and subject (10299 * 1): row combine all train and test data
* mergedData: add y and subject as new columns to x (10299 * 563)
* features, activity: read from text files for future use

```{r}
# reading from train folder

x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# reading from test folder

x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# reading features and acitivity labels

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

```


## Step 2 Extract only the measurements on the mean and stdev for each measurement

### Variables in Step 2

* isMeanSTD: indices for all variable names (V1-V561) that include "mean" or "std"
* extractedData: data with desired columns, as well as "y"" and "subject" columns (10299 * 68)

```{r}
names(features) <- c("column", "Measure")
isMeanSTD <- grep("mean\\(\\)|std\\(\\)", features$Measure)
extractedData <- mergedData[isMeanSTD]
extractedData$y <- as.matrix(y)
extractedData$subject <- as.matrix(subject)
names(extractedData)
```


##Step 3 Use descriptive activity names to name the activities in the data set

### Variables in Step 3

* activityLabel: list of descriptive activity named accordingly (10299 * 1)
* extractedData: replace activity numbers [1-6] with activityLabel in "y" column (10299 * 68)

```{r}
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity[, 2] <- tolower(gsub("_", ".", activity[, 2]))
activityLabel <- activity[y[, 1], 2]    # 10299 * 1
extractedData$y <- activityLabel
```


## Step 4 Appropriately label the data set with descriptive variable names

### Variables in Step 3

* labeledData: renamed column [1:66] (eg. V1, V4, etc) with descriptive variable names, modified the last two column names, and capitlize "mean" & "std" in column names (10299 * 68)


```{r}
labeledData <- extractedData
colnames(labeledData) <- c(gsub("[-\\(\\)]", "", features[["Measure"]][isMeanSTD]), "Activity.Label", "subject")
names(labeledData) <- gsub("mean", "Mean", names(labeledData))
names(labeledData) <- gsub("std", "Std", names(labeledData))

dim(labeledData)  # 10299 * 68
names(labeledData)
head(labeledData)

write.csv(labeledData, "./UCI HAR Dataset/labeled_Data.txt")
```


## Step 5 Create a second, independent tidy data set with the average of each variable for each activity and each subject

### Variables in Step 5

* $category: added column indicating the interaction with subject and Activity.Label
* tidyData: labeledData plus $category (10299 * 69)
* tmp, newRow: temp data frame to store the means of matching $category variables
* result: the tidy dataset that needs to be exported into txt file

```{r}
tidyData <- labeledData
tidyData$category <- interaction(labeledData$subject, labeledData$Activity.Label)

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
```