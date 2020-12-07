################################################################################
# Title : metaBroker - extrator
# Organism : All
# Omics area : Omics
# Users : Thomas Denecker
# Email : thomas.denecker@gmail.com
# Date : nov, 2020
# GitHub :
# DockerHub :
################################################################################

################################################################################
###                                Library                                   ###
################################################################################


library(xml2)
library(dplyr)

################################################################################
###                                 MAIN                                     ###
################################################################################
doc <- read_xml("inst/application/data/SRA.experiment.xsd")
typeLibraryStrategy_name = xml_attr(xml_find_all( doc, "/xs:schema/xs:simpleType[1]/xs:restriction/xs:enumeration"), attr="value" )
typeLibraryStrategy_description = sub("\n          ", "", xml_text( xml_find_all( doc, "/xs:schema/xs:simpleType[1]/xs:restriction/xs:enumeration"   ) ))
write.table(cbind(Name = typeLibraryStrategy_name, Description = typeLibraryStrategy_description), "inst/application/data/typeLibraryStrategy.tsv", quote = F, sep ="\t", row.names = F)
