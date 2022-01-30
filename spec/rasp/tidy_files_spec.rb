describe "The image has had build files, excess packages and other cruft deleted" do

  describe file('/usr/local/src') do
    it { should be_directory }
  end

  describe file('/usr/local/src/*') do
    it { should_not exist }
  end
  describe command('ls -l /usr/local/src/ | wc -l | xargs echo -n') do
    its('stdout') { should eq "1" }
  end

  %w[gpg dirmngr unzip].each do |deb|

    describe package(deb) do
      it { should_not be_installed }
    end

  end

end