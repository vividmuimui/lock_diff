module LockDiff
  module Github
    class RepositoryNameDetector
      REGEXP = %r!github\.com[/:](.*?)(?:.git)?\z!

      def initialize(url)
        @url = url
      end

      def call
        return unless @url
        @url.match(REGEXP).to_a.last.
          split("/").first(2).
          join("/")
      end

    end
  end
end
