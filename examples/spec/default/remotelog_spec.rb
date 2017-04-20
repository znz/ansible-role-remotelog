require 'spec_helper'

describe file('/etc/rsyslog.d/10-local.conf') do
  it { should be_file }
  its(:content) { should match(Regexp.new(Regexp.quote('%$year%%$month%%$day%_%fromhost-ip%.log'))) }
end

describe package('rsyslog') do
  it { should be_installed }
end

describe port(514) do
  it { should be_listening.with('tcp') }
  it { should be_listening.with('tcp6') }
  it { should be_listening.with('udp') }
  it { should be_listening.with('udp6') }
end

message = "Test#{Time.now.to_i}"

describe command("logger --server ::1 #{message}") do
  its(:stdout) { should eq '' }
  its(:stderr) { should eq '' }
  its(:exit_status) { should eq 0 }
end

log = "/var/log/remote/#{Time.now.strftime('%Y%m%d')}_::1.log"
describe file(log) do
  its(:content) { should match Regexp.new(Regexp.quote(message)) }
end
