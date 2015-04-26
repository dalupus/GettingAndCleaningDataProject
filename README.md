# GettingAndCleaningDataProject


This file explains how the run_analysis.R file works

## Download the data

First, if necessary, the data directory is created and the dataset downloaded
The data that is downloaded is in zip format so the file is unzipped

## Read in the files

The following files were then read in using read.table

* X_train.txt
* X_test.txt
* Y_train.txt
* Y_test.txt
* subject_train.txt
* subject_test.txt
* features.txt
* activity_labels.txt

## Combine the train and test sets

All of the train and test splits were merged together

## Fix up activities

A join was done using dplyr to change the numerics in Y to a factor with an actual name

## Assign column names

Column names were then assigned from the features.txt for the X data

## Select out the columns needed

The mean and std columns were then selected from the X dataset.  This was done with a simple grep of mean and std

## Fix up the column names

The column names were then changed such that they contained human readable format.  Various substitutions were done such as changing Acc to Acceleratometer

##  Combine the data into 1 dataset

The X, Y, and subject datasets were then merged via column to create 1 large dataset

## Write out the file

write.table was used to create a text version of the file

## Create the second tidy dataset

In order to accomplish this step we used the summarize_each function of dplyr with group by.  The mean of each column was gotten, grouped by subject and activity.  The column names were then changed to reflect the fact that they were the mean and the file again written out.


