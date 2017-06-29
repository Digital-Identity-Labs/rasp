control "no_build_tools" do
  impact 1.0
  title "No C build tools are available"
  desc "It's a little harder to build malware on a compromised container"


  %w[gcc make libc6-dev].each do |deb|

    describe package(deb) do
      it { should_not be_installed }
    end

  end

end