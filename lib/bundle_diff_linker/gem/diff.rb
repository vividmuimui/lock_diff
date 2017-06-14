module BundleDiffLinker
  module Gem
    class Diff
      # attr_reader :old_gem, :new_gem

      # def self.by(old_spec:, new_spec:)
      #   new(old_gem: GemInfo.new(old_spec), new_gem: GemInfo.new(new_spec))
      # end

      # def initialize(old_gem:, new_gem:)
      #   @old_gem = old_gem
      #   @new_gem = new_gem
      # end

      # def difference?
      #   @old_gem.rivision != @new_gem.rivision ||
      #     @old_gem.version != @new_gem.version
      # end

      def self.by(old_spec:, new_spec:)
        gem = Gem.new(new_spec.name)
        new(
          gem: gem,
          old_version: Version.new(gem: gem, spec: old_spec),
          new_version: Version.new(gem: gem, spec: new_spec)
        )
      end

      attr_reader :old_version, :new_version

      def initialize(gem:, old_version:, new_version:)
        @gem = gem
        @old_version = old_version
        @new_version = new_version
      end

      def changed?
        @old_version.rivision != @new_version.rivision ||
          @old_version.version != @new_version.version
      end

      def name
        @gem.name
      end

      def url
        @gem.url
      end

      def change_log_url
        @gem.change_log_url
      end

      def diff_url
        return unless @gem.github_url && @old_version.ref && @new_version.ref
        "#{@gem.github_url}/compare/#{@old_version.ref}...#{@new_version.ref}"
      end

    end
  end
end
