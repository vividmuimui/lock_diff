module LockDiff
  module Gem
    # wrapper of lazy_specification
    module Spec
      class UnSupportSource < StandardError; end

      def self.new(lockfile)
        Bundler::LockfileParser.new(lockfile).specs.map do |lazy_specification|
          case lazy_specification.source
          when Bundler::Source::Rubygems
            RubyGemSpec.new(lazy_specification)
          when Bundler::Source::Git
            GitSpec.new(lazy_specification)
          when Bundler::Source::Path
            PathSpec.new(lazy_specification)
          else
            raise UnSupportSource, "#{lazy_specification.source.class} source by #{lazy_specification.name} is not supported"
          end
        end
      end

      class Base
        extend Forwardable

        def_delegators :@spec, :name, :version

        def initialize(lazy_specification)
          @spec = lazy_specification
        end

        def revision
          @spec.git_version&.strip
        end

        def to_package
          Package.new(self)
        end

        def github_url; end
        def homepage_url; end
      end

      class RubyGemSpec < Base
        def_delegators :ruby_gem, :github_url, :homepage_url

        private

        def ruby_gem
          @ruby_gem ||= RubyGemRepository.find(@spec.name)
        end
      end

      class GitSpec < Base
        def github_url
          @github_url ||= Github::GithubUrlDetector.new(@spec.source.uri).call
        end
      end

      class PathSpec < Base
      end
    end

    class NullSpec
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def revision
      end

      def version
        nil
      end

      def github_url; end
      def homepage_url; end

      def to_package
        Package.new(self)
      end
    end

  end
end
