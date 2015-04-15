##Readme
1.I use Mac OS, from website <http://archive.ics.uci.edu/ml/machine-learning-databases/00240/>  download the file "UCI HAR Dataset.zip", and extract the zipfile on my folder "~/Documents/Learning R/", set the work folder is "./Documents/Learning R/UCI HAR Dataset/.
``` 
setwd("./Documents/Learning R/UCI HAR Dataset/")
``` 
 
2.Load packages 

``` 
library(data.table)
library(dplyr)
library(reshape2)
library(tidyr)
```
3.Read raw datasets

```
DT_train_X <- read.table("./train/X_train.txt")
DT_train_Y <- read.table("./train/Y_train.txt")
DT_train_sub <- read.table("./train/subject_train.txt")
DT_test_X <- read.table("./test/X_test.txt")
DT_test_Y <- read.table("./test/Y_test.txt")
DT_test_sub <- read.table("./test/subject_test.txt")
DT_features <- read.table("./features.txt", col.names = c("NO", "Names"),stringsAsFactors=F)
Active_label <- read.table("./activity_labels.txt", col.names=c("Active_No", "Active_Name"))
```
4.Combine test and train data, names that and extracts mean and standard deviation columes. Combine subjects test and train data, read features data, join subjects and features data. Finale, combine all datas into "DT_All".

```
DT_All_X <- rbind_list(DT_train_X,DT_test_X)
colnames(DT_All_X) <- DT_features$Names

DT_All_X <- DT_All_X[,grep("mean()|std()",DT_features[,2])]

DT_All_sub <- rbind(DT_train_sub,DT_test_sub)
colnames(DT_All_sub) <- "Subject"

DT_All_Y <- rbind_list(DT_train_Y,DT_test_Y)
colnames(DT_All_Y) = "Active_No"

DT_All_Y <- left_join(DT_All_Y, Active_label,by="Active_No") 
DT_All_Y <- DT_All_Y[,2]
DT_All <- cbind(DT_All_sub, DT_All_Y, DT_All_X)
```
5.Melt the dataset structure,  and calculat the average of each variable for each activity and each subject.

```
DT_All_melt <- melt(DT_All,id = c("Subject", "Active_Name"), measure.vars=c(3:81))
DT_All_Avg <- dcast(DT_All_melt, Subject + Active_Name~variable , mean )
```
6 Write a new tidy data file.

```
write.table(DT_All_Avg, "./DT_All_Avg.txt", row.names = FALSE)
```
7 Variables list

* \"DT\_All\_X\", combine traning and test data
* \"DT\_All\_Y\", combine traning and test label
*  \"DT\_All\_sub\", combine traning and test subject datas
*  \"DT\_All\", all data in one
*  \"DT\_All\_melt\", melt DT\_All data, 
*  \"DT\_All\_Avg\", calculat the average 
