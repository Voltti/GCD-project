# GCD-project
Coursera's Getting and Cleaning Data - The course project

run_analysis.R is R script for tidying the data set given in the project description (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones  for more information).
tidy_data.txt is the output of script on the data set.


# How the run_analysis.R works:

## Reading the data

The script reads selectively all the features with "mean()" or "std()" in the attribute's name in test and train data sets. All labels are selected, modified and assigned along the way.

## Processing the data.

The processing goes through all the data points in each feature variable for each experiment subject-activity pair and calculates a mean. It first checks what are all the unique subject-activity pairs, then pair at a time checks what rows belong to that experiment subject-activity pair and calculates means for each related feature variable columns.

A more specific description of the algorithms used can be found in the run_analysis.R script file.