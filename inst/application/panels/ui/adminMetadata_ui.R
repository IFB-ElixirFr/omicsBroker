adminMetadata <- fluidPage(
  fluidRow(h1("Metadata admin"),
           withLoader( rHandsontableOutput("dataTable_adminMetadata"))
  )
)
