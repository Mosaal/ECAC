# Load required packages
library(dplyr)

# Load required files
source(file="./DataStats.R")

## Process data
# CLients per gender
genders <- c()
genders[1] <- nrow(clients %>% filter(((birth_number / 100) %% 100) < 50))
genders[2] <- nrow(clients %>% filter(((birth_number / 100) %% 100) > 50))

# Plot it and export it
cols <- c("Male", "Female")
barplot(genders, ylab="Clients", xlab="Gender", names.arg=cols, main="Clients per Gender")

# Clients per decade
decades <- c()
decades[1] <- nrow(clients %>% filter(birth_number / 10000 < 20))
decades[2] <- nrow(clients %>% filter(birth_number / 10000 >= 20) %>% filter(birth_number / 10000 < 30))
decades[3] <- nrow(clients %>% filter(birth_number / 10000 >= 30) %>% filter(birth_number / 10000 < 40))
decades[4] <- nrow(clients %>% filter(birth_number / 10000 >= 40) %>% filter(birth_number / 10000 < 50))
decades[5] <- nrow(clients %>% filter(birth_number / 10000 >= 50) %>% filter(birth_number / 10000 < 60))
decades[6] <- nrow(clients %>% filter(birth_number / 10000 >= 60) %>% filter(birth_number / 10000 < 70))
decades[7] <- nrow(clients %>% filter(birth_number / 10000 >= 70) %>% filter(birth_number / 10000 < 80))
decades[8] <- nrow(clients %>% filter(birth_number / 10000 >= 80))

# Plot it and export it
cols <- c("<20", "20-30", "30-40", "40-50", "50-60", "60-70", "70-80", ">80")
barplot(decades, ylab="Clients", xlab="Decade", names.arg=cols, main="Clients per Decade")

# Issuance frequency
issuances <- c()
issuances[1] <- nrow(accounts %>% filter(frequency == "issuance after transaction"))
issuances[2] <- nrow(accounts %>% filter(frequency == "weekly issuance"))
issuances[3] <- nrow(accounts %>% filter(frequency == "monthly issuance"))

# Plot it and export it
cols <- c("issuance after transaction", "weekly issuance", "monthly issuance")
barplot(issuances, ylab="Frequency", xlab="Issuance", names.arg=cols, main="Issuances Frequency")

# Card type frequency
cTypes <- c()
cTypes[1] <- nrow(cards %>% filter(type == "junior"))
cTypes[2] <- nrow(cards %>% filter(type == "classic"))
cTypes[3] <- nrow(cards %>% filter(type == "gold"))

# Calculate percentage
total <- cTypes[1] + cTypes[2] + cTypes[3]
slices <- round((cTypes / total) * 100, digits=0)

# Plot it and export it
lbls <- c(
	paste("junior ", slices[1], "%", sep=""),
	paste("classic ", slices[2], "%", sep=""),
	paste("gold ", slices[3], "%", sep="")
)
pie(slices, labels=lbls, main="Credit Cards Frequency")

# Clients per region
cliReg <- c()
regNames <- unique(districts$region)

# Replace 'disID' by 'code' on clients table
tempCli <- c()
tempCli$code <- clients$district_id
tempCli$client_id <- clients$client_id
tempCli$birth_number <- clients$birth_number

# Merge districts and clients
mrg <- merge(tempCli, districts, by="code")

# Count number of clients per region
for (r in regNames) {
	cliReg[r] <- nrow(mrg %>% filter(region == r))
}

# Plot it and export it
barplot(cliReg, ylab="Clients", xlab="Region", names.arg=regNames, main="Clients per Region")

# Average salary per region
salReg <- c()
for (r in regNames) {
	temp <- districts %>% filter(region == r)
	salReg[r] <- mean(temp$average.salary)
}

# Plot it and export it
barplot(salReg, ylab="Average Salary", xlab="Region", names.arg=regNames, main="Average Salary per Region")

# Unemploymant rates growth
# TODO