
observeEvent(input$filesImport,  {

  if(!is.null(input$filesImport)){
    namesFiles = input$filesImport$name
    file.copy(input$filesImport$datapath, paste0("www/tmp/", nameTmpFolder, "/files/",namesFiles))

    for(n in namesFiles ) {
      if (! n %in% appReac$files){
        appReac$files = rbind.data.frame(appReac$files ,
                                         c(name = n,
                                           size = file.size(paste0("www/tmp/", nameTmpFolder, "/files/",n)),
                                           md5Server = md5sum(paste0("www/tmp/", nameTmpFolder, "/files/",n )),
                                           md5sumIn = "",
                                           md5sumCheck = "",
                                           expName = "",
                                           M = 0,
                                           C = 0,
                                           X = 0,
                                           E = 0,
                                           N = 0
                                         )
        )
      }
    }

    colnames(appReac$files) = c("Name",
                                "Size (bytes)",
                                "md5Server",
                                "md5sumIn",
                                "md5sumCheck",
                                "Experience name",
                                "Mandatory",
                                "Conditional mandatory",
                                "Optional",
                                "Environment-dependent",
                                "Not applicable"
                                )
  }
})

output$files = renderRHandsontable({
  if(nrow(appReac$files) != 0 & !is.null(input$dataTable)){
    tmp = rhandsontable(as.data.frame(appReac$files, stringsAsFactors =F) ,
                        selectCallback = TRUE,
                        stretchH = "all") %>%
      hot_cols(colWidths = 250) %>%
      hot_rows(rowHeights = 30) %>%
      hot_cols(fixedColumnsLeft = 1) %>%
      hot_col(col = "Experience name", type = "dropdown", source = appReac$experimentName)  %>%
      hot_col(col = "md5Server", readOnly = T)  %>%
      hot_col(col = "md5sumCheck", readOnly = T)  %>%
      hot_col(7:11, format = "0%")  %>%
      hot_col(col = "md5sumCheck", renderer =
                "function (instance, td, row, col, prop, value, cellProperties) {
              Handsontable.renderers.TextRenderer.apply(this, arguments);
              if (value == 'Check' ) {
                td.style.background = 'green';
                td.style.color = 'white';
                td.style.fontWeight = 'bold';
              } else if (value == 'Fill in an md5sum') {
                td.style.background = 'orange';
                td.style.color = 'black';
                td.style.fontWeight = 'bold';
              } else {
                td.style.background = 'red';
                td.style.color = 'black';
                td.style.fontWeight = 'bold';
              }
            }")

    tmp
  } else {
    NULL
  }

})

observeEvent(input$files, {
  appReac$files = hot_to_r(input$files)
  inter = as.matrix(appReac$dataTable)

  for (i in 1:nrow(appReac$files)){

    # MD5 sum
    if(appReac$files$md5Server[i] == appReac$files$md5sumIn[i] ){
      appReac$files$md5sumCheck[i] = "Check"
    } else if( appReac$files$md5sumIn[i] == ""){
      appReac$files$md5sumCheck[i] = "Fill in an md5sum"
    } else {
      appReac$files$md5sumCheck[i] = "Error"
    }

    # Coverage

    if(appReac$files[i, 6] != ""){
      appReac$files[i, 7:11] = unlist(lapply(c("M", "C", "X", "E", "-"), function(x){
        pos = which(as.character( as.data.frame(appReac$metatableFilter) %>% pull(Requirement)) == x)
        round(sum(as.character(inter[which(inter[,1] == appReac$files[i, 6] ),pos]) != "") / length(pos) * 100, 2)
      }))

    } else {
      appReac$files[i, 7:11] = 0
    }


  }

})
