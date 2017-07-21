require "httpclient"

module LockDiff
  module Github
    class UrlDetector
      # xxx.github.aaa/yyyy
      REGEXP = %r!https?://([^/]+)\.github\.[^/]+/([^/]+)!

      def initialize(urls)
        @urls = Array(urls).compact
      end

      def call
        url = @urls.find { |url| url.include?("github.com") }
        return unless url

        begin
          response = HTTPClient.get(url, follow_redirect: true)
          url = response.header.request_uri.to_s
        rescue
          repository = RepositoryNameDetector.new(url).call
          url = "https://github.com/#{repository}"
        end

        if url.match(REGEXP)
          _, owner, repo = url.match(REGEXP).to_a
          url = "https://github.com/#{owner}/#{repo}"
          HTTPClient.get(url).ok? ? url : nil
        else
          repository = RepositoryNameDetector.new(url).call
          "https://github.com/#{repository}"
        end
      rescue => e
        LockDiff.logger.warn("Could not detect github url by #{url} because of #{e.inspect}")
        nil
      end
    end
  end
end
