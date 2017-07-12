module LockDiff
  module Gem
    class Version
      extend Forwardable

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

      private

      def git_tag
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
