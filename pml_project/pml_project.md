#Background

Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement – a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it. In this project, your goal will be to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways. More information is available from the website here: http://groupware.les.inf.puc-rio.br/har (see the section on the Weight Lifting Exercise Dataset). 

#The Goal
In this study, six participants participated in a dumbell lifting exercise five different ways. The five ways, were (Class A), throwing the elbows to the front (Class B), lifting the dumbbell only halfway (Class C), lowering the dumbbell only halfway (Class D) and throwing the hips to the front (Class E). Class A corresponds to the specified execution of the exercise, while the other 4 classes correspond to common mistakes.

By processing data gathered from accelerometers on the belt, forearm, arm, and dumbell of the participants in two machine learning algorithms, i checked the capaccity of prediction of both almorithms and report the results here.

#Load packages and datasets
To start the analysis, we need load necessary packages, included "catet", "randomForest", "doMC", and then load datasets for traning and testing.

```
setwd("/Users//summerge/Documents/Learning R/")
library(caret)
library(randomForest)
library(doMC)
registerDoMC(cores = 4)

pml_Train <- read.csv("pml-training.csv")
pml_Test <- read.csv("pml-testing.csv")
```
#Data preprocessing
The datasets needed cleanup before it was for use.  The file have 160 columns,  from 1 to 7 columns are described name, date, time..., these columns not to be use, and there are lot of NA's value, them have not usable, if in any column, NA's value accounted for more than 75%, I eliminated this column.

```
pml_Train <- pml_Train[,-c(1:7)]
pml_Test <- pml_Test[,-c(1:7)]
colNames <- sapply(pml_Train, function(x) sum(is.na(x)|x == "")/length(x) > 0.75) == 0
pml_Train <- pml_Train[,colNames]
pml_Test <- pml_Test[,colNames]
```
#Cross validation and training data
I split the training dataset into two parts, 60% for training, 40% for validation. I use two models for training and validation data, the first is gbm model, second is rf model.

```
subSample <- createDataPartition(pml_Train$classe, p = 0.6, list = F)
subTraning <- pml_Train[subSample,]
subTesting <- pml_Train[-subSample,]

system.time(gbmModel <- train(classe~., method = "gbm", data = subTraning)) 
gbmpredictions <- predict(gbmModel, subTesting)
gbmCheck <- confusionMatrix(gbmpredictions,subTesting$classe)

system.time(rfModel <- randomForest(classe~., data = subTraning, method = "class"))
rfpredictions <- predict(rfModel, subTesting)
rfCheck <- confusionMatrix(rfpredictions, subTesting$classe)


```
the gbm model training and validation result is

```
    user   system  elapsed 
1427.928   11.355  563.851 

Confusion Matrix and Statistics

          Reference
Prediction    A    B    C    D    E
         A 2198   50    0    2    2
         B   22 1428   47    8   23
         C    7   34 1307   55   12
         D    3    1   12 1211   11
         E    2    5    2   10 1394

Overall Statistics
                                          
               Accuracy : 0.9607          
                 95% CI : (0.9562, 0.9649)
    No Information Rate : 0.2845          
    P-Value [Acc > NIR] : < 2.2e-16       
                                          
                  Kappa : 0.9503          
 Mcnemar's Test P-Value : 1.837e-11       

Statistics by Class:

                     Class: A Class: B Class: C Class: D Class: E
Sensitivity            0.9848   0.9407   0.9554   0.9417   0.9667
Specificity            0.9904   0.9842   0.9833   0.9959   0.9970
Pos Pred Value         0.9760   0.9346   0.9237   0.9782   0.9866
Neg Pred Value         0.9939   0.9858   0.9905   0.9887   0.9925
Prevalence             0.2845   0.1935   0.1744   0.1639   0.1838
Detection Rate         0.2801   0.1820   0.1666   0.1543   0.1777
Detection Prevalence   0.2870   0.1947   0.1803   0.1578   0.1801
Balanced Accuracy      0.9876   0.9625   0.9694   0.9688   0.9819

```
the rf model training and validation result is


```
   user  system elapsed 
 33.772   0.248  34.042 
 
 Confusion Matrix and Statistics

          Reference
Prediction    A    B    C    D    E
         A 2230    7    0    0    0
         B    1 1509   15    0    0
         C    0    2 1353   19    0
         D    0    0    0 1265    0
         E    1    0    0    2 1442

Overall Statistics
                                         
               Accuracy : 0.994          
                 95% CI : (0.992, 0.9956)
    No Information Rate : 0.2845         
    P-Value [Acc > NIR] : < 2.2e-16      
                                         
                  Kappa : 0.9924         
 Mcnemar's Test P-Value : NA             

Statistics by Class:

                     Class: A Class: B Class: C Class: D Class: E
Sensitivity            0.9991   0.9941   0.9890   0.9837   1.0000
Specificity            0.9988   0.9975   0.9968   1.0000   0.9995
Pos Pred Value         0.9969   0.9895   0.9847   1.0000   0.9979
Neg Pred Value         0.9996   0.9986   0.9977   0.9968   1.0000
Prevalence             0.2845   0.1935   0.1744   0.1639   0.1838
Detection Rate         0.2842   0.1923   0.1724   0.1612   0.1838
Detection Prevalence   0.2851   0.1944   0.1751   0.1612   0.1842
Balanced Accuracy      0.9989   0.9958   0.9929   0.9918   0.9998

```
From the results we have knew, the gbm model has 96.07% accuracy and used 1427.93 seconds user time, the rf model has 99.40% accuracy and used 33.77 seconds user time, rf model better than gbm model.

# Predict result

I choose rf model to predict unknown result.

```
answers <- predict(rfModel, pml_Test)
answers
 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 
 B  A  B  A  A  E  D  B  A  A  B  C  B  A  E  E  A  B  B  B 
Levels: A B C D E
```

