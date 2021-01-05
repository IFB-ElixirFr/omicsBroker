samplePage <- fluidPage(

  fluidRow(h1("Samples"),
           fluidRow(
             column(4,
                    h3("Database"),
                    fluidRow(
                      column(6,selectInput("dataBase", "Select Database",
                                           choices = c("ENA" = "MIP_ENA"),
                                           selected = "ENA"),

                             selectInput(inputId = "filterMinimalProfil", label = "Filter by mandatory : ",
                                         choices = c("All" = "all","Mandatory" = "M", "Conditional mandatory" = "C", "optional" = "X", "Environment-dependent" = "E" , "Not applicable" = "-"),
                                         selected = "all")
                      ),
                      column(6,
                             icon("question-circle"),
                             tags$label(class="control-label", "Database description"),
                             textOutput("helpDatabase"))
                    )

             ),
             column(8,
                    h3("Checklist"),
                    textInput("searchCF", NULL, placeholder = "Search"),
                    rHandsontableOutput("dataTable_checkLists", height = "500px")
             )
           ),

           fluidRow(
             column(8,
                    h3("Metadata table"),
                    downloadButton('dowloadExcel', 'Excel'),
                    tags$br(), tags$br(),
                    div(style="height: 700px;",
                        rHandsontableOutput("dataTable")
                    )
             ),
             column(4,
                    h3("Descriptions"),
                    textInput("search", NULL, placeholder = "Search"),
                    uiOutput("accordionArea")
             )
           )
  )
)


