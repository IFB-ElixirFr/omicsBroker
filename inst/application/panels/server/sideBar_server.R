output$sidebar <- renderUI({
  sidebarMenu( id = "tabs",
               menuItem("Home", tabName = "home", icon = icon("home")),

               p(style = "text-align: center;margin: 0px; font-weight: bold; background-color: #3c8dbc;padding: 5px;", 'Annotation'),
               menuItem("Project", tabName = "project", icon = icon("pen")),
               menuItem("Samples", tabName = "samplePage", icon = icon("vials")),
               menuItem("Files", tabName = "filesImportPage", icon = icon("file-import")),

               p(style = "text-align: center;margin: 0px; font-weight: bold; background-color: #3c8dbc;padding: 5px;", 'Publish'),
               menuItem("ENA", tabName = "publish_ENA", icon = icon("upload")),

               p(style = "text-align: center;margin: 0px; font-weight: bold; background-color: #3c8dbc;padding: 5px;", 'Admin'),
               menuItem("Metadata", tabName = "adminMetadata", icon = icon("tools")),
               menuItem("Packages", tabName = "adminPackages", icon = icon("tools")),
               menuItem("My projects", tabName = "myProjects", icon = icon("tools")),

               p(style = "text-align: center;margin: 0px; font-weight: bold; background-color: #3c8dbc;padding: 5px;", 'More'),
               menuItem("Session", tabName = "about", icon = icon("cubes")),
               menuItem("Help", tabName = "helpPage", icon = icon("question-circle"))
  )

})

updateTabItems(session, "tabs", selected = "home")
shinyjs::runjs("window.scrollTo(0, 0)")
