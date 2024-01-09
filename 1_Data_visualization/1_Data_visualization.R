library(tidyverse)
library(palmerpenguins)
library(ggthemes)

penguins

glimpse(penguins)

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)
) +
  geom_point()

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)
) +
  geom_point() +
  geom_smooth(method = "lm")

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(mapping = aes(color = species)) +
  geom_smooth(method = "lm")

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(mapping = aes(color = species, shape = species)) +
  geom_smooth(method = "lm")

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(aes(color = species, shape = species)) +
  geom_smooth(method = "lm") +
  labs(
    title = "Body mass and flipper length",
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Flipper length (mm)", y = "Body mass (g)",
    color = "Species", shape = "Species"
  ) +
  scale_color_colorblind()

# 1.2.5 Exercises

# 1. How many rows are in penguins? How many columns
dim(penguins) # 344 observations (rows), 8 variables (cols)

# 2. What does the bill_depth_mm variable in the penguins data frame describe?
# Read the help for ?penguins to find out.
?penguins # bill_depth_mm is a number denoting the the bill depth in millimeters

# 3. Make a scatterplot of bill_depth_mm vs. bill_length_mm.
# That is, make a scatterplot with bill_depth_mm on the y-axis and bill_length_mm on the x-axis.
# Describe the relationship between these two variables.
ggplot(data = penguins, mapping = aes(x = bill_length_mm, y = bill_depth_mm, color = species, shape = species)) + geom_point()
# without grouping by species, the data seems to be in clusters, and we can't describe an exact relationship.
ggplot(data = penguins, mapping = aes(x = bill_length_mm, y = bill_depth_mm, color = species, shape = species)) + geom_point()
# There seems to be a moderately strong positive linear relationship between bill_length_mm and bill_depth_mm, when we look at each species seperately.

# 4. What happens if you make a scatterplot of species vs. bill_depth_mm? What might be a better choice of geom?
ggplot(data = penguins, mapping = aes(x = species, y = bill_depth_mm)) + geom_point()
# we see three vertical lines representing the varying bill_depth_mm of observations in each species
# we can better use boxplots geom to visualize categorical variables against numerical variables
ggplot(data = penguins, mapping = aes(x = species, y = bill_depth_mm)) + geom_boxplot()

# 5. Why does the following give an error and how would you fix it?
ggplot(data = penguins) + geom_point()
# the error is caused by the `geom_point()` function call not being given its required aesthetics arguments for x and y
# we can fix this by giving the plot an aesthetic mapping in either the global level `ggplot` or within `geom_point`
# passing it the variables we want to plot for x and y (we choose species and bill_depth_mm here arbitrarily)
ggplot(data = penguins) + geom_point(mapping = aes(x = species, y = bill_depth_mm))

# 6. What does the na.rm argument do in geom_point()? What is the default value of the argument? Create a scatterplot where you successfully use this argument set to TRUE.
# > the `na.rm` argument removes missing values with a warning when the value is FALSE; when it is TRUE, the missing values are silently removed
# > the default value is FALSE
ggplot(data = penguins, mapping = aes(x = bill_length_mm, y = bill_depth_mm, color = species, shape = species)) + geom_point(na.rm = TRUE)

# 7. Add the following caption to the plot you made in the previous exercise: “Data come from the palmerpenguins package.” Hint: Take a look at the documentation for labs().
ggplot(data = penguins, mapping = aes(x = bill_length_mm, y = bill_depth_mm, color = species, shape = species)) + geom_point(na.rm = TRUE) +
  labs(caption = "Data comes from the palmerpenguins package.")

# 8. Recreate the following visualization. What aesthetic should bill_depth_mm be mapped to? And should it be mapped at the global level or at the geom level?
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(color = bill_depth_mm)) +
  geom_smooth()
# > bill_depth_mm should be mapping at the geom level as geom_smooth would otherwise need a different scale

# 9. Run this code in your head and predict what the output will look like. Then, run the code in R and check your predictions.
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = island)
) +
  geom_point() +
  geom_smooth(se = FALSE)
# > prediction: scatterplot of flipper_length vs body_mass, with observations grouped by island using color, and the line will not have an interval around it
# > results: mostly right, but I thought there would only be one line; here the colors are mapped globally, so we have 3 lines instead of 1 (if it were mapped at the geom level)

