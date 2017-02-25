library(plotly)

# Choropleth Maps

state_pop <- data.frame(State = state.abb, Pop = as.vector(state.x77[,1]))
state_pop$hover <- with(state_pop, paste(State, '<br>', "Population:", Pop))
borders <- list(color = toRGB("red"))

# Set up some mapping options
map_options <- list(
	scope = 'usa',
	projection = list(type = 'albers usa'),
	showlakes = TRUE,
	lakecolor = toRGB('white')
)

plot_ly(z = ~state_pop$Pop, text = ~state_pop$hover, locations = ~state_pop$State, 
	type = 'choropleth', locationmode = 'USA-states', 
	color = state_pop$Pop, colors = 'Blues', marker = list(line = borders)) %>%
	layout(title = 'US Population in 1975', geo = map_options)
