require "serverspec"
require "docker"
require "json"
require "rspec/retry"

JENKINS_HOME='/var/jenkins_home'

describe "Dockerfile" do
  before(:all) do
    @image = Docker::Image.build_from_dir('.', buildargs: {localAdmin: 'marianne'}.to_json)
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

  it 'Verify plugins.txt exists in ref' do
    expect(file('/usr/share/jenkins/ref/plugins.txt')).to exist
  end

  context 'all defined plugins exist' do
    File.open('plugins.txt').each do |line|
      (pluginname,version)=line.split /\s|:/
      describe file "#{JENKINS_HOME}/plugins/#{pluginname}.jpi" do
        it { should be_file }
      end
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

    describe file ('/var/jenkins_home/users/marianne') do
      it 'should be_directory', :retry => 15, :retry_wait => 3 do
        should exist
      end
    end
  end
end
