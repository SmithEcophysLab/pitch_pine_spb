# script to clean Pitch Pine SPB C/N data

library(dplyr)
library(tidyr)

## read in data
cn_2020_01 <- read.csv('raw/pp_spb_cn_2021.01.28.csv')[2:115, c(1, 4, 19, 36)]
cn_2020_03 <- read.csv('raw/pp_spb_cn_2021.03.12.csv')[2:115, c(1, 4, 19, 36)]

# change N & C from factors to numeric
cn_2020_01$Nitrogen.13 <- as.numeric(as.character(cn_2020_01$Nitrogen.13))
cn_2020_01$Carbon.13 <- as.numeric(as.character(cn_2020_01$Carbon.13))

cn_2020_03$Nitrogen.13 <- as.numeric(as.character(cn_2020_03$Nitrogen.13))
cn_2020_03$Carbon.13 <- as.numeric(as.character(cn_2020_03$Carbon.13))

# Add Analysis Date, Site, and ID columns, remove rows with standards
cn_2020_01_clean <- cn_2020_01 %>% separate(X, c("Sample", "Month", "Day", "Year")) %>%
  unite("Analysis Date", Month:Year) %>%
  filter(Sample.ID != "QC" & Sample.ID != "Blank" & Sample.ID != "Standard" & Sample.ID != "Bypass") %>%
  separate(Sample.ID, c("Site", "ID"), sep = "(?<=[A-Za-z])(?=[0-9])")
cn_2020_03_clean <- cn_2020_03 %>% separate(X, c("Sample", "Month", "Day", "Year")) %>%
  unite("Analysis Date", Month:Year) %>%
  filter(Sample.ID != "QC" & Sample.ID != "Blank" & Sample.ID != "Standard" & Sample.ID != "Bypass") %>%
  separate(Sample.ID, c("Site", "ID"), sep = "(?<=[A-Za-z])(?=[0-9])")

# add Year, Season, and DOY columns
cn_2020_01_clean$Year <- rep("2020")
cn_2020_03_clean$Year <- rep("2020")

cn_2020_01_clean$Season <- rep("fall")
cn_2020_03_clean$Season <- rep("fall")

cn_2020_01_clean$DOY <- rep(275)
cn_2020_03_clean$DOY <- rep(306)

# rename column headers
colnames(cn_2020_01_clean) = c("Sample", "Analysis Date", "Site", "ID", "N", "C", "Year", "Season", "DOY")
colnames(cn_2020_03_clean) = c("Sample", "Analysis Date", "Site", "ID", "N", "C", "Year", "Season", "DOY")

# combine datasets
cn_clean <- bind_rows(cn_2020_01_clean, cn_2020_03_clean)

# calculate CN ratio
cn_clean$CN <- cn_clean$C/cn_clean$N

# rename NRC and NCR to CNR
cn_clean$Site[cn_clean$Site == "NRC"] <- "CNR"
cn_clean$Site[cn_clean$Site == "NCR"] <- "CNR"

# adjust CNR ID numbers
cn_clean$ID[cn_clean$Site == "CNR" & cn_clean$ID == 2] <- 1
cn_clean$ID[cn_clean$Site == "CNR" & cn_clean$ID == 3] <- 2
cn_clean$ID[cn_clean$Site == "CNR" & cn_clean$ID == 5] <- 3
cn_clean$ID[cn_clean$Site == "CNR" & cn_clean$ID == 6] <- 4
cn_clean$ID[cn_clean$Sample == "CNR6"] <- 4
cn_clean$ID[cn_clean$Site == "CNR" & cn_clean$ID == 8] <- 5
cn_clean$ID[cn_clean$Site == "CNR" & cn_clean$ID == 9] <- 6
cn_clean$ID[cn_clean$Site == "CNR" & cn_clean$ID == 11] <- 7
cn_clean$ID[cn_clean$Site == "CNR" & cn_clean$ID == 13] <- 8
cn_clean$ID[cn_clean$Site == "CNR" & cn_clean$ID == 14] <- "14?"
cn_clean$ID[cn_clean$Site == "CNR" & cn_clean$ID == 15] <- 9
cn_clean$ID[cn_clean$Site == "CNR" & cn_clean$ID == 17] <- 10
cn_clean$ID[cn_clean$Site == "CNR" & cn_clean$ID == 18] <- 11
cn_clean$ID[cn_clean$Site == "CNR" & cn_clean$ID == 20] <- 12
cn_clean$ID[cn_clean$Site == "CNR" & cn_clean$ID == 21] <- 13
cn_clean$ID[cn_clean$Site == "CNR" & cn_clean$ID == 23] <- 14
cn_clean$ID[cn_clean$Site == "CNR" & cn_clean$ID == 24] <- 15
cn_clean$ID[cn_clean$Site == "CNR" & cn_clean$ID == 25] <- 16
cn_clean$ID[cn_clean$Site == "CNR" & cn_clean$ID == 27] <- 17
cn_clean$ID[cn_clean$Site == "CNR" & cn_clean$ID == 28] <- 18
cn_clean$ID[cn_clean$Site == "CNR" & cn_clean$ID == 30] <- 19

cn_clean <- dplyr::select(cn_clean, -"Sample")
cn_clean <- dplyr::select(cn_clean, "Year", "DOY", "Season", "Site", "ID", "C", "N", "CN", "Analysis Date")

write.csv(cn_clean, 'cn_data.csv', row.names = F)
