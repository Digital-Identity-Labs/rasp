control "apache_ssl_module_is_available" do
  impact 1.0
  title "Apache's SSL/TLS module is available and active"
  desc "Apache TLS functionality is available (but not actively in use)"

  describe file('/etc/apache2/mods-enabled/ssl.load') do
    it { should exist }
  end

  describe command('apache2ctl -t -D DUMP_MODULES') do
    its('stdout') { should include "ssl" }
  end


end