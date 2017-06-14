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
          select { |content| content.type == "file" }.
          find { |content|
            name = content.name.downcase.delete('_')
            CHANGE_LOG_CANDIDATES.find do |candidate|
              name.start_with? candidate
            end
          }&.html_url
      end

      def find_release_url
        unless BundleDiffLinker.client.releases(@repository).empty?
          @github_url + "/releases"
        end
      end

    end
  end
end
