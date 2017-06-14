module BundleDiffLinker
  module Gem
    class LockfileComparator
      def self.by(pr_gemfile_lock)
        new(
          old_lockfile: pr_gemfile_lock.base_file,
          new_lockfile: pr_gemfile_lock.head_file
        )
      end

      def initialize(old_lockfile:, new_lockfile:)
        @old_lockfile = old_lockfile
        @new_lockfile = new_lockfile
      end

      def compare
        old_specs_by_name = parse(@old_lockfile).specs.map { |spec| [spec.name, spec] }.to_h
        parse(@new_lockfile).specs.map do |new_spec|
          old_spec = old_specs_by_name[new_spec.name]
          next unless old_spec
          Diff.by(old_spec: old_spec, new_spec: new_spec)
        end.compact.select(&:difference?)
      end

      private

      def parse(lockfile)
        Bundler::LockfileParser.new(lockfile)
      end

    end
  end
end
