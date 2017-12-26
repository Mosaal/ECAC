# Load required packages
library(describer)

# Load data
cat("Loading accounts...\n")
accounts <- read.csv2(file="../Data/account.csv", sep=";", stringsAsFactors = FALSE)

cat("Loading credit cards...\n")
cards_train <- read.csv2(file="../Data/card_train.csv", sep=";", stringsAsFactors = FALSE)

cards_test <- read.csv2(file="../Data/card_test.csv", sep=";", stringsAsFactors = FALSE)

cat("Loading clients...\n")
clients <- read.csv2(file="../Data/client.csv", sep=";", stringsAsFactors = FALSE)

cat("Loading disposition...\n")
dispositions <- read.csv2(file="../Data/disp.csv", sep=";", stringsAsFactors = FALSE)

cat("Loading districts...\n")
districts <- read.csv2(file="../Data/district.csv", sep=";", stringsAsFactors = FALSE)

cat("Loading loans...\n")
loans_train <- read.csv2(file="../Data/loan_train.csv", sep=";", stringsAsFactors = FALSE)

loans_test <- read.csv2(file="../Data/loan_test.csv", sep=";", stringsAsFactors = FALSE)

cat("Loading transactions...\n")
transactions_train <- read.csv2(file="../Data/trans_train.csv", sep=";", stringsAsFactors = FALSE)

transactions_test <- read.csv2(file="../Data/trans_test.csv", sep=";", stringsAsFactors = FALSE)

# Summarize and describe data
cat("Accounts loaded.\n")
summary(accounts)
describe(accounts)
str(accounts)

cat("Credit Cards loaded.\n")
summary(cards_train)
describe(cards_train)
str(cards_train)

summary(cards_test)
describe(cards_test)
str(cards_test)

cat("Clients loaded.\n")
summary(clients)
describe(clients)
str(clients)

cat("Disposition loaded.\n")
summary(dispositions)
describe(dispositions)
str(dispositions)

cat("Districts loaded.\n")
summary(districts)
describe(districts)
str(districts)

cat("Loans loaded.\n")
summary(loans_train)
describe(loans_train)
str(loans_train)

summary(loans_test)
describe(loans_test)
str(loans_test)

cat("Transactions loaded.\n")
summary(transactions_train)
describe(transactions_train)
str(transactions_train)

summary(transactions_test)
describe(transactions_test)
str(transactions_test)