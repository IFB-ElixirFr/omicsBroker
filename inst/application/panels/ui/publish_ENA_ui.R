publish_ENA <- fluidPage(
  h1("Publish in ENA"),
  helpText("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus.
           Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies
           sed, dolor. Cras elementum ultrices diam. Maecenas ligula massa, varius a,
           semper congue, euismod non, mi. Proin porttitor, orci nec nonummy molestie,
           enim est eleifend mi, non fermentum diam nisl sit amet erat. Duis semper. Duis
           arcu massa, scelerisque vitae, consequat in, pretium a, enim. Pellentesque congue.
           Ut in risus volutpat libero pharetra tempor. Cras vestibulum bibendum augue.
           Praesent egestas leo in pede. Praesent blandit odio eu enim. Pellentesque sed
           dui ut augue blandit sodales. Vestibulum ante ipsum primis in faucibus orci
           luctus et ultrices posuere cubilia Curae; Aliquam nibh. Mauris ac mauris
           sed pede pellentesque fermentum. Maecenas adipiscing ante non diam sodales
           hendrerit. ", style = "text-align: justify;"),

  h2("Step 1 - Create ENA account"),
  p("The first step in making a submission on the ENA is to create a submission account in 'Webin Submissions Portal'.
    To do so, you will need to create an account at the following address: ",
    a("https://www.ebi.ac.uk/ena/submit/webin/", "Production service"), "or",
    a("https://wwwdev.ebi.ac.uk/ena/submit/webin/","Test service" ),
    " .Detailed documentation can be found at : ",
    a("https://ena-docs.readthedocs.io/en/latest/submit/general-guide/submissions-portal.html")),

  h2("Step 2 - Fill in your identifiers "),
  helpText("Once your account is created, you have a login and a password.
           Both will be required to submit on the ENA. You must fill them in below"),
  textInput("userID_ENA", label = HTML(paste("Webin submission account", span(style="color:red", "*")))),
  passwordInput("pwID_ENA", label= HTML(paste("Password", span(style="color:red", "*")))),

  h2("Step 3 - Publish ! "),
  helpText("It's time to submit on the ENA. A set of checks will be performed to
           ensure that no information is missing and that the submission is completed correctly.
           Alerts will be sent to you to guide you in case of problems."),
  actionButton("publishBtn_ENA", label = "Publish", icon = icon("upload")),

  h2("The different files generated"),
  helpText("In this section, you can download separately the different files
           needed for the submission."),

  actionButton("dowloadXML_projectSet_init", "Generate project set XML", icon = icon("download"), style = "width:200px;color: #444 !important; margin : 0px 15px;"),
  actionButton("dowloadXML_experiment_init", "Generate experiment XML", icon = icon("download"), style = "width:200px;color: #444 !important; margin : 0px 15px;"),
  actionButton("dowloadXML_samples_init", "Generate samples XML", icon = icon("download"), style = "width:200px;color: #444 !important; margin : 0px 15px;"),
  actionButton("dowloadXML_run_init", "Generate run XML", icon = icon("download"), style = "width:200px;color: #444 !important; margin : 0px 15px;"),
  actionButton("dowloadXML_submission_init", "Generate submission XML", icon = icon("download"), style = "width:200px;color: #444 !important; margin : 0px 15px;"),

  downloadButton("dowloadXML_projectSet", "Generate project set XML", style = "visibility: hidden; margin : 0; width:0px ; height:0px ; padding:0; border: 0px; "),
  downloadButton("dowloadXML_experiment", "Generate experiment XML", style = "visibility: hidden; margin : 0; width:0px ; height:0px ; padding:0; border: 0px; "),
  downloadButton("dowloadXML_samples", "Generate samples set XML", style = "visibility: hidden; margin : 0; width:0px ; height:0px ; padding:0; border: 0px; "),
  downloadButton("dowloadXML_run", "Generate run XML", style = "visibility: hidden; margin : 0; width:0px ; height:0px ; padding:0; border: 0px;"),
  downloadButton("dowloadXML_submission", "Generate submission XML", style = "visibility: hidden; margin : 0; width:0px ; height:0px ; padding:0; border: 0px;"),

)
