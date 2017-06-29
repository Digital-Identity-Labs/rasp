control "apache_on_port_80_and_443" do
  impact 1.0
  title "Apache is available on port 80 and port 443"
  desc "Run Apache service on port 80 and port 443 by default"

  describe apache_conf do
    its('Listen') { should include '80'}
    its('Listen') { should include '443'}
  end

  describe port(80) do
    it {should be_listening}
    its('protocols') {should include 'tcp6'}
    its('processes') {should include 'apache2'}
  end

  describe port(443) do
    it {should be_listening}
    its('protocols') {should include 'tcp6'}
    its('processes') {should include 'apache2'}
  end

  describe ssl(host: "0.0.0.0", port: 80) do
    it { should_not be_enabled }
  end

  # describe ssl(host: "0.0.0.0", port: 443) do
  #   it { should be_enabled }
  # end

end