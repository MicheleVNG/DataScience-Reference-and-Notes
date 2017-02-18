library(shiny)

shinyUI(fluidPage(
	titlePanel("Hello Shiny!"),
	sidebarLayout(
		sidebarPanel(
			h3("Sidebar")
		),
		mainPanel(
			h1("Heading 1"),
			h2("Heading 2"),
			h3("Heading 3"),
			h4("Heading 4"),
			h5("Heading 5"),
			h6("Heading 6"),
			p("Lorem ipsum dolor sit amet, consectetur adipiscing elit.", br(),
			  "Fusce at tortor rutrum, ", strong("condimentum arcu eu"), ", facilisis tortor.
			  Sed eu erat lorem. Nunc sodales ultrices nibh nec elementum.
			  Ut ac dui ut velit condimentum ", em("sollicitudin id a velit"), ".", br(),
			  a(href = "#", "Ut mattis velit eros"), ", sit amet finibus erat ultrices nec.
			  Aliquam accumsan magna vitae ante lobortis posuere.
			  Proin dapibus suscipit est nec egestas.
			  Vestibulum luctus semper sollicitudin."),
			hr(),
			pre("This
is
a Code Block"),
			div("This is some ", code("inline code"), ".")
		)
	)
))