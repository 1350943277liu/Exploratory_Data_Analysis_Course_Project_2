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


coalcomb <- str_detect(SCC$EI.Sector, "^Fuel Comb.*Coal$")
SCC_coal <- as.character(SCC$SCC)[coalcomb]

NEI_coal <- filter(NEI, SCC %in% SCC_coal)


NEI_coal <-  group_by(NEI_coal, year)
pm25.coal <- summarise(NEI_coal, emission=sum(Emissions)) 


##

p <- ggplot(pm25.coal, aes(as.factor(year), emission))
p + geom_col() + 
        labs(title = "Coal Combustion-related PM 2.5 Change") +
        xlab("Year") +
        ylab("Emission (tons)")



