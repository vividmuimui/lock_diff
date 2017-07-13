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
        new_specs_by_name = Spec.specs_by(@new_lockfile).map { |spec| [spec.name, spec] }.to_h
        names = (old_specs_by_name.keys + new_specs_by_name.keys).uniq

        names.map { |name|
          DiffInfo.by(
            old_spec: old_specs_by_name[name] || NullSpec.new(name),
            new_spec: new_specs_by_name[name] || NullSpec.new(name)
          )
        }.select(&:changed?)
      end
    end
  end
end
