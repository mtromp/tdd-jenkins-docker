require "serverspec"
require "docker"

JENKINS_HOME='/var/jenkins_home'

describe "Dockerfile" do
  before(:all) do
    @image = Docker::Image.build_from_dir('.')

    set :os, family: :debian
    set :backend, :docker
    set :docker_image, @image.id
  end


  it 'Verify files exist in opt' do
      expect(file('/opt/Dockerfile-tdd-jenkins-docker')).to exist
      expect(file('/opt/README-tdd-jenkins-docker.md')).to exist
  end

  it 'Verify no-setup-wizard.groovy exists in /usr/share/jenkins/ref/init.groovy.d' do
      expect(file('/usr/share/jenkins/ref/init.groovy.d/no-setup-wizard.groovy')).to exist
  end


  describe process 'java' do
    it { should be_running }

    it 'copies init.groovy.d files into place' do
      expect(file("#{JENKINS_HOME}/init.groovy.d/no-setup-wizard.groovy")).to exist
    end
  end
end
