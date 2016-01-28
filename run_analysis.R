library(plyr)


var <- read.table("features.txt")
features <- as.character(var[,2])
train_data <- read.table("train/X_train.txt",stringsAsFactors = FALSE,header =FALSE)
subject_train <- read.table("train/subject_train.txt",header=FALSE)
train_data <- cbind(train_data,subject_train)
activity <- read.table("activity_labels.txt",header = FALSE)
train_lable <- read.table("train/y_train.txt",header = FALSE)
train_data <- cbind(train_data,train_lable)
features <- append(features,c("subject","activity"))
names(train_data) <- features

test_data <- read.table("test/X_test.txt",stringsAsFactors = FALSE,header =FALSE)
subject_test <- read.table("test/subject_test.txt",header=FALSE)
test_data <- cbind(test_data,subject_test)
test_lable <- read.table("test/y_test.txt",header = FALSE)
test_data <- cbind(test_data,test_lable)
names(test_data) <- features

data <- rbind(train_data,test_data)

x <- grep("mean|std",features)


data_mean_std <- data[,x]
data_mean_std <- cbind(data_mean_std,data$activity)

names(data_mean_std)[names(data_mean_std)=="data$activity"] <- "activity"
data_mean_std$activity <- as.factor(data_mean_std$activity)
data_mean_std$activity <-  revalue(data_mean_std$activity, c("1"="WALKING",
                                  "2"="WALKING_UPSTAIRS",
                                  "3"="WALKING_DOWNSTAIRS",
                                  "4" =  "SITTING",
                                  "5" = "STANDING",
                                  "6"= "LAYING"))


names(data_mean_std) <- gsub("^t","time",names(data_mean_std))
names(data_mean_std) <- gsub("^f","frequency",names(data_mean_std))
names(data_mean_std) <- gsub("Acc","accelerometer",names(data_mean_std))
names(data_mean_std) <- gsub("Gyro","gyroscope",names(data_mean_std))

data_mean_std<-cbind(data_mean_std,data$subject)
names(data_mean_std)[names(data_mean_std)=="data$subject"] <- "subject"

new_data <- data_mean_std %>%
            group_by(subject,activity) %>%
            summarize_each(funs(mean))
