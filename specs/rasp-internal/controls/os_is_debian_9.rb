control "os_is_debian_9" do
  impact 1.0
  title "OS is Debian 9 (Stretch)"
  desc "The operating system is Debian 9 (Stretch) - probably MiniDeb"

  describe file('/etc/issue.net') do
    its('content') { should eq "Debian GNU/Linux 9\n" }
  end

end

