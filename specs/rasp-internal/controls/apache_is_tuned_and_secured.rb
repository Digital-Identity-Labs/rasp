control "apache_is_tuned_and_secured" do
  impact 1.0
  title "Apache has been tuned for performance and security"
  desc "Apache should be configured to run more securely and effiencently"

  describe apache_conf do
    its('ProxyRequests') { should eq ['off']}
  end

  describe apache_conf do
    its('TraceEnable') { should eq ['off']}
  end

  describe apache_conf do
    its('KeepAlive') { should eq ['on']}
  end

  describe apache_conf do
    its('EnableMMAP') { should eq ['on']}
  end


  describe apache_conf do
    its('EnableSendfile') { should eq ['on']}
  end

end
