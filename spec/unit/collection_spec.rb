require 'spec_helper'

RSpec.describe Entermedia::Adapter do
  describe '#base_url' do
    it 'should return the correct base url' do
      class Test1 < Entermedia::Collection
        @module_name = 'testmodule1'
      end
      expect(Test1.base_url).to eq('/services/module/testmodule1/')
    end

    it 'should not class with 2 subclasses overwriting properties' do
      class Test2 < Entermedia::Collection
        @module_name = 'testmodule2'
      end
      expect(Test2.base_url).to eq('/services/module/testmodule2/')
    end
  end

  describe '#get_method_url' do
    it 'should return correct method url' do
      method = 'bullets'
      class Test3 < Entermedia::Collection
        @module_name = 'testmodule3'
      end
      expect(Test3.get_method_url(method)).to eq('/services/module/testmodule3/bullets')
    end
  end
end
