library(tidyverse)


# 7.2 Reading data from a file ------------------------------------------------
students <- read_csv("data/students.csv")
# Or read directly from URL
# students <- read_csv("https://pos.it/r4ds-students-csv")

students <- read_csv("data/students.csv", na = c("N/A", ""))
students

students |>
  rename(
    student_id = `Student ID`,
    full_name = `Full Name`
  )

# clean names space and turns col names into snake_case
students |> janitor::clean_names()

students |>
  janitor::clean_names() |>
  mutate(meal_plan = factor(meal_plan))

students <- students |>
  janitor::clean_names() |>
  mutate(
    meal_plan = factor(meal_plan),
    age = parse_number(if_else(age == "five", "5", age))
  )

read_csv(
  "a,b,c
  1,2,3
  4,5,6"
)

read_csv(
  "The first line of metadata
  The second line of metadata
  x,y,z
  1,2,3",
  skip = 2
)

read_csv(
  "# A comment I want to skip
  x,y,z
  1,2,3",
  comment = "#"
)

read_csv(
  "1,2,3
  4,5,6",
  col_names = FALSE
)


read_csv(
  "1,2,3
  4,5,6",
  col_names = c("x", "y", "z")
)

# read_csv2 : reads semicolon-separated files (;)
# read_tsv : reads tab-delimited files
# read_delim : reads in files with any delimiter (guesses if not specified)
# read_fwf : reads fixed-width lines
# read_table : reads a common varaition of fixed-widht files where columns are separated by white space
# read_log : reads Apache-style log files

### 7.2.4. Exercises

# 1. What function would you use to read a file where fields were separated with “|”?
# > read_delim(file, delim="|")

# 2. Apart from file, skip, and comment, what other arguments do read_csv() and read_tsv() have in common?
# >  read_csv and read_tsv have all other arguments in common

# 3. What are the most important arguments to read_fwf()?
# > `col_positions`, which can be supplied with one of the following: `fwf_empty()`, `fwf_widths()`, or `fwf_positions()`
# > it defines where the columns start and end

# 4. Sometimes strings in a CSV file contain commas. To prevent them from causing problems, they need to be surrounded by a quoting character, like " or '. By default, read_csv() assumes that the quoting character will be ". To read the following text into a data frame, what argument to read_csv() do you need to specify?
# > the "quote" argument
read_csv("x,y\n1,'a,b'", quote = "\'")

# 5. Identify what is wrong with each of the following inline CSV files. What happens when you run the code?

read_csv("a,b\n1,2,3\n4,5,6")
# > there are only two named columns but there are 3 values per row (see know this as its separated by line breaks)
# > when we run it, readr coerces the last two values/columns in the rows by concatenating them, so two cells "2" and "3" becomes "23"

read_csv("a,b,c\n1,2\n1,2,3,4")
# > there are three named columns, but the first row has only 2 values, while the second row has 4 values
# > when we run it, readr fills the 'c' column of the first row with NA, and concetenates "3" and "4" into "34" for the second row

read_csv("a,b\n\"1")
# > there is an escaped double quote in the string, which is fine, as the readr by default detects quoted strings as using the escaped double quotes \"
# > however, there is only one value on the first row, where there should be 2
# > when we run it, readr generates a tibble with named columns "a" and "b", but with zero rows, so the "1" isn't read

read_csv("a,b\n1,2\na,b")
# > readr may have thought cols "a" and "b" are type "int" based on the first row (since they are not quoted), but the second row gives characters
# > when we run it, there is actually no problem, readr just coerces "a" and "b"'s data types into <chr>, and the second row is read as expected

read_csv("a;b\n1;3")
# > the delimiter is ";" instead of "," so we should use either read_csv2 or read_delim(..., delim=";") here.
# > when we run it, readr interprets "a;b" as a single column instead of two column, and subsequently, "1;3" is interpreted as a single value instead of two


# 6. Practice referring to non-syntactic names in the following data frame by:
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)

# a. Extracting the variable called 1.
annoying$"1"
annoying$`1`

annoying |>
  select(`1`)

annoying |>
  select("1")

# b. Plotting a scatterplot of 1 vs. 2.
annoying |>
  ggplot(aes(x = `2`, y = `1`)) + # only backticks `` will work here; using "", R interprets it as a string
  geom_point()

# c. Creating a new column called 3, which is 2 divided by 1.
annoying |>
  mutate(`3` = `2` / `1`)

# d. Renaming the columns to one, two, and three.
annoying |>
  mutate(`3` = `2` / `1`) |>
  rename(
    "one" = `1`,
    "two" = `2`,
    "three" = `3`
  )


# 7.3 Controlling column types --------------------------------------------

read_csv("
  logical,numeric,date,string
  TRUE,1,2021-01-15,abc
  false,4.5,2021-02-15,def
  T,Inf,2021-02-16,ghi
")

simple_csv <- "
  x
  10
  .
  20
  30"
# easy to see "." above, but for more complicated datasets, we may not see it easily

read_csv(simple_csv)

# can try to explicitly declare column type to see where it fails
df <- read_csv(
  simple_csv, 
  col_types = list(x = col_double())
)

# find out about error using `problems`
problems(df)
# > we see that the dataset uses '.' for missing values
# > so we tell readr to interpret '.' as NA
read_csv(simple_csv, na = ".")

another_csv <- "
x,y,z
1,2,3"

read_csv(
  another_csv, 
  col_types = cols(.default = col_character())
)

read_csv(
  another_csv,
  col_types = cols_only(x = col_character())
)


# 7.4 Reading data from multiple files ------------------------------------

# sales_files <- c("data/01-sales.csv", "data/02-sales.csv", "data/03-sales.csv")
sales_files <- c(
  "https://pos.it/r4ds-01-sales",
  "https://pos.it/r4ds-02-sales",
  "https://pos.it/r4ds-03-sales"
)
read_csv(sales_files, id = "file")

sales_files <- list.files("data", pattern = "sales\\.csv")
sales_files


# 7.5 Writing to a file ---------------------------------------------------

write_csv(students, "students.csv")

write_csv(students, "students-2.csv")
read_csv("students-2.csv")
# variable type information you just set up is lost when you save to CSV
# as you're starting over agan with reading from a plain text file


# alternatives:

# 1. write_rds and read_rds; wrapper for readRDS and saveRDS
# Basically RDS is R's custom binary format (serializable format)
# so you reload R objects instead of "reading in a csv", for instance
write_rds(students, "students.rds")
read_rds("students.rds")

# 2. reading/writing parquet files with the `arrow` package, which is a binary file format and works across programming languages
library(arrow)
write_parquet(students, "students.parquet")
read_parquet("students.parquet")

# parquet tends to be much faster than RDS and is usable outside of R, but does require the arrow package


# 7.6 Data entry ----------------------------------------------------------

# creating a tibble by hand
tibble(
  x = c(1, 2, 5),
  y = c("h", "m", "g"),
  z = c(0.08, 0.83, 0.60)
)

# or use t(ransposed) (ti)bble
tribble(
  ~x, ~y, ~z,
  1, "h", 0.08,
  2, "m", 0.83,
  5, "g", 0.60
)

