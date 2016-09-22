module Entermedia
  require 'rest-client'
  class Adapter
    @@options = {}
    def self.configure(options)
      @@options = options
    end

    def self.send_request(method, path, body = {}, options = {})
      if !@@options[:domain].nil?
        domain = @@options[:domain]
      else
        raise ArgumentError, 'domain must be configured'
      end
      if !@@options[:entermediaKey].nil?
        entermediaKey = @@options[:entermediaKey]
      else
        raise ArgumentError, 'entermediaKey must be configured'
      end

      cookies = {'entermedia.key': entermediaKey}
      response = {}
      begin
        response = RestClient::Request.execute(method: method.to_sym, url: domain + path, payload: body, headers: options, cookies: cookies)
        response = JSON::parse(response.body)
      rescue JSON::ParserError
        raise JSON::ParserError, response
      rescue RestClient::Exceptions::Timeout
        response = RestClient::Request.execute(method: method.to_sym, url: domain + path, payload: body, headers: options, cookies: cookies)
        response = JSON::parse(response.body)
      rescue => error
        raise error
      end
      response
    end

    def self.domain
      @@options[:domain]
    end
  end
end
