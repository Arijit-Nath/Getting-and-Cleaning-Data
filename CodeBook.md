##CodeBook

General Information on data, please refer to README.md


Description of steps undertaken to clean and reshape the data:

  1) Read the files "activity_labels.txt" & "features.txt", containing the labels for activities and features

  2) Read the test data

    >	Read the data "subject_test.txt" for test subject id
    >	Read the data "X_test.txt" for feature list for test observations
    >	Read the data "Y_test.txt" regarding the type of activity for test observations
    >	Bind above 3 data "subject_test.txt","X_test.txt", & "Y_test.txt" get the combine test observations
    >	Keep only necessary columns Subject.Id, Activity and columns containing mean and std in their description
    >	Add the description for activity type to produce the final test data for observations

  3) Read the training data
	Redo the same steps as in Step 2, but with Training data sets instead of Test data sets

  4) Merge Training and Test data to create one data set. As both Test & Train data has same dimentions.

  5) Reshape the merged data to produce the desired format for data aggregation

    >	Use the melt function to prepare data for dcast aggregation.
    >	Aggregate data with dcast function to produce the final (tidy) data set
  
  6) Finnaly write "Tidydata.txt" file with clean & formatted data.
