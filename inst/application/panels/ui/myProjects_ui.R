myProjects <- fluidPage(
  fluidRow(h1("My projects"),
           withLoader(rHandsontableOutput("dataTable_adminProjects"))
  )


)
