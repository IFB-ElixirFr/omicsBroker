observeEvent(input$publishBtn_ENA, {

  toDelete = NULL

  #=============================================================================
  # Create project file
  #=============================================================================

  #-----------------------------------------------------------------------------
  # Variable control : Projet
  #-----------------------------------------------------------------------------

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
    #-----------------------------------------------------------------------------
    # Variable control : Run
    #-----------------------------------------------------------------------------
  } else if (nrow(appReac$files) == 0 ) {
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

    saveXML(xmlText, paste0("www/tmp/", nameTmpFolder,"/project.xml"),  prefix='<?xml version="1.0" encoding="UTF-8"?>\n')


    #===========================================================================
    # Create submission file
    #===========================================================================

    doc = newXMLDoc()
    xmlText <-
      newXMLNode("SUBMISSION",
                 newXMLNode("ACTIONS",
                            newXMLNode("ACTION",
                                       newXMLNode("ADD")))

                 ,
                 doc = doc
      )

    saveXML(xmlText, paste0("www/tmp/", nameTmpFolder,"/submission.xml"),  prefix='<?xml version="1.0" encoding="UTF-8"?>\n')


    #===========================================================================
    # Publish
    #===========================================================================

    if (input$userID_ENA  == ""  | input$pwID_ENA == "") {
      sendSweetAlert(
        session = session,
        title = "Oops!",
        text = "Username and password are mandatory !",
        type = "error"
      )
    } else {
      h <- new_handle()
      handle_setopt(
        handle = h,
        httpauth = 1,
        userpwd = paste0(input$userID_ENA ,":", input$pwID_ENA)
      )
      handle_setform(h,
                     SUBMISSION = form_file(paste0("www/tmp/", nameTmpFolder,"/submission.xml")),
                     PROJECT= form_file(paste0("www/tmp/", nameTmpFolder,"/project.xml")))
      r <- curl_fetch_memory("https://wwwdev.ebi.ac.uk/ena/submit/drop-box/submit/",handle =  h)

      message(read_xml(rawToChar(r$content)))

      if (read_xml(rawToChar(r$content)) %>% xml_find_all("//RECEIPT") %>% xml_attr( "success") == "false") {
        sendSweetAlert(
          session = session,
          title = "Oops!",
          text = paste0(read_xml(rawToChar(r$content)) %>% xml_find_all("//MESSAGES") %>% xml_find_all(".//ERROR") %>% xml_text(), collapse = ""),
          type = "error"
        )
      } else {
        projectAccession = read_xml(rawToChar(r$content)) %>% xml_find_all("//PROJECT") %>% xml_attr( "accession")
        message(projectAccession)
        toDelete = c(toDelete,projectAccession )

      }

      #=========================================================================
      # Create sample file
      #=========================================================================
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

      saveXML(xmlText, paste0("www/tmp/", nameTmpFolder,"/sample.xml"),  prefix='<?xml version="1.0" encoding="UTF-8"?>\n')
      h <- new_handle()
      handle_setopt(
        handle = h,
        httpauth = 1,
        userpwd = paste0(input$userID_ENA ,":", input$pwID_ENA)
      )
      handle_setform(h,
                     SUBMISSION = form_file(paste0("www/tmp/", nameTmpFolder,"/submission.xml")),
                     SAMPLE= form_file(paste0("www/tmp/", nameTmpFolder,"/sample.xml")))
      r <- curl_fetch_memory("https://wwwdev.ebi.ac.uk/ena/submit/drop-box/submit/",handle =  h)

      message(read_xml(rawToChar(r$content)))

      if (read_xml(rawToChar(r$content)) %>% xml_find_all("//RECEIPT") %>% xml_attr( "success") == "false") {
        sendSweetAlert(
          session = session,
          title = "Oops!",
          text = paste0(read_xml(rawToChar(r$content)) %>% xml_find_all("//MESSAGES") %>% xml_find_all(".//ERROR") %>% xml_text(), collapse = ""),
          type = "error"
        )
      }  else {
        sampleAccession = read_xml(rawToChar(r$content)) %>% xml_find_all("//SAMPLE") %>% xml_attr( "accession")
        message(sampleAccession)
        toDelete = c(toDelete,sampleAccession )
      }

      #=========================================================================
      # Create experiment file
      #=========================================================================

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
                                newXMLNode("STUDY_REF", attrs = c(accession = projectAccession)),
                                newXMLNode("DESIGN",
                                           newXMLNode("DESIGN_DESCRIPTION"),
                                           newXMLNode("SAMPLE_DESCRIPTOR", attrs = c(accession = sampleAccession[i])),
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

      saveXML(xmlText, paste0("www/tmp/", nameTmpFolder,"/experiment.xml"), prefix='<?xml version="1.0" encoding="UTF-8"?>\n')

      #=========================================================================
      # Create run file
      #=========================================================================

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
      saveXML(xmlText, paste0("www/tmp/", nameTmpFolder,"/run.xml"),  prefix='<?xml version="1.0" encoding="UTF-8"?>\n')


      h <- new_handle()
      handle_setopt(
        handle = h,
        httpauth = 1,
        userpwd = paste0(input$userID_ENA ,":", input$pwID_ENA)
      )
      handle_setform(h,
                     SUBMISSION = form_file(paste0("www/tmp/", nameTmpFolder,"/submission.xml")),
                     EXPERIMENT= form_file(paste0("www/tmp/", nameTmpFolder,"/experiment.xml")),
                     RUN= form_file(paste0("www/tmp/", nameTmpFolder,"/run.xml")))
      r <- curl_fetch_memory("https://wwwdev.ebi.ac.uk/ena/submit/drop-box/submit/",handle =  h)

      message(read_xml(rawToChar(r$content)))

      if (read_xml(rawToChar(r$content)) %>% xml_find_all("//RECEIPT") %>% xml_attr( "success") == "false") {
        sendSweetAlert(
          session = session,
          title = "Oops!",
          text = paste0(read_xml(rawToChar(r$content)) %>% xml_find_all("//MESSAGES") %>% xml_find_all(".//ERROR") %>% xml_text(), collapse = ""),
          type = "error"
        )
      } else {
        sendSweetAlert(
          session = session,
          title = "Success!",
          text = "All files have been loaded into the dev instance.",
          type = "success"
        )
      }

      #=========================================================================
      # Create cancel file
      #=========================================================================
      doc = newXMLDoc()
      xmlText <-
        newXMLNode("SUBMISSION",
                   newXMLNode("ACTIONS",
                              unlist(lapply(toDelete, function(i){
                                newXMLNode("ACTION",
                                           newXMLNode("CANCEL", attrs = c(target = i))
                                )}))
                   )
                   ,
                   doc = doc
        )

      saveXML(xmlText, paste0("www/tmp/", nameTmpFolder,"/cancel.xml"),  prefix='<?xml version="1.0" encoding="UTF-8"?>\n')
    }

  }
})
