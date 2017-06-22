module BundleDiffLinker
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

    end
  end
end
