# Week 2

<!-- MarkdownTOC depth=3 -->

- [Lesson 1: Lattice Plotting System](#lesson-1-lattice-plotting-system)
	- [Simple plotting](#simple-plotting)
	- [Panel functions](#panel-functions)
		- [Custom panel functions](#custom-panel-functions)
	- [Summary](#summary)

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

