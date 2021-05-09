module LockDiff
  module Github
    class ChangelogUrlFinder
      def initialize(repository:, repository_url:, ref:)
        @repository = repository
        @repository_url = repository_url
        @ref = ref
      end

      def call
        directory.change_log_urls.push(find_release_url).compact
      end

      private

      def directory
        Directory.new(@repository, @ref)
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
