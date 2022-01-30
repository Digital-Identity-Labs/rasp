control "apache_supports_http2" do
  impact 1.0
  title "Apache is supports the http2 protocol"
  desc "Apache is supports the HTTP2 protocol, including HTTP2c"

  describe command('apache2ctl -t -D DUMP_MODULES') do
    its('stdout') { should include "http2_module" }
    its('stdout') { should include "proxy_http2_module" }
  end

end