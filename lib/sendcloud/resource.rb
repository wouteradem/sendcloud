module Sendcloud
  class Resource
    attr_reader :client

    def initialize(client, version: :v2)
      @client = client
      @version = version
    end

    private

    def conn
      @client.connection(@version)
    end

    def get_request(url, params: {}, headers: {})
      handle_response conn.get(url, params, headers)
    end

    def post_request(url, body:, headers: {})
      handle_response conn.post(url, body, headers)
    end

    def patch_request(url, body:, headers: {})
      handle_response conn.patch(url, body, headers)
    end

    def put_request(url, body:, headers: {})
      handle_response conn.put(url, body, headers)
    end

    def delete_request(url, params: {}, headers: {})
      handle_response conn.delete(url, params, headers)
    end

    def handle_response(response)
      case response.status
      when 400
        raise Error, "Your request was malformed. #{response.body["error"]}"
      when 401
        raise Error, "You did not supply valid authentication credentials. #{response.body["error"]}"
      when 403
        raise Error, "You are not allowed to perform that action. #{response.body["error"]}"
      when 404
        raise Error, "No results were found for your request. #{response.body["error"]}"
      when 429
        raise Error, "Your request exceeded the API rate limit. #{response.body["error"]}"
      when 500
        raise Error, "We were unable to perform the request due to server-side problems. #{response.body["error"]}"
      end

      response
    end
  end
end
