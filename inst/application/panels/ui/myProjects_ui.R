myProjects <- fluidPage(
  fluidRow(h1("My projects"),

           h3("Login"),
           textInput("omicsBroker_user", "User name"),
           passwordInput("omicsBroker_pw", "Password"),
           actionButton("loadProjectsSpace", "Load workspace"),

           h3("Workspace"),
           withLoader(rHandsontableOutput("dataTable_adminProjects"))
  )


)
