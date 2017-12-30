library(dplyr)

# Load necessary data
disp <- read.csv2(file = "../Original Data/disp.csv", sep = ";", stringsAsFactors = FALSE)
client <- read.csv2(file = "../Original Data/client.csv", sep = ";", stringsAsFactors = FALSE)
account <- read.csv2(file = "../Original Data/account.csv", sep = ";", stringsAsFactors = FALSE)
district <- read.csv2(file = "../Original Data/district.csv", sep = ";", stringsAsFactors = FALSE)
trans_test <- read.csv2(file = "../Original Data/trans_test.csv", sep = ";", stringsAsFactors = FALSE)
trans_train <- read.csv2(file = "../Original Data/trans_train.csv", sep = ";", stringsAsFactors = FALSE)

# Separate men from women
men <- client %>% filter(((birth_number / 100) %% 100) < 50)
women <- client %>% filter(((birth_number / 100) %% 100) > 50)

# Normalize women birth dates
women["birth_number"] <- women$birth_number - 5000

# Merge clients' new data
client <- rbind(women, men)
client <- client[with(client, order(client_id)),]

# Reformat clients' birth dates
client$birth_number <- as.Date(as.character(client$birth_number + 19000000), "%Y%m%d")
client[,"birth_year"] <- as.numeric(format(client$birth_number, '%Y'))

# Remove unnecessary data
client <- subset(client, select = -c(birth_number))

# Merge clients' data with the districts' data
client_district <- merge(client, district, by.x = "district_id", by.y = "code")

# Remove unnecessary data
client_district <- subset(client_district, select = -c(district_id, name, region, no..of.inhabitants, no..of.municipalities.with.inhabitants...499, no..of.municipalities.with.inhabitants.500.1999, no..of.municipalities.with.inhabitants.2000.9999, no..of.municipalities.with.inhabitants..10000, no..of.cities, ratio.of.urban.inhabitants, average.salary, unemploymant.rate..95, unemploymant.rate..96, no..of.enterpreneurs.per.1000.inhabitants, no..of.commited.crimes..95, no..of.commited.crimes..96))

# Merge dispositions with the accounts
account_client <- merge(disp, account)
account_client <- merge(account_client, client_district)

# Remove unnecessary data
account_client <- subset(account_client, select = -c(date, frequency, type, disp_id, district_id))

# Create final dataset holder
descriptive_dataset <- account_client

# Calculate balances' standard deviation
sd_balance <- aggregate(trans_train[,"balance"], list(account_id = trans_train$account_id), sd)
sd_balance_test <- aggregate(trans_test[,"balance"], list(account_id = trans_test$account_id), sd)

colnames(sd_balance)[2] <- "balance_sd"
colnames(sd_balance_test)[2] <- "balance_sd"

sd_balance_all <- merge(x = sd_balance, y = sd_balance_test, all = TRUE)
descriptive_dataset <- merge(descriptive_dataset, sd_balance_all, all.x=TRUE)

# Calculate balances' average
avg_balance <- aggregate(trans_train[,"balance"], list(account_id = trans_train$account_id), mean)
avg_balance_test <- aggregate(trans_test[,"balance"], list(account_id = trans_test$account_id), mean)

colnames(avg_balance)[2] <- "balance_avg"
colnames(avg_balance_test)[2] <- "balance_avg"

avg_balance_all <- merge(x = avg_balance, y = avg_balance_test, all = TRUE)
descriptive_dataset <- merge(descriptive_dataset, avg_balance_all, all.x=TRUE)

# Remove unnecessary data
descriptive_dataset <- subset(descriptive_dataset, select = -c(account_id))

# Write final dataset to a CSV file
write.csv(descriptive_dataset, file = "../Data/descriptive.csv", row.names = FALSE)