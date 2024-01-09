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
ggplot(diamonds, aes(x = cut)) +
  geom_bar() # geom_bar uses stat_count

# sometimes, we will want to specify a `stat` explicitly

# 1. override default stat
diamonds |> 
  count(cut) |> 
  ggplot(aes(x = cut, y = n)) +
  geom_bar(stat = "identity")
# `identity` maps the height of the bars to raw values of a y variable

# 2. override default mapping from transformed variables to aesthetics
ggplot(diamonds, aes(x = cut, y = after_stat(prop), group = 1)) +
  geom_bar()
# ^ display bar chart of proportions rather than counts
# To see possible variables computed by stat, look for "computed variables" section in help for ?geom_...

# 3. when we want draw greater attention to statistical transformation in your code
ggplot(diamonds) +
  stat_summary(
    aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )

### 9.5.1 Exercises

# 1. What is the default geom associated with stat_summary()? How could you rewrite the previous plot to use that geom function instead of the stat function?
# > According to ?stat_summary, stat_summary's `geom` argument defaults to "pointrange", which is geom_pointrange
diamonds |>
  group_by(cut) |> 
  summarize(
    lower = min(depth),
    upper = max(depth),
    midpoint = median(depth)
  ) |> 
  ggplot(aes(x = cut, y = midpoint)) +
  geom_pointrange(aes(ymin = lower, ymax = upper))

# 2. What does geom_col() do? How is it different from geom_bar()?
# > geom_bar makes the height of the bar proportional to the number of cases in each group
# > geom_col makes the height of the bar represent values in the data
ggplot(diamonds, aes(x = cut, y = depth)) +
  geom_col()

# 3. Most geoms and stats come in pairs that are almost always used in concert. Make a list of all the pairs. What do they have in common? (Hint: Read through the documentation.)
# > https://ggplot2.tidyverse.org/reference/#plot-basics

# geom_bar, geom_col, stat_count
# geom_bin_2d, stat_bin_2d
# geom_boxplot, stat_boxplot
# geom_contour, geom_contour_filled, stat_contour, stat_contour_filled
# geom_count, stat_sum
# geom_density, stat_density
# geom_density_2d, geom_density_2d_filled, stat_density_2d, stat_density_2d_filled
# geom_function, stat_function
# geom_hex, stat_bin_hex
# geom_freqpoly, geom_histogram, stat_bin
# geom_qq_line, stat_qq_line, geom_qq, stat_qq
# geom_quantile, stat_quantile
# geom_ribbon, geom_area, stat_align,
# geom_smooth, stat_smooth
# geom_violin, stat_ydensity
# geom_sf, geom_sf_label, geom_sf_text, coord_sf, stat_sf

# > all of these geom-stat pairs exist where the geom needs a new value computed from the data (usually summarizing multiple observations)
# > while the geoms that do not have a corresponding stat can be plotted using just the existing data without computing relying on calculations from multiple observations

# 4. What variables does stat_smooth() compute? What arguments control its behavior?

# > the computed variables are:
# > y, x: predicted values
# > ymin, xmin: lower pointwise confidence interval around the mean
# > ymax, xmax: upper pointwise confidence interval around the mean
# > se: standard error

# > Arguments that control its behavior include:
# >   `orientation`, `span`, `method`, `se`, `formula`, `n`, `fullrange`, `level`

# 5. In our proportion bar chart, we needed to set group = 1. Why? In other words, what is the problem with these two graphs?

# > the group setting tells ggplot what the group the proportions correspond to
ggplot(diamonds, aes(x = cut, y = after_stat(prop))) + 
  geom_bar()
ggplot(diamonds, aes(x = cut, y = after_stat(prop), group = 1)) + 
  geom_bar()
# > in the first function, setting `group = 1` makes ggplot plot the proportions based on `cut`s
# > this `1` is a constant, so each group has the same proportion, but we still see difference in total count on the y-axis

ggplot(diamonds, aes(x = cut, fill = color, y = after_stat(prop))) + 
  geom_bar()

ggplot(diamonds, aes(x = cut, fill = color, y = after_stat(prop), group = 1)) + 
  geom_bar() # > doesn't work as expected

ggplot(diamonds, aes(x = cut, fill = color, y = after_stat(prop), group = color)) + 
  geom_bar()

# > in the second function, we have an additional `fill` aesthetic,
# > setting `group = 1` fails, and ggplot warns us that it failed to infer the correct grouping structure
# > setting `group = color`, ggplot plots the bar chart, with `prop` on the y-axis, allowing us to compare the proportions of diamonds by cut across the whole data set
# >   ggplot also now plots the proportion of `color` within each cut

# > the problem was incorrect grouping or rather that ggplot doesn't know what group the proportions correspond to



# 9.6 Position adjustments ------------------------------------------------
ggplot(mpg, aes(x = drv, color = drv)) +
  geom_bar()

ggplot(mpg, aes(x = drv, fill = drv)) +
  geom_bar()

