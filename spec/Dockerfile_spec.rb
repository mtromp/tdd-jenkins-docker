require "serverspec"
require "docker"
require "rspec/retry"

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

  Dir['init.groovy.d/*'].each do |fname|
    groovy_file = "/usr/share/jenkins/ref/#{fname}"
    it "Verify file exists: #{groovy_file}" do
      expect(file(groovy_file)).to exist
    end
  end

  describe process 'java' do
    it { should be_running }

    it 'copies init.groovy.d files into place' do
      expect(file("#{JENKINS_HOME}/init.groovy.d/no-setup-wizard.groovy")).to exist
    end

    describe file ('/var/jenkins_home/config.xml') do
      it 'should be_file', :retry => 15, :retry_wait => 3 do
        should exist
      end
    end
  end
end
