control "apache_logs_to_stdout_by_default" do
  impact 1.0
  title "Apache logs messages to stdout, to be collected by Docker"
  desc "By default Apache should log to stdout, but log directory should be available on image"

  describe file('/var/log/apache2') do
    it { should be_directory }
    its('owner') { should eq 'root' }
    its('mode') { should cmp '0750' }
    it { should be_writable.by  'owner' }
  end

  %w[access.log error.log other_vhosts_access.log].each do |logfile|
    describe file("/var/log/apache2/#{logfile}") do
      its('type') { should be :pipe }
      it { should_not be_file }
      it { should_not be_directory }
    end
  end


end