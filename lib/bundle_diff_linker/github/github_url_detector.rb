require "httpclient"

module BundleDiffLinker
  module Github
    class GithubUrlDetector
      REGEXP = %r!https?://([^/]+)\.github\.[^/]+/([^/]+)!

      def initialize(urls)
        @urls = Array(urls).compact
      end

      def detect
        url = @urls.find { |url| url.include?("github.com") }
        return unless url

        BundleDiffLinker.logger.debug("Try to detect github url by #{url}")
        response = HTTPClient.get(url, follow_redirect: true)
        url = response.header.request_uri.to_s

        if url.match?(REGEXP)
          _, owner, repo = url.match(REGEXP).to_a
          _url = "https://github.com/#{owner}/#{repo}"
          if HTTPClient.get(_url).ok?
            url = _url
          end
        end

        repository = RepositoryNameDetector.new(url).detect
        "https://github.com/#{repository}"
      rescue => e
        BundleDiffLinker.logger.warn("Could not detect github url by #{url} because of #{e.inspect}")
        nil
      end
    end
  end
end
