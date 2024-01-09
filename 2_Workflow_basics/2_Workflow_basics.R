### 2.5 Exercises
# 1. Why does this code not work?
my_variable <- 10
my_varıable
#> Error in eval(expr, envir, enclos): object 'my_varıable' not found
#> 
#> we use 'i' in the assignment statement, but we used 'l' in the line after

# 2. Tweak each of the following R commands so that they run correctly:

library(tidyverse)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() +
  geom_smooth(method = "lm")

# 3. Press Option + Shift + K / Alt + Shift + K. What happens? How can you get to the same place using the menus?
# > a "Keyboard Shortcut Quick Reference" sheet pops up, overlaying RStudio
# > in the upper left-hand corner of your Mac screen (not RStudio, but the bar on top of the screen itself), navigate to "Help" > "Keyboard Shortcuts Help"

# 4. Let’s revisit an exercise from the Section 1.6. Run the following lines of code. Which of the two plots is saved as mpg-plot.png? Why?
my_bar_plot <- ggplot(mpg, aes(x = class)) +
  geom_bar()
my_scatter_plot <- ggplot(mpg, aes(x = cty, y = hwy)) +
  geom_point()
ggsave(filename = "mpg-plot.png", plot = my_bar_plot)
# > The first plot because we specify `plot = my_bar_plot` instead of using the default, which is the last saved plot