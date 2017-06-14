module BundleDiffLinker
  module Gem
    class Info
      attr_reader :name
      def initialize(name)
        @name = name
      end

      def ruby_gem
        if BundleDiffLinker.cache_response?
          @ruby_gem ||= RubyGem.new(name)
        else
          RubyGem.new(name)
        end
      end

      def url
        ruby_gem.github_url || ruby_gem.homepage_url
      end

      def github_url
        ruby_gem.github_url
      end

      def change_log_url
        if BundleDiffLinker.cache_response?
          @change_log_url ||= Github::ChangeLogUrlFinder.new(repository: repository, github_url: github_url).call
        else
          Github::ChangeLogUrlFinder.new(repository: repository, github_url: github_url).call
        end
      end

      def repository
        Github::RepositoryNameDetector.new(ruby_gem.github_url).call
      end

    end
  end
end
