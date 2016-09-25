require 'spec_helper'

dom = 'http://media.quodeck.com/media'
def media_stubs_new()
  dom = 'http://media.quodeck.com/media'
  base_url = dom + '/services/module'
  stub_request(:post, base_url + '/asset/create')
    .with({body: {jsonrequest: {name: 'timeout-file'}.to_json}})
    .to_timeout.to_return({body: {name: 'timeout-file'}.to_json})
  stub_request(:post, base_url + '/asset/create').to_return({body: {ans: 'abc'}.to_json})
  stub_request(:get, base_url + '/test/server_error').to_return({
    status: [500, 'Internal Server Error']
  })
  stub_request(:get, base_url + '/test/json_error').to_return({body: "wrongjson"})
  stub_request(:get, base_url + '/test/general').to_return({body: {ans: 'abc'}.to_json})
end
def stub_search(query, answer)
  base_url = @dom + '/services/module'
  search_url = base_url + '/asset/search'
  stub_request(:post, search_url)
    .with({body: {query: query}.to_json})
    .to_return({body: {results: answer}.to_json})
end
Asset = Entermedia::Asset

RSpec.describe Entermedia::Adapter do
  before(:all) do
    @dom = 'http://media.quodeck.com/media'
  end

  describe '#search' do
    it 'should search a term' do
      query_body = {
        terms: [{
          field: 'name',
          operator: 'contains',
          value: 'test'
        }]
      }
      ans = [{
        name: 'test'
      }].to_json
      stub_search(query_body, ans)
      arr = Asset.search(query_body)
      expect(arr).to eq(ans)
    end

    it 'should search multiple terms' do
      query_body = {
        terms: [{
          field: 'name',
          operator: 'contains',
          value: 'test'
        }, {
          field: 'keywords',
          operator: 'contains',
          value: 'tagged'
        }]
      }
      ans = [{
        name: 'test',
        keywords: [{name: 'tagged'}]
      }].to_json
      stub_search(query_body, ans)
      arr = Asset.search(query_body)
      expect(arr).to eq(ans)
    end
  end

  describe '#createAsset' do
    it 'should give an error if file is not provided' do
      meta = {
        name: 'test-asset'
      }
      expect{Asset.createAsset(meta, nil)}.to raise_error
    end

    it 'should give an error if assetFile is not of type File' do
      meta = {
        name: 'test-asset'
      }
      expect{Asset.createAsset(meta, 'sometext')}.to raise_error
    end

    it 'should give an error if required parameters are not provided' do
      # name is the only required parameter as of now
      meta = {
        keywords: ['test-asset']
      }
      f = File.new
      expect{Asset.createAsset(meta, f)}.to raise_error
    end

    it 'should create an asset with given parameters and file' do
      meta = {
        name: 'test-asset',
        keywords: ['test']
      }
      f = File.new
      expect{Asset.createAsset(meta, f)}.to_not raise_error
    end
  end

  describe '#updateMetaData' do
    it 'should change name' do
    end

    it 'should update multiple parameters' do
    end

    it 'should remove the id value from the assetData' do
    end
  end

  describe '#find_by_name' do
    it 'should find assets by name' do
    end

    it 'should return array of Assets' do
    end

    it 'should return url of the assets' do
    end
  end

  describe '#find_by_tags' do
    it 'should accept a tag and find ' do
    end

    it 'should accept multiple tags' do
    end
  end
  
  describe '#url' do
    it 'should get small image' do
    end
    
    it 'should return large image' do
    end
  end

  describe '#save' do
    it 'should update metadata when asset exists' do
    end

    it 'should upload asset if asset does not exist' do
    end
  end
end
