
##
## Course 4 - Exploratory Data Analysis Course Project #1
##

library(dplyr)
library(readr)

## create a data directory if none exists 
dataDir <- "./data/Course 4 Project 1"
if(!file.exists(dataDir)){
    dir.create(dataDir)
}

## get the zip file based on the supplied data set location
fileURL1 <- "https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip"
filename <- file.path(dataDir,"project 1.zip")

if(!file.exists(filename)){
    download.file(fileURL1,destfile = filename)
}

## unzip the zip file to a temporary directory
td <- tempdir()
projectDir = file.path(dataDir,"UC Irvine Dataset")
if(!file.exists(projectDir)){
    unzip(filename, ex = td)
}

## read the text file
filename <- file.path(td, "household_power_consumption.txt")
## power_consump <- read.csv2(filename, header = TRUE, 
##                           na.strings = "Not Available")

power_consump <- read_delim(filename,
                na = c("","?"),
                delim = ";",
                col_types = cols(
                    Date = col_character(),
                    Time = col_character(),
                    Global_active_power = col_double(),
                    Global_reactive_power = col_double(),
                    Voltage = col_double(),
                    Global_intensity = col_double(),
                    Sub_metering_1 = col_double(),
                    Sub_metering_2 = col_double(),
                    Sub_metering_3 = col_double()))

## filter and transform data as necessary 

power_consump$Date <- as.Date(power_consump$Date, "%d/%m/%Y")
power_filter <- power_consump %>%
    filter(Date >= "2007-02-01" & Date <= "2007-02-02")
power_filter$Datetime <- strptime(paste(power_filter$Date,power_filter$Time),"%Y-%m-%d %H:%M:%S")

##########
## Plot and discover the data - #4
##########

par(mfcol=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
with (power_filter,
    ## plot 1
    plot(Datetime,Global_active_power, ylab = "Global Active Power",xlab= "", type = 'l'))

## plot 2
plot(power_filter$Datetime,power_filter$Sub_metering_1, type = 'l', col='black',
     ylab="Energy sub metering", xlab = "")
lines(power_filter$Datetime,power_filter$Sub_metering_2, type = 'l', col='red')
lines(power_filter$Datetime,power_filter$Sub_metering_3, type = 'l', col='blue')
legend("top", col=c('black','red','blue'), bty = "n", y.intersp = .2,
   lty = 1, legend=names(power_filter[7:9]), cex=1)

## plot 3    
with (power_filter,
      plot(Datetime,Voltage,type = 'l'))
        
## plot 4
with (power_filter,
    plot(Datetime,Global_reactive_power,type = 'l'))
    
dev.copy(png, file = "plot4.png", height=480, width=480)
dev.off()

