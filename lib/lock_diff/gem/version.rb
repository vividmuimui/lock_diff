module LockDiff
  module Gem
    class Version
      extend Forwardable
      include Comparable

      def_delegators :@spec, :revision, :version

      def initialize(gem:, spec:)
        @gem = gem
        @spec = spec
      end

      def ref
        revision || git_tag
      end

      def to_s
        revision || version.to_s
      end

      def different?(other)
        revision != other.revision || version != other.version
      end

      def <=>(other)
        case
        when version && other.version
          version.send("<=>", other.version)
        else
          nil
        end
      end

      private

      def git_tag
        return unless version
        return @git_tag if defined? @git_tag
        @git_tag = Github::TagFinder.new(
          repository: @gem.repository,
          gem_name: @gem.name,
          version_str: version.to_s
        ).call
      end

    end

  end
end
