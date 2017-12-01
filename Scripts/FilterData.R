# Load required packages
library(dplyr)
library(plotly)

# Load required files
source(file="./DataStats.R")

## Process data
# CLients per gender
genders <- c()
genders[1] <- nrow(clients %>% filter(((birth_number / 100) %% 100) < 50))
genders[2] <- nrow(clients %>% filter(((birth_number / 100) %% 100) > 50))

# Plot it and export it
plot_ly(
	x=c("Men", "Women"),
	y=genders,
	name="Clients per Gender",
	type="bar"
)
export(file="../Plots/Gender.png")

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
plot_ly(
	x=c("<20", "20-30", "30-40", "40-50", "50-60", "60-70", "70-80", ">80"),
	y=decades,
	name="Clients per Decades",
	type="bar"
)
export(file="../Plots/Decades.png")
