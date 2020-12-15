project <- fluidPage(

  fluidRow(h1("Project"),
           fluidRow(
             column(6,
                    h3("General"),

                    tags$label(class="control-label", "Title", tags$span(style="color:red;", "*")),
                    helpText(style="font-style: italic;", "A short descriptive title for the project."),
                    textInput("projectSet_title", label = NULL, width = "100%"),

                    tags$label(class="control-label", "Alias", tags$span(style="color:red;", "*")),
                    helpText(style="font-style: italic;", "An alias to the project (i.e.: salivarius_dynamic)"),
                    textInput("projectSet_alias", label = NULL, width = "100%"),


                    tags$label(class="control-label", "Description", tags$span(style="color:red;", "*")),
                    helpText(style="font-style: italic;", "A long description of the scope of the project."),
                    textAreaInput("projectSet_description", label = NULL, width = "100%",
                                  resize = "vertical") %>%
                      shiny::tagAppendAttributes(style = 'width: 100%;')
             ),

             column(6,
                    h3("People"),
                    h2("Team"),
                    div(style="width:300px",
                        textInput("projectSet_submitter", label = "Submitter user name", width = "100%") %>%
                          helper(type = "inline",
                                 title = "Submitter user name",
                                 content = c("This is a <b>text input</b>.",
                                             "This is on a new line."))
                    ),

                    dateInput("release_date", "Release date"),

                    h2("Organization"),
                    textInput("Organization_name", label = "Organization name"),
                    selectInput("Organization_role",label = "Organization role",  choices = "owner"),
                    selectInput("Organization_type", label = "Organization type", choices = "center"),

                    h2("Contact"),
                    textInput("Contact_email", label = "Contact email"),
                    textInput("Contact_First", label = "Contact first name"),
                    textInput("Contact_Last", label = "Contact last name")
             )
           ),

           fileInput(
             inputId = "selectPGD",
             label = "Select a  PGD - Opidor file",
             multiple = F,
             accept = NULL,
             width = NULL,
             buttonLabel = "Browse...",
             placeholder = "No file selected"
           ),
           actionButton("importPGD","Import PGD")
  )
)
