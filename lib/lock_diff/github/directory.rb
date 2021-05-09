module LockDiff
  module Github
    class Directory
      def initialize(repository, ref)
        @repository = repository
        @ref = ref
      end

      def change_log_urls
        contents.select(&:change_log?).map(&:html_url)
      end

      private

      def contents
        @contents ||= Github.client.contents(@repository, ref: @ref)
      end
    end
  end
end
