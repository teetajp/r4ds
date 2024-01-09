library(tidyverse)


# 9.2 Aesthetic mappings --------------------------------------------------

mpg
# displ: numerical var
# hwy: numerical var
# class: categorical var

ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy, shape = class)) +
  geom_point()
# we get a warning when using shape since the 'class' factor has more 6 levels

ggplot(mpg, aes(x = displ, y = hwy, size = class)) +
  geom_point()
#> Warning: Using alpha for a discrete variable is not advised. 

ggplot(mpg, aes(x = displ, y = hwy, alpha = class)) +
  geom_point()
#> Warning: Using alpha for a discrete variable is not advised. 

# Not good to a map an unordered discrete (categorical) variable to an ordered aesthetic 
# as it implies a ranking that does not in fact exist

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(color = "blue")

# aesthetics
# - color: chr string
# - size: millimeters
# - shape: integer (see https://r4ds.hadley.nz/layers_files/figure-html/fig-shapes-1.png)

### 9.2.1 Exercises

# 1. Create a scatterplot of hwy vs. displ where the points are pink filled in triangles.

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(color = "pink", shape = "triangle")
  # geom_point(color = "pink", shape = 17)
  
# 2. Why did the following code not result in a plot with blue points?
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy, color = "blue"))
# > because we specified "blue" in the aesthetic mapping, which is intended to map aesthetics to variables
# > in this case, "blue" is interpreted as a constant, not the color

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy), color = "blue")
# > the updated code here works

# 3. What does the stroke aesthetic do? What shapes does it work with? (Hint: use ?geom_point)

# > According to ?geom_point, "# For shapes that have a border (like 21), you can colour the inside and
# outside separately. Use the stroke aesthetic to modify the width of the
# border"

# > https://ggplot2.tidyverse.org/articles/ggplot2-specs.html
# > The size of the filled part is controlled by size, the size of the stroke is controlled by stroke. Each is measured in mm, and the total size of the point is the sum of the two.

# for "filled shapes", total size is sum of stroke and fill
ggplot(mpg, aes(displ, hwy)) + geom_point(shape = 23, fill = "red", color = "blue") # "filled shape"
ggplot(mpg, aes(displ, hwy)) + geom_point(shape = 23, stroke = 1, fill = "red", color = "blue") # "filled shape"
ggplot(mpg, aes(displ, hwy)) + geom_point(shape = 23, size = 5, fill = "red", color = "blue") # "filled shape"
ggplot(mpg, aes(displ, hwy)) + geom_point(shape = 23, stroke = 1, size = 5, fill = "red", color = "blue") # "filled shape"
ggplot(mpg, aes(displ, hwy)) + geom_point(shape = 23, stroke = 5, size = 1, fill = "red", color = "blue") # "filled shape"

# > the stroke aesthetic allows us to modify the width of the border of shapes that have a border
# > size/width of stroke is measured in mm
ggplot(mpg, aes(displ, hwy)) + geom_point(shape = 5) # "hollow shape" (0-14)
ggplot(mpg, aes(displ, hwy)) + geom_point(shape = 5, stroke = 1) # "hollow shape", adjusted width

ggplot(mpg, aes(displ, hwy)) + geom_point(shape = 18) # "solid shape"
ggplot(mpg, aes(displ, hwy)) + geom_point(shape = 18, stroke = 1, size = 5, color = "pink") # "solid shape"
ggplot(mpg, aes(displ, hwy)) + geom_point(shape = 18, stroke = 5, size = 1, color = "pink") # "solid shape"
# > size has a larger impact on overall size than stroke for "solid" shapes (15-20), but still has an additive effect; they affect the same thing, just in different magnitudes

# 4. What happens if you map an aesthetic to something other than a variable name, like aes(color = displ < 5)? Note, you’ll also need to specify x and y.
ggplot(mpg, aes(x = displ, y = hwy, color = displ < 5)) + geom_point()
# > we get levels for each aesthetic based on the unique values of the variable passed in
# > in the above case, since `displ < 5` is a logical vector, we partition and plot the points based on TRUE/FALSE

ggplot(mpg, aes(x = displ, y = hwy, stroke = displ < 5)) + geom_point()

ggplot(mpg, aes(x = displ, y = hwy, color = 3)) + geom_point()
# > if its a constant, then we get the corresponding aesthetic assigned with some random value


# 9.3 Geometric objects ---------------------------------------------------

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth()

# not every aesthetic works with every geom; if you try, ggplot2 will silently ignore that aestheticmapping

# geom_smooth allows different line types for different factor levels
ggplot(mpg, aes(x = displ, y = hwy, shape = drv)) +
  geom_smooth()

ggplot(mpg, aes(x = displ, y = hwy, linetype = drv)) +
  geom_smooth()

ggplot(mpg, aes(x = displ, y = hwy, color = drv)) + 
  geom_point() +
  geom_smooth(aes(linetype = drv))

# applying `group` aesthetic to a categorical variable to draw multiple objects
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth()

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(group = drv)) # all line groups have same features, but they are distinct

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(color = drv), show.legend = FALSE) # each line groups has a different color

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth() # local aesthetic mappings (geom-specific)
  # allows us to display different aesthetics in different layers

# specifying different data for each layer
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_point(
    data = mpg |> filter(class == "2seater"),
    color = "red"
  ) +
  geom_point(
    data = mpg |> filter(class == "2seater"),
    shape = "circle open", size = 3, color = "red"
  ) # the latter overrides the earlier data layer

# different geoms can reveal different features of your data
ggplot(mpg, aes(x = hwy)) +
  geom_histogram(binwidth = 2)

ggplot(mpg, aes(x = hwy)) +
  geom_density()