# 10. Will these two graphs look different? Why/why not?
# > No, it shouldn't be cause the aesthetic mappings are the same and inherited
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point() +
  geom_smooth()

ggplot() +
  geom_point(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  ) +
  geom_smooth(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  )


### 1.4 Visualizing distributions
ggplot(penguins, aes(x = species)) +
  geom_bar()

ggplot(penguins, aes(x = fct_infreq(species))) + geom_bar()

ggplot(penguins, aes(x = body_mass_g)) + geom_histogram(binwidth = 200)
ggplot(penguins, aes(x = body_mass_g)) + geom_histogram(binwidth = 20)
ggplot(penguins, aes(x = body_mass_g)) + geom_histogram(binwidth = 2000)
ggplot(penguins, aes(x = body_mass_g)) + geom_density()

## 1.4.3 Exercises

# 1. Make a bar plot of species of penguins, where you assign species to the y aesthetic. How is this plot different?
ggplot(penguins, aes(y = species)) + geom_bar()
# > the categorical variable `species` is on the y-axis instead, so the bar projects horizontally to right

# 2. How are the following two plots different? Which aesthetic, color or fill, is more useful for changing the color of bars?
ggplot(penguins, aes(x = species)) +
  geom_bar(color = "red")

ggplot(penguins, aes(x = species)) +
  geom_bar(fill = "red")
# > the `color` aesthetic changes the outline color of the bar, while the `fill` aesthetic changes the shape of the area inside theb ars
# > `fill` is the more useful aesthetic here for changing the color of the bars

# 3. What does the bins argument in geom_histogram() do?
ggplot(penguins, aes(x = body_mass_g)) + geom_histogram(bins=10)
ggplot(penguins, aes(x = body_mass_g)) + geom_histogram(bins=60)
# > the `bins` argument allows users to specify the desired number of bins instead of binwidth; R will compute binwidth based on the specified number of bins

# 4. Make a histogram of the carat variable in the diamonds dataset that is available when you load the tidyverse package. Experiment with different binwidths. What binwidth reveals the most interesting patterns?
summary(diamonds)
dim(diamonds)
ggplot(diamonds, aes(x = carat)) + geom_histogram()
ggplot(diamonds, aes(x = carat)) + geom_histogram(binwidth=0.2)
ggplot(diamonds, aes(x = carat)) + geom_histogram(binwidth=0.1)
ggplot(diamonds, aes(x = carat)) + geom_histogram(binwidth=0.05)
ggplot(diamonds, aes(x = carat)) + geom_histogram(binwidth=0.025)
ggplot(diamonds, aes(x = carat)) + geom_histogram(binwidth=0.0125)
ggplot(diamonds, aes(x = carat)) + geom_histogram(binwidth=0.00625)
# > the most interesting pattern is probably binwidth of 0.025

### 1.5 Visualizing relationships
# 1 numerical and 1 categorical variable
ggplot(penguins, aes(x = species, y = body_mass_g)) + geom_boxplot()

ggplot(penguins, aes(x = body_mass_g, color = species)) + geom_density(linewidth = 0.75)

ggplot(penguins, aes(x = body_mass_g, color = species, fill = species)) + geom_density(alpha = 0.5)

# two categorical variables
ggplot(penguins, aes(x = island, fill = species)) + geom_bar()
ggplot(penguins, aes(x = island, fill = species)) + geom_bar(position = "fill")

# two numerical variables
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()

# three or more variables
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = island))

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = species)) +
  facet_wrap(~island)

### 1.5.5 Exercises

# 1. The mpg data frame that is bundled with the ggplot2 package contains 234 observations collected by the US Environmental Protection Agency on 38 car models. Which variables in mpg are categorical? Which variables are numerical? (Hint: Type ?mpg to read the documentation for the dataset.) How can you see this information when you run mpg?
?mpg
glimpse(mpg)
summary(mpg)
# > the variables that are of `chr` type are categorical; although some numerical variables like number of cylinders are arguably categorical too

