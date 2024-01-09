library(tidyverse)

## 5.2 Tidy Data
### 5.2.1 Exercises

# 1. For each of the sample tables, describe what each observation and each column represents.
# > Each observation in table1 represents the documented number of cases of TB as well as the population in a country in a certain year
# > Each column in table1 represents a variable ('country', 'year', 'cases', 'population').
# > Each observation in table2 represents the count for a specific variable based on the "type" variable ("cases" or "population") for a country in a certain year
# > Each column in table2 represents a variable except for "type" and "count", where "type" is indicates the variable type corresponding to "count"
# > Each observation in table3 represents the rate of tuberculosis in a country's population in a given year. "Rate" is the number of cases divided by the size of the population.
# > Each row in table3 represents a variable.

# 2. Sketch out the process you’d use to calculate the rate for table2 and table3. You will need to perform four operations:
# > table2: filter out rows by country to find rows where type == "cases" and where type == "population" then mutate to store the rate for the specific country
# > table3: for each observation, extract the prefix before '/' and the suffix as "cases" and "population", then mutate and store as double after dividing the two numbers

## 5.3 Lengthening data
billboard

billboard |>
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank",
  )

billboard |>
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank",
    values_drop_na = TRUE
  )

billboard_longer <-billboard |>
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank",
    values_drop_na = TRUE
  ) |> 
  mutate(
    week = parse_number(week)
  )
billboard_longer


billboard_longer |>
  ggplot(aes(x = week, y = rank, group = track)) +
  geom_line(alpha = 0.25) +
  scale_y_reverse()

df <- tribble(
  ~id, ~bp1, ~bp2,
  "A", 100, 120,
  "B", 140, 115,
  "C", 120, 125
)

df |> 
  pivot_longer(
    cols = bp1:bp2,
    names_to = "measurement",
    values_to = "value"
  )

who2

who2 |>
  pivot_longer(
    cols = !(country:year),
    names_to = c("diagnosis", "gender", "age"),
    names_sep = "_",
    values_to = "count"
  )

household

household |>
  pivot_longer(
    cols = !family,
    names_to = c(".value", "child"),
    names_sep = "_",
    values_drop_na = TRUE
  )


## 5.4 Widening data
cms_patient_experience

cms_patient_experience |>
  distinct(measure_cd, measure_title)

cms_patient_experience |> 
  pivot_wider(
    names_from = measure_cd,
    values_from = prf_rate,
  )

cms_patient_experience |> 
  pivot_wider(
    id_cols = starts_with("org"),
    names_from = measure_cd,
    values_from = prf_rate,
  )
# we just lost the measure_title as well?

df <- tribble(
  ~id, ~measurement, ~value,
  "A", "bp1", 100,
  "B", "bp1", 140,
  "B", "bp2", 115,
  "A", "bp2", 120,
  "A", "bp3", 105,
)

df |>
  pivot_wider(
    names_from = measurement,
    values_from = value,
  )

df |>
  distinct(measurement) |> 
  pull()

df |> 
  select(-measurement, -value) |> 
  distinct()

df |> 
  select(-measurement, -value) |> 
  distinct() |> 
  mutate(x = NA, y = NA, z = NA)

df <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "A",        "bp1",    102,
  "A",        "bp2",    120,
  "B",        "bp1",    140, 
  "B",        "bp2",    115
)

df |>
  pivot_wider(
    names_from = measurement,
    values_from = value
  )

df |> 
  group_by(id, measurement) |> 
  summarize(n = n(), .groups = "drop") |> 
  filter(n > 1)