ggplot(mpg, aes(x = hwy)) +
  geom_boxplot()

# other plots
library(ggridges)

ggplot(mpg, aes(x = hwy, y = drv, fill = drv, color = drv)) +
  geom_density_ridges(alpha = 0.5, show.legend = FALSE)

# https://ggplot2.tidyverse.org/reference

### 9.3.1 Exercises

# 1. What geom would you use to draw a line chart? A boxplot? A histogram? An area chart?
# > line chart: geom_smooth or geom_path
# > boxplot: geom_boxplot
# > histogram: geom_histogram
# > area chart: geom_area

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_area()

# 2. Earlier in this chapter we used show.legend without explaining it:
  
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(color = drv), show.legend = FALSE)

# What does show.legend = FALSE do here? What happens if you remove it? Why do you think we used it earlier?
  
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(color = drv))
# > `show.legend = FALSE` hides the legend; if we remove it, it defaults to TRUE
# > probably used it earlier because it was redundant (when we plot numerical vs categorical, and the categorical levels are displayed on one of the axis)

# 3. What does the `se` argument to `geom_smooth()` do?
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth() # default `se = TRUE`
  
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(se = FALSE)

# > it toggles the confidence interval around the smoothed line

# 4. Recreate the R code necessary to generate the following graphs. Note that wherever a categorical variable is used in the plot, it’s drv.

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(se = FALSE)

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(aes(group = drv), se = FALSE)

ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  geom_smooth(se = FALSE)


ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth(se = FALSE)

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth(aes(linetype = drv), se = FALSE)

ggplot(mpg, aes(x = displ, y = hwy,)) +
  geom_point(shape = "circle filled", size = 2, color = "white", aes(fill = drv, stroke = 1))


# 9.4 Facets --------------------------------------------------------------
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_wrap(~cyl)
  # splits plots into subplots that eac hdisplay oen subset of the data based on a categorical variable

# facetting plot with combination of two variables
# -> use `facet_grid()` instead of `facet_wrap()`
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_grid(drv ~ cyl)

# defaults to same scale across facets => useful for comparing data across facets
# allowing different scales in each faceet => allows us to visualize relationship within each facet better
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_grid(drv ~ cyl, scales = "free_y")

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_grid(drv ~ cyl, scales = "free_x")

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_grid(drv ~ cyl, scales = "free")

### 9.4.1 Exercises

# 1. What happens if you facet on a continuous variable?
ggplot(mpg, aes(x = hwy)) +
  geom_boxplot() +
  facet_wrap(~displ)
# > works, but we get a subplot for each unique value, which can be a lot

# 2. What do the empty cells in the plot above with facet_grid(drv ~ cyl) mean? Run the following code. How do they relate to the resulting plot?
ggplot(mpg) + 
  geom_point(aes(x = drv, y = cyl))

# > this categorical vs categorical variable plot shows a grid of whether one or more data points exist in a factor-level combination
# > so the empty plots are where there does not exist points in that factor-level combination

# 3. What plots does the following code make? What does . do?

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

# > the facets get stacked either horizontally or vertically based based on whetehr the variable is on the LHS or RHS
# > the `.` is just a placeholder

# 4. Take the first faceted plot in this section:
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

# What are the advantages to using faceting instead of the color aesthetic? What are the disadvantages? How might the balance change if you had a larger dataset?

# > it takes a lot more space to replot the axes
# > facets may be good for when there are a lot of data points that make plotting everything on the same subplot overcrowded
# > plotting everything in a single graph may be useful for comparing different levels when the clusters do not overlap as much

# > with larger number of data points, using facets is good if we only have a few factor levels
# > but with lower number of levels, using color aesthetics is still fine

# > without facet wrap, categorical levels with more observations may mask the levels with less observations

# 5. Read ?facet_wrap. What does nrow do? What does ncol do? What other options control the layout of the individual panels? Why doesn’t facet_grid() have nrow and ncol arguments?

# > nrow sets the number of rows, which will determine the number of subplots on each row (== number of columns)
# > ncol sets the number of cols, which will determine the number of subplots on each col (== number of rows)

# > the total number of subplots must be <= nrow * ncol 

# > other options include `dir`, which controls whether the panels should be arranged horizontally or vertically
# > facet_grid doesn't have `nrow` and `ncol` doesn't have the arguments because they are determined automatically by the number of levels of thw two categorical variables in the formula passed into the args

# 6. Which of the following plots makes it easier to compare engine size (displ) across cars with different drive trains? What does this say about when to place a faceting variable across rows or columns?
ggplot(mpg, aes(x = displ)) + 
  geom_histogram() + 
  facet_grid(drv ~ .)

ggplot(mpg, aes(x = displ)) + 
  geom_histogram() +
  facet_grid(. ~ drv)

# > the first plot makes it easier to compare engine size across cars with different drive trains
# > Since we want to compare `displ` between different `drv` trains, we should facet on the same axis as the variable we want to compare against

# 7. Recreate the following plot using facet_wrap() instead of facet_grid(). How do the positions of the facet labels change?
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy)) +
  facet_wrap(~drv, ncol = 1)

ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy)) +
  facet_wrap(~drv, ncol = 1, strip.position = "right")

ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy)) +
  facet_wrap(~drv, nrow = 3)

ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy)) +
  facet_wrap(~drv, nrow = 3, strip.position = "right")
# > the position of the facet labels is horizontal instead of vertical by default
# > but we can control it with `strip.position`

# 9.5 Statistical transformations -----------------------------------------


# 9.6 Position adjustments ------------------------------------------------



# 9.7 Coordinate systems --------------------------------------------------


# 9.8 The layered grammar of graphics -------------------------------------



