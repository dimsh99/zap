require 'spec_helper'

describe 'test::hostsfile_entry' do
  before(:each) do
    allow(File).to receive(:readlines).and_call_original
    allow(File).to receive(:readlines)
      .with('/etc/hosts') { ['127.0.0.1	localhost localhost.localdomain\n',
                             '10.10.125.1	testhost1.example.com\n',
                             '10.10.135.2	testhost2.example.com\n',
                             '10.10.125.4	testhost3.example.com\n'] }
  end

  context 'without a pattern' do
    let(:runner) do
      ChefSpec::SoloRunner.new(step_into: 'zap_hostsfile_entry') do |node|
      end.converge(described_recipe)
    end

    it 'remove all hostsfile entries except 127.0.0.1' do
      expect(runner).not_to remove_hostsfile_entry('127.0.0.1')
      expect(runner).to remove_hostsfile_entry('10.10.125.1')
      expect(runner).to remove_hostsfile_entry('10.10.135.2')
      expect(runner).not_to remove_hostsfile_entry('10.10.125.4')
    end
  end

  context 'with a pattern' do
    let(:runner) do
      ChefSpec::SoloRunner.new(step_into: 'zap_hostsfile_entry') do |node|
        node.normal['hostsfile_entry']['pattern'] = '10.10.12*'
      end.converge(described_recipe)
    end

    it 'removes only hostsfile entries matching the pattern' do
      expect(runner).not_to remove_hostsfile_entry('127.0.0.1')
      expect(runner).not_to remove_hostsfile_entry('10.10.135.2')
      expect(runner).to remove_hostsfile_entry('10.10.125.1')
      expect(runner).not_to remove_hostsfile_entry('10.10.125.4')
    end
  end
end
