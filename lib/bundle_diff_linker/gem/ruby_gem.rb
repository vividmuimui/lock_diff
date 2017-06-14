require "httpclient"
require 'ostruct'

module BundleDiffLinker
  module Gem
    # wrapper of RubyGEm
    class RubyGem
      extend Forwardable

      def_delegator :@ruby_gem, :homepage_uri, :homepage_url
      def_delegator :@ruby_gem, :source_code_uri, :source_code_url

      def initialize(name)
        BundleDiffLinker.logger.debug("Fetch #{name} gem info by rubygems")
        content = HTTPClient.get_content("https://rubygems.org/api/v1/gems/#{name}.json")
        @ruby_gem = OpenStruct.new(JSON.parse(content))
      rescue => e
        BundleDiffLinker.logger.warn("Could not fetch gem info of #{@spec.full_name} because of #{e.inspect}")
      end

      def github_url
        Github::GithubUrlDetector.new([source_code_url, homepage_url]).call
      end
      memoize :github_url

    end
  end
end
