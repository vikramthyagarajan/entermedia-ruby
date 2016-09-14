module Entermedia
  class Collection
    @module_name = 'module'
    @@path = '/services/module/'

    def self.base_url
      @@path + @module_name + '/'
    end

    def self.get_method_url(method)
      self.base_url + method
    end
  end
end
