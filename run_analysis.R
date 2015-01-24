##	Tasks in hand
##	1)	Merges the training and the test sets to create one data set.
##	2)	Extracts only the measurements on the mean and standard deviation for each measurement. 
##	3)	Uses descriptive activity names to name the activities in the data set
##	4)	Appropriately labels the data set with descriptive variable names. 
##	5)	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
##
# Loading dplyr library
library(plyr)
##
# Read in the data from files
##
features     = read.table('./features.txt',header=FALSE); #imports features.txt
activityType = read.table('./activity_labels.txt',header=FALSE); #imports activity_labels.txt
subjectTrain = read.table('./train/subject_train.txt',header=FALSE); #imports subject_train.txt
xTrain       = read.table('./train/x_train.txt',header=FALSE); #imports x_train.txt
yTrain       = read.table('./train/y_train.txt',header=FALSE); #imports y_train.txt
subjectTest = read.table('./test/subject_test.txt',header=FALSE); #imports subject_test.txt
xTest       = read.table('./test/x_test.txt',header=FALSE); #imports x_test.txt
yTest       = read.table('./test/y_test.txt',header=FALSE); #imports y_test.txt

# create 'x' data set
xdata <- rbind(xTrain, xTest);

# create 'y' data set
ydata <- rbind(yTrain, yTest);

# create 'subject' data set
subjectdata <- rbind(subjectTrain, subjectTest);

# get only columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2]);

# subset the desired columns
xdata <- xdata[, mean_and_std_features];

# correct the column names
names(xdata) <- features[mean_and_std_features, 2];

# Step 3
# Use descriptive activity names to name the activities in the data set
# update values with correct activity names
ydata[, 1] <- activityType[ydata[, 1], 2];

# correct column name
names(ydata) <- "activity";


# Step 4
# Appropriately label the data set with descriptive variable names
###############################################################################

# correct column name
names(subjectdata) <- "subject";

# bind all the data in a single data set
alldata <- cbind(xdata, ydata, subjectdata);

# Step 5
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
###############################################################################

# 66 <- 68 columns but last two (activity & subject)
averagesdata <- ddply(alldata, .(subject, activity), function(x) colMeans(x[, 1:66]));

write.table(averagesdata, "averages_data.txt", row.name=FALSE);