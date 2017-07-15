module LockDiff
  module Gem
    class DiffInfo
      extend Forwardable

      attr_reader :old_version, :new_version
      def_delegators :@package, :name, :url
      def_delegators :@diff_info, :changed?, :status, :status_emoji, :changelog_url, :changelog_name, :commits_url, :commits_url_text

      def self.by(old_spec:, new_spec:)
        package = Package.new(new_spec.name)
        new(
          package: package,
          old_version: Version.new(package: package, spec: old_spec),
          new_version: Version.new(package: package, spec: new_spec)
        )
      end

      def initialize(package:, old_version:, new_version:)
        @package = package
        @diff_info = LockDiff::DiffInfo.new(
          old_version: old_version,
          new_version: new_version,
          package: package
        )
      end

    end
  end
end
