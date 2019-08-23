FROM jenkins/jenkins:2.176.2

ARG localAdmin

ENV LOCAL_ADMIN=${localAdmin:-admin} \
    LOCAL_PASSWORD=${localAdmin:-admin} \
    JENKINS_VERSION=2.176.2

COPY Dockerfile /opt/Dockerfile-tdd-jenkins-docker
COPY README.md /opt/README-tdd-jenkins-docker.md

COPY init.groovy.d /usr/share/jenkins/ref/init.groovy.d
COPY plugins.txt /usr/share/jenkins/ref/

RUN /usr/local/bin/install-plugins.sh $(cat /usr/share/jenkins/ref/plugins.txt)

RUN  echo -n ${JENKINS_VERSION} > /usr/share/jenkins/ref/jenkins.install.InstallUtil.lastExecVersion
RUN  echo -n ${JENKINS_VERSION} > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
