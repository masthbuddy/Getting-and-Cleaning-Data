
## This is the solution to the Getting and Cleaning Data Course Project of the 
## DataScience Specialisation in Coursera.

## The library 'dplyr' is needed to use some of the functions in the code below.
library(dplyr)


## Load train, test , subject and activity datasets into tables

sub_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
features_data <- read.table("UCI HAR Dataset/features.txt")
activity_names <- read.table("UCI HAR Dataset/activity_labels.txt")


## Merging the train and test datasets 
x_data <- rbind(x_train,x_test)
y_data <- rbind(y_train,y_test)
sub_data <- rbind(sub_train,sub_test)


## The datsets have no header names. 
## Generating them using the features file for x_data and manually for other tables
colnames(x_data) <- features_data[,2]
colnames(y_data) <- "activity_id"
colnames(sub_data) <- "subject_id"
colnames(activity_names) <- c("act_id","activity_name") 

## Selecting the required feature names corresponding to mean and std
## For achieving the above, making use of grep and general expressions
## by value = TRUE, the function returns the names of the features
mean_std_feature_names <- grep("(mean|std)", names(x_data), value = TRUE)

## filtering the x_data by only the required features
mean_std_x_data <- x_data[mean_std_feature_names]

## Generating complete dataset by adding 'subject_id' and 'activity_id' features to 'x_data'
all_data <- cbind(sub_data,mean_std_x_data,y_data)

## Inner Join with activity_names to generate the descriptive names of activities.
## Joined on the column 'activity_id' in x_data and 'act_id' in activity_names.
all_data_descriptive <- inner_join(all_data,activity_names,by = c("activity_id" = "act_id"))

## Activity_id is not needed as Activity_name is already added
all_data_descriptive <- select(all_data_descriptive,-activity_id)

## Grouping Data by subject_id and activity_name
group_data <- group_by(all_data_descriptive,subject_id,activity_name)

## finding the mean of the features on grouped data
group_mean_data <- summarise_each(group_data, funs(mean))

## Writing the final tidy averaged feature data into the file 'group_mean_tidy_data.txt'
write.table(group_mean_data,"group_mean_tidy_data.txt",row.names = FALSE)








