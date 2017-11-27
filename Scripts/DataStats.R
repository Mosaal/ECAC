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
cat("Summarize and describe the Accounts...\n")
summary(accounts)
describe(accounts)

cat("Summarize and describe the Credit Cards...\n")
summary(cards)
describe(cards)

cat("Summarize and describe the Clients...\n")
summary(clients)
describe(clients)

cat("Summarize and describe the Disposition...\n")
summary(disposition)
describe(disposition)

cat("Summarize and describe the Districts...\n")
summary(districts)
describe(districts)

cat("Summarize and describe the Loans...\n")
summary(loans)
describe(loans)

cat("Summarize and describe the Transactions...\n")
summary(transactions)
describe(transactions)