#This R script is written for assignment 1 from coursera "Exploratory Data Analysis" course
#This is plot 4 of the assignement 1
#This particular script is trying to plot 4 plots using par() function
#This program is written such a way that it downloads data from online on the fly and unzip it
#Also it loads the data directly into a R variable for further analysis
#tempdir() function is used to get temporary directory for file unload and unzip. tempdir will be
#deleted automatically at the end of R session.

library(RCurl)

#help(package=RCurl)

#Declaring required variables to have url, zip and source filename.
url <- URLdecode("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip")
#Creating temp. directory to unload data and unzip it
tmpdir <- tempdir()
zipfile <- paste(tmpdir,"/household_power_consumption.zip",sep="")
srcfile <- paste(tmpdir,"/household_power_consumption.txt",sep="")
srcfilename <- "household_power_consumption.txt"

#Data needs to be read from temp dir. So storing current dir into a variable which can be used to revert
#working directory at the end.
currentdir <- getwd()
setwd(tmpdir)

#Download file and unzip it
download.file(url = url,destfile = zipfile,method = "curl")
unzip(zipfile = zipfile,files = srcfilename)


#Declaring first 2 variables as character(which will be typecasted later for date timestamp)
#rest as numeric
classes <- c(rep("character",2),rep("numeric",7))

#There are questions marks in few variables. '?' needs to be interpreted as NA.
#na.strings paramater should help to interpret ? to NA.
alldata <- read.table(srcfile, header = TRUE, sep = ";",dec = ".", na.strings = "?",colClasses = classes)
#Varifying data to make sure it is fetched properly
str(alldata)

#Don;t need to work with tempdir. reverting it to prev. working dir
setwd(currentdir)

#Converting Date variable into Date data type
alldata$Date <- as.Date(alldata$Date,"%d/%m/%Y")

#Subsetting Date = '2007-02-01' || '2007-02-02' for graphics
hshldpwr <- subset(alldata, Date == as.Date("2007-02-01") | Date == as.Date("2007-02-02"))


#Remove NAs which is not required for plotting and take only complete cases for plot
hshldpwrC <- hshldpwr[complete.cases(hshldpwr),]

#Create datetimestamp dummy variable to combine date and timestamp columns
hshldpwrC$dttm <- strptime(paste(hshldpwrC$Date, hshldpwrC$Time), "%Y-%m-%d %H:%M:%S")

#Plotting on screen and writing into png file is having some weird behaviour
#Opening png file and plot directly on the png file
png(filename = "plot4.png")

#Setting 2 rows and 2 columns for plot
par(mfrow = c(2,2))

#First plot in first row first column
plot(x = hshldpwrC$dttm, y = hshldpwrC$Global_active_power, type="l"
     , ylab="Global Active Power (kilowatts)"
     , xlab="")


#Second plot in first row second column
plot(x = hshldpwrC$dttm, y = hshldpwrC$Voltage, type="l"
     , ylab="Voltage"
     , xlab="datetime")

#Third plot in second row first column
plot(x = hshldpwrC$dttm, y = hshldpwrC$Sub_metering_1, type="l"
     , ylab="Engergy Sub metering"
     , xlab="")
lines(x = hshldpwrC$dttm, y = hshldpwrC$Sub_metering_2, col="red", type="l")
lines(x = hshldpwrC$dttm, y = hshldpwrC$Sub_metering_3, col="blue", type="l")
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
       , lty=1,lwd=2,col=c("black","red","blue"),bty="n")

#Fourth plot in second row second column
plot(x = hshldpwrC$dttm, y = hshldpwrC$Global_reactive_power, type="l"
     , ylab="Global_reactive_power"
     , xlab="datetime")

#Closing device off
dev.off()

#reverting canvas setup to default
par(mfrow = c(1,1))
