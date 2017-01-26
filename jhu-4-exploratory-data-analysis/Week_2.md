# Week 2

<!-- MarkdownTOC depth=3 -->

- [Lesson 1: Lattice Plotting System](#lesson-1-lattice-plotting-system)
	- [Simple plotting](#simple-plotting)
	- [Panel functions](#panel-functions)
		- [Custom panel functions](#custom-panel-functions)
	- [Summary](#summary)
- [Lesson 2: ggplot2](#lesson-2-ggplot2)
	- [Hello world with ggplot2](#hello-world-with-ggplot2)
	- [Facets](#facets)
	- [About the ggplot2 system](#about-the-ggplot2-system)
		- [Example with a medical data frame](#example-with-a-medical-data-frame)
		- [Adding more layers](#adding-more-layers)
		- [Axis limits](#axis-limits)

<!-- /MarkdownTOC -->


## Lesson 1: Lattice Plotting System

The `lattice` plotting system is useful for producing Trellis graphics, and uses the `lattice` and the `grid` packages.

Main functions:

* `xyplot`: scatterplots
* `bwplot`: boxplots
* `histogram`: histograms
* `stripplot`: boxplots with actual points
* `dotplot`: plot dots on "violin strings"
* `splom`: scatterplot matrix
* `levelplot`, `contourplot` to plot image data

The general syntax is like this:

```{r}
# Plot x and y, conditioned on f and g
xyplot(y ~ x | f * g, data)
```

### Simple plotting

```{r}
library(lattice)
library(datasets)
## Simple scatterplot
xyplot(Ozone ~ Wind, data = airquality)
```

```{r}
library(lattice)
library(datasets)
## Convert 'Month' to a factor variable
airquality <- transform(airquality, Month = factor(Month))
xyplot(Ozone ~ Wind | Month, data = airquality, layout = c(5, 1))
```

Lattice auto-prints the "plot object", but it could otherwise be stored.

```{r}
p <- xyplot(Ozone ~ Wind, data = airquality)
print(p)
```

### Panel functions

The main point of using lattice is using **panel functions**. Each panel represents x and y for a given subset of data.

```{r}
set.seed(10)
x <- rnorm(100)
f <- rep(0:1, each = 50)
y <- x + f - f * x + rnorm(100, sd = 0.5)
f <- factor(f, labels = c("Group 1", "Group 2"))
xyplot(y ~ x | f, layout = c(2, 1))
```

#### Custom panel functions

```{r}
## Custom panel function
xyplot(y ~ x | f, panel = function(x, y, ...) {
	panel.xyplot(x, y, ...) # 1st, call the default panel function for 'xyplot'
	panel.abline(h = median(y), lty = 2) # Add a horizontal line at the median
})
```

```{r}
## Custom panel function
xyplot(y ~ x | f, panel = function(x, y, ...) {
	panel.xyplot(x, y, ...) # 1st, call the default panel function for 'xyplot'
	panel.lmline(x, y, col = 2) # Overlay a linear regression line
})
```

### Summary

Lattice plots are constructed with a single function call. Layout is usually handled automatically.

It's ideal for creating conditional plots and look at a lot of information at once.

## Lesson 2: ggplot2

`ggplot2` is an implementation of the *Grammar of Graphics*. The logic is to have a flexible way of creating graphs based on a grammar (nouns, verbs, adjectives) with the ability to create *sentences* (graphs) no one ever thought before.

*"Shorten the distance from the mind to the page"*

The basic functions:

* `qplot()`: "quick plot", much like the `plot` function in base R
* `ggplot()`: extended version

In ggplot2 function calls you can handle:

* *aesthetics*: size, shape, color
* *geoms*: points, lines, bars

Factors are very important because they indicate subsets of data, and should be labeled.

### Hello world with ggplot2

```{r}
library(ggplot2)
qplot(displ, hwy, data = mpg)

qplot(displ, hwy, data = mpg, color = drv) # Color based on the drv factor variable

qplot(displ, hwy, data = mpg, geom = c("point", "smooth")) # Specify which geoms to display: points themselves, and the smooth line
```

```{r}
qplot(hwy, data = mpg, fill = drv) # 1 variable -> histogram
```

### Facets 

Facets are like panels in `lattice`. The facets parameter takes two inputs separated by the tilde `~`:

* the left-hand side variable indicates the rows of the panels
* the right-hand side variable indicates the columns of the panels

```{r}
qplot(displ, hwy, data = mpg, facets = . ~ drv)
```

```{r}
qplot(hwy, data = mpg, facets = drv ~ ., binwidth = 2)
```

### About the ggplot2 system

The `qplot()` function is useful for quickly plotting with very powerful features. It should not be used if graphics customization is needed.

Components of a `ggplot2` plot:

* a **data frame**
* **aesthetic mappings**: color, size
* **geoms**: geometric objects
* **facets**: for conditional plots
* **stats**: statistical transformations like binning, quantiles, smoothing
* **scales**
* **coordinate system**

In ggplot2, plots are built up in layers (like the "artist's palette" model of the base plotting system).

#### Example with a medical data frame

Translate the medical question directly into a plot, created with `qplot()`:

```{r}
qplot(logpm25, NocturnalSympt, data = maacs, facets = . ~ bmicat, geom = c("point", "smooth"), method = "lm")
```

Now the task is to recreate the same plot with `ggplot()`.

Phase one: `g` is a `ggplot` object that is a data frame with an aesthetics mapping associated. It doesn't include enough information for plotting (`print(g)` would give an error), yet.  
Adding a **geom** to the `g` object makes it ready for plotting: it explicitly tells "I want to have a *points* graph".

```{r}
g <- ggplot(maacs, aes(logpm25, NocturnalSympt)) # Initial call to ggplot with aesthetics mapping
g + geom_point() # Explicitly print ggplot object with points
```

#### Adding more layers

**Smoothing line**

```{r}
g + geom_point() + geom_smooth() # Add local polynomial regression fitting (loess)
g + geom_point() + geom_smooth(method = "lm") # Linear regression line
```

**Facets layer**

```{r}
g + geom_point() + facet_grid(. ~ bmicat) + geom_smooth(method = "lm")
```

The `facet_grid()` function takes as input the variables to use for the `rows` and the `columns` of the matrix of plots.

**Annotation**

* Labels: `xlab()`, `ylab()`, `labs()`, `ggtitle()`
* Each `geom_*()` function has options
* `theme()` allows to modify global settings
* There are 2 standard themes:
   * `theme_gray()` default
   * `theme_bw()`

Some example options:

```{r}
g + geom_point(color = "steelblue", size = 4, alpha = 1/2) # Constant color
g + geom_point(aes(color = bmicat), size = 4, alpha = 1/2) # Color based on a data variable
```

```{r}
g + geom_point(aes(color = bmicat)) + labs(title = "MAACS Cohort") + labs(x = expression("log " * PM[2.5]), y = "Nocturnal Symptoms") # Labels
```

```{r}
g + geom_point(aes(color = bmicat), size = 2, alpha = 1/2) + geom_smooth(size = 4, linetype = 3, method = "lm", se = FALSE) # Customizing geom_smooth
```

```{r}
g + geom_point(aes(color = bmicat)) + theme_bw(base_family = "Times") # Changing the theme
```

#### Axis limits

```{r}
testdat <- data.frame(x = 1:100, y = rnorm(100))
testdat[50, 2] <- 100 # Outlier

plot(testdat$x, testdat$y, type = "l", ylim = c(-3, 3)) # Hiding the outlier with ylim

g <- ggplot(testdat, aes(x = x, y = y))
g + geom_line() # Odd

g + geom_line() + ylim(-3, 3) # SUBSETS the data and the outlier is missing
g + geom_line() + coord_cartesian(ylim = c(-3, 3)) # Like base plotting
```
