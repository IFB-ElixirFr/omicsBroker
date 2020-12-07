
output$dataTable_adminProjects = renderRHandsontable({

  DF = data.frame(Title = c("Etude de l'impact du changement de concentration en fer chez la levure C. glabrata",
                            "Etude de l'impact de l'utilisation de milieux enrichis en C12 chez C. albicans",
                            "Evolution des séquences de la COVID"),
                  Alias = c("Toto", "Titi", "Tata"),
                  Description = c("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet,
                                  adipiscing nec, ultricies sed, dolor. Cras elementum ultrices diam. Maecenas ligula massa, varius a, semper congue, euismod
                                  non, mi. Proin porttitor, orci nec nonummy molestie, enim est eleifend mi, non fermentum diam nisl sit amet erat. Duis semper.
                                  Duis arcu massa, scelerisque vitae, consequat in, pretium a, enim. Pellentesque congue. Ut in risus volutpat libero pharetra tempor.
                                  Cras vestibulum bibendum augue. Praesent egestas leo in pede. Praesent blandit odio eu enim. Pellentesque sed dui ut augue blandit sodales.
                                  Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Aliquam nibh. Mauris ac mauris sed pede pellentesque
                                  fermentum. Maecenas adipiscing ante non diam sodales hendrerit.",
                                  "Ut velit mauris, egestas sed, gravida nec, ornare ut, mi. Aenean ut orci vel massa suscipit pulvinar. Nulla sollicitudin. Fusce varius,
                                  ligula non tempus aliquam, nunc turpis ullamcorper nibh, in tempus sapien eros vitae ligula. Pellentesque rhoncus nunc et augue. Integer id felis.
                                  Curabitur aliquet pellentesque diam. Integer quis metus vitae elit lobortis egestas. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.
                                  Morbi vel erat non mauris convallis vehicula. Nulla et sapien. Integer tortor tellus, aliquam faucibus, convallis id, congue eu, quam. Mauris
                                  ullamcorper felis vitae erat. Proin feugiat, augue non elementum posuere, metus purus iaculis lectus, et tristique ligula justo vitae magna.",
                                  "liquam convallis sollicitudin purus. Praesent aliquam, enim at fermentum mollis, ligula massa adipiscing nisl, ac euismod nibh nisl eu lectus.
                                  Fusce vulputate sem at sapien. Vivamus leo. Aliquam euismod libero eu enim. Nulla nec felis sed leo placerat imperdiet. Aenean suscipit nulla in justo.
                                  Suspendisse cursus rutrum augue. Nulla tincidunt tincidunt mi. Curabitur iaculis, lorem vel rhoncus faucibus, felis magna fermentum augue, et ultricies
                                  lacus lorem varius purus. Curabitur eu amet."),


                  Files = c("Fichier1_R1.fastq.gz\nFichier1_R2.fastq.gz\nFichier2_R1.fastq.gz\nFichier2_R2.fastq.gz",
                            "Fichier1_R1.fastq.gz\nFichier1_R2.fastq.gz",
                            "Fichier2_R1.fastq.gz\nFichier2_R2.fastq.gz"),

                  LastUpdate = seq(from = Sys.Date(), by = "days", length.out = 3),
                  Status = c("In progress",
                             "Ready to publish",
                             "In progress"),
                  Load = c('<a class="btn btn-primary" href="#" role="button">Load</a>',
                           '<a class="btn btn-primary" href="#" role="button">Load</a>',
                           '<a class="btn btn-primary" href="#" role="button">Load</a>'),
                  stringsAsFactors = FALSE)


  rhandsontable(DF,  stretchH = "all") %>%
    hot_cols(colWidths = 250) %>%
    hot_rows(rowHeights = 30) %>%
    hot_col("Load", renderer = "html") %>%
    hot_col("Load", renderer = htmlwidgets::JS("safeHtmlRenderer")) %>%
    hot_col("Load", readOnly = TRUE)
})
