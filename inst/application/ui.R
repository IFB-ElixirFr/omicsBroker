################################################################################
# Title : omicsBroker - UI
# Organism : All
# Omics area : Omics
# Users : Thomas Denecker
# Email : thomas.denecker@gmail.com
# Date : nov, 2020
# GitHub :
# DockerHub :
################################################################################

################################################################################
###                                Library                                   ###
################################################################################

#===============================================================================
# Application
#===============================================================================
suppressMessages(suppressWarnings(library(shiny)))
suppressMessages(suppressWarnings(library(shinyjs)))
suppressMessages(suppressWarnings(library(shinyalert)))
suppressMessages(suppressWarnings(library(shinydashboard)))
suppressMessages(suppressWarnings(library(shinydashboardPlus)))
suppressMessages(suppressWarnings(library(shinyWidgets)))
suppressMessages(suppressWarnings(library(shinycssloaders)))
suppressMessages(suppressWarnings(library(shinyhelper)))
suppressMessages(suppressWarnings(library(colourpicker)))
suppressMessages(suppressWarnings(library(shinycustomloader)))

#===============================================================================
# Data treatment
#===============================================================================


suppressMessages(suppressWarnings(library(ontologyIndex)))
suppressMessages(suppressWarnings(library(readxl)))
suppressMessages(suppressWarnings(library(xlsx)))
suppressMessages(suppressWarnings(library(dplyr)))
suppressMessages(suppressWarnings(library(knitr)))
suppressMessages(suppressWarnings(library(reshape2)))
suppressMessages(suppressWarnings(library(rhandsontable)))
suppressMessages(suppressWarnings(library(stringr)))
suppressMessages(suppressWarnings(library(tibble)))

#===============================================================================
# Write report
#===============================================================================

suppressMessages(suppressWarnings(library(rlist)))
suppressMessages(suppressWarnings(library(svglite)))
suppressMessages(suppressWarnings(library(rmarkdown)))
suppressMessages(suppressWarnings(library(XML)))

#===============================================================================
# Import
#===============================================================================

suppressMessages(suppressWarnings(library(tools)))

################################################################################
###                             PANELS                                       ###
################################################################################

source("panels/ui/home_ui.R", local = TRUE)
source("panels/ui/sample_ui.R", local = TRUE)
source("panels/ui/project_ui.R", local = TRUE)
source("panels/ui/filesImportPage_ui.R", local = TRUE)
source("panels/ui/publish_ENA_ui.R", local = TRUE)
source("panels/ui/about_ui.R", local = TRUE)
source("panels/ui/adminMetadata_ui.R", local = TRUE)
source("panels/ui/adminChecklists_ui.R", local = TRUE)
source("panels/ui/myProjects_ui.R", local = TRUE)
source("panels/ui/helpPage_ui.R", local = TRUE)


################################################################################
###                              JS                                        ###
################################################################################

jscode <- "
shinyjs.collapseFunction = function(id) {
var list = document.getElementsByClassName('panel-collapse');
 for (let item of list) {
    if (item.classList.contains('in')) {
      item.classList.remove('in');
    }
}

var element = document.getElementById('panel_'+ id);
element.classList.add('in');

var element = document.getElementById('heading_'+ id);
var topPos = element.offsetTop;
console.log(topPos)
document.getElementById('scrollDiv').scroll({
  top: topPos - 5,
  left: 0,
  behavior: 'smooth'
});

}
"

################################################################################
###                              MAIN                                        ###
################################################################################

shinyUI(

  dashboardPage(
    title = "omicsBroker",
    header = dashboardHeader(title = "omicsBroker",
                                 dropdownMenu(icon = icon("question-circle"),badgeStatus =NULL,headerText = "Global information",
                                              messageItem(
                                                from = "Find our project?",
                                                message = "Visit our Github!",
                                                icon = icon("github", class = "fa"),
                                                href = "https://github.com/IFB-ElixirFr/omicsBroker"
                                              ),
                                              messageItem(
                                                from = "New User?",
                                                message = "Read the docs!",
                                                icon = icon("book"),
                                                href = "https://github.com/IFB-ElixirFr/omicsBroker/blob/main/README.md"
                                              ),
                                              messageItem(
                                                from = "A bug with app?",
                                                message = "Declare an issue!",
                                                icon = icon("exclamation-triangle"),
                                                href = "https://github.com/IFB-ElixirFr/omicsBroker/issues/new"
                                              ))

    ),
    sidebar = dashboardSidebar( uiOutput('sidebar') ),
    body = dashboardBody(id= "dashboardBody",
                         tags$head(tags$link(href = "img/logo.png",
                                             rel ="icon", type="image/png")),
                         tags$head(tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/js/bootstrap.min.js")),
                         tags$head(HTML('<link rel="stylesheet" type="text/css"
                   href="css/style.css" />')),
                         useShinyjs(),
                         extendShinyjs(text = jscode, functions = c("collapseFunction")),
                         useShinyalert(),
                         tabItems(
                           tabItem("home", home),
                           tabItem("samplePage", samplePage),
                           tabItem("project", project),
                           tabItem("filesImportPage", filesImportPage),
                           tabItem("publish_ENA", publish_ENA),
                           tabItem("adminMetadata", adminMetadata),
                           tabItem("adminChecklists", adminChecklists),
                           tabItem("myProjects", myProjects),
                           tabItem("about", about),
                           tabItem("helpPage", helpPage)
                         )
    )
  )
)
