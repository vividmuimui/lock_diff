module LockDiff
  module Gem
    class DiffInfo
      extend Forwardable

      attr_reader :old_version, :new_version
      def_delegators :@gem, :name, :url

      def self.by(old_spec:, new_spec:)
        gem = Gem.new(new_spec.name)
        new(
          gem: gem,
          old_version: Version.new(gem: gem, spec: old_spec),
          new_version: Version.new(gem: gem, spec: new_spec)
        )
      end

      def initialize(gem:, old_version:, new_version:)
        @gem = gem
        @old_version = old_version
        @new_version = new_version
      end

      def changed?
        @old_version.revision != @new_version.revision ||
          @old_version.version != @new_version.version
      end

      def change_log_url
        @change_log_url ||= Github::ChangeLogUrlFinder.new(
          repository: @gem.repository,
          github_url: @gem.github_url,
          ref: @new_version.ref
        ).call
      end

      def change_log_name
        File.basename(change_log_url)
      end

      def compare_url
        return unless @gem.github_url && @old_version.ref && @new_version.ref
        "#{@gem.github_url}/compare/#{@old_version.ref}...#{@new_version.ref}"
      end

      def compare_url_text
        "#{old_version}...#{new_version}"
      end

    end
  end
end
