SamsungData <- function()
{
     url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
     base <- getwd()           #Setting up base
     setwd(base)               #Setting work directory as base
     if(!file.exists("getdata-projectfiles-UCI_HAR_Dataset.zip"))     # Check for existing Samsung Data in work directory
     {
          download.file(url,destfile = "getdata-projectfiles-UCI_HAR_Dataset.zip")
     }
     if(!file.exists("UCI HAR Dataset")){
          unzip("getdata-projectfiles-UCI_HAR_Dataset.zip") # Unzipping contents from Samsung Data
     }
     #####################################################################################
     ##################### Merging Training and Test Data ################################
     #####################################################################################
     setwd(base)
     setwd("./UCI HAR Dataset/test")                             # Accessing Test Folder and data
     smartdatatest <- read.table("X_test.txt")         # Reading test data
     smartdatatest[,562] <- read.table("y_test.txt")   # Adding columns for activity identifier
     smartdatatest[,563] <- read.table("subject_test.txt") # Adding column for subject identifier
     setwd(base)
     setwd("./UCI HAR Dataset")
     colnames(smartdatatest) <- make.names(read.table("features.txt")[,2])
     
     setwd(base)
     setwd("./UCI HAR Dataset/train")                             # Accessing train Folder and data
     smartdatatrain <- read.table("X_train.txt")       # Reading train data
     smartdatatrain[,562] <- read.table("y_train.txt") # Adding columns for activity identifier
     smartdatatrain[,563] <- read.table("subject_train.txt") # Adding column for subject identifier
     
     setwd(base)
     setwd("./UCI HAR Dataset")
     colnames(smartdatatrain) <- make.names(read.table("features.txt")[,2])
     
     smartdata <- rbind.data.frame(smartdatatest,smartdatatrain,deparse.level = 1) # Binding Test and Training Data together
     
     ##################################################################################################
     ##################### Subsetting Mean and Standard Deviation data ################################
     ##################################################################################################
     
     smartdatamean <- smartdata[,c(grepl(".mean..",colnames(smartdata),ignore.case = FALSE))]
     smartdatastd <- smartdata[,c(grepl(".std..",colnames(smartdata),ignore.case = FALSE))]
     smartdata1 <- cbind(smartdatamean,smartdatastd)                  # Size of matrix with mean and std is 79
     smartdata1 <- cbind(smartdata1,smartdata[,562],smartdata[,563])  # Adding Identifier columns from smartdata
     
     ###################################################################################################
     ##################### Adding Appropriate names for activity column ################################
     ###################################################################################################    
     
     library(plyr)
     smartdata1$`smartdata[, 562]`=as.factor(smartdata1$`smartdata[, 562]`)
     smartdata1$`smartdata[, 562]`<- revalue((smartdata1$`smartdata[, 562]`),c("1"="WALKING","2"="WALKING_UPSTAIRS","3"="WALKING_DOWNSTAIRS","4"="SITTING","5"="STANDING","6"="LAYING"))
     
     ##############################################################################################
     ##################### Finding Average of individual variables ################################
     ##############################################################################################          
     
     splitsmart <- split(smartdata1,smartdata1$`smartdata[, 563]`)         # Splitting smartdata by subject
     actlist <- as.character(read.table("activity_labels.txt")[,2])        # Reading activity names
     SmartDataTable1 <- matrix(NA,nrow=180,ncol=79)                        # Creating a dummy matrix of size 180x79
     m=0
     for(k in 1:length(splitsmart)){                                       # Initiating two loops, one for subject other for activity
          for(l in 1:length(actlist)){
               m=m+1
               SmartDataTable1[m,] <- round(colSums((splitsmart[[k]][which(splitsmart[[k]]$`smartdata[, 562]`==actlist[l]),])[,1:79])/length(which(splitsmart[[k]]$`smartdata[, 562]`==actlist[l])),3) # Calculating average
          }
          
          col80<-rep(c(actlist),30)                                        # Creating new column for activity identifier in new data
          col81<-rep(1:30,each=6)                                          # Creating new column for subject identifier in new data
          SmartDataTable <- cbind(SmartDataTable1,col80,col81)             # Creating new datatable
          colnames(SmartDataTable) <- colnames(smartdata1)                 # Assigning column names
          setwd(base)
          write.table(SmartDataTable,file="Data.txt",row.names = FALSE)
     } 
}