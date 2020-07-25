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

# subset and calculate
NEI <- NEI %>% subset(fips == "24510" | fips == "06037") %>%
        rename(city = fips)

NEI$city <- sub("24510", "Baltimore City", NEI$city)      
NEI$city <- sub("06037", "Los Angeles County", NEI$city)      

SCC$SCC <- as.character(SCC$SCC)
motorv <- str_detect(SCC$EI.Sector, "Vehicles")

SCC.motor <- SCC$SCC[motorv]


NEI.motor <- subset(NEI, SCC %in% SCC.motor ) %>%
        group_by(city, year) %>%
        summarise(emission = sum(Emissions))

# plot
png("plot6.png")
ggplot(NEI.motor, aes(year, emission, color=city)) + 
        geom_line() + 
        scale_x_continuous(breaks= seq(1999, 2008, by = 3)) +
        labs(title = "Motor vehicle PM2.5 Emission Changes in Baltimore City and Los Angeles County") +
        xlab("Year") +
        ylab("Emission (tons)")
dev.off()

