control "switch_shib_repo_is_used" do
  impact 1.0
  title "Use SWITCH's Debian package repository"
  desc "SWITCH provides a great set of recent Shibboleth SP packages for Debian OSs"

  describe apt('http://pkg.switch.ch/switchaai/debian') do
    it { should exist }
    it { should be_enabled }
  end

end