library(tidyverse)

# download data if necessary
if (!dir.exists("exdata-data-NEI_data")) {
        if (!file.exists("exdata-data-NEI_data.zip")) {
                download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                              destfile = "exdata-data-NEI_data.zip",
                              method = "curl")
                unzip("exdata-data-NEI_data.zip")
        }
}

# read data
NEI <- read_rds("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- read_rds("./exdata-data-NEI_data/Source_Classification_Code.rds")
NEI <- as_tibble(NEI)
SCC <- as_tibble(SCC)

# tidy data
NEI$type <- tolower(NEI$type)
NEI$type <- sub("-", "", NEI$type)

# subset data of Baltimore City
NEI.baltimore <- subset(NEI, fips == "24510")

#calculate
NEI.baltimore <- group_by(NEI.baltimore, year, type)
pm25 <- summarise(NEI.baltimore, emission =sum(Emissions)) 

# plot
png("plot3.png")
ggplot(pm25, aes(year, emission, color=type)) +
        geom_line() +
        labs(title = "PM2.5 Emission Changes from Different Sources in Baltimore City") +
        xlab("Year") +
        ylab("Emission (tons)") +
        scale_x_continuous(breaks= seq(1999, 2008, by = 3))
dev.off()

