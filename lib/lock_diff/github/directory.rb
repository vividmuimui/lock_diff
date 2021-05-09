module LockDiff
  module Github
    class Directory
      def initialize(repository, ref, path: nil)
        @repository = repository
        @ref = ref
        @path = path
      end

      def change_log_urls
        contents.select(&:change_log?).map(&:html_url)
      rescue Octokit::NotFound
        []
      end

      private

      def contents
        @contents ||= Github.client.contents(@repository, ref: @ref, path: @path)
      end
    end
  end
end
