library(dplyr)


if(!file.exists("./data")){dir.create("./data")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
unzip(zipfile="./data/Dataset.zip",exdir="./data")
}

path <- file.path("./data" , "UCI HAR Dataset")

# read in the files
x_test  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
x_train <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)
y_test  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
y_train <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)
sub_test  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)
sub_train <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
feat_names <- read.table(file.path(path, "features.txt"),head=FALSE)[,2]
activities <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)

#combine the test and train sets

x <- rbind(x_train,x_test)
y <- rbind(y_train,y_test)
subject <- rbind(sub_train,sub_test)

# fix up the activities by doing a left_join

y <- select(left_join(y,activities),2)

#set the column names

colnames(x) <- feat_names
colnames(y) <- c("activity")
colnames(subject) <- c("subject")

# set the appropriate columns from the x dataset

x<-x[,grep("meaxn\\(|std\\(",feat_names)]
colnames(x)<-sub("Acc", "Accelerometer", colnames(x))
colnames(x)<-sub("Gyro", "Gyroscope", colnames(x))
colnames(x)<-sub("Mag", "Magnitude", colnames(x))
colnames(x)<-sub("^t", "Time", colnames(x))
colnames(x)<-sub("^f", "Frequency", colnames(x))
colnames(x)<-sub("BodyBody", "Body", colnames(x))
colnames(x)<-sub("\\(\\)","",colnames(x))
colnames(x)<-sub("-mean","Mean",colnames(x))
colnames(x)<-sub("-std","Std",colnames(x))
colnames(x)<-sub("-","",colnames(x))

# combine up the dataframes into our master datagrame

dataset <- cbind(x,subject,y)

write.table(dataset,"tidyDataset1.txt",row.name=FALSE)

#  now we create our new second tidy dataset using dplyr

dataset2 <- group_by(dataset,subject,activity)
dataset2 <- summarise_each(dataset2,funs(mean))
colnames(dataset2) <- paste(colnames(dataset2),"Mean",sep = "")
colnames(dataset2)[1:2] <- c("subject","activity")
write.table(dataset,"tidyDataset2.txt",row.name=FALSE)
