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

# Making Plot4
par(mfrow = c(2, 2), mar=c(4,4,2,1), oma=c(0,0,2,0))
with(data_sub, {
  plot(Datetime, Global_active_power, ylab = "Global Active Power", xlab = "", type = "l", col = "black")
  plot(Datetime, Voltage,  type = "l", col = "black")
  plot(Datetime, Sub_metering_1,xlab = "", ylab = "Energy sub metering", type = "l", col = "black")
  lines(Datetime, Sub_metering_2,type = "l", col = "red")
  lines(Datetime, Sub_metering_3,type = "l", col = "blue")
  legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2.5, bty="n",cex=0.7, inset=0.09,legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
  plot(Datetime, Global_reactive_power, type = "l", col = "black")
})

#Saving Plot4
dev.copy(png,file = 'Plot4.png', height=480, width=480)
dev.off()