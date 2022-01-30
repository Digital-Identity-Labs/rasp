control "apache_risky_modules_are_disabled" do
  impact 1.0
  title "Apache modules that may be harmful are disabled"
  desc "Apache modules that are not required, and which present a risk, should not be enabled"

  describe file('/etc/apache2/mods-enabled/status.load') do
    it { should exist }
  end

  describe command('apache2ctl -t -D DUMP_MODULES') do
    its('stdout') { should_not include "cgi_module" }
    its('stdout') { should_not include "cgid_module" }
    its('stdout') { should_not include "php" }
  end

end