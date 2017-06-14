module BundleDiffLinker
  module Gem
    class Gem
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def url
        ruby_gem.github_url || ruby_gem.homepage_url
      end

      def github_url
        ruby_gem.github_url
      end

      def change_log_url
        return unless repository
        Github::ChangeLogUrlFinder.new(repository: repository, github_url: github_url).call
      end
      memoize :change_log_url

      def repository
        Github::RepositoryNameDetector.new(ruby_gem.github_url).call
      end

      def tags
        return [] unless repository
        BundleDiffLinker.github_client.tags(repository)
      end
      memoize :tags

      private

      def ruby_gem
        RubyGem.new(name)
      end
      memoize :ruby_gem

    end
  end
end
