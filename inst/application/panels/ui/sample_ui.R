samplePage <- fluidPage(

  fluidRow(h1("Samples"),
           fluidRow(
             column(6,
                    h3("Data source"),
                    fluidRow(
                      column(6,selectInput(inputId = "selectDataSource", label = "Select data source",
                                choices = c("Eukaryote" = "migs_eu",
                                            "Bacteria/Archaea Genome" = "migs_ba",
                                            "Plasmid"  ="migs_pl",
                                            "Viral genome" = "migs_vi",
                                            "Organelle genome"="migs_org",
                                            "Metagenomes" = "me",
                                            "Target gene"= "mimarks_s",
                                            "Target gene (isolation and growth condition)"= "mimarks_c",
                                            "Single amplified genome sequence"="misag",
                                            "Metagenome-assembled genome sequence"= "mimag",
                                            "miuvig"= "miuvig"),
                                selected = "migs_eu"),

                    selectInput(inputId = "filter", label = "Information about whether an item",
                                choices = c("All" = "all","Mandatory" = "M", "Conditional mandatory" = "C", "optional" = "X", "Environment-dependent" = "E" , "Not applicable" = "-"),
                                selected = "all")
                      ),
                    column(6,
                           icon("question-circle"),
                           tags$label(class="control-label", "Description"),
                           textOutput("helpDataSource"))
                    )
             ),
             column(6,
                    h3("Packages"),
                    fluidRow(
                      column(6,uiOutput("selectPackagesItemsUI")),
                      column(6,
                             icon("question-circle"),
                             tags$label(class="control-label", "Description"),
                             textOutput("helpPackagesItems"))
                    )


             )
           ),

           fluidRow(
             column(8,
                    h3("Table"),
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


