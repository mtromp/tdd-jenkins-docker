require "serverspec"
require "docker"

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
