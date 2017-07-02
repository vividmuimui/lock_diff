module LockDiff
  module Gem
    class Gem
      extend Forwardable

      attr_reader :name
      def_delegator :ruby_gem, :github_url

      def initialize(name)
        @name = name
      end

      def url
        ruby_gem.github_url || ruby_gem.homepage_url
      end

      def change_log_url
        Github::ChangeLogUrlFinder.new(repository: repository, github_url: ruby_gem.github_url).call
      end
      memoize :change_log_url

      def repository
        Github::RepositoryNameDetector.new(ruby_gem.github_url).call
      end

      def tag_names
        LockDiff.client.tag_names(repository)
      end
      memoize :tag_names

      private

      def ruby_gem
        RubyGem.new(name)
      end
      memoize :ruby_gem

    end
  end
end
