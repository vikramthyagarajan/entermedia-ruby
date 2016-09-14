module Entermedia
  class Adapter
    # options = {
    #   entermediaKey: String
    #   domain: String
    # }
    def self.configure(options)
      @@options = options
    end
    def self.send_request(method, path, body = {}, options = {})
      domain = @@options[:domain]
      entermediaKey = @@options[:entermediaKey]

      cookies = {'entermedia.key': entermediaKey}
      response = {}
      begin
        response = RestClient::Request.execute(method: method.to_sym, url: domain + path, payload: body, headers: options, cookies: cookies)
        response = JSON::parse(response.body)
      rescue => error
        p 'error during request'
        p error.message
        p error.response.to_s
        return error
      end
      response
    end

    def self.domain
      @@options[:domain]
    end
  end
end
