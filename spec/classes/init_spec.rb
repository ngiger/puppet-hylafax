require 'spec_helper'
describe 'hylafax' do

  context 'with defaults for all parameters' do
    it { should contain_class('hylafax') }
  end
end
