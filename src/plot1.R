#This R script is written for assignment 1 from coursera "Exploratory Data Analysis" course
#This is plot 1 of the assignement 1
#This particular script is trying to plot histogram of global_active_power variable
#This program is written such a way that it downloads data from online on the fly and unzip it
#Also it loads the data directly into a R variable for further analysis
#tempdir() function is used to get temporary directory for file unload and unzip. tempdir will be
#deleted automatically at the end of R session.

library(RCurl)

#help(package=RCurl)

#Declaring required variables to have url, zip and source filename
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

#TThere are few variable values with '?'. '?' needs to be interpreted as NA.
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

#Ploting histogram
hist(hshldpwr$Global_active_power, xlab = "Global Active Power (kilowatts)",col = "red",main = "Global Active Power")

#Copying image to bitmap device - png
dev.copy(png, file = "plot1.png")
dev.off()
