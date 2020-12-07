################################################################################
# Title : metaBroker - Panel - Sample
# Owner : Thomas Denecker
# Email : thomas.denecker@gmail.com
# Date : nov, 2020
# GitHub :
# DockerHub :
################################################################################

################################################################################
# Function
################################################################################

firstup <- function(x) {
  substr(x, 1, 1) <- toupper(substr(x, 1, 1))
  x
}

################################################################################
# MAIN
################################################################################

#===============================================================================
# Read Data
#===============================================================================

metatable <- read_excel("./data/mixs_v5.xlsx", sheet = "MIxS")
Env = metatable %>% filter (Section == "environment") %>% mutate(Item = firstup(Item)) %>% pull(Item)

packagesItems <- read_excel("./data/mixs_v5.xlsx",
                            sheet = "environmental_packages")
experiment <- read.csv2("./data/typeLibraryStrategy.tsv", sep = "\t")

#===============================================================================
# Constants
#===============================================================================

requirement = c("M" ='<span style="color: red;"><i class="fa fa-asterisk"></i></span> Mandatory',
                "C" = "Conditional mandatory" ,"X" = "optional" ,
                "E" = "Environment-dependent", "-" = "Not applicable")

#===============================================================================
# Data source
#===============================================================================

output$helpDataSource  <- renderText({
  if(!is.null(input$selectDataSource)){
    switch (input$selectDataSource,
            "migs_eu" = "Eukaryotic samples.",
            "migs_ba" = "Cultured bacterial/archaeal sample.",
            "migs_pl"  = "Plasmid samples.",
            "migs_vi" = "Viral samples.",
            "migs_org" = "Organelle samples.",
            "me" = "Sequences obtained using whole genome sequencing on samples obtained directly from the environment, without culturing or identification of the organisms.",
            "mimarks_s"= "Target gene",
            "mimarks_c"= "Target gene (isolation and growth condition)",
            "misag"="Single amplified genome sequence sample",
            "mimag"= "Metagenome-assembled genome sequence sample.",
            "miuvig"= "miuvig"
    )
  }
})

#===============================================================================
# Package items
#===============================================================================

output$selectPackagesItemsUI <- renderUI({
  selectInput(inputId = "selectPackagesItems", label = "Select package",
              choices = unique(packagesItems$`Environmental package`))
})

output$helpPackagesItems  <- renderText({
  if(!is.null(input$selectPackagesItems)){
    switch (input$selectPackagesItems,
            "air" = "Cultured bacterial/archaeal libraries from residential and hospital indoor ventilation system.",
            "built environment" = "",
            "host-associated" = "Cultured bacterial/archaeal libraries with the emphasis on the ecological and physiological interactions between hosts and environment. Typical samples sources include skin or stool from mouse.",
            "human-associated" = "Cultured bacterial/archaeal libraries from the body sites such as anterior nares, retro auricular crease, saliva and nares.",
            "human-gut" = "Cultured bacterial/archaeal libraries from human gastrointestinal track typically with samples from stool.",
            "human-oral" = "Cultured bacterial/archaeal libraries from habitats such as teeth, gingival sulcus, tongue, cheeks, hard and soft palates, and tonsils.",
            "human-skin" = "Cultured bacterial/archaeal libraries from human skin such as nare, external auditory canal, occiput, retroauricular crease, and volar forearm.",
            "human-vaginal" = "Cultured bacterial/archaeal libraries from locations such as poster fornix, mid vagina, and introitus.",
            "hydrocarbon resources-cores" = "",
            "hydrocarbon resources-fluids/swabs" = "",
            "microbial mat/biofilm" = "Cultured bacterial/archaeal libraries without specific categories, such as ant fungus, beach sand, dust, fermentation, and compost.",
            "miscellaneous natural or artificial environment" = "Cultured bacterial/archaeal libraries generally not classified in any particular categories, such as samples collected from debris after natural disaster and echinoderm.",
            "plant-associated" = "Cultured bacterial/archaeal libraries in plants typically as a response to changes in environment with samples from, as an example, the roots.",
            "sediment" = "Cultured bacterial/archaeal libraries from the locations such as estuaries, wetland, and river bed.",
            "soil" = "Cultured bacterial/archaeal libraries from the locations such forest, glaciers, and permafrost.",
            "wastewater/sludge" = "Cultured bacterial/archaeal libraries from sewage and sludge.",
            "water" = "Cultured bacterial/archaeal libraries from, for example, tap/drinking water, swimming pool, river, and ocean."
    )
  }
})

#===============================================================================
# Datatable
#===============================================================================

