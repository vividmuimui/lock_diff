require "httpclient"
require 'ostruct'

module BundleDiffLinker
  module Gem
    class RubyGem
      def initialize(name)
        BundleDiffLinker.logger.debug("Fetch #{name} gem info by rubygems")
        content = HTTPClient.get_content("https://rubygems.org/api/v1/gems/#{name}.json")
        @ruby_gem = JSON.parse(content)
      rescue => e
        BundleDiffLinker.logger.warn("Could not fetch gem info of #{@spec.full_name} because of #{e.inspect}")
      end

      def github_url
        if BundleDiffLinker.cache_response?
          @github_url ||= Github::GithubUrlDetector.new([source_code_url, homepage_url]).call
        else
          Github::GithubUrlDetector.new([source_code_url, homepage_url]).call
        end
      end

      def homepage_url
        @ruby_gem.homepage_uri
      end

      def source_code_url
        @ruby_gem.source_code_uri
      end

    end
  end
end
