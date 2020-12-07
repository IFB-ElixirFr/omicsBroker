output$dataTable_adminMetadata = renderRHandsontable({
  rhandsontable(metatable,  stretchH = "all") %>%
    hot_cols(colWidths = 250) %>%
    hot_rows(rowHeights = 30) %>%
    hot_col(col = c("migs_eu",	"migs_ba",	"migs_pl",	"migs_vi",	"migs_org",
                    "me",	 "mimarks_s",	"mimarks_c",	"misag",	"mimag",
                    "miuvig"),
            type = "dropdown",
            source = c("M", "C", "X", "E", "-"),
            strict = FALSE)
})


