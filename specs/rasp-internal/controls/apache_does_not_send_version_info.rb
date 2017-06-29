control "apache_does_not_send_version_info" do
  impact 1.0
  title "Apache does not send version info in a header, or version info in error pages"
  desc "Apache does not send software version information (don't advertise vulnerabilities)"

  describe apache_conf do
    its('ServerTokens') { should eq ['prod']}
  end

  describe apache_conf do
    its('ServerSignature') { should eq ['off']}
  end

  describe http('http://localhost/floof') do
    its('headers.server') { should eq "Apache" }
    its('body') { should_not include "Apache/2." }
    its('body') { should_not include "Debian" }
  end

end