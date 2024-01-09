library(dplyr)
library(nycflights13)

not_cancelled <- flights |> 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled |>
  group_by(year, month, day) |> 
  summarize(mean = mean(dep_delay))


# Syntax Highlighting for Errors ------------------------------------------

# x y <- 10

# 3 == NA

getwd()

# not recommended to set working directory from within R
# setwd("/path/to/my/CoolProject")