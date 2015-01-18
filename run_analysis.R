##########################################
# This portion sets up the necessary     #
# files and packages for the assignment. #
##########################################

# Requires the appropriate files.
library(data.table)
library(reshape2)

# Downloads file.
x <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
y <- "./UCI HAR Dataset.zip"
download.file(x, y)

# Unzips, then lists zipped contents in a list.
unzip(y)
listoffiles <<- unzip(y, list=T)

###############################################
# Training data is loaded into RStudio  here. #
###############################################

# Loads variable names first to prepare for merging.
dataheaders <- read.table(listoffiles$Name[2], sep="", colClasses = "character")

# Then loads subject codes.
trainsubject <- read.table(listoffiles$Name[30])

# Loads activity label, then links it to activity attribute name.
trainlabeltemp <- read.table(listoffiles$Name[32])
activitynames <- read.table(listoffiles$Name[1], sep="")
trainlabel <- merge(trainlabeltemp, activitynames)

# Loads full training dataset.
traindata <- read.table(listoffiles$Name[31], sep = "", header=F)

# Renames full dataset column names.
setnames(traindata, names(traindata), dataheaders[,2])

# Binds trainsubject, trainlabel and traindata together, then renames trainsubject and trainlabel.
fulltraindata <- cbind(trainsubject, trainlabel, traindata)

##########################################
# Test data is loaded into RStudio here. #
##########################################

# Loads test data subjects.
testsubject <- read.table(listoffiles$Name[16])

# Loads activity label, and links it to the activity attribute names.
testlabeltemp <- read.table(listoffiles$Name[18])
testlabel <- merge(testlabeltemp, activitynames)

# Loads full training dataset.
testdata <- read.table(listoffiles$Name[17], sep = "", header=F)

# Renames full dataset column names.
setnames(testdata, names(testdata), dataheaders[,2])

###############################################
# Test and training data are merged together. #
###############################################

# Binds trainsubject, trainlabel and traindata together, then renames trainsubject and trainlabel.
fulltestdata <- cbind(testsubject, testlabel, testdata)

# Binds training dataset and test dataset together.
fulldata <- rbind(fulltraindata,fulltestdata)
colnames(fulldata)[1:3] <- c("Subject", "Label", "Activity")

##############################################
# Only data with means and SD are subsetted. #
##############################################

# Finds and subsets data with "mean" and "std" in their column names.
selectedcolumn <- grep(".*mean.*|.*std.*", names(fulldata))
selecteddataset <- fulldata[,c(1, 2,3, selectedcolumn)]

###############################################
# Data is tidied, then written into tidy.txt. #
###############################################

# Finally, creates a tidy dataset with means of variable by subject and activity, and writes to a .txt file named "tidy.txt"
df_melted <- melt(selecteddataset, id = c("Subject", "Label", "Activity"))
tidy <- dcast(df_melted, Subject + Label + Activity ~ variable, mean)
write.table(tidy, "./tidy.txt", row.name=FALSE)
