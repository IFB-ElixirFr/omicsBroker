library(xml2)

#===============================================================================
# Get all checklist
#===============================================================================
for(i in c(11:25, 27:41, 43:45, 47:53)){
  download.file(paste0("https://www.ebi.ac.uk/ena/browser/api/xml/ERC0000",i,"?download=true"), destfile = paste0("./inst/application/checklists/ERC0000",i,".xml"))
}

checklisteTable = NULL
for (f in list.files("inst/application/checklists/")){
  inter = read_xml(paste0("inst/application/checklists/", f))
  checklisteTable = rbind(checklisteTable,
                          c(
                            ACCESSION = inter %>% xml_find_all(".//CHECKLIST") %>% xml_attr("accession"),
                            SOURCE = paste0("https://www.ebi.ac.uk/ena/browser/api/xml/", inter %>% xml_find_all(".//CHECKLIST") %>% xml_attr("accession")),
                            TYPE = inter %>% xml_find_all(".//CHECKLIST") %>% xml_attr("checklistType"),
                            AUTHORITY = inter %>% xml_find_all("/CHECKLIST_SET/CHECKLIST/DESCRIPTOR/AUTHORITY") %>% xml_text(),
                            LABEL = inter %>% xml_find_all("/CHECKLIST_SET/CHECKLIST/DESCRIPTOR/LABEL") %>% xml_text(),
                            DESCRIPTION = inter %>% xml_find_all("/CHECKLIST_SET/CHECKLIST/DESCRIPTOR/DESCRIPTION") %>% xml_text())
  )
}


write.table(checklisteTable, "inst/application/data/checklisteTable.tsv", sep = "\t", quote = F, row.names = F)

#===============================================================================
# Complet table
#===============================================================================

extractXmlField <- function(path){
  unlist(lapply(FIELDS , function(x){
    interToTest = x %>%  xml_find_all(path) %>% xml_text()
    if(length(interToTest) == 0){
      return("")
    }else {
      return(paste(interToTest, collapse = "@"))
    }
  }))
}

allCLElements = NULL
for (f in list.files("inst/application/checklists/")){
  cat(f)
  inter = read_xml(paste0("inst/application/checklists/", f))

  # Get FIELDS
  FIELDS =  inter %>% xml_find_all("//FIELD")

  # Extract in table
  inter = cbind.data.frame(
    CHEKLIST = gsub(".xml","", f),
    NAME = extractXmlField(".//NAME"),
    LABEL = extractXmlField(".//LABEL"),
    DESCRIPTION = extractXmlField(".//DESCRIPTION"),
    MANDATORY = extractXmlField(".//MANDATORY"),
    VALUE = unlist(lapply(FIELDS %>%  xml_find_all("FIELD_TYPE") , function(x){
      paste(x %>%  xml_find_all(".//VALUE") %>% xml_text(), collapse = "@")
    })),

    UNIT = unlist(lapply(FIELDS , function(x){
      paste(x %>%  xml_find_all(".//UNIT") %>% xml_text(), collapse = "@")
    })),

    REGEX_VALUE = unlist(lapply(FIELDS %>%  xml_find_all("FIELD_TYPE") , function(x){
      paste(x %>%  xml_find_all(".//REGEX_VALUE") %>% xml_text(), collapse = "@")
    }))
  )

  allCLElements = rbind(allCLElements,
                        inter)
}

write.table(allCLElements,"inst/application/data/allCLElements.tsv", sep = "\t", quote = F, row.names = F)
