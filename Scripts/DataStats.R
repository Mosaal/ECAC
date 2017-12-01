# Load required packages
library(describer)

# Load data
cat("Loading accounts...\n")
accounts <- read.csv2(file="../Data/account.csv")

cat("Loading credit cards...\n")
cards <- read.csv2(file="../Data/card_train.csv")

cat("Loading clients...\n")
clients <- read.csv2(file="../Data/client.csv")

cat("Loading disposition...\n")
disposition <- read.csv2(file="../Data/disp.csv")

cat("Loading districts...\n")
districts <- read.csv2(file="../Data/district.csv")

cat("Loading loans...\n")
loans <- read.csv2(file="../Data/loan_train.csv")

cat("Loading transactions...\n")
transactions <- read.csv2(file="../Data/trans_train.csv")

# Summarize and describe data
cat("Accounts loaded.\n")
summary(accounts)
describe(accounts)

cat("Credit Cards loaded.\n")
summary(cards)
describe(cards)

cat("Clients loaded.\n")
summary(clients)
describe(clients)

cat("Disposition loaded.\n")
summary(disposition)
describe(disposition)

cat("Districts loaded.\n")
summary(districts)
describe(districts)

cat("Loans loaded.\n")
summary(loans)
describe(loans)

cat("Transactions loaded.\n")
summary(transactions)
describe(transactions)