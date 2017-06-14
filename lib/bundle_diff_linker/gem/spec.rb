module BundleDiffLinker
  module Gem
    # wrapper of lazy_specification
    class Spec
      extend Forwardable

      def_delegators :@spec, :name, :version
      def_delegator :@spec, :git_version, :rivision

      def self.specs_by(lockfile)
        Bundler::LockfileParser.new(lockfile).specs.map do |lazy_specification|
          new(lazy_specification)
        end
      end

      def initialize(lazy_specification)
        @spec = lazy_specification
      end

    end
  end
end
