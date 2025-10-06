module Sendcloud
  class ServicePointClient
    BASE_DOMAIN = "https://servicepoints.sendcloud.sc"

    attr_reader :api_key, :adapter

    def initialize(api_key:, adapter: Faraday.default_adapter, stubs: nil)
      @api_key = api_key
      @adapter = adapter

      # Test stubs for requests
      @stubs = stubs
    end

    def service_point
      ServicePointResource.new(self)
    end

    def connection(version = :v2)
      case version.to_sym
      when :v2 then (@connection_v2 ||= build_connection("#{BASE_DOMAIN}/api/v2"))
      when :v3 then (@connection_v3 ||= build_connection("#{BASE_DOMAIN}/api/v3"))
      else
        raise ArgumentError, "Unsupported version: #{version.inspect}"
      end
    end

    private

    def build_connection(base_url)
      @connection ||= Faraday.new(base_url) do |conn|
        conn.request :authorization, :AccessToken, api_key
        conn.request :json
        conn.response :json, content_type: "application/json"
        conn.response :follow_redirects, clear_authorization_header: false
        conn.adapter adapter, @stubs
      end
    end
  end
end
