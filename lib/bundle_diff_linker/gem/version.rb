module BundleDiffLinker
  module Gem
    class Version
      def initialize(gem:, spec:)
        @gem = gem
        @spec = spec
      end

      def ref
        git_tag || rivision
      end

      def rivision
        @spec.rivision
      end

      def version
        @spec.version
      end

      def to_s
        @spec.version.to_s
      end

      private

      def git_tag
        if BundleDiffLinker.cache_response?
          @git_tag ||= BundleDiffLinker::Github::TagFinder.new(name: @gem.name, repository: @gem.repository, version: version.to_s).call
        else
          BundleDiffLinker::Github::TagFinder.new(name: @gem.name, repository: @gem.repository, version: version.to_s).call
        end
      end

    end
  end
end
