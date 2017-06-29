control "apache_shib2_module_is_active" do
  impact 1.0
  title "Apache's Shib2 module is enabled"
  desc "Apache's Shib2 module is available and enabled "

  describe file('/etc/apache2/mods-enabled/shib2.load') do
    it { should exist }
  end

  describe command('apache2ctl -t -D DUMP_MODULES') do
    its('stdout') { should include "mod_shib" }
  end

end