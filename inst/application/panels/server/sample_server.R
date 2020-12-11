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

taxo = read.csv2("./data/taxo_small.tsv", sep = "\t")
# taxo = read.csv2("./data/taxo.tsv", sep = "\t")

# https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxcat.zip
# taxo = read.csv2("names.dmp", sep = "\t", stringsAsFactors = F)
# taxo = taxo[, c(1,3,5,7)]
# colnames(taxo) = c("ID", "name_txt", "name", "class")
# taxo = taxo %>% filter(class == "scientific name")
# nword = sapply(strsplit(taxo$name_txt, " "), length)
# taxo = taxo[nword == 2,]
# taxo[, 2] = gsub("\\[", "" , taxo[, 2])
# taxo[, 2] = gsub("\\]", "" , taxo[, 2])
# write.table(taxo[, 1:2], "taxo.tsv",  sep = "\t", quote = F, row.names = F)


chekcLists_Table = read.csv2("./data/checklisteTable.tsv", sep = "\t")
allCLElements = read.csv2("./data/allCLElements.tsv", sep ="\t")

#===============================================================================
# Constants
#===============================================================================

requirement = c("M" ='<span style="color: red;"><i class="fa fa-asterisk"></i></span> Mandatory',
                "C" = "Conditional mandatory" ,"X" = "optional" ,
                "E" = "Environment-dependent", "-" = "Not applicable")

#===============================================================================
# Data base
#===============================================================================


observeEvent(input$dataBase, {
  if(input$dataBase != ""){
    updateSelectInput(session, "filterMinimalProfil",
                      choices = unique(subset(allCLElements, CHEKLIST == input$dataBase)[,"MANDATORY"]) )
  }

})

output$helpDatabase <- renderText({
  if(!is.null(input$dataBase)){
    switch (input$dataBase,
            "MIP_ENA" = "The European Nucleotide Archive (ENA) provides a comprehensive record
            of the world’s nucleotide sequencing information, covering raw sequencing data,
            sequence assembly information and functional annotation."
    )
  }
})

#===============================================================================
# Datatable
#===============================================================================

output$dataTable_checkLists = renderRHandsontable({
  if(!is.null(input$searchCF)){

    MAT = cbind.data.frame(chekcLists_Table %>%
                             mutate(Selected = F,
                                    ACCESSION = paste0("<a target='_blank' href='",SOURCE,"'>",ACCESSION,"</a>"),
                                    Mandatory = T,
                                    Recommended = F,
                                    Optional = F) %>%
                             select(Selected, ACCESSION,LABEL, Mandatory,Recommended,Optional,
                                    TYPE, AUTHORITY, DESCRIPTION)

    )
    if(input$searchCF != ""){
      MAT =  MAT %>%
        filter_all(any_vars(str_detect(., pattern = input$searchCF)))
    }

    rhandsontable(MAT,
                  stretchH = "all") %>%
      hot_cols(colWidths = c(25,25,50,25,25,25,25,25, 200)) %>%
      hot_rows(rowHeights = 30) %>%
      hot_col(c(2,3,4, 7:ncol(MAT)), readOnly = T) %>%
      hot_col(2, renderer = htmlwidgets::JS("safeHtmlRenderer"))
  }
})


output$dataTable = renderRHandsontable({

  # Data base selection
  dataXML = subset(allCLElements, CHEKLIST == input$dataBase)

  # Add metadata profiles

  if(!is.null(input$dataTable_checkLists)){
    inter = hot_to_r(input$dataTable_checkLists)

    for(p in which(inter[, 1])){
      message(c("mandatory", "recommended","optional")[c(inter[p,4],
                                                                          inter[p,5],
                                                                          inter[p,6])])

      SubSet = allCLElements %>%
        filter(CHEKLIST == as.character(chekcLists_Table$ACCESSION[p])) %>%
        filter(MANDATORY  %in% c("mandatory", "recommended","optional")[c(inter[p,4],
                                                                           inter[p,5],
                                                                           inter[p,6])])

      dataXML = rbind(dataXML,
                      SubSet
      )

    }

  }


  appReac$metatableFilter = dataXML

  MAT = matrix("", nrow = 10, ncol = nrow(dataXML),
               dimnames = list(1:10,
                               dataXML$LABEL))

  tmpDT = rhandsontable(MAT, selectCallback = TRUE) %>%
    hot_context_menu(
      customOpts = list(
        na = list(name = "not applicable",
                  callback = htmlwidgets::JS(
                    "function (key, options) {
                          var selected = this.getSelected();
		                      this.setDataAtCell(selected[0][0], selected[0][1], 'not applicable');
                       }")),
        nc = list(name = "not collected",
                  callback = htmlwidgets::JS(
                    "function (key, options) {
                          var selected = this.getSelected();
		                      this.setDataAtCell(selected[0][0], selected[0][1], 'not collected');
                       }")),
        np = list(name = "not provided",
                  callback = htmlwidgets::JS(
                    "function (key, options) {
                          var selected = this.getSelected();
		                      this.setDataAtCell(selected[0][0], selected[0][1], 'not provided');
                       }"))
      )
    ) %>%
    hot_cols(colWidths = 250) %>%
    hot_rows(rowHeights = 30) %>%
    hot_cols(fixedColumnsLeft = 1) %>%
    hot_col(col = "Organism", type = "dropdown", source = sort(taxo[,2]),
            strict = FALSE) %>%
    hot_col(col = "Organism", renderer =
              "function (instance, td, row, col, prop, value, cellProperties) {
              Handsontable.renderers.TextRenderer.apply(this, arguments);
                td.style.fontStyle = 'italic';
            }")

  # Validator
  for(p in which(dataXML$REGEX_VALUE != "")) {
    tmpDT= tmpDT %>% hot_col(p, validator = paste0("
           function (value, callback) {

            setTimeout(function(){
              const regex = RegExp('",dataXML$REGEX_VALUE[p], "');
              callback( regex.test(value));
            }, 100)
           }"),
                             allowInvalid = FALSE)
  }

  # Option
  for(p in which(dataXML$VALUE != "")) {
    tmpDT= tmpDT %>%
      hot_col(p, type = "dropdown", source = unlist(strsplit(dataXML$VALUE[p], "@")),
              strict = FALSE)
  }

  tmpDT
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
  appReac$experimentName = unique(hot_to_r(input$dataTable)[, 1 ])
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
             if(mf$MANDATORY[i] =="mandatory"){
               mad = paste0('<span style="color: red;"><i class="fa fa-asterisk"></i></span> Mandatory')
             } else {
               mad = mf$MANDATORY[i]
             }

             if(mf$VALUE[i] != ""){
               val = paste0('<h2>Value</h2>
               <p>',gsub("@", " ", mf$VALUE[i]),'</p>')
             } else {
               val = ""
             }

             if(mf$UNIT[i] != ""){
               uni = paste0('<h2>Unit</h2>
               <p>', mf$UNIT[i],'</p>')
             } else {
               uni = ""
             }

             if(mf$REGEX_VALUE[i] != ""){
               reg = paste0('<h2>REGEX</h2>
               <p>', mf$REGEX_VALUE[i],'</p>')
             } else {
               reg = ""
             }


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
            ',firstup(mf$LABEL[i]),'
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
            <p>',mf$DESCRIPTION[i], '</p>
            ',paste(val, uni, reg, collapse= ""),'
            <h2>Harmonized Name</h2>
            <p>', mf$NAME[i],'</p>
            <p class="required">
              ',mad, '
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
