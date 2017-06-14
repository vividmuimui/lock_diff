module BundleDiffLinker
  module Github
    class TagFinder
      def initialize(name:, repository:, version:)
        @name = name
        @repository = repository
        @version = version
      end

      def call
        BundleDiffLinker.logger.debug("Try to detect git tag of #{full_name}")
        BundleDiffLinker.github_client.tags(@repository).find do |tag|
          tag.name == @version ||
            tag.name == "v#{@version}" ||
            tag.name == "#{@name}-#{@version}"
        end&.name
      rescue => e
        BundleDiffLinker.logger.warn("Could not detect git tag of #{full_name} because of #{e.inspect}")
        BundleDiffLinker.logger.warn(e.backtrace.first)
        nil
      end

      private

      def full_name
        "#{@repository}-#{@version}"
      end
    end
  end
end
