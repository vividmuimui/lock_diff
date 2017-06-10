require "httpclient"
require 'ostruct'

module BundleDiffLinker
  class RubyGem < OpenStruct
    def initialize(name)
      content = HTTPClient.get_content("https://rubygems.org/api/v1/gems/#{name}.json")
      super(JSON.parse(content))
    end

    def github_url
      @github_url ||= begin
        BundleDiffLinker.logger.debug("detect github url of #{name}")
        detect_github_uri
      end
    end

    def homepage_url
      homepage_uri
    end

    private

    REGEXP = /https?:\/\/(\w+)\.github\.\w+\/(\w+)/
    def detect_github_uri
      uri = [source_code_uri, homepage_uri].compact.find { |uri| uri.match(/github\.com\//) }
      return unless uri
      response = HTTPClient.get(uri, follow_redirect: true)
      uri = response.header.request_uri.to_s

      if uri.match?(REGEXP)
        _, owner, repo = uri.match(REGEXP).to_a
        _uri = "https://github.com/#{owner}/#{repo}"
        if HTTPClient.get(_uri).ok?
          uri = _uri
        end
      end

      uri
    rescue => e
      BundleDiffLinker.logger.error("Could not detect github url of #{name} because of #{e.inspect}")
      BundleDiffLinker.logger.error(e.backtrace.first)
      nil
    end

  end
end
