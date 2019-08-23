require "serverspec"
require "docker"
require "json"
require "rspec/retry"

JENKINS_HOME='/var/jenkins_home'
JENKINS_VERSION='2.176.2'

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

  describe 'Files generated to disable setup wizard' do
    describe file "#{JENKINS_HOME}/jenkins.install.InstallUtil.lastExecVersion" do
      it { should be_file }
      its(:content) { should eq "#{JENKINS_VERSION}" }
    end
    describe file "#{JENKINS_HOME}/jenkins.install.UpgradeWizard.state" do
      it { should be_file }
      its(:content) { should eq "#{JENKINS_VERSION}" }
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

    describe command('ls /var/jenkins_home/users') do
      its(:stdout) {should contain('marianne')}
    end
  end
end
