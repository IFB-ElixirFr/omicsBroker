output$sidebar <- renderUI({
  sidebarMenu( id = "tabs",
               menuItem("Home", tabName = "home", icon = icon("home")),
               p(style = "text-align: center;margin: 0px; font-weight: bold; background-color: #3c8dbc;padding: 5px;", 'Annotation'),
               menuItem("Project", tabName = "project", icon = icon("pen")),
               menuItem("Samples", tabName = "samplePage", icon = icon("vials")),
               menuItem("Files", tabName = "filesImportPage", icon = icon("file-import")),

               p(style = "text-align: center;margin: 0px; font-weight: bold; background-color: #3c8dbc;padding: 5px;", 'Download'),

               actionButton("dowloadXML_projectSet_init", "Generate project set XML", icon = icon("download"), style = "width:200px;color: #444 !important; margin : 6px 15px 0px 15px;"),
               downloadButton("dowloadXML_projectSet", "Generate project set XML", style = "visibility: hidden; margin : 0; width:0px ; height:0px ; padding:0; border: 0px; "),

               actionButton("dowloadXML_experiment_init", "Generate experiment XML", icon = icon("download"), style = "width:200px;color: #444 !important; margin : 0px 15px;"),
               downloadButton("dowloadXML_experiment", "Generate experiment XML", style = "visibility: hidden; margin : 0; width:0px ; height:0px ; padding:0; border: 0px; "),

               actionButton("dowloadXML_samples_init", "Generate samples XML", icon = icon("download"), style = "width:200px;color: #444 !important; margin : 6px 15px 0px 15px;"),
               downloadButton("dowloadXML_samples", "Generate samples set XML", style = "visibility: hidden; margin : 0; width:0px ; height:0px ; padding:0; border: 0px; "),

               actionButton("dowloadXML_run_init", "Generate run XML", icon = icon("download"), style = "width:200px;color: #444 !important; margin : 0px 15px;"),
               downloadButton("dowloadXML_run", "Generate run XML", style = "visibility: hidden; margin : 0; width:0px ; height:0px ; padding:0; border: 0px;"),

               actionButton("dowloadXML_submission_init", "Generate submission XML", icon = icon("download"), style = "width:200px;color: #444 !important; margin : 0px 15px;"),
               downloadButton("dowloadXML_submission", "Generate submission XML", style = "visibility: hidden; margin : 0; width:0px ; height:0px ; padding:0; border: 0px;"),

               p(style = "text-align: center;margin: 0px; font-weight: bold; background-color: #3c8dbc;padding: 5px;", 'Publish'),
               actionButton("publish_ENA", "ENA", style = "width:200px;color: #444 !important; margin : 6px 15px 6px 15px;"),

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
