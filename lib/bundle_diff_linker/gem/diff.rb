module BundleDiffLinker
  module Gem
    class Diff
      attr_reader :old_gem, :new_gem

      def self.by(old_spec:, new_spec:)
        new(old_gem: GemInfo.new(old_spec), new_gem: GemInfo.new(new_spec))
      end

      def initialize(old_gem:, new_gem:)
        @old_gem = old_gem
        @new_gem = new_gem
      end

      def difference?
        @old_gem.rivision != @new_gem.rivision ||
          @old_gem.version != @new_gem.version
      end
    end
  end
end
