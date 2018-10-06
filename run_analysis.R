##Import Libraries require for this project

packages <- c("data.table", "reshape2")
sapply(packages, require, character.only = TRUE, quietly = TRUE)

##Get Data
# download zip file containing data if it hasn't already been downloaded
filename <- "getdata_dataset.zip"
if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
}


# Fetch Activities and Features data
activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt")

#add descriptive names, rather than V1 & V2
names(activity_labels)<-c("Activity.Id","Activity")

feature_list<-read.table("UCI HAR Dataset/features.txt")


#######################
####READ TEST DATA#####
#######################
# Read the test subject file per observation
test_subjects<-read.table("UCI HAR Dataset/test/subject_test.txt")

# Rename it to Subject.Id
names(test_subjects)<-"Subject.Id"

# Read features file for test data
test_dataset<-read.table("UCI HAR Dataset/test/X_test.txt")

# Label the test_dataset with descriptive variable from the feature_list
names(test_dataset)<-feature_list$V2

# Read activities from Ytest file
test_activities<-read.table("UCI HAR Dataset/test/Y_test.txt")

# Rename the column name of test_activities
names(test_activities)<-"Activity.Id"

# Bind the test data set per observations
testset<-cbind(test_subjects,test_dataset,test_activities)

# Take only columns that include the word mean, std and Subject.Id, Activity.Id
sliced_testset <<- testset[,grepl("Subject.Id|Activity.Id|mean\\(\\)|std\\(\\)",colnames(testset))]

# Add descriptive activity names to the activities in the test data set
final_testset<-merge(sliced_testset,activity_labels,all=TRUE)


#######################
####READ TRAIN DATA####
#######################
# Read the train subject file per observation
train_subjects<-read.table("UCI HAR Dataset/train/subject_train.txt")

# Rename it to Subject.Id
names(train_subjects)<-"Subject.Id"

# Read features file for test data
train_dataset<-read.table("UCI HAR Dataset/train/X_train.txt")

# Label the train_dataset with descriptive variable from the feature_list
names(train_dataset)<-feature_list$V2

# Read activities from Ytrain file
train_activities<-read.table("UCI HAR Dataset/train/Y_train.txt")

# Rename the column name of train_activities
names(train_activities)<-"Activity.Id"

# Bind the train data set per observations
trainset<-cbind(train_subjects,train_dataset,train_activities)

# Take only columns that include the word mean, std and Subject.Id, Activity.Id
sliced_trainset <<- trainset[,grepl("Subject.Id|Activity.Id|mean\\(\\)|std\\(\\)",colnames(trainset))]

# Add descriptive activity names to the activities in the train data set
final_trainset<-merge(sliced_trainset,activity_labels,all=TRUE)

# Merge the Test and Train data sets
data<-merge(final_testset,final_trainset,all=TRUE)

#creates a second, independent tidy data set with the average of each variable for each activity and each subject

# First we melt the data set in order to produce a casted table on multiple columns later on.
# we melt the data set on all value conserving as ids (Subject.Id and Activity)

# take the column names which will be aggregated
average_columns<-colnames(data[,3:68])

#melt the data
melted_data<- melt(data,id=c("Subject.Id","Activity"),measure.vars=average_columns)

#now cast the melted data set to produce the tidy dataset
tidy_dataset <- dcast(melted_data, Subject.Id + Activity ~ variable, mean)

#Finally, create Tidydata file contained cleanup data/observations
write.table(tidy_dataset, file = "Tidydata.txt", row.names= FALSE)