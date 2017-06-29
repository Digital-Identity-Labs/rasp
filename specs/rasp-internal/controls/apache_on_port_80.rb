control "apache_on_port_80" do
  impact 1.0
  title "Apache is available on port 80, as HTTP and H2c"
  desc "Run IdP in Jetty as a non-root user"

  describe apache_conf do
    its('Listen') { should include '80'}
  end

  describe port(80) do
    it {should be_listening}
    its('protocols') {should include 'tcp6'}
    its('processes') {should include 'apache2'}
  end

  describe ssl(host: "0.0.0.0", port: 80) do
    it { should_not be_enabled }
  end

end