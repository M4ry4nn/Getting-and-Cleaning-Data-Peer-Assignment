## download files
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, "data.zip")
unzip("data.zip")


##  Merge the training and the test sets to create one data set.
##  Use descriptive activity names to name the activities in the data set
##  Appropriately labels the data set with descriptive variable names. 

library(dplyr)

        ## Merge the Subject Numbers by rows "subject_train.txt" and "subject_test.txt", store the result in a new data frame and name the Column "subjectNO"

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", quote="\"", stringsAsFactors=FALSE)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", quote="\"", stringsAsFactors=FALSE)
subject_all <- bind_rows(subject_train, subject_test)
colnames(subject_all) <- "subjectNO"
View (subject_all)
        
        ## Merge the Activity Numbers by rows "y_train.txt" and "y_test.txt",assign the "activity_labels.txt",store in a new data frame and name the columns "activityNO" and "activity"

y_train <- read.table("UCI HAR Dataset/train/y_train.txt", quote="\"", stringsAsFactors=FALSE)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", quote="\"", stringsAsFactors=FALSE)
y_all <- bind_rows(y_train, y_test)

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", quote="\"", stringsAsFactors=FALSE)
lable_factor <- as.factor(activity_labels$V2)
y_all$V2 <- factor(y_all$V1, levels=c(1,2,3,4,5,6), labels = lable_factor)

colnames(y_all)= c("activityNO","activity")
View (y_all)

        ## Merge the measurements by rows "x_train.txt" and "x_test.txt",store in a new data frame called "x_all" and name the columns with "features.txt" 

x_train <-read.table("UCI HAR Dataset/train/X_train.txt", quote="\"", stringsAsFactors=FALSE)
x_test <-read.table("UCI HAR Dataset/test/X_test.txt", quote="\"", stringsAsFactors=FALSE)
x_all <- bind_rows(x_train, x_test)
        
features <- read.table("UCI HAR Dataset/features.txt", quote="\"", stringsAsFactors=FALSE)
View(features)
names(x_all)=features$V2
View(x_all)
        
        ## Merge the new data frames to a new data frame by columns

entire_data <-cbind(subject_all,y_all,x_all)
View(entire_data)


## Extract the measurements on the mean and standard deviation for each measurement. 

extracted_data <- entire_data[,grep("subjectNO|activityNO|activity|.*mean.*|.*std.*",names(entire_data),value=TRUE)]
View(extracted_data)
write.table(extracted_data, file="tidy_data.txt", row.names = FALSE)

## Create a second, independent tidy data set with the average of each variable for each activity and each subject

secondframe <- aggregate(extracted_data[,4:82], by = list(extracted_data$subjectNO, extracted_data$activity), FUN = mean)
colnames(secondframe)[1:2] <- c("subjectNO", "activity")
View(secondframe)
write.table(secondframe, file="second_tidy_data.txt", row.names = FALSE)
