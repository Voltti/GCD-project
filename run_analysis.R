## A funtion to analyse the "Human Activity Recognition Using Smartphones Data Set" (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
## Funtion combines the subject, activity and feature data from the set. Only feature data with
## "mean()" or "std()" in the description label are included.
## And average for each feature for every subject and every activity is calculated and returned as a data.frame.

run_analysis <- function() {
    
    ## Reading meta-data
    featuresAll <- read.table(file="features.txt")
    ## Getting an index vector for data selection. Features with "mean()" or "std()" in the name are selected.
    featSelected <- grep("mean\\(\\)$|std\\(\\)$", featuresAll[,"V2"],ignore.case=TRUE)    
    ## Generating label vector for later use. "-Avg" prefix added to all selected feature labels.
    Labels <- c("Subject", "Activity",as.character(paste(featuresAll[featSelected,"V2"],"-Avg", sep="")))  
    rm(featuresAll)
    
    ## Reading data: test
    raw_data <- read.table(file="test/subject_test.txt")
    raw_data <- cbind(raw_data, read.table(file="test/y_test.txt"))
    ## Using the featSelected vector to read only the wanted features from the file.
    raw_data <- cbind(raw_data, read.table(file="test/X_test.txt")[,featSelected])
    
    ## Reading data: train
    raw_data_temp <- read.table(file="train/subject_train.txt")
    raw_data_temp <- cbind(raw_data_temp, read.table(file="train/y_train.txt"))
    ## Using the featSelected vector to read only the wanted features from the file.
    raw_data_temp <- cbind(raw_data_temp, read.table(file="train/X_train.txt")[,featSelected])
    
    ## Combining the test and train data sets
    raw_data <- rbind(raw_data, raw_data_temp)
    ## Freeing up memory
    rm(raw_data_temp)
    
    ## Naming the columns
    colnames(raw_data) <- Labels
    
    # Converting the integers referring to activities into character labels
    actLabels <- read.table(file="activity_labels.txt", stringsAsFactors = FALSE)
    for(i in 1:length(raw_data$Activity)) {
        ## Comparing the data set's "Actitity" column's each cells with the actLabels first column.
        ## If there's a match with the activity variables(integers), then the corresponding character label
        ## is set to that data set's cell from the second column of actLabels.
        raw_data[i,"Activity"] <- actLabels[raw_data[i,"Activity"] == actLabels[,"V1"], "V2"]
    }
    
    ## For the data processing loop we set few assisting variables:
    ## subject_n for each unique test sucject in data set; activity_n for each unique activity.
    ## The process will subset data for each subject and activity pair.
    subject_n <- unique(raw_data$Subject)
    activity_n <- as.character(actLabels$V2)

    ## The calculations are done inside the table(no assisting table is defined).
    ## row_selection variable will be used to keep track what rows(with the calculated averages) of the table will be returned in the end.
    
    row_selection <- NULL
    
    #The data processing
    for (i in 1:length(subject_n)) {
        for (j in 1:length(activity_n)) {
            
            ## Index vector with all rows for a subject-activity pair.
            r_index <- as.numeric(row.names(raw_data[raw_data[,1] == subject_n[i] & raw_data[,2] == activity_n[j],]))
            
            ## We check if there's any data for the subject-activity pair. If not, then skip to another subject-activity pair.
            if (length(r_index)>0) {
                ## Calculating column means for all the rows of current subject-activity pair
                ## for each column (except "Sucject" and "Activity" columns, thus staring from 3rd column).
                ## The results are stored in the row defined in the index vector (r_index) first element.
                for (k in 3:ncol(raw_data)) {
                    raw_data[r_index[1],k] <- mean(raw_data[r_index,k])    
                }
                
            }
            ## The row number for row with the calculated means is stored
            row_selection <- c(row_selection, r_index[1])
            
        }
        
    }
    
    ## Returning the data.
    raw_data[row_selection,]
}