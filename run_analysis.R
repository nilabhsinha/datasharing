
activity <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", header=FALSE)["V2"]
colList <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt", header=FALSE)["V2"]

# Required list of columns having mean and standard deviation info.
reqcolList <- grep("mean|std", colList$V2)

x_test <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
names(x_test) <- colList$V2
sub_test <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
names(sub_test) <- "Subject"
y_test <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
names(y_test) <- "Label"
test_data <- cbind(sub_test, y_test, subset(x_test, select = colnames(x_test)[reqcolList]))


x_train <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
names(x_train) <- colList$V2
sub_train <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
names(sub_train) <- "Subject"
y_train <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
names(y_train) <- "Label"
train_data <- cbind(sub_train, y_train, subset(x_train, select = colnames(x_train)[reqcolList]))


#Combine test and train data for required fields
combinedData <- rbind(test_data, train_data)

#Create summary dataset
summary_data <- aggregate(combinedData[,3:ncol(combinedData)],
                          list(
                            Subject=combinedData$Subject, 
                            Activity=combinedData$Label),
                          mean)

summary_data <- summary_data[order(summary_data$Subject),]

# Replace with descriptive names
summary_data$Activity <- activity[summary_data$Activity,]


# Write the tidy data as a text file
write.table(summary_data, file="./tidyActivitydata.txt", sep="\t", row.names = FALSE)
