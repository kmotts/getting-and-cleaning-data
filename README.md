# getting-and-cleaning-data
creates tidy data set from UCI HAR Dataset

UCI HAR data should be stored in a subfolder from the working directory as so:
./data/UCI Har Dataset/

The R file loads the train and test data sets. 
It then creates new columns in each data set for activity and subject.
It changes the column names to match the feature.
It then combines the train and test data sets into a single data set.

It then finds the mean of each feature by activity and subject.

It also plots the means by subject and activity of each feature 
as a point plot and boxplot and saves it to a pdf in the working directory.

