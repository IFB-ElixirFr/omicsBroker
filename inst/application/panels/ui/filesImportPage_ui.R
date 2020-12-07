filesImportPage <- fluidPage(
  fluidRow(h1("File Import"),
           h3("Select file(s)"),
           helpText("Lorem ipsum"),
           fileInput(
             inputId = "filesImport",
             label = NULL,
             multiple = T,
             accept = NULL,
             width = NULL,
             buttonLabel = "Browse...",
             placeholder = "No file selected"
           ),

           h3("Imported file(s)"),
           rHandsontableOutput("files", height = "500px")
  )
)