ggplot(mpg, aes(x = drv, fill = class)) +
  geom_bar()

# stacking is performed automatically using the position adjustment specified by `position` argument.
# options: `identity`, `dodge`, `fill`, `stack`

ggplot(mpg, aes(x = drv, fill = class)) +
  geom_bar(alpha = 1/5, position = "identity") # positions objects exactly where it falls (XXX: does cause overlapping for bars)

ggplot(mpg, aes(x = drv, color = class)) +
  geom_bar(fill = NA, position = "identity") # "identity" is more useful for 2D geoms

# fill: works like stacking but makes each set of stacked bars the same height, useful for comparing proportions across groups
ggplot(mpg, aes(x = drv, fill = class)) +
  geom_bar(position = "fill")

# dodge: places overlapping objects directly besides on another, makes it easier to compare individual values
ggplot(mpg, aes(x = drv, fill = class)) +
  geom_bar(position = "dodge") 

# for 2D: overplotting is when many points overlap each other, makes it hard to see distribution of data
#   use `jitter` to add some random noise to spread out points more
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(position = "jitter")


### 9.6.1 Exercises

# 1. What is the problem with the following plot? How could you improve it?
ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_point()

# > the points seem to overlap due to rounding/discreteness of the values, makes hard to see density of points

ggplot(mpg, aes(x = cty, y = hwy)) + 
  geom_jitter()
# > add slight randomness to spread out the points a bit

# 2. What, if anything, is the difference between the two plots? Why?
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(position = "identity")
# > there is no difference, because the default argument of `position` to `geom_point` is `identity`
# > we know this based on `args(geom_point)` or `?geom_point`

# 3. What parameters to geom_jitter() control the amount of jittering?
# > `width` and `height` controls the amount of vertical and horizontal jitter

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_jitter(width = 0, height = 0)

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_jitter() # both args defaults to 0.4

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_jitter(width = 0.1, height = 0.1)

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_jitter(width = 1, height = 1)

# 4. Compare and contrast geom_jitter() with geom_count().

# > `geom_jitter` adds randomness to individual points
# > `geom_count` counts the number of observations at each location, then maps the count to point area
# > both are variations of `geom_point`
# > geom_jitter may be more useful to see visualize the distribution of the data if we know that the values are continuous but were rounded to be discrete
# > geom_count may be more useful to visualize the density/distribution of the data when we know that the data-generating process is discrete
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_jitter()

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_count()
  
# 5. What’s the default position adjustment for geom_boxplot()? Create a visualization of the mpg dataset that demonstrates it.
# > the default position adjustment for `geom_boxplot` is `dodge2`
ggplot(mpg, aes(x = class, y = hwy)) +
  geom_boxplot()

ggplot(mpg, aes(x = class, y = hwy)) +
  geom_boxplot(position = "dodge2")

# 9.7 Coordinate systems --------------------------------------------------

# default coord system is Cartesian coord system (x, y)
# two other systems:

# 1. `coord_quickmap`: sets aspect ratio correctly for geographic maps
nz <- map_data("nz")

ggplot(nz, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black") # elongates/shrinks based on display

ggplot(nz, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black") +
  coord_quickmap() # aspect ratio remains correct even when we resize window

# 2. `coord_polar`: polar coordinates
bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = clarity, fill = clarity), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1)

bar + coord_flip()
bar + coord_polar()

### 9.7.1 Exercises

# 1. Turn a stacked bar chart into a pie chart using coord_polar().
ggplot(mpg, aes(x = drv, fill = class)) +
  geom_bar(position = "stack") +
  theme(aspect.ratio = 1) +
  coord_polar()

# 2. What’s the difference between coord_quickmap() and coord_map()?
# > both `coord_map` and `coord_quickmap` is used to switch to geographical coordinates and plot things correctly
# > but `coord_quickmap` uses a heuristic/approximation which preserves straight lines, and it works best for smaller areas closer to the equator
# > We should use `coord_sf` instead of both of these, however, as `coord_sf` supersedes them.

# 3. What does the following plot tell you about the relationship between city and highway mpg? Why is coord_fixed() important? What does geom_abline() do?
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() +
  coord_fixed()

# > the plot shows that `cty` and `hwy` are strongly positively correlated
# > `coord_fixed` preserves the aspect ratio to ensure that units on the x and y-axis as 1 to 1 (square aspect ratio), although we can specify it differently
# > this is important when the units on the x and y axis are the same (in this case it is miles per gallon) for correct interpretation from plots.
# > `geom_abline` adds reference lines to the plot

# 9.8 The layered grammar of graphics -------------------------------------

# Template:

# ggplot(data = <DATA>) + 
#   <GEOM_FUNCTION>(
#     mapping = aes(<MAPPINGS>),
#     stat = <STAT>, 
#     position = <POSITION>
#   ) +
#   <COORDINATE_FUNCTION> +
#   <FACET_FUNCTION>
  


