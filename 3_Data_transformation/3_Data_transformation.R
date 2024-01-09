library(nycflights13)
library(tidyverse)

flights

View(flights)
print(flight, width = Inf)
glimpse(flights)

flights |>
  filter(dest == "IAH") |>
  group_by(year, month, day) |>
  summarize(
    arr_delay = mean(arr_delay, na.rm = TRUE)
  )

## 3.2 Rows
flights |>
  filter(dep_delay > 120)

flights |>
  filter(month == 1 & day == 1)

flights |>
  filter(month == 1 | month == 2)

flights |>
  filter(month %in% c(1, 2))

jan1 <- flights |>
  filter(month == 1 & day == 1)

flights |>
  arrange(year, month, day, dep_time)

flights |>
  arrange(desc(dep_delay))

flights |> distinct()

flights |>
  distinct(origin, dest)

flights |>
  distinct(origin, dest, .keep_all = TRUE)

flights |>
  count(origin, dest, sort = TRUE)

### 3.2.5 Exercises
# 1. In a single pipeline for each condition, find all flights that meet the condition:

# - Had an arrival delay of two or more hours
flights |> filter(arr_delay >= 60 * 2)

# - Flew to Houston (IAH or HOU)
flights |> filter(dest %in% c("IAH", "HOU"))

# - Were operated by United, American, or Delta
flights |> filter(carrier %in% c("AA", "DL", "UA"))

# - Departed in summer (July, August, and September)
flights |> filter(month %in% c(7, 8, 9))

# - Arrived more than two hours late, but didn’t leave late
flights |> filter(arr_delay > 2 * 60 & dep_delay <= 0)

# - Were delayed by at least an hour, but made up over 30 minutes in flight
flights |> filter(dep_delay >= 1 * 60 & dep_delay - arr_delay > 30)

# 2. Sort flights to find the flights with longest departure delays. Find the flights that left earliest in the morning.
flights |> arrange(desc(dep_delay)) |> arrange(dep_time)

# 3. Sort flights to find the fastest flights. (Hint: Try including a math calculation inside of your function.)
flights |> arrange(distance / air_time)

# 4. Was there a flight on every day of 2013?
flights |> filter(year == 2013) |> distinct(month, day) |> count()
# > output: 365 days; Since 2013 is not a leap year and the df has 365 days
# >   we conclude that there was a flight on everyday of 2013

# 5. Which flights traveled the farthest distance? Which traveled the least distance?
flights |> arrange(desc(distance)) # farthest distance flights
flights |> arrange(distance) # shortest distance flights

# 6. Does it matter what order you used filter() and arrange() if you’re using both? Why/why not? Think about the results and how much work the functions would have to do.
# > order doesn't matter unless we are applying a function that relies on row order inside of filter()
# > however, using filter first before arrange will help reduce the computation
# > as a basic rule, it takes O(n log n) to sort a dataframe; if we filtered out k rows, then arrange will only take O( (n-k)*log(n-k) ) time instead

## 3.3 Columns
flights |>
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60
  )

flights |>
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
   .before = 1
  )

flights |>
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .after = day
  )

flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    hours = air_time / 60,
    gain_per_hour = gain / hours,
    .keep = "used"
  )

flights |>
  select(year, month, day)

flights |>
  select(year:day)

flights |>
  select(!year:day)

flights |>
  select(where(is.character))

flights |>
  select(tail_num = tailnum)

flights |>
  rename(tail_num = tailnum)

flights |>
  relocate(time_hour, air_time)

flights |>
  relocate(year:dep_time, .after = time_hour)

flights |>
  relocate(starts_with("arr"), .before = dep_time)

### 3.3.5 Exercises
# 1. Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers to be related?
# > dep_delay = dep_time - sched_dep_time
flights |>
  relocate(dep_time, sched_dep_time, dep_delay)

# 2. Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights.
flights |>
  select(dep_time, dep_delay, arr_time, arr_delay)

