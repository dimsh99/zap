hostsfile_entry '10.10.125.4' do
  hostname 'testhost4.example.com'
end

zap_hostsfile_entry '/etc/hosts' do
  pattern  node['hostsfile_entry']['pattern']
  filter do |address|
    address != '127.0.0.1'
  end
end
