module LockDiff
  module Gem
    # wrapper of lazy_specification
    class Spec
      extend Forwardable

      def_delegators :@spec, :name, :version

      def self.specs_by(lockfile)
        Bundler::LockfileParser.new(lockfile).specs.map do |lazy_specification|
          new(lazy_specification)
        end
      end

      def initialize(lazy_specification)
        @spec = lazy_specification
      end

      def revision
        @spec.git_version&.strip
      end

      def to_package
        Package.new(self)
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

      def to_package
        Package.new(self)
      end
    end

  end
end
