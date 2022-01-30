require 'spec_helper'

describe "Apache worker processes do not run as root (the overseer process does still run as root, though)" do

  describe user('www-data') do
    it { should exist }
    it { belong_to_group 'www-data'}
    it { should belong_to_primary_group 'www-data' }
    it { should have_home_directory '/var/www' }
    it { should have_login_shell '/usr/sbin/nologin' }
  end

  describe group('www-data') do
    it { should exist }
  end

  describe command('xargs --null --max-args=1 echo < /proc/$(cat /var/run/apache2/apache2.pid)/environ') do
    its('stdout') { should include "APACHE_RUN_USER=www-data" }
    its('stdout') { should include "APACHE_RUN_GROUP=www-data" }
  end

  describe process('apache2') do
    its(:user) { should eq("root").or(eq('www-data')) }
  end

end
