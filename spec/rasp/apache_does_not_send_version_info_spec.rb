describe "Apache does not send software version information (don't advertise vulnerabilities)" do

  # describe apache_conf do
  #   its('ServerTokens') { should eq ['prod'] }
  # end
  #
  # describe apache_conf do
  #   its('ServerSignature') { should eq ['off'] }
  # end

  describe http_get('80', 'localhost', '/floof') do
    its(:headers) { should include('server' => "Apache") }
    its('body') { should_not include "Apache/2." }
    its('body') { should_not include "Debian" }
  end

end