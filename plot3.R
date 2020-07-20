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

options(scipen = 2)
pm25 <- ggplot(NEI.baltimore, aes(year, log10(Emissions)))
pm25 + geom_point(alpha=0.3) + facet_grid(.~type) + geom_smooth(method = "lm")

