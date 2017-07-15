module LockDiff
  module Gem
    class Package
      extend Forwardable

      def_delegators :@spec, :name, :revision, :version
      def_delegator :ruby_gem, :github_url

      def initialize(spec)
        @spec = spec
      end

      def ref
        revision || git_tag
      end

      def version_str
        revision || version.to_s
      end

      def different?(other)
        revision != other.revision || version != other.version
      end

      def url
        ruby_gem.github_url || ruby_gem.homepage_url
      end

      def repository
        Github::RepositoryNameDetector.new(ruby_gem.github_url).call
      end

      private

      def ruby_gem
        @ruby_gem ||= RubyGemRepository.find(name)
      end

      def git_tag
        return unless version
        return @git_tag if defined? @git_tag
        @git_tag = Github::TagFinder.new(
          repository: repository,
          package_name: name,
          version_str: version.to_s
        ).call
      end

    end
  end
end
