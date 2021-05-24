module LockDiff
  module Github
    class ChangelogUrlFinder
      def initialize(repository:, repository_url:, ref:, package_name:)
        @repository = repository
        @repository_url = repository_url
        @ref = ref
        @package_name = package_name
      end

      def call
        directories.flat_map(&:change_log_urls).push(find_release_url).compact
      end

      private

      def directories
        [
          Directory.new(@repository, @ref),
          Directory.new(@repository, @ref, path: @package_name),
          Directory.new(@repository, @ref, path: "gems/#{@package_name}")
        ]
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
