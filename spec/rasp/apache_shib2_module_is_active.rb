control "apache_shib_module_is_active" do
  impact 1.0
  title "Apache's Shib module is enabled"
  desc "Apache's Shib module is available and enabled "

  describe file('/etc/apache2/mods-enabled/shib.load') do
    it { should exist }
  end

  describe command('apache2ctl -t -D DUMP_MODULES') do
    its('stdout') { should include "mod_shib" }
  end

end