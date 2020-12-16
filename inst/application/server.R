################################################################################
# Title : metaBroker - SERVER
# Organism : All
# Omics area : Omics
# Users : Thomas Denecker
# Email : thomas.denecker@gmail.com
# Date : Oct, 2020
# GitHub :
# DockerHub :
################################################################################

################################################################################
###                                Library                                   ###
################################################################################

library(shiny)

################################################################################
###                           FUNCTIONS                                      ###
################################################################################

createAlias <- function(x){
  x = iconv(x, from = 'UTF-8', to = 'ASCII//TRANSLIT')
  x = gsub("[[:punct:]]", " ", x)
  x = gsub(" ", "_", x)
}

################################################################################
###                              MAIN                                        ###
################################################################################

shinyServer(function(input, output, session) {

  options(shiny.maxRequestSize=100*1024^2)

  #===========================================================================
  # PANELS & FUNCTIONS
  #===========================================================================

  source("panels/server/about_server.R", local = TRUE)
  source("panels/server/home_server.R", local = TRUE)
  source("panels/server/sample_server.R", local = TRUE)
  source("panels/server/project_server.R", local = TRUE)
  source("panels/server/download_server.R", local = TRUE)
  source("panels/server/filesImportPage_server.R", local = TRUE)
  source("panels/server/sideBar_server.R", local = TRUE)
  source("panels/server/adminMetadata_server.R", local = TRUE)
  source("panels/server/adminChecklists_server.R", local = TRUE)
  source("panels/server/myProjects_server.R", local = TRUE)
  source("panels/server/publish_ENA_server.R", local = TRUE)

  #===========================================================================
  # Session
  #===========================================================================

  si <- sessionInfo()

  observe_helpers(session, help_dir = "helpfiles/")

  #===========================================================================
  # Reactive Values
  #===========================================================================

  tmpFolderRV <- reactiveValues()
  appReac <- reactiveValues()
  appReac$rowSelec <- -1
  appReac$login = F
  appReac$files = data.frame(name=character(),
                             size=numeric(),
                             md5Server=character(),
                             md5sumIn=character(),
                             md5sumCheck=character(),
                             expName=character(),
                             M = numeric(),
                             C = numeric(),
                             X = numeric(),
                             E = numeric(),
                             N = numeric())

  #===========================================================================
  # Dir creation
  #===========================================================================

  if(! dir.exists("www/tmp")){
    dir.create("www/tmp")
  }

  wd = getwd()
  nameTmpFolder = format(Sys.time(), "%Y%m%d_%H%M%S")

  tmpFolder = paste0("www/tmp/",nameTmpFolder)
  tmpFolderWithoutWWW = paste0("tmp/",nameTmpFolder)

  dir.create(paste0("www/tmp/", nameTmpFolder))
  dir.create(paste0("www/tmp/", nameTmpFolder, "/files"))

  #===========================================================================
  # Clean temp
  #===========================================================================

  session$onSessionEnded(function(userID = users_data$USERS) {
    unlink(tmpFolder, recursive = T)
  })

})
