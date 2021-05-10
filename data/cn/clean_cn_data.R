# script to clean Pitch Pine SPB C/N data

library(dplyr)
library(tidyr)

## read in data
cn_2020_03 <- read.csv('raw/pp_spb_cn_2021.03.12.csv')[2:115, c(1, 4, 19, 36)]

# Add Analysis Date, Site, and ID columns, remove rows with standards
cn_2020_03_clean <- cn_2020_03 %>% separate(X, c("Sample", "Month", "Day", "Year")) %>%
  unite("Analysis Date", Month:Year) %>%
  filter(Sample.ID != "QC" & Sample.ID != "Blank" & Sample.ID != "Standard" & Sample.ID != "Bypass") %>%
  separate(Sample.ID, c("Site", "ID"), sep = "(?<=[A-Za-z])(?=[0-9])")
# rename column headers
colnames(cn_2020_03_clean) = c("Sample", "Analysis Date", "Site", "ID", "N", "C")
# rename NRC and NCR to CNR
cn_2020_03_clean$Site[cn_2020_03_clean$Site == "NRC"] <- "CNR"
cn_2020_03_clean$Site[cn_2020_03_clean$Site == "NCR"] <- "CNR"
# add Year and Season columns
cn_2020_03_clean$Year <- rep("2020")
cn_2020_03_clean$Season <- rep("fall")

# adjust CNR ID numbers
cn_2020_03_clean$ID[cn_2020_03_clean$Site == "CNR" & cn_2020_03_clean$ID == 2] <- 1
cn_2020_03_clean$ID[cn_2020_03_clean$Site == "CNR" & cn_2020_03_clean$ID == 3] <- 2
cn_2020_03_clean$ID[cn_2020_03_clean$Site == "CNR" & cn_2020_03_clean$ID == 5] <- 3
cn_2020_03_clean$ID[cn_2020_03_clean$Site == "CNR" & cn_2020_03_clean$ID == 6] <- 4
cn_2020_03_clean$ID[cn_2020_03_clean$Sample == "CNR6"] <- 4
cn_2020_03_clean$ID[cn_2020_03_clean$Site == "CNR" & cn_2020_03_clean$ID == 8] <- 5
cn_2020_03_clean$ID[cn_2020_03_clean$Site == "CNR" & cn_2020_03_clean$ID == 9] <- 6
cn_2020_03_clean$ID[cn_2020_03_clean$Site == "CNR" & cn_2020_03_clean$ID == 11] <- 7
cn_2020_03_clean$ID[cn_2020_03_clean$Site == "CNR" & cn_2020_03_clean$ID == 13] <- 8
cn_2020_03_clean$ID[cn_2020_03_clean$Site == "CNR" & cn_2020_03_clean$ID == 14] <- "14?"
cn_2020_03_clean$ID[cn_2020_03_clean$Site == "CNR" & cn_2020_03_clean$ID == 15] <- 9
cn_2020_03_clean$ID[cn_2020_03_clean$Site == "CNR" & cn_2020_03_clean$ID == 17] <- 10
cn_2020_03_clean$ID[cn_2020_03_clean$Site == "CNR" & cn_2020_03_clean$ID == 18] <- 11
cn_2020_03_clean$ID[cn_2020_03_clean$Site == "CNR" & cn_2020_03_clean$ID == 20] <- 12
cn_2020_03_clean$ID[cn_2020_03_clean$Site == "CNR" & cn_2020_03_clean$ID == 21] <- 13
cn_2020_03_clean$ID[cn_2020_03_clean$Site == "CNR" & cn_2020_03_clean$ID == 23] <- 14
cn_2020_03_clean$ID[cn_2020_03_clean$Site == "CNR" & cn_2020_03_clean$ID == 24] <- 15
cn_2020_03_clean$ID[cn_2020_03_clean$Site == "CNR" & cn_2020_03_clean$ID == 25] <- 16
cn_2020_03_clean$ID[cn_2020_03_clean$Site == "CNR" & cn_2020_03_clean$ID == 27] <- 17
cn_2020_03_clean$ID[cn_2020_03_clean$Site == "CNR" & cn_2020_03_clean$ID == 28] <- 18
cn_2020_03_clean$ID[cn_2020_03_clean$Site == "CNR" & cn_2020_03_clean$ID == 30] <- 19

cn_2020_03_clean <- dplyr::select(cn_2020_03_clean, -"Sample")

write.csv(cn_2020_03_clean, 'cn_data.csv', row.names = F)
