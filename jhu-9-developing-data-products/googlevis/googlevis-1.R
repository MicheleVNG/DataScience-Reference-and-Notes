library(googleVis)
M <- gvisMotionChart(Fruits, "Fruit", "Year",
		     options = list(width = 600, height = 400))

print(M, file = "googlevis-1.html")
