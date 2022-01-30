control "apache_version" do
  impact 1.0
  title "Apache version is correct"
  desc "A recent version of Apache has been installed correctly"

  describe package('apache2') do
    it { should be_installed }
    its('version') { should >= '2.4' }
  end

  describe command('apache2ctl -v') do
    its('stdout') { should include "Server version: Apache/2.4." }
  end


end