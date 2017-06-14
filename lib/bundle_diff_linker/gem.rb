require "bundle_diff_linker/gem/diff"
require "bundle_diff_linker/gem/pr_lockfile"
require "bundle_diff_linker/gem/lockfile_comparator"

module BundleDiffLinker
  module Gem
    class << self
      def pr_lockfile(pull_request)
        PrLockfile.new(pull_request)
      end

      def diffs(pr_lockfile)
        LockfileComparator.by(pr_lockfile).compare
      end

    end
  end
end
