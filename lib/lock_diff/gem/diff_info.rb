module LockDiff
  module Gem
    class DiffInfo
      extend Forwardable

      attr_reader :old_version, :new_version
      def_delegators :@gem, :name, :url
      def_delegators :@diff_info, :changed?, :status, :status_emoji, :change_log_url, :change_log_name, :commits_url, :commits_url_text

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
        @diff_info = LockDiff::DiffInfo.new(
          old_version: old_version,
          new_version: new_version,
          github_url: gem.github_url,
          repository: gem.repository
        )
      end

    end
  end
end
