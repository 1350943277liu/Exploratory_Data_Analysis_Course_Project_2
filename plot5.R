library(tidyverse)

if (!dir.exists("exdata-data-NEI_data")) {
        if (!file.exists("exdata-data-NEI_data.zip")) {
                download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                              destfile = "exdata-data-NEI_data.zip",
                              method = "curl")
                unzip("exdata-data-NEI_data.zip")
        }
}

NEI <- read_rds("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- read_rds("./exdata-data-NEI_data/Source_Classification_Code.rds")
NEI <- as_tibble(NEI)
SCC <- as_tibble(SCC)

NEI$type <- tolower(NEI$type)
NEI$type <- sub("-", "", NEI$type)

NEI.baltimore <- subset(NEI, fips == "24510")

SCC$SCC <- as.character(SCC$SCC)
SCC$Short.Name <- as.character(SCC$Short.Name)
motorv <- str_detect(SCC$Short.Name, "Motor Vehicles | Motorcycles")

SCC.motor <- SCC$SCC[motorv]



NEI.motor <- subset(NEI.baltimore, SCC %in% SCC.motor )


options(scipen = 2)
NEI.motor <-  group_by(NEI.motor, year)
pm25.year <- summarise(NEI.motor, emission=sum(Emissions)) 


p <- ggplot(pm25.year, aes(as.factor(year), emission))
p+geom_col() + 
        labs(title = "Motor Vehicle PM 2.5 Emission") +
        xlab("Year") +
        ylab("Emission (tons)")

t <- ggplot(NEI.motor, aes(year, Emissions, color=SCC))
t + geom_point()







