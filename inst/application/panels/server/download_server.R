
#===============================================================================
# Download button
#===============================================================================

#-------------------------------------------------------------------------------
# Excel
#-------------------------------------------------------------------------------

output$dowloadExcel <- downloadHandler(
  filename = function() {
    paste('data-', Sys.Date(), '.xlsx', sep='')
  },
  content = function(con) {
    write.xlsx2(hot_to_r(input$dataTable), con)
  }
)


#-------------------------------------------------------------------------------
# XML - Submission
#-------------------------------------------------------------------------------

observeEvent(input$dowloadXML_projectSet_init, {
  if (input$projectSet_title == "" ) {
    sendSweetAlert(
      session = session,
      title = "Oops!",
      text = "A title must be filled in !",
      type = "error"
    )
  } else if (input$projectSet_alias == "") {
    sendSweetAlert(
      session = session,
      title = "Oops!",
      text = "An alias must be filled in !",
      type = "error"
    )
  } else if (input$projectSet_description == "" ) {
    sendSweetAlert(
      session = session,
      title = "Oops!",
      text = "A desciption must be filled in !",
      type = "error"
    )
  } else {
    shinyjs::runjs("document.getElementById('dowloadXML_projectSet').click();")
  }

})

output$dowloadXML_projectSet <- downloadHandler(
  filename = function() {
    paste('projectSet-', Sys.Date(), '.xml', sep='')
  },
  content = function(con) {
    doc = newXMLDoc()
    xmlText <-
      newXMLNode("PROJECT_SET",
                 newXMLNode("PROJECT", attrs = c(alias = createAlias(input$projectSet_alias)),
                            newXMLNode("TITLE", input$projectSet_title),
                            newXMLNode("DESCRIPTION", input$projectSet_description),
                            newXMLNode("SUBMISSION_PROJECT",
                                       newXMLNode("SEQUENCING_PROJECT"))
                 )
                 ,
                 doc = doc
      )

    saveXML(xmlText, con,  prefix='<?xml version="1.0" encoding="UTF-8"?>\n')

  })


#-------------------------------------------------------------------------------
# XML - Samples
#-------------------------------------------------------------------------------

observeEvent(input$dowloadXML_samples_init, {
  if (is.null(input$dataTable) ) {
    sendSweetAlert(
      session = session,
      title = "Oops!",
      text = "Sample table is empty !",
      type = "error"
    )
  } else {
    shinyjs::runjs("document.getElementById('dowloadXML_samples').click();")
  }
})

output$dowloadXML_samples <- downloadHandler(
  filename = function() {
    paste('samples-', Sys.Date(), '.xml', sep='')
  },
  content = function(con) {

    interDf = as.data.frame(appReac$dataTable)
    interDf = interDf[interDf[,1] != "", ]

    doc = newXMLDoc()
    xmlText <-
      newXMLNode("SAMPLE_SET",
                 unlist(lapply(1:nrow(interDf), function(i){
                   newXMLNode("SAMPLE", attrs = c(alias = createAlias(interDf[i, "Experience name"])),
                              newXMLNode("TITLE", interDf[i, "Experience name"]),
                              newXMLNode("SAMPLE_NAME",
                                         newXMLNode("TAXON_ID", taxo[which(taxo[,2] == interDf[i, "Organism"]), 1]),
                                         newXMLNode("SCIENTIFIC_NAME", interDf[i, "Organism"] )
                              ),
                              newXMLNode("SAMPLE_ATTRIBUTES",
                                         unlist(lapply(which(colnames(interDf) %in% appReac$LABELSamples ), function(j){
                                           newXMLNode("SAMPLE_ATTRIBUTE",
                                                      newXMLNode("TAG", colnames(interDf)[j]),
                                                      newXMLNode("VALUE", interDf[i, j])
                                           )
                                         }))

                              )
                   )
                 })),
                 doc = doc

      )

    saveXML(xmlText, con,  prefix='<?xml version="1.0" encoding="UTF-8"?>\n')

  })

#-------------------------------------------------------------------------------
# XML - Submission
#-------------------------------------------------------------------------------
observeEvent(input$dowloadXML_submission_init, {
  shinyjs::runjs("document.getElementById('dowloadXML_submission').click();")
})

output$dowloadXML_submission <- downloadHandler(
  filename = function() {
    paste('submission-', Sys.Date(), '.xml', sep='')
  },
  content = function(con) {
    doc = newXMLDoc()
    xmlText <-
      newXMLNode("SUBMISSION",
                 newXMLNode("ACTIONS",
                            newXMLNode("ACTION",
                                       newXMLNode("ADD")))

                 ,
                 doc = doc
      )

    saveXML(xmlText, con,  prefix='<?xml version="1.0" encoding="UTF-8"?>\n')

  })

#-------------------------------------------------------------------------------
# XML - Experiment
#-------------------------------------------------------------------------------

observeEvent(input$dowloadXML_experiment_init, {
  shinyjs::runjs("document.getElementById('dowloadXML_experiment').click();")
})


