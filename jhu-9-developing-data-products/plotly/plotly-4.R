library(plotly)

# Histogram
plot_ly(x = ~precip, type = "histogram")

# Boxplot
plot_ly(iris, y = ~Petal.Length, color = ~Species, type = "box")

# Heatmap
terrain1 <- matrix(rnorm(100*100), nrow = 100, ncol = 100)
plot_ly(z = ~terrain1, type = "heatmap")

# Surface
terrain2 <- matrix(sort(rnorm(100*100)), nrow = 100, ncol = 100)
plot_ly(z = ~terrain2, type = "surface")
