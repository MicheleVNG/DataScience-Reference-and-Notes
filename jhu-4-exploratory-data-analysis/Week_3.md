# Week 2

<!-- MarkdownTOC depth=3 -->

- [Lesson 1: Hierarchical Clustering](#lesson-1-hierarchical-clustering)
  - [Hierarchical clustering example](#hierarchical-clustering-example)
  - [Prettier dendrogram](#prettier-dendrogram)
  - [Measuring distance between clusters](#measuring-distance-between-clusters)
  - [`heatmap\(\)`](#heatmap)
  - [Notes](#notes)
- [Lesson 2: K-Means Clustering & Dimension Reduction](#lesson-2-k-means-clustering--dimension-reduction)
  - [K-Means Clustering](#k-means-clustering)
    - [K-Means clustering example](#k-means-clustering-example)
    - [Heatmaps](#heatmaps)
    - [Summary](#summary)
  - [Principal Component Analysis and Singular Value Decomposition](#principal-component-analysis-and-singular-value-decomposition)
- [Lesson 3: Working with Color in R](#lesson-3-working-with-color-in-r)
  - [`colorRamp`](#colorramp)
  - [`colorRampPalette`](#colorramppalette)
  - [Interesting palettes of color](#interesting-palettes-of-color)
  - [`smoothScatter`](#smoothscatter)
  - [`rgb`](#rgb)

<!-- /MarkdownTOC -->

## Lesson 1: Hierarchical Clustering

Clustering organizes things that are **close** into groups.

Key problems:

* Define distance
* How to group points
* Visualizing groups
* Interpreting groups

Hierarchical clustering has an agglomerative, bottom-up approach.  
Requires a **distance** definition (metric), and a **merging approach**.  
Produces a tree (*dendrogram*) showing how close thing are to each other.

Some distance metrics:

* *Continuous*: **euclidean distance**, "straight line distance".  
  It's easy to generalize to `n` dimensions.  
  `sqrt( (A1-A2)^2 + (B1-B2)^2 + ... + (Z1-Z2)^2 )`
* *Continuous*: **correlation similarity**
* *Binary*: **manhattan distance**, it's the "blocks" distance. Wikipedia: [Taxicab Geometry](https://en.wikipedia.org/wiki/Taxicab_geometry).  
  Formula: sum of the absolute distance between coordinates.  
  `|A1-A2| + |B1-B2| + ... + |Z1-Z2|`  
  The Manhattan distance can be useful in some contexts, because it can more accurately represent the correct distance.

You need to pick a distance metric that makes sense for the problem.

### Hierarchical clustering example

```{r}
# Initialization
set.seed(1234)
# par(mar = c(0,0,0,0))
x <- rnorm(12, mean = rep(1:3, each = 4), sd = 0.2)
y <- rnorm(12, mean = rep(c(1, 2, 1), each = 4), sd = 0.2)

# Visualize the points:
plot(x, y, col = "blue", pch = 19, cex = 2)
text(x + 0.05, y + 0.05, labels = as.character(1:12))
```

```{r}
dataFrame <- data.frame(x = x, y = y)
distxy <- dist(dataFrame)
# Calculates all the distances in a matrix or data frame. Calculate the euclidean distance matrix by default. Use method parameters to override the distance measure

hClustering <- hclust(distxy)
plot(hClustering)
```

The dendrogram doesn't tell how many clusters are there. You need to cut it at a certain point.

### Prettier dendrogram

Useful function to make prettier dendrograms:

```{r}
myplclust <- function(hclust, lab = hclust$labels, lab.col = rep(1, length(hclust$labels)), 
    hang = 0.1, ...) {
    ## modifiction of plclust for plotting hclust objects *in colour*!  Copyright
    ## Eva KF Chan 2009 Arguments: hclust: hclust object lab: a character vector
    ## of labels of the leaves of the tree lab.col: colour for the labels;
    ## NA=default device foreground colour hang: as in hclust & plclust Side
    ## effect: A display of hierarchical cluster with coloured leaf labels.
    y <- rep(hclust$height, 2)
    x <- as.numeric(hclust$merge)
    y <- y[which(x < 0)]
    x <- x[which(x < 0)]
    x <- abs(x)
    y <- y[order(x)]
    x <- x[order(x)]
    plot(hclust, labels = FALSE, hang = hang, ...)
    text(x = x, y = y[hclust$order] - (max(hclust$height) * hang), labels = lab[hclust$order], 
        col = lab.col[hclust$order], srt = 90, adj = c(1, 0.5), xpd = NA, ...)
}
```

```{r}
dataFrame <- data.frame(x = x, y = y)
distxy <- dist(dataFrame)
hClustering <- hclust(distxy)
myplclust(hClustering, lab = rep(1:3, each = 4), lab.col = rep(1:3, each = 4))
```

[RGraphGallery Dendrograms](http://gallery.r-enthusiasts.com/RGraphGallery.php?graph=79)

### Measuring distance between clusters

What represents the new location of two merged points?

One option is to use *average linkage*, so the new location is the "center of gravity" between the two points.  
The other option is to use *complete linkage*: if you want to measure the distance between two clusters, you have to take the distance between the two farthest points in the clusters.

### `heatmap()`

The `heatmap()` function runs a hierarchical cluster analysis on the rows and the columns of a matrix.

```{r}
dataFrame <- data.frame(x = x, y = y)
set.seed(143)
dataMatrix <- as.matrix(dataFrame)[sample(1:12), ]
heatmap(dataMatrix)
```

### Notes

The clustering picture may be unstable:

* Changing a few points could change the groups
* Try to pick a different distance measure
* Try to change the merging strategy
* Change the scale of points of one variable

Choosing where to cut isn't always obvious.

## Lesson 2: K-Means Clustering & Dimension Reduction

### K-Means Clustering

K-Means clustering is an old technique, but still useful to get a sense of high-dimensional data.

Pick a distance metric as for the Hierarchical clustering approach.

You need to have a sense of how many groups are in the dataset.

You need:

* a distance metric
* a number of clusters
* an initial guess as to cluster centroids

You get:

* final estimate of cluster centroids
* an assignment of each point to clusters

#### K-Means clustering example

```{r}
set.seed(1234)
# par(mar = c(0,0,0,0))
x <- rnorm(12, mean = rep(1:3, each = 4), sd = 0.2)
y <- rnorm(12, mean = rep(c(1, 2, 1), each = 4), sd = 0.2)
plot(x, y, col = "blue", pch = 19, cex = 2)
text(x + 0.05, y + 0.05, labels = as.character(1:12))
```

K-Means clustering starts from a random set of centroids, then iteratively:

1. Assigns each point to the nearest centroid
2. Recalculates the new centroid location


```{r}
dataFrame <- data.frame(x, y)
kmeansObj <- kmeans(dataFrame, centers = 3)
names(kmeansObj)
# returns a list of metadata for the k-means clustering result

# par(mar = rep(0.2, 4))
plot(x, y, col = kmeansObj$cluster, pch = 19, cex = 2)
points(kmeansObj$centers, col = 1:3, pch = 3, cex = 3, lwd = 3)
```

#### Heatmaps

```{r}
set.seed(1234)
dataMatrix <- as.matrix(dataFrame)[sample(1:12), ]
kmeansObj2 <- kmeans(dataMatrix, centers = 3)
par(mfrow = c(1, 2), mar = c(2, 4, 0.1, 0.1))
image(t(dataMatrix)[, nrow(dataMatrix):1], yaxt = "n")
image(t(dataMatrix)[, order(kmeansObj$cluster)], yaxt = "n")
```

#### Summary

K-Means requires a number of clusters.

K-Means is not deterministic, it's unstable depending on the number of iterations and starting points.

### Principal Component Analysis and Singular Value Decomposition

```{r}
set.seed(12345)
# par(mar = rep(0.2, 4))
dataMatrix <- matrix(rnorm(400), nrow = 40)
image(1:10, 1:40, t(dataMatrix)[, nrow(dataMatrix):1])

# par(mar = rep(0.2, 4))
heatmap(dataMatrix)
```

[...]

The goal of this technique is to identify the most important uncorrelated variables that can explain as much variability in the dataset as possible.

[...]

## Lesson 3: Working with Color in R

Proper use of color can help describing the data.

Default color schemes are bad. There are better ways to handle color.

The `grDevices` package has 2 functions that help handling colors:

* `colorRamp`: takes a palette of colors and returns a function that takes values between 0 and 1, indicating the extremes of the color palette.
* `colorRampPalette`: takes a palette of colors and returns a function that takes integer arguments and returns a vector of colors interpolating the palette.

Also, `colors()` lists the names of colors you can use in any plotting function.

### `colorRamp`

```{r}
pal <- colorRamp(c("red", "blue"))

pal(0)
#      [,1] [,2] [,3]
# [1,]  255    0    0

pal(1)
#      [,1] [,2] [,3]
# [1,]    0    0  255

pal(0.5)
#       [,1] [,2]  [,3]
# [1,] 127.5    0 127.5

pal(seq(0, 1, len = 10))
#            [,1] [,2]      [,3]
#  [1,] 255.00000    0   0.00000
#  [2,] 226.66667    0  28.33333
#  [3,] 198.33333    0  56.66667
#  [4,] 170.00000    0  85.00000
#  [5,] 141.66667    0 113.33333
#  [6,] 113.33333    0 141.66667
#  [7,]  85.00000    0 170.00000
#  [8,]  56.66667    0 198.33333
#  [9,]  28.33333    0 226.66667
# [10,]   0.00000    0 255.00000
```

### `colorRampPalette`

```{r}
pal <- colorRampPalette(c("red", "yellow"))

pal(2)
# [1] "#FF0000" "#FFFF00"

pal(10)
# [1] "#FF0000" "#FF1C00" "#FF3800" "#FF5500" "#FF7100"
# [6] "#FF8D00" "#FFAA00" "#FFC600" "#FFE200" "#FFFF00"
```

### Interesting palettes of color

The `RColorBrewer` package gives a set of interesting color palettes.

There are three types of palettes:

* **Sequential**: ordered, numerical data
* **Diverging**: data that deviate from something (e.g. deviation from the mean, positive vs. negative, ...)
* **Qualitative**: not ordered, typically categorical data

```{r}
library(RColorBrewer)

cols <- brewer.pal(3, "BuGn")

cols
# [1] "#E5F5F9" "#99D8C9" "#2CA25F"

pal <- colorRampPalette(cols)
image(volcano, col = pal(20))
```

### `smoothScatter`

```{r}
x <- rnorm(10000)
y <- rnorm(10000)

smoothScatter(x, y)
```

### `rgb`

The `rgb()` function creates any color via RGB proportions. Also, it can add transparency (*alpha*).

```{r}
x <- rnorm(1000)
y <- rnorm(1000)

plot(x, y, pch = 19)
plot(x, y, pch = 19, col = rgb(0, 0, 0, 0.2))
```






