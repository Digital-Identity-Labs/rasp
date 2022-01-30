control "apache_status_is_enabled" do
  impact 1.0
  title "Apache Status module is enable and active"
  desc "Apache provides a status page with access limited to local IP addresses"

  describe file('/etc/apache2/mods-enabled/status.load') do
    it { should exist }
  end

  describe command('apache2ctl -t -D DUMP_MODULES') do
    its('stdout') { should include "status_module" }
  end

end