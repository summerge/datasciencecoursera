library(data.table)
library(lubridate)
setwd("/Volumes/System/Users/summerge/Documents/Learning R/")
electric <- fread("household_power_consumption.txt",na.strings = c("?"))
electric <- electric[(electric$Date == "1/2/2007" | electric$Date == "2/2/2007"),]
electric$Date_Time <- parse_date_time(paste(electric$Date,electric$Time),
                                      "%d/%m/%y %H:%M:%S")
electric <- transform(electric,  
                      Global_active_power = as.numeric(Global_active_power), 
                      Global_reactive_power = as.numeric(Global_reactive_power), 
                      Voltage = as.numeric(Voltage),  
                      Global_intensity = as.numeric(Global_intensity), 
                      Sub_metering_1 = as.integer(Sub_metering_1), 
                      Sub_metering_2 = as.integer(Sub_metering_2), 
                      Sub_metering_3 = as.integer(Sub_metering_3))
png(file = "plot2.png",height = 480, width = 480, bg = "white")
par(mfrow = c(1,1), cex = 0.8)
with(electric, plot(Date_Time, Global_active_power, type = "l", xlab = "",
                    ylab = "Global active power(kilowatts)"))
dev.off()