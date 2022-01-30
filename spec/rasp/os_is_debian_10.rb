control "os_is_debian_10" do
  impact 1.0
  title "OS is Debian 10 (Buster)"
  desc "The operating system is Debian 10 (Buster) - probably MiniDeb"

  describe file('/etc/issue.net') do
    its('content') { should eq "Debian GNU/Linux 10\n" }
  end

end

