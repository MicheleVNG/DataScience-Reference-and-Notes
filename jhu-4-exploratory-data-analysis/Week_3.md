# Week 2

<!-- MarkdownTOC depth=3 -->

- [Lesson 1: Hierarchical Clustering](#lesson-1-hierarchical-clustering)
	- [Hierarchical clustering example](#hierarchical-clustering-example)
	- [Prettier dendrogram](#prettier-dendrogram)
	- [Measuring distance between clusters](#measuring-distance-between-clusters)
	- [`heatmap\(\)`](#heatmap)
	- [Notes](#notes)
- [Lesson 2: K-Means Clustering & Dimension Reduction](#lesson-2-k-means-clustering--dimension-reduction)
- [Lesson 3: Working with Color in R](#lesson-3-working-with-color-in-r)

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



## Lesson 3: Working with Color in R



