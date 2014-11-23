#Creates temp directory to download zipped file
td <- tempdir()
tf <- tempfile(tmpdir=td, fileext=".zip")

#Downloads file into temmp directory
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", tf)

#Unzips file into temp
unzip(tf, exdir=td, overwrite=TRUE)

#Reading test and training sets
training = read.csv(filepath[27], sep="", header=FALSE)
training[,562] = read.csv(filepath[28], sep="", header=FALSE)
training[,563] = read.csv(filepath[26], sep="", header=FALSE)

testing = read.csv(filepath[15], sep="", header=FALSE)
testing[,562] = read.csv(filepath[16], sep="", header=FALSE)
testing[,563] = read.csv(filepath[14], sep="", header=FALSE)

#Read header labels
activityLabels = read.csv(filepath[1], sep="", header=FALSE)

#Adjusts features
features = read.csv(filepath[2], sep="", header=FALSE)
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

# Merge training and test sets together
allData = rbind(training, testing)

# Get only the data on mean and std. dev.
colsWeWant <- grep(".*Mean.*|.*Std.*", features[,2])

# First reduce the features table to what we want
features <- features[colsWeWant,]
# Now add the last two columns (subject and activity)
colsWeWant <- c(colsWeWant, 562, 563)
# And remove the unwanted columns from allData
allData <- allData[,colsWeWant]
# Add the column names (features) to allData
colnames(allData) <- c(features$V2, "Activity", "Subject")
colnames(allData) <- tolower(colnames(allData))

currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
  allData$activity <- gsub(currentActivity, currentActivityLabel, allData$activity)
  currentActivity <- currentActivity + 1
}

allData$activity <- as.factor(allData$activity)
allData$subject <- as.factor(allData$subject)

tidy = aggregate(allData, by=list(activity = allData$activity, subject=allData$subject), mean)
# Remove the subject and activity column, since a mean of those has no use
tidy[,90] = NULL
tidy[,89] = NULL
write.table(tidy, "tidy.txt", sep="\t")