output$dataTable = renderRHandsontable({
  nRows = 20
  #-----------------------------------------------------------------------------
  # Filter DS
  #-----------------------------------------------------------------------------
  if(input$filter == "all"){
    metatableFilter = as.data.frame(metatable) %>%
      mutate(Requirement = as.data.frame(metatable)[,input$selectDataSource]) %>%
      select( "Item", "Definition","Value syntax", "Structured comment name","Requirement" )
  } else {
    metatableFilter = as.data.frame(metatable) %>%
      mutate(Requirement = as.data.frame(metatable)[,input$selectDataSource]) %>%
      filter(Requirement %in% c("M", input$filter)) %>%
      select( "Item", "Definition","Value syntax", "Structured comment name", "Requirement")
  }

  #-----------------------------------------------------------------------------
  # Add package
  #-----------------------------------------------------------------------------
  if(!is.null(input$selectPackagesItems)){
    subpackagesItems = packagesItems %>% filter(`Environmental package` == input$selectPackagesItems) %>%
      select(`Package item`, Definition, `Value syntax`, `Structured comment name`, "Requirement")
    colnames(subpackagesItems)  = c("Item", "Definition","Value syntax", "Structured comment name", "Requirement")

    appReac$metatableFilter = rbind(metatableFilter, subpackagesItems)
  } else {
    appReac$metatableFilter = metatableFilter
  }


  #-----------------------------------------------------------------------------
  # Autocomplete
  #-----------------------------------------------------------------------------
  pos = which(substr(appReac$metatableFilter$`Value syntax`, 1, 1) == "[")
  sourcesAutocomplet = lapply(pos, function(x){
    inter = appReac$metatableFilter$`Value syntax`[x]
    inter = sub("\\[", "", inter)
    inter = sub("\\]", "", inter)
    unlist(strsplit(inter, "\\|"))
  })

  names(sourcesAutocomplet) = appReac$metatableFilter$Item[pos]

  #-----------------------------------------------------------------------------
  # create DF
  #-----------------------------------------------------------------------------
  DF = NULL
  for(i in 1:nrow(appReac$metatableFilter)){
    if(grepl("boolean", appReac$metatableFilter$`Value syntax`[i]) ){
      if(is.null(DF)){
        DF = logical(nRows)
      } else {
        DF = cbind.data.frame(DF,
                              logical(nRows))
      }

    } else if(grepl("timestamp", appReac$metatableFilter$`Value syntax`[i])){
      if(is.null(DF)){
        DF = rep(Sys.Date(), nRows)
      } else {
        DF = cbind.data.frame(DF,
                              rep(Sys.Date(), nRows))
      }
    } else if(grepl("integer", appReac$metatableFilter$`Value syntax`[i]) | grepl("float", appReac$metatableFilter$`Value syntax`[i])){
      if(is.null(DF)){
        DF = numeric(nRows)
      } else {
        DF = cbind.data.frame(DF,
                              numeric(nRows))
      }
    } else {
      if(is.null(DF)){
        DF =  character(length = nRows)
      } else {
        DF = cbind.data.frame(DF,
                              character(length = nRows))
      }
    }

  }

  colnames(DF) =  appReac$metatableFilter$Item
  colnames(DF) = firstup(colnames(DF))
  DF = as.data.frame(DF)

  tmp = rhandsontable(DF ,
                      comments = matrix(ncol = ncol(DF), nrow = nrow(DF)),
                      selectCallback = TRUE,
                      stretchH = "all") %>%
    hot_cols(colWidths = 250) %>%
    hot_rows(rowHeights = 30) %>%
    hot_cols(fixedColumnsLeft = 1) %>%
    hot_col(col = "Organism", type = "autocomplete", source = species,
            strict = FALSE) %>%
    hot_col(col = "Sequencing method", type = "autocomplete",
            source = experiment$Name,
            strict = FALSE)

  for (i in 1:length(sourcesAutocomplet)){
    tmp = tmp %>%
      hot_col(col =  firstup(names(sourcesAutocomplet)[i]),
              type = "autocomplete", source = sourcesAutocomplet[[i]],
              strict = FALSE)
  }

  tmp
})


observeEvent(input$dataTable_select, {
  if(!is.null(input$dataTable_select)){
    if (input$dataTable_select$select$c != appReac$rowSelec){
      js$collapseFunction(input$dataTable_select$select$c )
    }
    appReac$rowSelec = input$dataTable_select$select$c
  }
})



observeEvent(input$dataTable, {
  appReac$projectName = unique(as.character(hot_to_r(input$dataTable)[, "Project name" ]))
  appReac$dataTable =  hot_to_r(input$dataTable)
})


#===============================================================================
# Accordion Area
#===============================================================================

output$accordionArea <- renderUI({
  if(!is.null(input$search)){
    if(input$search == ""){
      mf = appReac$metatableFilter

    } else {
      mf =  appReac$metatableFilter %>%
        filter_all(any_vars(str_detect(., pattern = input$search)))
    }
    if(nrow(mf) !=0){
      div( id="scrollDiv", style= "height:700px; overflow:auto; position:relative;", HTML('
    <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
  '),

           HTML(unlist(lapply(1:nrow(mf), function(i){
             paste0(
               '    <div class="panel"
         id="panelContainer_',i,'">
      <div class="panel-heading"
           role="tab"
           id="heading_',i ,'">
        <h4 class="panel-title">
          <a role="button"
             data-toggle="collapse"
             data-parent="#accordion"
             href="#panel_',i,'"
             aria-expanded="false"
             aria-controls="panel_',i,'">
            ',firstup(mf$Item[i]),'
          </a>
        </h4>
      </div>
      <div id="panel_',i,'"
           class="panel-collapse collapse"
           role="tabpanel"
           aria-labelledby="heading_',i ,'">
        <div class="panel-body">
          <div class="descrip">
            <h2>Definition</h2>
            <p>',mf$Definition[i], '</p>
            <h2>Format</h2>
            <p>',mf$`Value syntax`[i],'</p>
            <h2>Harmonized Name</h2>
            <p>', mf$`Structured comment name`[i],'</p>
            <p class="required">
              ',requirement[mf$Requirement[i]], '
            </p>
            <div style="clear: both;"></div>
          </div>
        </div>
      </div>
    </div>
')})))

           , HTML('
    </div>
  '),
      )
    } else {
      NULL
    }
  }


})
