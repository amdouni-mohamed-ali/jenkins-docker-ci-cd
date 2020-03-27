# Web Application

This is a simple example of how to use spring to build a web application.

## Prerequisites

To create your development environment, you will need to :

- install java 8 (or above)
- install maven
- install git to clone the project
- you favorite IDE (i'm using intellij) 

## Installing

To clone the project, run this command :

```bash
$ git clone https://github.com/amdouni-mohamed-ali/jenkins-docker-ci-cd.git
$ cd jenkins-docker-ci-cd/web-app
```

And run this command to package the project and run test :

```
    $ mvn clean package
```

If everything turns out alright, you should end up with this result :

```log
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 1.498 s - in com.example.webapp.WebAppApplicationTests
2020-03-27 19:20:20.073  INFO 26758 --- [extShutdownHook] o.s.s.concurrent.ThreadPoolTaskExecutor  : Shutting down ExecutorService 'applicationTaskExecutor'
[INFO] 
[INFO] Results:
[INFO] 
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
[INFO] 
[INFO] 
[INFO] --- maven-jar-plugin:3.1.2:jar (default-jar) @ web-app ---
[INFO] Building jar: /home/salto/tutorials/jenkins/jenkins-pipeline-github/web-app/target/web-app-0.0.1-SNAPSHOT.jar
[INFO] 
[INFO] --- spring-boot-maven-plugin:2.2.6.RELEASE:repackage (repackage) @ web-app ---
[INFO] Replacing main artifact with repackaged archive
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  8.685 s
[INFO] Finished at: 2020-03-27T19:20:21+01:00
[INFO] ------------------------------------------------------------------------
```

## Overview

In this example we will create a simple spring web application.

You can run the app using this command :

```shell script
$ cd target && java -jar web-app-0.0.1-SNAPSHOT.jar
```

You can now access the web app via this link :

[http://localhost:8070](http://localhost:8070)

![jenkins](https://user-images.githubusercontent.com/16627692/77787985-c1464280-7060-11ea-97dd-b14a3ba916cf.png)

## Built With

* Java - oracle jdk "1.8.0_101"
* [Maven](https://maven.apache.org/) - Dependency Management (version 3.6.0)
* [Intellij](https://www.jetbrains.com/) - IDE (version 2019.3.4)
* [Spring Boot](https://spring.io/projects/spring-boot) - (v2.2.6.RELEASE)

