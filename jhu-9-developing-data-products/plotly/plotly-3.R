library(plotly)

# Lines
data("airmiles")
plot_ly(x = time(airmiles), y = airmiles, type = "scatter", mode = "lines")

# Multi-line chart
library(tidyr)
library(dplyr)
data("EuStockMarkets")

stocks <- as.data.frame(EuStockMarkets) %>%
	gather(index, price) %>%
	mutate(time = rep(time(EuStockMarkets), 4))

plot_ly(stocks, x = ~time, y = ~price, color = ~index, type = "scatter", mode = "lines")
