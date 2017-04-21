require 'spec_helper'

describe file('/etc/rsyslog.d/10-local.conf') do
  it { should be_file }
  its(:content) { should match(Regexp.new(Regexp.quote('%$year%%$month%%$day%_%fromhost-ip%.log'))) }
end

describe package('rsyslog') do
  it { should be_installed }
end

describe port(514) do
  # precise64 failed. see https://bugs.launchpad.net/ubuntu/+source/rsyslog/+bug/789174
  it { should be_listening.with('tcp') }
  it { should be_listening.with('tcp6') }
  it { should be_listening.with('udp') }
  it { should be_listening.with('udp6') }
end

now = Time.now.utc
message = "Test#{now.to_i}"
vm_ip = '10.0.2.15'

describe command("echo '<13>#{now.strftime('%b %d %H:%M:%S')} serverspec: #{message}' | nc -s #{vm_ip} -u -w 1 #{vm_ip} 514") do
  its(:stdout) { should eq '' }
  its(:stderr) { should eq '' }
  its(:exit_status) { should eq 0 }
end

# flush log
describe command("/etc/init.d/rsyslog restart") do
  its(:stderr) { should eq '' }
  its(:exit_status) { should eq 0 }
end

log = "/var/log/remote/#{now.strftime('%Y%m%d')}_#{vm_ip}.log"
describe file(log) do
  its(:content) { should match /^#{now.strftime('%b %d %H:%M:%S')} (?:#{Regexp.quote(vm_ip)}|precise64) serverspec: #{Regexp.quote(message)}$/ }
end
