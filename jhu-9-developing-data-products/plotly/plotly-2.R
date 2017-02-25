library(plotly)

# Use colors
plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", color = ~factor(cyl))

# Continuous variable as color
plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", color = ~disp)

# Change sizing
plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", color = ~factor(cyl), size = ~hp)

# 3D plot
set.seed(2016-07-21)
temp <- rnorm(100, mean = 30, sd = 5)
pressue <- rnorm(100)
dtime <- 1:100
plot_ly(x = ~temp, y = ~pressue, z = ~dtime,
	type = "scatter3d", color = ~temp)