module BundleDiffLinker
  module Gem
    class Spec
      def self.specs(lazy_specifications)
        lazy_specifications.map do |lazy_specification|
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
        @spec.version.to_s
      end

      def rivision
        @spec.rivision
      end

    end
  end
end
