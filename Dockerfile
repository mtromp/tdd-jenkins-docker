FROM jenkins/jenkins:2.176.2

ARG localAdmin

ENV LOCAL_ADMIN=${localAdmin:-admin}

COPY Dockerfile /opt/Dockerfile-tdd-jenkins-docker
COPY README.md /opt/README-tdd-jenkins-docker.md

COPY init.groovy.d /usr/share/jenkins/ref/init.groovy.d
COPY plugins.txt /usr/share/jenkins/ref/

RUN /usr/local/bin/install-plugins.sh $(cat /usr/share/jenkins/ref/plugins.txt)
