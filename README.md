# tdd-jenkins-docker
Working out what I need to do to configure serverspec and develop init-groovy.d scripts for jenkins docker

# Assumptions
* the version of ruby, gem and serverspec are find for what I want to do
* the version of docker will work for me.
* will pull down the latest jenkins/jenkins:lts docker as the base for this work


# Unknowns
* how to configure the project so that bundle exec rake spec will run all the tests


# Decisions
* Dockerfile will be a the top level of the project
* Use a Gemfile to specify the required gems so that others don't need to know which gems to require.
  - the Gemfile is used by bundler to grab the required gems. Execute `bundle install` in the directory with the Gemfile everytime you change the Gemfile contents.
