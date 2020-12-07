output$dataTable_adminPackages = renderRHandsontable({
  rhandsontable(packagesItems,  stretchH = "all") %>%
    hot_cols(colWidths = 250) %>%
    hot_rows(rowHeights = 30)
})
