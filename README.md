# GetData_Project
## The program included pulls the data from the source, unzips, and processes the data to obtain a lean necessary information using data generated from smart phones
- Initially, the program sets up a base/root folder for it to access different files in different folders. If the source file does not exist by name "getdata-projectfiles-UCI_HAR_Dataset.zip", it downloads from the source location. Unzips it and then start calling necessary data.
- Firstly, the data in the training and the test folder needs to be combined. In order to achieve this, the data in the test folder is read and two additional columns corresponding to the identifiers of activity and subject is added. Similarly, the training data is also called in and added with same columns for identification. The column names are assigned according to the data from features.txt and these two seperate data frames are joined together to form a larger dataset
- Secondly, the data frames are subsetted, the columns containing the terms mean and std are retained and remaining data is purged
- Thirdly, the column containing identifier in terms of number is appropraitely renamed with actual activity names from "activity_labels.txt"
- Addition of appropriate column names for the table has already been achieved in previous steps.
- Next step is to find average of individual variables for each subject and activity. To achieve this, the data frame is split into a list with  subjects. Two loops are initiated, one for subject and another for activity, the split data frame is looped for finding average and a new data set with average values is formed. The data set is then appended with columns for idenfication of activity and subject.
- Finally, the data set is then written as txt file in the same base folder.
