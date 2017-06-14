module BundleDiffLinker
  module Gem
    class Spec
      def self.specs_by(lockfile)
        Bundler::LockfileParser.new(lockfile).specs.map do |lazy_specification|
          new(lazy_specification)
        end
      end

      def initialize(lazy_specification)
        @spec = lazy_specification
      end

      def name
        @spec.name
      end

      def version
        @spec.version
      end

      def rivision
        @spec.git_version
      end

    end
  end
end
