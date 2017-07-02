module LockDiff
  module Github
    class RepositoryNameDetector
      REGEXP = %r!github\.com/([^/]+)/([^/]+)!

      def initialize(url)
        @url = url
      end

      def call
        return unless @url
        _, repo_owner, repo_name = @url.match(REGEXP).to_a
        "#{repo_owner}/#{repo_name}"
      end

    end
  end
end
