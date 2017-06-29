control "apache_is_not_forward_proxy" do
  impact 1.0
  title "Apache is not acting as a forward proxy"
  desc "Run Apache without it acting as a forward proxy (like Squid, etc)"

  describe apache_conf do
    its('ProxyRequests') { should eq ['off']}
  end

end