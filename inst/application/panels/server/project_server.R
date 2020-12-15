observeEvent(input$importPGD, {
  if(!is.null(input$selectPGD) & input$selectPGD$datapath != ""){

    pgd = read_html(input$selectPGD$datapath)
    # txt = pgd %>% html_nodes("body") %>% html_text()
    #
    # txt <- gsub("&lt;", "<", txt)
    # txt <- gsub("&gt;", ">", txt)
    # txt <- gsub("\\n", ">", txt)
    # txt = gsub("<br>", "", txt)
    # txt = gsub("<br />", "", txt)

    # title = read_html(txt) %>% xml_find_all("//body") %>% xml_find_first(".//h1") %>% xml_text()
    title = pgd %>% xml_find_all("//body") %>% xml_find_first(".//h1") %>% xml_text()

    nodes <- pgd %>% xml_find_all("//body") %>% xml_find_first(".//div")
    nodes <- pgd %>% xml_find_all("//body") %>% xml_find_all("//div")
    nodes <- nodes[which(xml_attr(nodes, "class") =="cover-page")] %>% xml_find_all("//p")
    description <- nodes[grep("Résumé du projet",nodes) + 1 ] %>% xml_text()
    contact <- gsub("Chercheur Principal : ", "", nodes[grep("Chercheur Principal",nodes)  ] %>% xml_text())

    # Update

    updateTextInput(session, "projectSet_title",value =  title)
    updateTextInput(session, "projectSet_alias",value =  createAlias(title))
    updateTextAreaInput(session,"projectSet_description", value = description)
    updateTextAreaInput(session,"projectSet_submitter", value = contact)


  }
})





