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

#### Post installation

If everything is configured (you've created the volume and installed jenkins), you can use this command to run the container :

    $ docker-compose up

## Overview

Our code structure is as follow :

```
jenkins-docker-ci-cd
│
└─── web-app
└─── jenkins
└─── Dockerfile
└─── docker-compose.yml
```

- web-app : This is a Java web application. We will use its source code to build a docker container (of the app) and deploy it on the deploy machine.
- jenkins : This directory will contain the scripts to build, test, push and deploy the web application.
- Dockerfile : This is the jenkins docker file (used to build our jenkins-docker image).
- docker-compose.yml : This file will be used to run the jenkins container.

This is ou ci/cd workflow.

![Flow](https://user-images.githubusercontent.com/16627692/77823028-43ce1100-70f8-11ea-9118-0dfd647827a4.png)

## Run/Stop the app

To start the docker environment, run this command :

    $ docker-compose up --build

Well, the first time you run this command you have to wait about 10 minutes to setup the database :

Wait for these logs :

```log
mysql       | 2020-02-04T15:40:39.855273Z 0 [Warning] CA certificate ca.pem is self signed.
mysql       | 2020-02-04T15:40:40.206740Z 1 [Warning] root@localhost is created with an empty password ! Please consider switching off the --initialize-insecure option.
|
|
|
mysql       | 2020-02-04T15:31:25.379440Z 0 [Note] mysqld: ready for connections.
|
|
mysql       | 2020-02-04 15:31:43+00:00 [Note] [Entrypoint]: Creating database db
mysql       | 2020-02-04 15:31:43+00:00 [Note] [Entrypoint]: Creating user user
mysql       | 2020-02-04 15:31:43+00:00 [Note] [Entrypoint]: Giving user user access to schema db
mysql       | 2020-02-04 15:31:43+00:00 [Note] [Entrypoint]: /usr/local/bin/docker-entrypoint.sh: running /docker-entrypoint-initdb.d/schema.sql
|
|
|
mysql       | 2020-02-04 15:43:21+00:00 [Note] [Entrypoint]: Database files initialized
mysql       | 2020-02-04 15:43:21+00:00 [Note] [Entrypoint]: Starting temporary server
mysql       | 2020-02-04 15:43:21+00:00 [Note] [Entrypoint]: Waiting for server startup
|
|
mysql       | 2020-02-04T15:43:55.339162Z 0 [Note] mysqld: ready for connections.
mysql       | Version: '5.7.28'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server (GPL)
```

As we can see the database is ready now for connections.

To check the database status, use adminer to connect to it :

![adminer](https://user-images.githubusercontent.com/16627692/73834477-16f23180-480c-11ea-9d00-a11b76f10801.png)

The password is : password

To stop the app you can simply run this command :

    $ docker-compose down

Each time you change the project dependencies or the schema.sql file you have to delete the app volumes and rerun the app :

    $ docker-compose down
    $ docker-compose rm
    $ docker volume prune

## Simple Test

In this section we will show you how the app works by making a registration scenario.

Check the database content (USERS and TOKENS tables) before continuing :

![adminer_add_user](https://user-images.githubusercontent.com/16627692/73835712-2bcfc480-480e-11ea-9437-01e5f7029b63.jpg)

![adminer_add_token](https://user-images.githubusercontent.com/16627692/73835628-017e0700-480e-11ea-9062-2a8ac3c6d7c7.png)

Go to the registration page and create a new account :

- [http://localhost:3000/signup](http://localhost:3000/signup)

![signup](https://user-images.githubusercontent.com/16627692/73835246-5ec58880-480d-11ea-8e85-dcf996676300.jpg)

![after_signup](https://user-images.githubusercontent.com/16627692/73835504-c5e33d00-480d-11ea-9491-b442efabbaa3.png)

Now check your email address, you will find a new message :

![confirmation_email](https://user-images.githubusercontent.com/16627692/73835768-44d87580-480e-11ea-9409-73fb9973afe1.png)

Copy/paste the link in your browser and click enter. The verification process will be triggered anf if every thing is OK you will be redirected
to the login page :

![login](https://user-images.githubusercontent.com/16627692/73836063-c6300800-480e-11ea-87dc-f183eaeccb1f.png)

Check the database and you'll find that your account has beed verified :

![adminer_add_token_after](https://user-images.githubusercontent.com/16627692/73836178-faa3c400-480e-11ea-89f2-9d55d909b0d4.png)

The token confirmation data has been updated and the request host and user agent also.

![adminer_add_user_after](https://user-images.githubusercontent.com/16627692/73836308-3b034200-480f-11ea-905f-ba90cb049132.jpg)

And the user account has been confirmed.

Now we can access the app via the login page :

- [http://localhost:3000/login](http://localhost:3000/login)

![dashboard](https://user-images.githubusercontent.com/16627692/73836400-74d44880-480f-11ea-883f-c799c5006cfb.png)

`PN` : If you will make examples on the net using this code, make sure to not commit your send grid api key or just delete it when you finish.

## Authors

- Mohamed Ali AMDOUNI
