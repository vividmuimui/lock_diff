module LockDiff
  module Gem
    class LockfileComparator
      def self.compare_by(pr_gemfile_lock)
        new(
          old_lockfile: pr_gemfile_lock.base_file,
          new_lockfile: pr_gemfile_lock.head_file
        ).call
      end

      def initialize(old_lockfile:, new_lockfile:)
        @old_lockfile = old_lockfile
        @new_lockfile = new_lockfile
      end

      def call
        old_specs_by_name = Spec.specs_by(@old_lockfile).map { |spec| [spec.name, spec] }.to_h

        Spec.specs_by(@new_lockfile).select { |new_spec|
          old_specs_by_name[new_spec.name]
        }.map { |new_spec|
          DiffInfo.by(old_spec: old_specs_by_name[new_spec.name], new_spec: new_spec)
        }.compact.select(&:changed?)
      end
    end
  end
end
