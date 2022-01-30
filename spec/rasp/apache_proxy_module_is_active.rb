control "apache_proxy_module_is_active" do
  impact 1.0
  title "Apache has the proxy module active"
  desc "Apache should run with the proxy module active"

  describe file('/etc/apache2/mods-enabled/proxy.load') do
    it { should exist }
  end

  describe command('apache2ctl -t -D DUMP_MODULES') do
    its('stdout') { should include "proxy_module" }
    its('stdout') { should include "proxy_balancer_module" }
    its('stdout') { should include "proxy_http_module" }
    its('stdout') { should include "proxy_http2_module" }
  end

end