source('./DataStats.R')

library(dplyr)

#district
#set missing values
districts$unemploymant.rate..95[districts$unemploymant.rate..95 == "?"] <- districts$unemploymant.rate..96[districts$unemploymant.rate..95 == "?"]
districts$no..of.commited.crimes..95[districts$no..of.commited.crimes..95 == "?"] <- districts$no..of.commited.crimes..96[districts$no..of.commited.crimes..95 == "?"]
districts$unemploymant.rate..95 <- as.numeric(districts$unemploymant.rate..95)
districts$unemploymant.rate..96 <- as.numeric(districts$unemploymant.rate..96)

#unimportant data
districts$no..of.municipalities.with.inhabitants...499 <- NULL
districts$no..of.municipalities.with.inhabitants.500.1999 <- NULL
districts$no..of.municipalities.with.inhabitants.2000.9999 <- NULL
districts$no..of.municipalities.with.inhabitants..10000 <- NULL
districts$no..of.cities <- NULL

#-----------------------------------------------------------

#get women
women <- clients %>% filter( ((birth_number / 100) %% 100) > 50)
men <- clients %>% filter( ((birth_number / 100) %% 100) < 50)

#normalize date for women
women["birth_number"] <- women$birth_number - 5000
#set gender
women[,"gender"] <- 0
men[,"gender"] <- 1

clients <- rbind(women,men)
clients <- clients[ with(clients, order(client_id)),]

#clients
clients$birth_number <- as.Date(as.character(clients$birth_number + 19000000), "%Y%m%d")
clients[,"birth_year"] <- as.numeric(format(clients$birth_number,'%Y'))
clients$birth_number <- NULL


#merge data
merged_data <- merge(clients, districts, by.x = "district_id", by.y = "code")
#unimportant data
merged_data$district_id <- NULL
merged_data$no..of.municipalities.with.inhabitants...499 <- NULL
merged_data$no..of.municipalities.with.inhabitants.500.1999 <- NULL
merged_data$no..of.municipalities.with.inhabitants.2000.9999 <- NULL
merged_data$no..of.municipalities.with.inhabitants..10000 <- NULL
merged_data$no..of.cities <- NULL

merged_data <- merge(merged_data, dispositions, by = "client_id")
#in dipositions only owners information is important
merged_data <- subset(merged_data, merged_data$type == "OWNER")
#unimportant data
merged_data$district_id <- NULL
merged_data$name <- NULL
merged_data$type <- NULL

merged_data <- merge(merged_data, accounts, by = "account_id", all.x = TRUE)
#unimportant data
merged_data$date <- NULL
merged_data$district_id <- NULL


#merge loans with processed data
merged_train <- merge(merged_data, loans_train)
merged_test <- merge(merged_data, loans_test)

merged_train$status[is.na(merged_train$status)] <- 0
merged_test$status[is.na(merged_test$status)] <- 0
merged_train$status <- as.integer(merged_train$status)
merged_test$status <- as.integer(merged_test$status)

#unimportant data

merged_train$date <- NULL
merged_test$date <- NULL


transactions_train$balance <- as.numeric(transactions_train$balance)
transactions_test$balance <- as.numeric(transactions_test$balance)
# sd and avg balance
sd_balance_train <- aggregate(transactions_train[,"balance"], list(account_id = transactions_train$account_id), sd)
sd_balance_test <- aggregate(transactions_test[,"balance"], list(account_id = transactions_test$account_id), sd)

colnames(sd_balance_train)[2] <- "balance_sd"
colnames(sd_balance_test)[2] <- "balance_sd"

avg_balance_train <- aggregate(transactions_train[,"balance"], list(account_id = transactions_train$account_id), mean)
avg_balance_test <- aggregate(transactions_test[,"balance"], list(account_id = transactions_test$account_id), mean)

colnames(avg_balance_train)[2] <- "balance_avg"
colnames(avg_balance_test)[2] <- "balance_avg"

# merge transactions data
merged_train <- merge(merged_train, avg_balance_train, by = "account_id", all.x = TRUE)
merged_train<- merge(merged_train, sd_balance_train, by = "account_id", all.x = TRUE)
merged_test <- merge(merged_test, avg_balance_test, by = "account_id", all.x = TRUE)
merged_test<- merge(merged_test, sd_balance_test, by = "account_id", all.x = TRUE)

#unimportant data
merged_train$no..of.municipalities.with.inhabitants...499 <- NULL
merged_train$no..of.municipalities.with.inhabitants.500.1999 <- NULL
merged_train$no..of.municipalities.with.inhabitants.2000.9999 <- NULL
merged_train$no..of.municipalities.with.inhabitants..10000 <- NULL
merged_train$no..of.cities <- NULL

merged_test$no..of.municipalities.with.inhabitants...499 <- NULL
merged_test$no..of.municipalities.with.inhabitants.500.1999 <- NULL
merged_test$no..of.municipalities.with.inhabitants.2000.9999 <- NULL
merged_test$no..of.municipalities.with.inhabitants..10000 <- NULL
merged_test$no..of.cities <- NULL

#removing ids
merged_train$account_id <- NULL
merged_train$disp_id <- NULL

merged_test$account_id <- NULL
merged_test$disp_id <- NULL

#Adapting some collumns
merged_train$frequency[merged_train$frequency=="monthly issuance"] <- 0
merged_train$frequency[merged_train$frequency=="weekly issuance"] <- 1
merged_train$frequency[merged_train$frequency=="issuance after transaction"] <- 2

merged_test$frequency[merged_test$frequency=="monthly issuance"] <- 0
merged_test$frequency[merged_test$frequency=="weekly issuance"] <- 1
merged_test$frequency[merged_test$frequency=="issuance after transaction"] <- 2

merged_train$frequency <- as.numeric(merged_train$frequency)
merged_test$frequency <- as.numeric(merged_test$frequency)

merged_train$region[merged_train$region=="Prague"] <- 0
merged_train$region[merged_train$region=="central Bohemia"] <- 1
merged_train$region[merged_train$region=="south Bohemia"] <- 2
merged_train$region[merged_train$region=="west Bohemia"] <- 3
merged_train$region[merged_train$region=="north Bohemia"] <- 4
merged_train$region[merged_train$region=="east Bohemia"] <- 5
merged_train$region[merged_train$region=="south Moravia"] <- 6
merged_train$region[merged_train$region=="north Moravia"] <- 7

merged_test$region[merged_test$region=="Prague"] <- 0
merged_test$region[merged_test$region=="central Bohemia"] <- 1
merged_test$region[merged_test$region=="south Bohemia"] <- 2
merged_test$region[merged_test$region=="west Bohemia"] <- 3
merged_test$region[merged_test$region=="north Bohemia"] <- 4
merged_test$region[merged_test$region=="east Bohemia"] <- 5
merged_test$region[merged_test$region=="south Moravia"] <- 6
merged_test$region[merged_test$region=="north Moravia"] <- 7

merged_train$region <- as.numeric(merged_train$region)
merged_test$region <- as.numeric(merged_test$region)

################################################################################




write.csv(merged_train, file="../Data/processed_train.csv", row.names = FALSE)

write.csv(merged_test, file="../Data/processed_test.csv", row.names = FALSE)