require "httpclient"
require 'ostruct'

module LockDiff
  module Gem
    # wrapper of RubyGem
    class RubyGem
      extend Forwardable

      def_delegator :@ruby_gem, :homepage_uri, :homepage_url
      def_delegator :@ruby_gem, :source_code_uri, :source_code_url

      def initialize(name)
        content = HTTPClient.get_content("https://rubygems.org/api/v1/gems/#{name}.json")
        @ruby_gem = OpenStruct.new(JSON.parse(content))
      rescue => e
        LockDiff.logger.warn("Could not fetch gem info of #{@spec.full_name} because of #{e.inspect}")
      end

      def github_url
        @github_url ||= Github::GithubUrlDetector.new([source_code_url, homepage_url]).call
      end

    end
  end
end
