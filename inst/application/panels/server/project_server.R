# output$dowloadXML_project <- downloadHandler(
#   filename = function() {
#     paste('project-', Sys.Date(), '.xml', sep='')
#   },
#   content = function(con) {
#     doc = newXMLDoc()
#
#     xmlText <-
#       newXMLNode("Submission",
#                  newXMLNode("Description",
#                             newXMLNode("Comment",
#                                        input$project_description),
#                             newXMLNode("Submitter", attrs = c(user_name = input$SubmitterUser_name)),
#                             newXMLNode("Organization", attrs = c(role = input$Organization_role, type = input$Organization_type),
#                                        newXMLNode("Name", input$Organization_name),
#                                        newXMLNode("Contact", attrs = c(email = input$Contact_email),
#                                                   newXMLNode("Name",
#                                                              newXMLNode("First", input$Contact_First),
#                                                              newXMLNode("Last", input$Contact_Last)
#                                                   )
#                                        )
#                             ),
#                             newXMLNode("Hold", attrs = c(release_date = input$release_date))
#                  ),
#                  doc = doc
#       )
#     saveXML(xmlText, con)
#   }
# )







