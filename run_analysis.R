#Download and unzip the data
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/assignmentdata.zip")
unzip("./data/assignmentdata.zip")

feature_label<-read.csv2("./data/UCI HAR Dataset/features.txt",header=FALSE)
feature_label2<-as.vector(t(feature_label))                                           #create a row vector with column names
test<-read.csv("./data/UCI HAR Dataset/test/X_test.txt",sep="")
colnames(test)<-feature_label2
test_activity_label<-read.csv("./data/UCI HAR Dataset/test/y_test.txt",sep="",col.names="activity")
test_sub_label<-read.csv("./data/UCI HAR Dataset/test/subject_test.txt",sep="",col.names="subject")
test2<-cbind(test_sub_label,test_activity_label,test)                                 #combime the activity, subject, and activity data for test

train<-read.csv("./data/UCI HAR Dataset/train/X_train.txt",sep="")
colnames(train)<-feature_label2
train_activity_label<-read.csv("./data/UCI HAR Dataset/train/y_train.txt",sep="",col.names="activity")
train_sub_label<-read.csv("./data/UCI HAR Dataset/train/subject_train.txt",sep="",col.names="subject")
train2<-cbind(train_sub_label,train_activity_label,train)                             #combime the activity, subject, and activity data for train

#Merges the training and the test sets to create one data set
mergedData<-rbind(train2,test2)

#Extracts only the measurements on the mean and standard deviation for each measurement. 
mean_measurement<-mergedData[,grepl("mean",colnames(mergedData))]
std_measurement<-mergedData[,grepl("std",colnames(mergedData))]
mergedData1<-cbind(mergedData$subject,mergedData$activity,mean_measurement,std_measurement)
colnames(mergedData1)[1:2]<-c("subject","activity")

#Uses descriptive activity names to name the activities in the data set
activity_list<-read.csv("./data/UCI HAR Dataset/activity_labels.txt",sep="",header=FALSE)
colnames(activity_list)<-c("activity","activity_label")
mergedData2<-merge(activity_list, mergedData1,by.x="activity",by.y="activity")

#Appropriately labels the data set with descriptive variable names. 
#t=time, f=frequency, Acc=Accelerometer,Gyro=Gyroscope, Mag=Magnitude
colnames(mergedData2)<-gsub("tBody","timeBody",colnames(mergedData2))
colnames(mergedData2)<-gsub("tGravity","timeGravity",colnames(mergedData2))
colnames(mergedData2)<-gsub("fBody","frequencyBody",colnames(mergedData2))
colnames(mergedData2)<-gsub("fGravity","frequencyGravity",colnames(mergedData2))
colnames(mergedData2)<-gsub("Acc","Accelerometer",colnames(mergedData2))
colnames(mergedData2)<-gsub("Gyro","Gyroscope",colnames(mergedData2))
colnames(mergedData2)<-gsub("Mag","Magnitude",colnames(mergedData2))

#From the data set in step 4, creates a second, independent tidy data set with the average of 
#each variable for each activity and each subject.
library(data.table)
mergedData2$activity_subject<-paste(mergedData2$activity,mergedData2$subject,sep="_")
mergedData3<-data.table(mergedData2)
tidydata<-mergedData3[, lapply(.SD, mean), by = 'activity_subject']
tidydata2<-tidydata[,c(2,4:83),with=FALSE]
tidydata3<-merge(activity_list, tidydata2,by.x="activity",by.y="activity")
write.table(tidydata3, file = "tidydata.txt", row.names = FALSE)
