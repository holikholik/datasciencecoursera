#plot 2
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

png(filename = "plot2.png",width = 480, height = 480)
plot(hpc2$Date3,hpc2$Global_active_power,type="l",xlab="",ylab="Global Active Power (kilowatts)")
dev.off()

