require "httpclient"
require 'ostruct'

module BundleDiffLinker
  class RubyGem < OpenStruct
    def initialize(name)
      BundleDiffLinker.logger.debug("Fetch #{name} gem info by rubygems")
      content = HTTPClient.get_content("https://rubygems.org/api/v1/gems/#{name}.json")
      super(JSON.parse(content))
    rescue => e
      BundleDiffLinker.logger.warn("Could not fetch gem info of #{@spec.full_name} because of #{e.inspect}")
    end

    def github_url
      @github_url ||= Github::GithubUrlDetector.new([source_code_uri, homepage_uri]).detect
    end

    def homepage_url
      homepage_uri
    end

  end
end
