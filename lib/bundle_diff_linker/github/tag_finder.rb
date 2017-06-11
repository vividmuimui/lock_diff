module BundleDiffLinker
  module Github
    class TagFinder
      def initialize(gem_info)
        @gem_info = gem_info
      end

      def find
        return unless @gem_info.repository
        BundleDiffLinker.logger.debug("Try to detect git tag of #{full_name}")
        BundleDiffLinker.github_client.tags(@gem_info.repository).find do |tag|
          tag.name == @gem_info.version ||
            tag.name == "v#{@gem_info.version}" ||
            tag.name == "#{@gem_info.name}-#{@gem_info.version}"
        end&.name
      rescue => e
        BundleDiffLinker.logger.warn("Could not detect git tag of #{full_name} because of #{e.inspect}")
        BundleDiffLinker.logger.warn(e.backtrace.first)
        nil
      end

      private

      def full_name
        "#{@gem_info.repository}-#{@gem_info.version}"
      end
    end
  end
end
