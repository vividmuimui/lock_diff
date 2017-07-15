module LockDiff
  module Github
    class ChangelogUrlFinder
      CHANGE_LOG_CANDIDATES = %w(
        changelog
        changes
        history
        releases
        releasenote
        news
      )

      def initialize(repository:, github_url:, ref:)
        @repository = repository
        @github_url = github_url
        @ref = ref
      end

      def call
        find_change_log_url || find_release_url
      end

      private

      def find_change_log_url
        Github.client.contents(@repository, ref: @ref).
          select(&:file?).
          find { |content|
            name = content.name.downcase.delete('_')
            CHANGE_LOG_CANDIDATES.any? { |candidate| name.start_with? candidate }
          }&.html_url
      end

      def find_release_url
        return unless @github_url
        unless Github.client.exist_releases?(@repository)
          @github_url + "/releases"
        end
      end

    end
  end
end
