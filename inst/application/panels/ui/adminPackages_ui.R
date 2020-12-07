adminPackages <- fluidPage(
  fluidRow(h1("Packages admin"),
           withLoader(rHandsontableOutput("dataTable_adminPackages"))
  )
)
