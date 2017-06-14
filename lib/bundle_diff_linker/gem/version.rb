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

      def git_tag
        version_str = @spec.version.to_s
        @gem.tags.find do |tag|
          tag.name == version_str ||
            tag.name == "v#{version_str}" ||
            tag.name == "#{@gem.name}-#{version_str}"
        end&.name
      end

    end
  end
end
