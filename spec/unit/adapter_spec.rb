require 'spec_helper'

dom = 'http://media.quodeck.com/media'
def media_stubs()
  dom = 'http://media.quodeck.com/media'
  base_url = dom + '/services/module'
  stub_request(:get, base_url + '/test/timeout_error').to_timeout.to_return({body: {ans: 'abc'}.to_json})
  stub_request(:get, base_url + '/test/server_error').to_return({
    status: [500, 'Internal Server Error']
  })
  stub_request(:get, base_url + '/test/json_error').to_return({body: "wrongjson"})
  stub_request(:get, base_url + '/test/general').to_return({body: {ans: 'abc'}.to_json})
end

RSpec.describe Entermedia::Adapter do
  before(:each) do
    media_stubs
  end

  describe '#configure' do
    it 'should take in domain parameter' do
      Entermedia::Adapter.configure({
        domain: dom
      })
      options = Entermedia::Adapter.class_variable_get(:@@options)
      expect(options[:domain]).to eq(dom)
    end

    it 'should not merge options' do
      key = 'firstKey'
      Entermedia::Adapter.configure({
        entermediaKey: key
      })
      options = Entermedia::Adapter.class_variable_get(:@@options)
      expect(options[:domain]).to be_nil
      expect(options[:entermediaKey]).to eq(key)
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
      new_dom = 'app1.com'
      Entermedia::Adapter.class_variable_set(:@@options, {
        domain: new_dom
      })
      result = Entermedia::Adapter.domain
      expect(result).to eq(new_dom)
    end
  end

  describe '#send_request' do
    it 'should throw an error if no key is provided' do
      Entermedia::Adapter.configure({
        domain: dom
      })
      expect{Entermedia::Adapter.send_request('get', '/services/module/test')}.to raise_error(ArgumentError)
    end

    it 'should throw an error if no domain is provided' do
      Entermedia::Adapter.configure({
        entermediaKey: dom
      })
      expect{Entermedia::Adapter.send_request('get', '/services/module/test')}.to raise_error(ArgumentError)
    end

    it 'should retry 2 times on timeout' do
      Entermedia::Adapter.configure({
        domain: dom,
        entermediaKey: dom
      })
      # This url times out twice and then returns a json. response should be the json
      response = Entermedia::Adapter.send_request('get', '/services/module/test/timeout_error')
      expect(response).to eq({'ans'.to_s=> 'abc'})
    end

    it 'should correctly handle an error in network' do
      Entermedia::Adapter.configure({
        domain: dom,
        entermediaKey: dom
      })
      expect{Entermedia::Adapter.send_request('get', '/services/module/test/server_error')}.to raise_error(StandardError)
    end

    it 'should handle error in json parsing' do
      Entermedia::Adapter.configure({
        domain: dom,
        entermediaKey: dom
      })
      expect{Entermedia::Adapter.send_request('get', '/services/module/test/json_error')}.to raise_error(JSON::ParserError)
    end

    it 'should run the request and return a hash' do
      Entermedia::Adapter.configure({
        domain: dom,
        entermediaKey: dom
      })
      # This url times out twice and then returns a json. response should be the json
      response = Entermedia::Adapter.send_request('get', '/services/module/test/general')
      expect(response).to eq({'ans'.to_s=>  'abc'})
    end

    it 'should add a debug option to log details' do
    end
  end
end
