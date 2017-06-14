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
        if BundleDiffLinker.cache_response?
          @change_log_url ||= Github::ChangeLogUrlFinder.new(repository: repository, github_url: github_url).call
        else
          Github::ChangeLogUrlFinder.new(repository: repository, github_url: github_url).call
        end
      end

      def repository
        Github::RepositoryNameDetector.new(ruby_gem.github_url).call
      end

      def tags
        if BundleDiffLinker.cache_response?
          @git_tag ||= fetch_tags
        else
          fetch_tags
        end
      end

      private

      def fetch_tags
        return [] unless repository
        BundleDiffLinker.github_client.tags(repository)
      end

      def ruby_gem
        if BundleDiffLinker.cache_response?
          @ruby_gem ||= RubyGem.new(name)
        else
          RubyGem.new(name)
        end
      end

    end
  end
end
