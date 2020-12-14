output$dataTable_adminMetadata = renderRHandsontable({
  rhandsontable(allCLElements,  stretchH = "all") %>%
    hot_cols(colWidths = 250) %>%
    hot_rows(rowHeights = 30) %>%
    hot_col(col = "MANDATORY",
            type = "dropdown",
            source = c("mandatory", "optional", "recommended"),
            strict = FALSE)
})


