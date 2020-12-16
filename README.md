<p align="center"><img src="./inst/application/www/img/logo.svg" alt="logo" height="150px"></p>

------

omicsBroker is a tool to easily annotate and publish omics data to ENA (EBI database).

## omicsBroker & Docker
The omicsBroker application was developed with Docker and the image containing R and all necessary libraries is available online ([here](https://hub.docker.com/repository/docker/tdenecker/omicsbroker)).
Using omicsBroker by this method guarantees reproducibility of the analyses.

### Requirements

We use Docker to develop and manage omicsBroker. We invite you to verify that the
following requirements are correctly satisfied before trying to bootstrap the
application:

* [Docker 1.12.6+](https://docs.docker.com/engine/installation/)

> We recommend you to follow Docker's official documentations to install
required docker tools (see links above).To help you, explanatory videos for each
operating system are available [here](https://www.bretfisher.com/installdocker/)

**Docker must be on for the duration of omicsBroker use.**

### Quick start

Have you read the "Requirements" section above?

#### Run application

**Reminder** : Docker must always be switched on for any installation and use of omicsBroker !

##### Step 1 : Open a terminal 

- [Windows](https://youtu.be/uE9WgNr3OjM)
- [mac OSX](https://www.youtube.com/watch?v=QROX039ckO8)
- [Linux](https://linuxconfig.org/how-to-open-a-terminal-on-ubuntu-bionic-beaver-18-04-linux)

##### Step 2 : Run application

``` bash
docker run --rm -p 3838:3838 --name omicsBroker tdenecker/omicsbroker
```

**Note** On linux, it may be necessary to use sudo (`sudo docker run --rm -p 3838:3838 --name omicsBroker tdenecker/omicsbroker`)

## omicsBroker & R

omicsBroker is available as an R package. You can install it as follows: 

``` R
# install.packages('devtools', repos='https://cran.rstudio.com/', dependencies = TRUE)

library(devtools)
install_github('IFB-ElixirFr/omicsBroker')

omicsBroker::shiny_application(port = 3838, host = '0.0.0.0')
```

**Warning** : The packages may be different from those used during the development of the application. This method does not guarantee reproducibility.

## omicsBroker & ShinyProxy

The limitation of the previous approaches is that the launch of the Shiny application is only done on a CPU. When several users are connected, performance drops sharply. One solution is to use [Shinyproxy](https://www.shinyproxy.io/).

Shinyproxy is a java application that allows to deploy Shiny applications without any limit, either in number of applications or in number of users. The only limit is the resources you have at your disposal to run this service (CPU and RAM).

When the user connects to the Shinyproxy set up, the user chooses the application among the available Shiny applications. A container docker of the application is then launched and the user is redirected to the application.

This approach has been tested in an [ubuntu 20.04 VM](https://biosphere.france-bioinformatique.fr/catalogue/appliance/173/) in the [IFB cloud](https://www.france-bioinformatique.fr/cloud-ifb/).

### Download configuration files

``` bash
mkdir shinyProxy
cd shinyProxy/

wget https://raw.githubusercontent.com/IFB-ElixirFr/omicsBroker/main/shinyProxy/Dockerfile
wget https://raw.githubusercontent.com/IFB-ElixirFr/omicsBroker/main/shinyProxy/application.yml
```

### Build docker network

``` bash
docker network create sp-network
```

### Build docker Shinyproxy image

``` bash
docker build -t shinyproxy .
```

### Import omicsBroker image

``` bash
docker pull tdenecker/omicsbroker
```

### Run omicsBroker

``` bash
sudo docker run -d -v /var/run/docker.sock:/var/run/docker.sock --net sp-network -p 443:80 shinyproxy
```

**WARNING** : The open port of the IFB cloud VMs is port 443 (which you can find in this part of command line `-p 443:80`). This port can change depending on the deployment location.

### Open application

If this method has been used in the IFB cloud VMs, Shiny proxi is available at https://XXX.XXX.XXX.XXX:443 where XXX.XXX.XXX.XXX is the IP address of the VM.

## Development

### Debug

During development or if server crashes (gray screen), you will probably need to get all messages (errors, warnings and notifications) in the R terminal.

Does the problem persist? Post an [Issues](https://github.com/IFB-ElixirFr/omicsBroker/issues) and we will try to find a solution!

### Test modifications in Docker environnement

``` bash
docker run -it -p 3838:3838 -v ABSOLUTE_PATH_TO_omicsBroker_FOLDER/inst/application:/home/ tdenecker/omicsbroker bash -c "R -e \"shiny::runApp('/home/', host='0.0.0.0', port=3838)\""
```

### Connect to a R session

``` bash
docker run -ti --rm tdenecker/omicsbroker R
```

**Warning**: nothing is saved in this session (package installation, ...)

## Documentation

The application comes with a wiki to help you best when using it. It is available [here](https://github.com/IFB-ElixirFr/omicsBroker/wiki). This wiki is currently being written.

## Citation
If you use omicsBroker project, please cite us :

IFB-ElixirFr , **omicsBroker**, (2020), GitHub repository, https://github.com/IFB-ElixirFr/omicsBroker

## Contributors

- Thomas Denecker (ORCID [0000-0003-1421-7641](https://orcid.org/0000-0003-1421-7641))
- Hélène Chiapello (ORCID [0000-0001-5102-0632](https://orcid.org/0000-0001-5102-0632))
- Jacques van Helden (ORCID [0000-0002-8799-8584](https://orcid.org/0000-0002-8799-8584))

## Ressources & Documentations 

- Genomic Standards Consortium : [MIxS Checklist v5.0](http://press3.mcs.anl.gov/gensc/files/2020/02/mixs_v5.xlsx) and [GitHub](https://github.com/GenomicsStandardsConsortium/mixs-legacy/blob/master/mixs5/mixs_v5.xlsx)
- ENA submission : [ENA: Guidelines and Tutorials](https://ena-docs.readthedocs.io/en/latest/index.html)

## Contributing

Please, see the [CONTRIBUTING](CONTRIBUTING.md) file.

## Contributor Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](http://contributor-covenant.org/). By participating in this project you
agree to abide by its terms. See [CODE_OF_CONDUCT](CODE_OF_CONDUCT.md) file.

## License

omicsBroker is released under the BSD-3 License. See the bundled [LICENSE](LICENSE)
file for details.
