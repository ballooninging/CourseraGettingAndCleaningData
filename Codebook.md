# Codebook for CourseraGettingAndCleaningData repo

The variables, data, and transformations conducted to clean up the data is described in this codebook.

* The site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

* The data for the project: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Steps taken in run_analysis.R

The run_analysis.R script does the following:

1. The download URL and destination file URL is first saved into R objects `x` and `y` respectively. The file is saved into the destination "./UCI HAR Dataset.zip".
2. Files are then downloaded, then unzipped. The list of unzipped files are saved into `listoffiles` with class `data.frame`, with variable names `Name`, `Length`, `Date`.
3. Variables names for the training dataset is first loaded into `dataheaders`.
4. Subject keys are then loaded into `trainsubject`.
5. Activity keys are then loaded into `trainlabeltemp`.
6. Activity labels are loaded into `activitynames`.
7. Activity keys are linked to their labels, and merged into a new `data.frame` `trainlabel`.
8. The full training dataset is then loaded into `fulltraindata`.
9. `fulltraindata`'s column names are reassigned to `dataheaders`'s elements.
10. Steps 3 to 7 are repeated for the test data, but all instances of `train` in the R objects mentioned are replaced with `test`.
11. The test and training datasets are then binded together to form `fulldata`, and the first three columns are renamed into `Subject` as the subject ID, `Label` as the activity label ID, and `Activity` as the activity name.
12. Only columns with "mean" and "std" are selected from `fulldata`, and pushed into `selecteddataset`.
13. A `tidy` dataset with means for all variables, grouped by `Subject`, `Label` and `Activity` is created.
14. `tidy.txt` is finally outputted.
