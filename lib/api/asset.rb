require 'json'
require_relative './adapter.rb'
module Entermedia
  class Asset < Collection
    @module_name = 'asset'

    # Class Functions
    def self.search(query)
      method = 'search'
      body = {
        query: query
      }
      url = self.get_method_url(method)
      response = Entermedia::Adapter.send_request('POST', url, body.to_json, {:content_type=> :json})
      response['results'] rescue []
    end

    def self.createAsset(assetData, assetFile)
      p 'creating'
      p @module_name
      method = 'create'
      body = {
        jsonrequest: assetData.to_json,
        file: assetFile,
        multipart: true
      }
      url = self.get_method_url(method)
      response = Entermedia::Adapter.send_request('POST', url, body, {})
      response rescue {}
    end

    def self.updateMetaData(assetId, assetData)
      method = 'data/' + assetId
      body = {
        jsonrequest: assetData.except('id').to_json,
      }
      url = self.get_method_url(method)
      response = Entermedia::Adapter.send_request('PUT', url, body, {:content_type=> :json})
      response rescue {}
    end

    def self.find_by_name(name)
      assets = self.search({
        terms: [
          field: 'name',
          operator: 'contains',
          value: name
        ]
      })
      assets.map do |assetData|
        Asset.new(assetData)
      end
    end

    def self.find_by_tags(name)
      self.search({
        terms: [
          field: 'keywords',
          operator: 'contains',
          value: name
        ]
      })
    end

    def initialize(assetData, assetFile = nil, sourcePath = 'QuoDeck/uncategorized')
      p 'inittting'
      @assetData = assetData
      # @assetData[:sourcePath] = sourcePath
      @assetFile = assetFile
    end

    def data
      @assetData
    end

    def url(type = 'small')
      case type
      when 'small'
        filename = 'image200x200.jpg'
      else
        filename = 'image200x200.jpg'
      end
      Client.domain + '/services/module/asset/downloads/preset/' + @assetData['sourcepath'].to_s + '/' + filename
    end

    def save
      if @assetFile.nil?
        id = @assetData['id']
        self.class.updateMetaData(id, @assetData)
      else
        response = self.class.createAsset(@assetData, @assetFile)
        @assetData = response['data']
        response
      end
    end
  end
end
