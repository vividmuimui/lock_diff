module BundleDiffLinker
  module Github
    class ChangeLogUrlFinder
      CHANGE_LOG_CANDIDATES = %w(
        changelog
        changes
        history
        releases
        releasenote
        news
      )

      def initialize(repository:, github_url:)
        @repository = repository
        @github_url = github_url
      end

      def call
        find_change_log_url || find_release_url
      end

      private

      def find_change_log_url
        BundleDiffLinker.client.contents(@repository).
          select(&:file?).
          find { |content|
            name = content.name.downcase.delete('_')
            CHANGE_LOG_CANDIDATES.any? { |candidate| name.start_with? candidate }
          }&.html_url
      end

      def find_release_url
        return unless @github_url
        unless BundleDiffLinker.client.exist_releases?(@repository)
          @github_url + "/releases"
        end
      end

    end
  end
end
