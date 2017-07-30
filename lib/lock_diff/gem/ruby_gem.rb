require "httpclient"
require 'ostruct'
require 'json'

module LockDiff
  module Gem
    # wrapper of RubyGem
    class RubyGem
      extend Forwardable

      def initialize(name)
        @ruby_gem = Repository.find(name)
      end

      def repository_url
        @repository_url ||= Github::UrlDetector.new([source_code_url, @ruby_gem.homepage_uri]).call
      end

      def url
        @ruby_gem.project_uri
      end

      private

      def source_code_url
        @ruby_gem.source_code_uri
      end

      class Repository
        class << self
          def find(name)
            ruby_gem = repository[name]
            return ruby_gem if ruby_gem
            repository[name] = fetch(name)
          end

          def fetch(name)
            content = HTTPClient.get_content("https://rubygems.org/api/v1/gems/#{name}.json")
            OpenStruct.new(JSON.parse(content))
          rescue => e
            LockDiff.logger.warn("Could not fetch gem info of #{name} because of #{e.inspect}")
            NullRubyGem.new(name)
          end

          def repository
            @repository ||= {}
          end
        end
      end

    end

    class NullRubyGem
      def initialize(name)
        @name = name
      end

      def homepage_uri
      end

      def source_code_uri
      end

      def project_uri
      end

    end
  end
end
