# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "sendcloud"
require "minitest/autorun"
require "faraday"
require "faraday/follow_redirects"
require "json"
require "base64"

class Minitest::Test
  def stub_response(fixture:, status: 200, headers: {"Content-Type" => "application/json"})
    [status, headers, File.read("test/fixtures/#{fixture}.json")]
  end

  def stub_request(path, response:, method: :get, body: {}, version: :v2)
    Faraday::Adapter::Test::Stubs.new do |stub|
      arguments = [method, "/api/#{version}/#{path}"]
      arguments << body.to_json if [:post, :put, :patch].include?(method)
      stub.send(*arguments) { |env| response }
    end
  end
end
