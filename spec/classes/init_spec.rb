require 'spec_helper'
describe 'kibana' do

  context 'with defaults for all parameters' do
    it { should contain_class('kibana') }
  end
end
