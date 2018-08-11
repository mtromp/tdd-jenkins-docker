# tdd-jenkins-docker
Working out what I need to do to configure serverspec and develop init-groovy.d scripts for jenkins docker

## Assumptions
* the version of ruby, gem and serverspec are find for what I want to do
* the version of docker will work for me.
* will pull down the latest jenkins/jenkins:lts docker as the base for this work


## Unknowns
* how to configure the project so that bundle exec rake spec will run all the tests


## Decisions
* Dockerfile will be a the top level of the project
* Use a Gemfile to specify the required gems so that others don't need to know which gems to require.
  - the Gemfile is used by bundler to grab the required gems. Execute `bundle install` in the directory with the Gemfile everytime you change the Gemfile contents.
* Base this docker on the current lts release of jenkins/jenkins from dockerhub

### create spec directory and files
The tests will be in the spec directory.

## The first test
commit: "verify Dockerfile exists in docker"
* The docker must have a copy of the Dockerfile inside and located in /opt
* The name of the Dockerfile inside the docker should include the name of this project
  - `/opt/Dockerfile-tdd-jenkins-docker`

This first test can simply be run with `bundle exec rspec`

## The second test
commit: "verify README.md exists in docker"
* The docker must have a copy of the README.md inside and located in /opt
* The name of the README.md inside the docker should include the name of this project
  - `/opt/README-tdd-jenkins-docker.md`

## The third test
commit: "verify that init.groovy.d file is moved"
- files in init.groovy.d will be copied inside the docker to /usr/share/jenkins/ref/init.groovy.d
- prime the directory with `no-setup-wizard.groovy`
The challenge for this test was that the Dockerfile COPY directive for a directory
will error if the local directory is empty. I needed to include an empty file in order
for the docker build command to work.

## The fourth test
- the running container will have `no-setup-wizard.groovy` in ${JENKINS_HOME}/init.groovy.d
- simplified and learned how to write better tests.
