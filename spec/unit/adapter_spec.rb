require 'spec_helper'

RSpec.describe Entermedia::Adapter do
  describe '#configure' do
    it 'should take in domain parameter' do
      dom = 'http://localhost:3000/media'
      Entermedia::Adapter.configure({
        domain: dom
      })
      options = Entermedia::Adapter.class_variable_get(:@@options)
      expect(options[:domain]).to eq(dom)
    end

    it 'should merge options' do
      new_dom = 'app2.com'
      key = 'firstKey'
      Entermedia::Adapter.configure({
        entermediaKey: key
      })
      options = Entermedia::Adapter.class_variable_get(:@@options)
      expect(options[:domain]).to eq(new_dom)
      expect(options[:entermediaKey]).to eq(new_dom)
    end

    it 'should overwrite same options' do
      new_dom = 'app2.com'
      Entermedia::Adapter.configure({
        domain: new_dom
      })
      options = Entermedia::Adapter.class_variable_get(:@@options)
      expect(options[:domain]).to eq(new_dom)
    end
  end

  describe '#domain' do
    it 'should return the domain that is set' do
      dom = 'app1.com'
      Entermedia::Adapter.class_variable_set(:@@options, {
        domain: dom
      })
      result = Entermedia::Adapter.domain
      expect(result).to eq(dom)
    end
  end

  describe '#send_request' do
    it 'should throw an error if no key is provided' do
    end

    it 'should throw an error if no domain is provided' do
    end

    it 'should correctly handle an error in network' do
    end

    it 'should run the request and return a hash' do
    end
  end
end
