control "apache_uses_event_mpm" do
  impact 1.0
  title "Apache uses the Event MPM"
  desc "Apache uses an event-based MPM to handle requests"

  describe command('apache2ctl -V') do
    its('stdout') { should include "Server MPM:     event" }
  end

end