flights |>
  select(starts_with("dep"), starts_with("arr"))

flights |>
  select(dep_time:arr_delay, -contains("sched"))

# 3. What happens if you specify the name of the same variable multiple times in a select() call?
flights |>
  select(dep_time, dep_time)
# > the variable is only selected/shown once

# 4. What does the any_of() function do? Why might it be helpful in conjunction with this vector?
variables <- c("year", "month", "day", "dep_delay", "arr_delay")
# > any_of allows you to select any of the columns in the argument without throwing error if the column is missing (just ignores it instead)
# > good if we are repeating the column selection multiple times
flights |>
  select(any_of(variables))

# 5. Does the result of running the following code surprise you? How do the select helpers deal with upper and lower case by default? How can you change that default?
flights |> select(contains("TIME"))
# > yes, it surprises me because I thought R is case-sensitive.
# > but it seems that the select helper ignores cases by default
# > we can change default by setting `ignore.case = FALSE`
flights |> select(contains("TIME", ignore.case = FALSE))

# 6. Rename air_time to air_time_min to indicate units of measurement and move it to the beginning of the data frame.
flights |>
  rename(air_time_min = air_time) |>
  relocate(air_time_min)

# 7. Why doesn’t the following work, and what does the error mean?
flights |> 
  select(tailnum) |> 
  arrange(arr_delay)
# > the code doesn't work because we selected only `tailnum`, so the only
#   remaining column in the dataframe is `tailnum`, so `arr_delay` doesn't exist here
# > we could arrange it first before selecting


## 3.4 The pipe
flights |>
  filter(dest == "IAH") |>
  mutate(speed = distance / air_time * 60) |>
  select(year:day, dep_time, carrier, flight, speed) |>
  arrange(desc(speed))

# use pipes instead of
flights1 <- filter(flights, dest == "IAH")
flights2 <- mutate(flights1, speed = distance / air_time * 60)
flights3 <- select(flights2, year:day, dep_time, carrier, flight, speed)
arrange(flights3, desc(speed))

# or nested calls
arrange(
  select(
    mutate(
      filter(
        flights, 
        dest == "IAH"
      ),
      speed = distance / air_time * 60
    ),
    year:day, dep_time, carrier, flight, speed
  ),
  desc(speed)
)

## 3.5 Groups
flights |>
  group_by(month)

flights |>
  group_by(month) |>
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    n = n()
  )

flights |>
  group_by(dest) |>
  slice_max(arr_delay, n = 3, with_ties = FALSE) |>
  relocate(dest, arr_delay)

daily <- flights |>
  group_by(year, month, day)
daily

daily_flights <- daily |>
  summarize(n = n())

daily |>
  ungroup() |>
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    flights = n()
  )

flights |>
  summarize(
    delay = mean(dep_delay, na.rm = TRUE),
    n = n(),
    .by = month
  )

flights |>
  summarize(
    delay = mean(dep_delay, na.rm = TRUE),
    n = n(),
    .by = c(origin, dest)
  )

### 3.5.7 Exercises

# 1. Which carrier has the worst average delays? Challenge: can you disentangle the effects of bad airports vs. bad carriers? Why/why not? (Hint: think about flights |> group_by(carrier, dest) |> summarize(n()))
flights |>
  group_by(carrier) |>
  summarize(delay = mean(dep_delay, na.rm = TRUE)) |>
  arrange(desc(delay))

# > F9 carrier has the worst average delays

flights |>
  group_by(carrier, dest) |>
  summarize(n())

# if other carriers also has higher than average delays at a certain airport,
# then it is likely that the delay is caused by the "bad airport" rather than the carrier
# look at the number of flights in those high-delay airport and what carriers fly from there and at what percentage
# maybe some airports mainly operates with F9 or another airline, so the effect would is likely to be from the airline
# but if those airports have a multitude of airlines operating from there, then it is likely just the effects of the airport itself

