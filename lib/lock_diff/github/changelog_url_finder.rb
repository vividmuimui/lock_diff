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

      def initialize(repository:, repository_url:, ref:)
        @repository = repository
        @repository_url = repository_url
        @ref = ref
      end

      def call
        change_log_urls.push(find_release_url).compact
      end

      private

      def change_log_urls
        Github.client.contents(@repository, ref: @ref).
          select(&:file?).
          select do |content|
            name = content.name.downcase.delete('_')
            CHANGE_LOG_CANDIDATES.any? { |candidate| name.start_with? candidate }
          end&.map(&:html_url)
      end

      def find_release_url
        return unless @repository_url
        unless Github.client.exist_releases?(@repository)
          @repository_url + "/releases"
        end
      end

    end
  end
end
