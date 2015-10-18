#plot 4
fileUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,destfile="./data/household_power_consumption.zip")
unzip("./data/household_power_consumption.zip")

hpc<-read.table("household_power_consumption.txt",header=TRUE,sep=";")
sapply(hpc[,3:8],class)
hpc[,3:8] <- lapply( hpc[,3:8], function(x) as.numeric(as.character(x)) )   #convert factors to numeric value
ctime<-paste(hpc$Date,hpc$Time,sep="")                                  #create new time variable
cDate<-strptime(ctime,"%d/%m/%Y %H:%M:%S")    
hpc$Date2<-as.Date(cDate)                                               #convert time variable to proper date format
hpc$Date3<-as.POSIXct(cDate)                                            #convert time variable to proper date-time format
hpc2<-hpc[(hpc$Date2=="2007-02-01")|(hpc$Date2=="2007-02-02"),]         #conditionally sort out data

png(filename = "plot4.png",width = 480, height = 480)
par(mfrow=c(2,2))
with(hpc2,{
        plot(Date3,Global_active_power,type="l",xlab="",ylab="Global Active Power")
        plot(Date3,Voltage,type="l",xlab="datetime",ylab="Voltage")
        with(hpc2, {
                plot(Date3,Sub_metering_1, type = "n",xlab="",ylab="Energy sub metering")
                lines(Date3, Sub_metering_1)
                lines(Date3, Sub_metering_2,col="red")
                lines(Date3, Sub_metering_3,col="blue")
                legend("topright", lty = 1, col = c("black","red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"),bty="n")
        })
        plot(Date3,Global_reactive_power,type="l",xlab="datetime",ylab="Global_reactive_power")
})
dev.off()