# 2. Find the flights that are most delayed upon departure from each destination.
flights |>
  group_by(dest) |>
  slice_max(dep_delay) |>
  relocate(dest, flight, dep_delay)

# 3. How do delays vary over the course of the day. Illustrate your answer with a plot.
flights |>
  group_by(hour) |>
  summarize(delay = mean(dep_delay, na.rm = TRUE)) |>
  ggplot(mapping = aes(x = hour, y = delay)) + geom_smooth()
# > early morning flights tend to get delayed less
# > flights get delayed more over the course of the day, peaking in the evening

# 4. What happens if you supply a negative n to slice_min() and friends?
flights |>
  slice_min(dep_delay, n = -3)

flights |>
  slice_min(dep_delay, n = 3)

flights |>
  slice_max(dep_delay, n = -3)

flights |>
  slice_max(dep_delay, n = 3)
# > it just arranges the data in ascending or descending order based on if we use slice_min or slice_max, but doesn't "slice" or remove rows

# 5. Explain what count() does in terms of the dplyr verbs you just learned. What does the sort argument to count() do?

# > count() basically calls group_by() if we give it columns, then calls summarize(n = n())
# (it counts the number of observations in each group)
# > the sort argument arranges the counts in descending order if TRUE

# 6. Suppose we have the following tiny data frame:
df <- tibble(
  x = 1:5,
  y = c("a", "b", "a", "a", "b"),
  z = c("K", "K", "L", "L", "K")
)

# a. Write down what you think the output will look like, then check if you were correct, and describe what group_by() does.
df |>
  group_by(y)
# > the output should look the same, but the output will show that we have variable "y" as a group
# > (correct)
# > group_by adds a property to the data frame object, describing the groups to be used in future verbs

# b. Write down what you think the output will look like, then check if you were correct, and describe what arrange() does. Also comment on how it’s different from the group_by() in part (a)?
df |>
  arrange(y)
# > the rows will be sorted in ascending, lexicographical order according to column y
# > the other columns may not be in order, within each group of y
# > (correct)
# > arrange sorts the rows based on the column we tell it to sort on, and these columns/groups don't apply to future verbs

# c. Write down what you think the output will look like, then check if you were correct, and describe what the pipeline does.
df |>
  group_by(y) |>
  summarize(mean_x = mean(x))
# > the output will show two columns: y and mean_x, which is the mean of the x values within each y group
# > (correct)

# d. Write down what you think the output will look like, then check if you were correct, and describe what the pipeline does. Then, comment on what the message says.
df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x))
# > the output will group by both y and z, then commute the mean x value of each y,z group.
# > For example, (a, K) will be a different group than (a, L)
# (correct)

# e. Write down what you think the output will look like, then check if you were correct, and describe what the pipeline does. How is the output different from the one in part (d).
df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x), .groups = "drop")
# > the groups will be ignored and dropped from the dataframe,
# > so the output should just be one row describing the mean x value across the entire dataframe
# > (incorrect): the output values are still the same, but the groups inside the dataframe are dropped, so they won't be used for future verbs

# f. Write down what you think the outputs will look like, then check if you were correct, and describe what each pipeline does. How are the outputs of the two pipelines different?
df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x))

# > the output will show the computed the mean x value of each (y, z) group
# > there will also only be one group "y" left due to how multiple grouping works in dplyr
df |>
  group_by(y, z) |>
  mutate(mean_x = mean(x))
# > there will be a new column "mean_x" which is the mean of each group (y, z)
# > but the row count will still be the same
# > there will still be two groups, "y" and "z"

## 3.6 Aggregates and Sample Size
batters <- Lahman::Batting |> 
  group_by(playerID) |> 
  summarize(
    performance = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    n = sum(AB, na.rm = TRUE)
  )
batters

batters |> 
  filter(n > 100) |> 
  ggplot(aes(x = n, y = performance)) +
  geom_point(alpha = 1 / 10) + 
  geom_smooth(se = FALSE)

batters |> 
  arrange(desc(performance))
