control "shibd_runs_in_the_background" do
  impact 1.0
  title "Shibd daemon is running alongside Apache"
  desc "Container needs to run more than one process, so uses runit to manage things"

  describe processes('shibd') do
    it { should exist }
    its('users') { should eq ['_shibd'] }
  end

end