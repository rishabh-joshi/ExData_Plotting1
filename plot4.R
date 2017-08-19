# This funciton performs the following tasks:
# 1. Downloads the zip file of the dataset
# 2. Unzips the file
# 3. Reads only the data between 1/2/2007 and 2/2/2007
# 4. Correctly formats the date and time
# Note: For Step 4, this function requires the lubridate package
# If the package is not found, it is automatically installed

read_data <- function()
{
    URL = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    dest = "exdata_data_household_power_consumption.zip"
    if(!file.exists(dest))
        download.file(URL, dest)
    dataFile = "./household_power_consumption.txt"
    if(!file.exists(dataFile))  unzip(dest)
    
    # only reading the names of the columns
    temp = read.table(dataFile, sep = ";", header = T, nrows = 1)
    
    # only reading the data between 1/2/2007 and 2/2/2007
    power = read.table(dataFile, sep = ";", skip = 66637, nrows = 2880)
    
    # assigning previously read column names
    names(power) = names(temp)
    
    if(!require(lubridate))
        install.packages("lubridate")
    
    library(lubridate)
    power$datetime = paste(power$Date,power$Time)
    power$datetime = dmy_hms(power$datetime)
    power
}


# The following peice of code will create plot4.png
# Note that the plot function by default creates images of dimensions
# 480 x 480 pixels
power = read_data()
png(file="plot4.png")
par(mfcol = c(2,2))
plot(power$datetime, power$Global_active_power, type="l", xlab="", ylab="Global Active Power")
plot(power$datetime, power$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
lines(power$datetime, power$Sub_metering_2, col = "red")
lines(power$datetime, power$Sub_metering_3, col = "blue")
legend("topright",lwd=2,col=c("black","blue","red"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),bty="n")
with(power,plot(datetime,Voltage,type="l"))
with(power,plot(datetime,Global_reactive_power,type="l"))
dev.off()