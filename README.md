# jenkins-docker-ci-cd

In this repository, we will explain how to use jenkins to implement a continuous integration/continuous deployment (CI/CD) pipeline into your codebase. I’ll walk through the demo code and steps that I used to implement CI/CD pipelines into my code base.
We will not use cloud services like kubernetes or elastic-beanstalk in this example. To communicate two services, we will use technologies like
file transfer, ssh connections ...

This example is based on the last section of the jenkins-from-zero-to-hero tutorial that you can find here :

[https://www.udemy.com/course/jenkins-from-zero-to-hero/](https://www.udemy.com/course/jenkins-from-zero-to-hero/)

To implement this solution we have used these technologies :

- [Jenkins](https://jenkins.io/) - Jenkins is an open source automation server which enables developers around the world to reliably build, test, and deploy their software.
- [docker](https://www.docker.com/) - Docker is a set of platform as a service (PaaS) products that uses OS-level virtualization to deliver software in packages called containers.

## Development prerequisites

for development, you will need to install :

### Docker

In order to run this application as a container you'll need docker installed.

- [Windows](https://docs.docker.com/windows/started)
- [OS X](https://docs.docker.com/mac/started/)
- [Linux](https://docs.docker.com/linux/started/)

## Install

### Clone repository

Checkout the project :

    $ git clone https://github.com/amdouni-mohamed-ali/jenkins-docker-ci-cd.git

### Run jenkins container

#### First installation

If this is the first time you run the jenkins container, please run this command line :

    $ mkdir jenkins_home

This directory holds the jenkins data. It's gonna be a docker volume (run this command only the first time).
Now you can run this command :

    $ docker-compose up --build

Wait for these log lines (the first time you run the container a password will be show) :

```log
jenkins    | *************************************************************
jenkins    | *************************************************************
jenkins    | *************************************************************
jenkins    |
jenkins    | Jenkins initial setup is required. An admin user has been created and a password generated.
jenkins    | Please use the following password to proceed to installation:
jenkins    |
jenkins    | 5adc356bec7d444ba0bd39f9d98b69a0
jenkins    |
jenkins    | This may also be found at: /var/jenkins_home/secrets/initialAdminPassword
jenkins    |
jenkins    | *************************************************************
jenkins    | *************************************************************
jenkins    | *************************************************************

jenkins    | 2020-03-28 13:00:03.681+0000 [id=21]	INFO	hudson.WebAppMain$3#run: Jenkins is fully up and running
```

Now you can access to jenkins via this link :

[http://localhost:8080](http://localhost:8080)

The first time, jenkins will ask you for the password show in the logs (5adc356bec7d444ba0bd39f9d98b69a0). Type it and install the suggested plugins (make sure that the pipeline plugin has been successfully installed). The last thing is to create an admin user and introduce a password. In my case, i'm using jenkins/password as login/password.

![localhost](https://user-images.githubusercontent.com/16627692/77825699-5aca2e80-710b-11ea-9bfe-ed16bb4dcce4.png)

The second time you run this container, you can use this command (to skip all configurations steps above) :

    $ docker-compose up

#### Create the pipeline project

From the jenkins GUI, create a new pipeline project :

1. New Item
2. The name of the job will be pipeline-jenkins-docker-ci-cd
3. choose pipeline from the projects template
4. click on OK
5. From the pipeline section :

   5.1. Choose `Pipeline script from scm` From the Definition combo box

   5.2. Choose `Git` from the SCM combo box

   5.2.1. In the `Repository URL` section, type the url of your repository. In my case it will be this repository (https://github.com/amdouni-mohamed-ali/jenkins-docker-ci-cd.git)

   5.2.2 If your repository is private. From the `Credentials`, add a new credentials (your github login/password) so git can download the source code.

6. Make sure that the jenkins file name in the `Script Path` section is Jenkinsfile.

7. Click on save

![pipeline](https://user-images.githubusercontent.com/16627692/77826826-1c843d80-7112-11ea-8b58-9dda1b6a7213.png)

Now you have to modify the WORKSPACE variable located in the `jenkins/build/mvn.sh` file. The workspace must be the jenkins
workspace located in the jenkins_home/workspace/pipeline-jenkins-docker-ci-cd directory.

#### Create a new docker hub repository

In our ci/cd workflow, we will push the web app docker image to the docker hub repository. Then we will deploy this image from the deploy machine. For this reason you have to :

1. create a docker hub account if you don't have one
2. create a new repository (i named it jenkins-docker-ci-cd in my case). It can be private or public it's up to you (private in my case).

![docker-hub-repo](https://user-images.githubusercontent.com/16627692/77828353-2b232280-711b-11ea-81cf-e818bf2cc477.png)

## Overview

### Code structure

Our code structure is as follow :

```
jenkins-docker-ci-cd
│
└─── web-app
|
└─── jenkins
|    └─── build
|    |    └─── build.sh
|    |    └─── docker-compose-build.yml
|    |    └─── Dockerfile-Java
|    |    └─── mvn.sh
|
└─── Dockerfile
└─── docker-compose.yml
└─── Jenkinsfile
```

- web-app : This is a Java web application. We will use its source code to build a docker container (of the app) and deploy it on the deploy machine.
- jenkins : This directory will contain the scripts to build, test, push and deploy the web application.
- Dockerfile : This is the jenkins docker file (used to build our jenkins-docker image).
- docker-compose.yml : This file will be used to run the jenkins container.
- Jenkinsfile : this is the jenkins file that contains our workflow (scripts to run in each stage).

### CI/CD workflow

This is our ci/cd workflow.

![Flow](https://user-images.githubusercontent.com/16627692/77823028-43ce1100-70f8-11ea-9118-0dfd647827a4.png)

#### The Build stage

In this stage we will build our jar file using a maven command (mvn clean package : a maven command to build a java application) and then we gonna build a java docker image using the generated jar. To do this we gonna use two scripts :

- jenkins/build/mvn.sh : If you check the Jenkinsfile, you'll find that the first script to run in this stage is
  `./jenkins/build/mvn.sh mvn -B -DskipTests clean package`. This script will copy
  the web-app directory (the java code) into a maven container and build the code (using mvn -B -DskipTests clean package).

- jenkins/build/build.sh : This script will copy the generated jar file (from web-app/target) into the build directory. Then, it's gonna build a java docker image and move the jar file to it.

## Authors

- Mohamed Ali AMDOUNI
