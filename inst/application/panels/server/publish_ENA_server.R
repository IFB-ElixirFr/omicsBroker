observeEvent(input$publishBtn_ENA, {

  #=============================================================================
  # Create project file
  #=============================================================================

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
  }

  #=============================================================================
  # Create submission file
  #=============================================================================

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


  #=============================================================================
  # Publish
  #=============================================================================

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

    message(paste0(input$userID_ENA ,":", input$pwID_ENA))

    handle_setform(h,
                   SUBMISSION = form_file(paste0("www/tmp/", nameTmpFolder,"/submission.xml")),
                   PROJECT= form_file(paste0("www/tmp/", nameTmpFolder,"/project.xml")))
    r <- curl_fetch_memory("https://wwwdev.ebi.ac.uk/ena/submit/drop-box/submit/",handle =  h)

    message(read_xml(rawToChar(r$content)))


    if(r$status_code == "403"){
      sendSweetAlert(
        session = session,
        title = "Oops!",
        text = "The username (Webin-XXXXX) or the password have an error!",
        type = "error"
      )
    } else {
      sendSweetAlert(
        session = session,
        title = "Success !",
        text = "The project is publish in dev instance !",
        type = "success"
      )

      projectAccession = read_xml(rawToChar(r$content)) %>% xml_find_all("//PROJECT") %>% xml_attr( "accession")
      message(projectAccession)

      doc = newXMLDoc()
      xmlText <-
        newXMLNode("SUBMISSION",
                   newXMLNode("ACTIONS",
                              newXMLNode("ACTION",
                                         newXMLNode("CANCEL", attrs = c(target = projectAccession))
                              )
                   )
                   ,
                   doc = doc
        )

      saveXML(xmlText, paste0("www/tmp/", nameTmpFolder,"/cancel.xml"),  prefix='<?xml version="1.0" encoding="UTF-8"?>\n')
    }


  }


})
