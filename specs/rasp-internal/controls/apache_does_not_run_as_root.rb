control "apache_does_not_run_as_root" do
  impact 1.0
  title "Apache processes do not run as root"
  desc "Apache worker processes do not run as root (the overseer process does still run as root, though)"

  describe user('www-data') do
    it { should exist }
    its('group') { should eq 'www-data' }
    its('groups') { should eq ['www-data']}
    its('home') { should eq '/var/www' }
    its('shell') { should eq '/usr/sbin/nologin' }
  end

  describe group('www-data') do
    it { should exist }
  end

  describe command('xargs --null --max-args=1 echo < /proc/$(cat /var/run/apache2/apache2.pid)/environ') do
    its('stdout') { should include "APACHE_RUN_USER=www-data" }
    its('stdout') { should include "APACHE_RUN_GROUP=www-data" }
  end

  describe apache_conf do
    its('User') { should eq  ["${APACHE_RUN_USER}"]}
    its('Group') { should eq ["${APACHE_RUN_GROUP}"]}
  end

  describe processes('apache2') do
    its('users') {should  cmp ['root', 'www-data', 'www-data']}
  end

end