output$dowloadXML_experiment <- downloadHandler(
  filename = function() {
    paste('experiment-', Sys.Date(), '.xml', sep='')
  },
  content = function(con) {
    interDf = as.data.frame(appReac$dataTable)
    interDf = interDf[interDf[,1] != "", ]

    doc = newXMLDoc()
    xmlText <-
      newXMLNode("EXPERIMENT_SET",
                 unlist(lapply(1:nrow(interDf), function(i){

                   if(interDf[i, "Library layout"] == "PAIRED"){
                     ll =  newXMLNode("PAIRED", attrs = c(NOMINAL_LENGTH = interDf[i, "Insert size"]))
                   } else {
                     ll =  newXMLNode("SINGLE")
                   }

                   newXMLNode("EXPERIMENT", attrs = c(alias = createAlias(interDf[i, "Experience name"])),
                              newXMLNode("TITLE", interDf[i, "Experience name"]),
                              newXMLNode("STUDY_REF", attrs = c(alias = "XXXXXXXXXXXXXXXXXXX")),
                              newXMLNode("DESIGN",
                                         newXMLNode("DESIGN_DESCRIPTION"),
                                         newXMLNode("SAMPLE_DESCRIPTOR", attrs = c(accession = "XXXXXXXXXXXXXXXXXXX")),
                                         newXMLNode("LIBRARY_DESCRIPTOR",
                                                    newXMLNode("LIBRARY_NAME"),
                                                    newXMLNode("LIBRARY_STRATEGY", interDf[i, "Library strategy"]),
                                                    newXMLNode("LIBRARY_SOURCE", interDf[i, "Library source"]),
                                                    newXMLNode("LIBRARY_SELECTION", interDf[i, "Library selection"]),
                                                    newXMLNode("LIBRARY_LAYOUT", ll),
                                                    newXMLNode("LIBRARY_CONSTRUCTION_PROTOCOL", interDf[i, "Library construction protocol"] )
                                         )
                              ) ,
                              newXMLNode("PLATFORM",
                                         newXMLNode(interDf[i, "Platform"],
                                                    newXMLNode("INSTRUMENT_MODEL",interDf[i, "Instrument"] )
                                         )
                              )
                              # ,
                              # newXMLNode("EXPERIMENT_ATTRIBUTES" ,
                              #            newXMLNode("EXPERIMENT_ATTRIBUTE",
                              #                       newXMLNode("TAG", "XXXXXXXXXXXXXXXXXXX"),
                              #                       newXMLNode("VALUE", "XXXXXXXXXXXXXXXXXXX")
                              #            )
                              # )
                   )
                 }))
                 ,
                 doc = doc
      )

    saveXML(xmlText, con, prefix='<?xml version="1.0" encoding="UTF-8"?>\n')
  }
)

#-------------------------------------------------------------------------------
# XML - Run
#-------------------------------------------------------------------------------
observeEvent(input$dowloadXML_run_init, {
  if (nrow(appReac$files) == 0 ) {
    sendSweetAlert(
      session = session,
      title = "Oops!",
      text = "No file has been imported",
      type = "error"
    )
  } else if (any(appReac$files$md5sumCheck != "Check") ) {
    sendSweetAlert(
      session = session,
      title = "Oops!",
      text = "Before generating the file, all md5sum must be 'Check'.",
      type = "error"
    )
  } else if (any(appReac$files[, "Experience name"] == "") ) {
    sendSweetAlert(
      session = session,
      title = "Oops!",
      text = "All files must be associated with an experiment ! ",
      type = "error"
    )
  } else if (any(table(appReac$files[, "Experience name"]) > 2) ) {
    sendSweetAlert(
      session = session,
      title = "Oops!",
      text = "An experiment can only be associated to a maximum of 2 files (paired end).",
      type = "error"
    )
  } else {
    shinyjs::runjs("document.getElementById('dowloadXML_run').click();")
  }
})

output$dowloadXML_run <- downloadHandler(
  filename = function() {
    paste('run-', Sys.Date(), '.xml', sep='')
  },
  content = function(con) {
    experimentNames = unique(appReac$files[, "Experience name"])
    doc = newXMLDoc()
    xmlText <-
      newXMLNode("RUN_SET",
                 unlist(lapply(1:length(experimentNames), function(i){
                   subTable = as.data.frame(as.data.frame(appReac$files) %>% filter(`Experience name` == as.character(experimentNames[i])))
                   newXMLNode("RUN", attrs = c(alias = paste0('run_', i)),
                              newXMLNode("EXPERIMENT_REF", attrs = c(refname = createAlias(experimentNames[i]) )),
                              newXMLNode("DATA_BLOCK",
                                         newXMLNode("FILES",
                                                    unlist(lapply(1:nrow(subTable), function(j){
                                                      newXMLNode("FILE",attrs = c(filename = subTable$Name[j],
                                                                                  filetype = "fastq",
                                                                                  checksum_method = "MD5",
                                                                                  checksum = subTable$md5Server[j]) )

                                                    }) )
                                         )
                              )
                   )
                 })) ,
                 doc = doc
      )
    saveXML(xmlText, con,  prefix='<?xml version="1.0" encoding="UTF-8"?>\n')
  }
)

