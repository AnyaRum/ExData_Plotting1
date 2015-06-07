# Cleaning workspace
rm(list = ls())

# Downloading and unzipping data

if (!file.exists("household_power_consumption.txt")){
  temp <- tempfile()
  download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
  file <- unzip(temp)
  unlink(temp)
} else {
  file = './household_power_consumption.txt' 
}

# Reading the data from *.txt file using fread makes it faster
library(data.table)
data_all <- fread(file, header=T, sep=";", stringsAsFactors = FALSE)

# Replacing ? with NA
data_all[data_all == "?"] <- NA
# Converting Date column from character to date format
data_all$Date <- as.Date(data_all$Date, format="%d/%m/%Y")

# Subsetting the data frame
data_sub <- subset(data_all, (Date == "2007-02-01" | Date == "2007-02-02"))
rm(data_all)

# Merging date and time columns into one
data_sub$Datetime <- as.POSIXct(paste(data_sub$Date, data_sub$Time))

# Converting character columns into numeric
indx <- sapply(data_sub, is.character)
data_sub[indx] <- lapply(data_sub[indx], function(x) as.numeric(x))

#====================================================================

# Making Plot1

with(data_sub, hist(as.numeric(Global_active_power), main="Global Active Power", xlab="Global Active Power (kilowatts)", ylab="Frequency", col="Red"))

#Saving Plot1
dev.copy(png,file = 'Plot1.png',height=480, width=480)
dev.off()