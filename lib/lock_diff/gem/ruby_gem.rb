require "httpclient"
require 'ostruct'
require 'json'

module LockDiff
  module Gem
    # wrapper of RubyGem
    class RubyGem
      extend Forwardable

      def initialize(name)
        content = HTTPClient.get_content("https://rubygems.org/api/v1/gems/#{name}.json")
        @ruby_gem = OpenStruct.new(JSON.parse(content))
      rescue => e
        LockDiff.logger.warn("Could not fetch gem info of #{name} because of #{e.inspect}")
        @ruby_gem = NullRubyGem.new(name)
      end

      def github_url
        @github_url ||= Github::GithubUrlDetector.new([source_code_url, homepage_url]).call
      end

      def homepage_url
        @ruby_gem.homepage_uri
      end

      private

      def source_code_url
        @ruby_gem.source_code_uri
      end

    end

    class NullRubyGem
      def initialize(name)
        @name = name
      end

      def homepage_uri
      end

      def source_code_uri
      end

    end
  end
end
