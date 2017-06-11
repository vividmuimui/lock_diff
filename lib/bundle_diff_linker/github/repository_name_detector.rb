module BundleDiffLinker
  module Github
    class RepositoryNameDetector
      REGEXP = %r!github\.com/([^/]+)/([^/]+)!

      def initialize(url)
        @url = url
      end

      def detect
        return unless @url
        _, repo_owner, repo_name = @url.match(REGEXP).to_a
        "#{repo_owner}/#{repo_name}"
      end

    end
  end
end
