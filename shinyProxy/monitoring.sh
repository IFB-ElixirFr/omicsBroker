#!/bin/bash

### Write monitoring file
sar -P ALL > monitoring.txt

### Remove space and create a tsv file
unexpand -a monitoring.txt > monitoring.tsv

### Run Script R in docker omicsBroker
docker run -it -v ${PWD}:/home/ tdenecker/omicsbroker bash -c "Rscript /home/monitoring.R"
