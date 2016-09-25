require 'json'
require_relative './adapter.rb'
module Entermedia
  class Asset < Collection
    @module_name = 'asset'

    # Runs a search query on the media library, based on the json query argument passed
    # Returns the results field of the POST call, which is an array of assets found for that query
    def self.search(query)
      method = 'search'
      body = {
        query: query
      }
      url = self.get_method_url(method)
      response = Entermedia::Adapter.send_request('POST', url, body.to_json, {:content_type=> :json})
      response['results'] rescue []
    end

    # Uploads a file with the provided metadata on the media server
    # Params:
    # +assetData+: (Hash) : The metadata of the file uploaded
    # +assetFile+: (File) : The file to be uploaded as the asset
    def self.createAsset(assetData, assetFile)
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

    # Updates the asset metadata of a given assetId
    # Params:
    # +assetId+: (String) : The id of the asset to be updated
    # +assetData+: (Hash) : The new asset metadata that needs to be set
    def self.updateMetaData(assetId, assetData)
      method = 'data/' + assetId
      body = {
        jsonrequest: assetData.except('id').to_json,
      }
      url = self.get_method_url(method)
      response = Entermedia::Adapter.send_request('PUT', url, body, {:content_type=> :json})
      response rescue {}
    end

    # Finds assets whose name starts contains the given parameter. Returns an array of type Asset
    # Params:
    # +name+: (String) : The name to be searched
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
