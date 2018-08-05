FROM jenkins/jenkins:lts

COPY Dockerfile /opt/Dockerfile-tdd-jenkins-docker
COPY README.md /opt/README-tdd-jenkins-docker.md
