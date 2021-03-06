# Week 1

<!-- MarkdownTOC depth=3 -->

- [Lesson 1: Graphs](#lesson-1-graphs)
	- [Principles of Analytic Graphics](#principles-of-analytic-graphics)
	- [Exploratory Graphs](#exploratory-graphs)
		- [One-dimension summary of data](#one-dimension-summary-of-data)
		- [Two \(and more\) dimensions](#two-and-more-dimensions)
		- [Summary](#summary)
- [Lesson 2: Plotting](#lesson-2-plotting)
	- [Plotting systems in R](#plotting-systems-in-r)
	- [Base plotting systems](#base-plotting-systems)
		- [Key parameters](#key-parameters)
		- [Base plotting functions](#base-plotting-functions)
- [Lesson 3: Graphics Devices](#lesson-3-graphics-devices)
	- [File devices](#file-devices)

<!-- /MarkdownTOC -->



## Lesson 1: Graphs

### Principles of Analytic Graphics

1. **Show comparisons** - *"compared to what?"* If there's nothing to compare, it's useful to compare the presence of something to the absence of that thing.
2. **Show causality, mechanism, explanation, systematic structure** - you can show multiple graphs to suggest an underlining idea
3. **Show multivariate data** - the real world is made of more than two varibles. Try to show the relevant ones (more than 2!)
4. **Integrate evidence** - don't let the tool drive the analysis, integrate the data you need.
5. **Describe and document the evidence**
6. Ultimately, it's the **content that matters**, you need to have an interesting and relevant story to tell

### Exploratory Graphs

It's useful to use graphs as a tool to *understand* data: find patterns, suggest models, set the basis for further analysis.

The goal is to have a *personal understanding* of the data, not to show someone else. So you usually make a large number, very quickly.

**Example with an Air Pollution dataset.**

```{r}
# Load sample data
pollution <- read.csv("data/avgpm25.csv", colClasses = c("numeric", "character", "factor", "numeric", "numeric"))
```

**Q**: Are there any counties in the U.S. that exceed the national standard of 12 µg/m3 for fine particle pollution?

*Always have a question about your data, even a vague background one.*

#### One-dimension summary of data

**Five Number Summary**

It's not really a plot, but still worth mentioning.

```{r}
summary(pollution$pm25)
```

**Boxplot**

Represents the data median, 1st and 3rd quartiles, and long tail values.

```{r}
boxplot(pollution$pm25, col = "blue")
```

**Histogram**

It gives more information about the shape of the distribution.

```{r}
hist(pollution$pm25, col = "green")
rug(pollution$pm25)
```

The `rug()` function gives a little bit more detail about the individual observations that make the histogram.

It's useful to play with the `breaks` argument to find a meaningful representation.

**Overlaying Features**

Used to highlight specific points of interest.

```{r}
boxplot(pollution$pm25, col = "blue")
abline(h = 12)

hist(pollution$pm25, col = "green")
abline(v = 12, lwd = 2)
abline(v = median(pollution$pm25), col = "magenta", lwd = 4)
```

**Barplot**

Graph useful for *categorical data*.

```{r}
barplot(table(pollution$region), col = "wheat", main = "Number of Counties in Each Region")
```

#### Two (and more) dimensions

**General ideas**

Two dimensions:

* Groups / overlayed 1-dimensional plots
* Scatterplots
* Smooth scatterplots

More than two dimensions:

* Groups / overlayed 2D plots
* Use color, size, shape as new dimensions
* Spinning plots
* 3D plots (usually not interesting)

**Multiple Boxplots**

Useful to compare a numeric variable (i.e. `pm25`) vs. a categorical one (i.e. `region`)

```{r}
barplot(pm25 ~ region, data = pollution, col = "red")
```

**Multiple Histograms**

Same concept (numeric vs. categorical variables), but using histograms.

```{r}
par(mfrow = c(2, 1), mar = c(4, 4, 2, 1))
hist(subset(pollution, region == "east")$pm25, col = "green")
hist(subset(pollution, region == "west")$pm25, col = "green")
# Code looks less obvious, hard to understand
```

**Scatterplot**

Obvious representation for two-dimensional data. It's useful to place reference values (i.e. the national average).

Color can be used to display categorical variables.

```{r}
with(pollution, plot(latitude, pm25, col = region))
abline(h = 12, lwd = 2, lty = 2)
```

**Multiple Scatterplots**

Alternative to represent categorical differences in data. Could be more meaningful depending on the data.

```{r}
par(mfrow = c(1, 2), mar = c(5, 4, 2, 1))
with(subset(pollution, region == "west"), plot(latitude, pm25, main = "West"))
with(subset(pollution, region == "east"), plot(latitude, pm25, main = "East"))
```

#### Summary

Exploratory plots are quick and dirty. They let you summarize the data quickly and graphically (easy to understand), and to formulate the first basic hypotheses to be explored later on in the analysis.

## Lesson 2: Plotting

### Plotting systems in R

There are 3 different plotting systems in R.

* Base plotting system  
   Idea: you add things to the graph one by one.  
   *"Artist's palette" model*
	- Generation vs. Annotation
	- Convenient, but you can't go back (it's an accumulative process)
	- There's no "language", it's just a series of R commands
* Lattice system  
   *Entire plot specified by one function; conditioning*
	- Construct an entire plot all at once 
	- Useful for "conditional" plots (looking at x and y across levels of z), also called "panel" plots
	- Good to create a lot of plots at once
* ggplot2 system
   *Mixes elements of Base and Lattice*
	- Comes from the "grammar of graphics"
	- Rigorous theoretical system
	- A lot of "good" defaults
	- More intuitive than lattice

The three systems are not interchangeable.

### Base plotting systems

Packages:

* `graphics`: `plot`, `hist`, `boxplot`, ...
* `grDevices`: various graphics devices (X11, PDF, PostScript, PNG, ...)
* `lattice`: code for producing Trellis graphics, functions like `xyplot`, `bwplot`, `levelplot`
* `grid`: different system, lattice builds on top of it

Two phases to create a base plot:
* Initialize a new plot
* Annotate an existing plot

`plot()` is a generic function that evaluates the input you give, and defaults to a basic method with a lot of parameters (hint: `?par`).

```{r}
## Base histogram
library(datasets)
hist(airquality$Ozone)
```

```{r}
## Base scatterplot
library(datasets)
with(airquality, plot(Wind, Ozone))
```

```{r}
## Base boxplot
library(datasets)
airquality <- transform(airquality, Month = factor(Month))
boxplot(Ozone ~ Month, airquality, xlab = "Month", ylab = "Ozone (ppb)")
```

#### Key parameters

Some **key base graphics parameters**:
* `pch`: plotting character (defaults is open circle)
* `lty`: line type (default is solid line)
* `lwd`: line width
* `col`: plotting color (number, string, hex code, or `colors()`)
* `xlab`, `ylab`: labels for the x/y axis

`par()` can specify the **global graphics parameters** for the current session.
* `las`: orientation of the axis labels
* `bg`: background color
* `mar`: margin size
* `oma`: outer margin
* `mfrow`, `mfcol`: number of plots per row and per column

You can see the defaults for the global parameters with the `par` function:

```{r}
par("bg")
# [1] "white"
```

#### Base plotting functions

* `plot`: scatterplot
* `lines`: *add* lines to a plot
* `points`: *add* points to a plot
* `text`: *add* labels
* `title`: *add* annotations to x, y axis, title, subtitle, outer margin
* `mtext`: *add* tex tot the margins
* `azis`: *add* axix ticks/labels

```{r}
# Add a title
library(datasets)
with(airquality, plot(Wind, Ozone))
title(main = "Ozone and Wind in New York City")
```

```{r}
# Highlight a certain month
with(airquality, plot(Wind, Ozone), main = "Ozone and Wind in New York City")
with(subset(airquality, Month == 5), points(Wind, Ozone, col = "blue"))
```

```{r}
with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in New York City", type = "n"))
# type = "n" just initializes the plot, so that I can then plot individual subsets one by one
with(subset(airquality, Month == 5), points(Wind, Ozone, col = "blue"))
with(subset(airquality, Month != 5), points(Wind, Ozone, col = "red"))
legend("topright", pch = 1, col = c("blue", "red"), legend = c("May", "Other Months"))
```

```{r}
with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in New York City", pch = 20))
model <- lm(Ozone ~ Wind, airquality) # Linear Regression
abline(model, lwd = 2) # Add the linear regression line to the plot
```

```{r}
# Multiple plots on a single device
par(mfrow = c(1, 2))
with(airquality, {
	plot(Wind, Ozone, main = "Ozone and Wind")
	plot(Solar.R, Ozone, main = "Ozone and Solar Radiation")
})
```

```{r}
par(mfrow = c(1, 3), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0)) # Set margin and outer margin to allow space for the mtext()
with(airquality, {
	plot(Wind, Ozone, main = "Ozone and Wind")
	plot(Solar.R, Ozone, main = "Ozone and Solar Radiation")
	plot(Temp, Ozone, main = "Ozone and Temperature")
	mtext("Ozone and Weather in New York City", outer = TRUE)
})
```

## Lesson 3: Graphics Devices

A **graphics device** is something where you can make a plot appear.

* Window (screen device)
* PDF, PNG, JPEG, SVG (file device)

`?Devices`: list of graphic devices

For exploratory analysis, the screen device is just fine. For other uses, the file devices can be useful (i.e. for sharing).

Two approaches to plotting:

1. Simple way: call plotting funcion, the plot appears, annotate it. Enjoy.
2. Explicitly launch a graphic device, plot, explicitly close the graphics device with `dev.off()`

```{r}
pdf(file = "myplot.pdf") # PDF device
with(faithful, plot(eruptions, waiting))
title(main = "Old Faithful Geyser data")
dev.off()
```

### File devices

**Vector** formats:

* `pdf`: useful for line-type graphics, not efficient with many objects/points
* `svg`: supports animation and interactivity, potentially useful for web-based plots
* `win.metafile`
* `postscript`

**Bitmap** formats:

* `png`
* `jpeg`
* `tiff`
* `bmp`

You can use multiple graphics devices simultaneously, but plotting can occur on one graphics device at a time.  
`dev.cur()` gets the current graphics device  
`dev.set()` sets the active graphics device (corresponding to a certain integer value)

Nice to know:

* `dev.copy()`: copy a plot from one the active device to another (to a file)  
* `dev.copy2pdf()`: copy directly to a PDF













