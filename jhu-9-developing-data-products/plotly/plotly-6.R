library(plotly)
library(ggplot2)

set.seed(100)
d <- diamonds[sample(nrow(diamonds), 1000), ]

p <- ggplot(data = d, aes(x = carat, y = price)) +
	geom_point(aes(text = paste("Clarity:", clarity)), size = 4) +
	geom_smooth(aes(colour = cut, fill = cut)) +
	facet_wrap(~ cut)

(gg <- ggplotly(p))

plotly_POST(gg)
