adminChecklists <- fluidPage(
  fluidRow(h1("Checklist admin"),
           withLoader(rHandsontableOutput("dataTable_adminChecklists"))
  )
)
