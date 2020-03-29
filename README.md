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
|    |
|    └─── test
|    |    └─── mvn.sh
|    |
|    └─── push
|    |    └─── push.sh
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

#### The Test stage

In this stage we will run the tests of our java application.

- jenkins/test/mvn.sh : In this script we will use a maven container to copy the source code of our application to it and run tests.

#### The Push stage

In this stage we will push the docker image create in the build stage to the docker hub. We've already created a docker hub repo in the `Create a new docker hub repository` section.

- jenkins/push/push.sh : In this script we will logging into my docker hub account (via command line), tag the already created image so it can be pushed to docker hub (adding my docker id to the image) and push it to docker hub.

To run this stage you have to pass your docker hub password to the script so you can log into your docker account. If you have a look at the script you'll notice the \$DOCKER_PASS variable. As this script will be launched by jenkins we'll add this variable to jenkins as a credential.

1. Click the Credentials link in the sidebar.
2. Click on the Global credentials domain.
3. Click [Add Credentials] (in the sidebar).
4. Select `Secret text` from the Kind menu, type your password and type `registry-pass` in the ID are.
5. Click OK.

![credentials-pixlr](https://user-images.githubusercontent.com/16627692/77830649-42b5d780-712a-11ea-932b-9b2350c6fdfd.jpg)

Check the Jenkinsfile to know how to pass this credential to the script.

#### The Deploy stage

##### Install the deploy machine

We will deploy our code on an another machine. We will call it the deployment or the deploy machine. If you have already an another machine (physical or virtual) and you have an ssh access you can use it.
In my case i will use an amazon virtual machine. If you don't have an amazon account you can create a new one. You'll have a one year free access.

To create an amazon ec2 instance and log into it using ssh, you can follow these examples :

- [https://www.youtube.com/watch?v=PrkEulPOV4s](https://www.youtube.com/watch?v=PrkEulPOV4s)

- [https://docs.aws.amazon.com/efs/latest/ug/gs-step-one-create-ec2-resources.html](https://docs.aws.amazon.com/efs/latest/ug/gs-step-one-create-ec2-resources.html)

##### Create the prod user

Now we gonna create a new use on this user and we will call it prod-user. This is the responsible to deploy our application (to avoid using the root user).

1. connect to machine (as root) using the downloaded key

```sh
$ ssh -i "aws-vm-key.pem" ec2-user@ec2-3-17-81-229.us-east-2.compute.amazonaws.com
```

- aws-vm-key.pem : is the key generated by amazon and downloaded in the last step
- ec2-3-17-81-229.us-east-2.compute.amazonaws.com : is the ip of my virtual machine

If you are using Windows as OS, you can download [Putty](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) to connect to the machine.

2. create a new user

```sh
$ sudo useradd prod-user
```

Add him to the docker group :

```sh
sudo usermod -aG docker prod-user
```

3. Now we gonna create an ssh key

This is gonna be the link of communication between jenkins and the deploy machine. But Why ?

In the deploy stage, we gonna access the deploy machine from the jenkins machine (using ssh) and run a shell script. This script will use docker commands to download the new image of our application and deploy it.

3.1. connect to the jenkins container

```sh
$ docker exec -it jenkins bash
```

3.2. go to the tmp directory

```sh
$ cd /tmp
```

3.3. generate a new key (use prod as file name) and skip questions by clicking on enter

```sh
$ ssh-keygen -f prod
```

You should have two files like this :

```sh
$ ls -ltr | grep prod
```

```log
-rw-r--r-- 1 jenkins jenkins     402 Mar 29 10:43 prod.pub
-rw------- 1 jenkins jenkins    1679 Mar 29 10:43 prod
```

4. add the public key to deploy machine

4.1. copy the content of the prod.pub file

4.2. connect to the deploy machine and run these commands to add the key

```sh
$ sudo su
$ su prod-user
$ cd /home/prod-user/
$ mkdir .ssh
$ chmod 700 .ssh
$ vi .ssh/authorized_keys
```

Paste the content of the prod.pub file (remove the last part of the jenkins@XXXXXXXXXXXXX)

```sh
$ chmod 400 .ssh/authorized_keys
```

4.3. Logout from the machine

```sh
$ exit
```

5. add the private key to the jenkins machine

copy the content of the prod file and paste it in `jenkins/deploy/aws-vm-prod-user.pem` (you can remove the existing key)

We can use an another method. The jenkins remote access method. We can add an ssh connection directly in jenkins so he can access and execute ssh scripts directly.

##### The Deploy scripts

In this stage we gonna use two scripts to deploy our application.

- jenkins/deploy/deploy.sh : As the deploy machine didn't have the image to deploy and its tag, we will copy (jenkins) these data to a temp file `/tmp/.auth`. This file will contain the image (and the tag) to deploy and the docker password to pull the image (because the repo is private). Then, we gonna transfer this file to the deploy machine. Finally, we gonna transfer an another script the `publish.sh` to the deploy and execute it.

- jenkins/deploy/publish.sh : In this script we will extract the image (to deploy) properties from `/tmp/.auth` and run it.

## Authors

- Mohamed Ali AMDOUNI
