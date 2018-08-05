require "serverspec"
require "docker"

JENKINS_HOME='/var/jenkins_home'

describe "Dockerfile" do
  before(:all) do
    @image = Docker::Image.build_from_dir('.')

    set :os, family: :debian
    set :backend, :docker
    set :docker_image, @image.id
    # override the entry point in the jenkins/jenkins:lts docker
    set :docker_container_create_options, { 'Entrypoint' => ['bash'] }
  end

  context 'Verifies that Dockerfile-tdd-jenkins-docker is in /opt' do
      it 'Dockerfile-tdd-jenkins-docker exists in opt' do
          expect(file('/opt/Dockerfile-tdd-jenkins-docker')).to exist
      end
  end
  context 'Verifies that README-tdd-jenkins-docker.md is in /opt' do
      it 'README-tdd-jenkins-docker.md exists in opt' do
          expect(file('/opt/README-tdd-jenkins-docker.md')).to exist
      end
  end
  context 'Verifies that no-setup-wizard.groovy is in /usr/share/jenkins/ref/init.groovy.d' do
      it 'no-setup-wizard.groovy exists in /usr/share/jenkins/ref/init.groovy.d' do
          expect(file('/usr/share/jenkins/ref/init.groovy.d/no-setup-wizard.groovy')).to exist
      end
  end
end

describe "RunningDockerfile" do
  before(:all) do
    @image = Docker::Image.build_from_dir('.')

    set :os, family: :debian
    set :backend, :docker
    set :docker_container, 'spec_container'
    @container = Docker::Container.create(
      'Image' => @image.id,
      'name' => 'spec_container',
    )
    @container.start
  end

  after(:all) do
    @container.kill
    @container.delete(:force => true)
  end

  describe process 'java' do
    it 'should be_running', :retry => 15, :retry_wait => 3 do
      should be_running
    end
    it 'copies init.groovy.d files into place' do
      expect(file("#{JENKINS_HOME}/init.groovy.d/no-setup-wizard.groovy")).to exist
    end
  end
end