# 2. Make a scatterplot of hwy vs. displ using the mpg data frame. Next, map a third, numerical variable to color, then size, then both color and size, then shape. How do these aesthetics behave differently for categorical vs. numerical variables?
ggplot(mpg, aes(x = hwy, y = displ)) + geom_point()
ggplot(mpg, aes(x = hwy, y = displ, color = cty)) + geom_point()
ggplot(mpg, aes(x = hwy, y = displ, size = cty)) + geom_point()
ggplot(mpg, aes(x = hwy, y = displ, color = cty, size = cty)) + geom_point()
ggplot(mpg, aes(x = hwy, y = displ, shape = cyl)) + geom_point() # error: # shape does not take a continuous, numerical variable
ggplot(mpg, aes(x = hwy, y = displ, shape = as.factor(cyl))) + geom_point()
ggplot(mpg, aes(x = hwy, y = displ, shape = drv)) + geom_point() # error: # shape does not take a continuous, numerical variable

# > `color` can take use both numerical and categorical variables
# > `size` should use ideally continuous numerical variables rather than discrete
# > `shape` can only take a categorical variable

# 3. In the scatterplot of hwy vs. displ, what happens if you map a third variable to linewidth?
ggplot(mpg, aes(x = hwy, y = displ)) + geom_point()
ggplot(mpg, aes(x = hwy, y = displ, linewidth = cty)) + geom_point()
ggplot(mpg, aes(x = hwy, y = displ, linewidth = cty)) + geom_point() + geom_smooth()
# > if we use a discrete variable for `linewidth`, it will connect the points between observations of the same factor level
# > if we use a continuous numeric variable for `linewidth`, it will change the density/darkness of the geom_smooth line, but this is not very obvious

# 4. What happens if you map the same variable to multiple aesthetics?
# > we are able to see the variable in more dimensions, especially for aesthetics like shape and color, which allows for a range
# > while for some aesthetics, it will just be the same plot but with a new feature, which may or may not enhance the visuals
ggplot(mpg, aes(x = hwy, y = hwy)) + geom_point(aes(color=hwy, size=hwy))

# 5. Make a scatterplot of bill_depth_mm vs. bill_length_mm and color the points by species. What does adding coloring by species reveal about the relationship between these two variables? What about faceting by species?
ggplot(penguins, aes(x = bill_depth_mm, y = bill_length_mm, color = species)) + geom_point() + geom_smooth()
# > adding the color reveals that there is a positive linear relationship between `bill_depth_mm` and `bill_length_mm`, which we wouldn't see if we didn't color the points by `species`
ggplot(penguins, aes(x = bill_depth_mm, y = bill_length_mm)) + geom_point() + geom_smooth() + facet_wrap(~species)
# > faceting does the same, but makes it easier to compare the effect of the variable on the x-axis on the response on the y-axis as the observations are in separate groups and don't overlap

# 6.Why does the following yield two separate legends? How would you fix it to combine the two legends?
ggplot(
  data = penguins,
  mapping = aes(
    x = bill_length_mm, y = bill_depth_mm, 
    color = species, shape = species
  )
) +
  geom_point() +
  labs(color = "Species")

# > there are two separate legends because we added a separate label for color of Species specifically,
# so we can either remove `labs` or add another argument `shape = Species`
ggplot(
  data = penguins,
  mapping = aes(
    x = bill_length_mm, y = bill_depth_mm
  )
) +
  geom_point(mapping = aes(color = species, shape = species)) +
  labs(shape = "Species", color = "Species")

# 7. Create the two following stacked bar plots. Which question can you answer with the first one? Which question can you answer with the second one?
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill")
# in the above plot, we can answer whether a species appears on an/any/all island; we can also answer questions about the composition of penguin species by island and compare them across islands
ggplot(penguins, aes(x = species, fill = island)) +
  geom_bar(position = "fill")
# in the second plot, we can answer where which islands a species is present on; also, we can answer how a particular species' population is distributed across islands (where do Adelies live on the most?)

## 1.6 saving your plots
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()
ggsave(filename = "penguin-plot.png")

### 1.6.1 Exercises

# 1. Run the following lines of code. Which of the two plots is saved as mpg-plot.png? Why?
ggplot(mpg, aes(x = class)) +
  geom_bar()
ggplot(mpg, aes(x = cty, y = hwy)) +
  geom_point()
ggsave("mpg-plot.png")
# > the second plot is saved because the default argument for `ggsave` is the last plot displayed

# 2. What do you need to change in the code above to save the plot as a PDF instead of a PNG? How could you find out what types of image files would work in ggsave()?
# > pass the argument `device = "pdf"` to `ggsave`
# > find out more using `?ggsave`