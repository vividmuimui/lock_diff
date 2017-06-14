require_relative "gem/diff"
require_relative "gem/gem"
require_relative "gem/lockfile_comparator"
require_relative "gem/pr_lockfile"
require_relative "gem/ruby_gem"
require_relative "gem/spec"
require_relative "gem/version"

module BundleDiffLinker
  module Gem
    class << self
      def pr_lockfile(pull_request)
        PrLockfile.new(pull_request)
      end

      def diffs(pr_lockfile)
        LockfileComparator.by(pr_lockfile).call
      end

    end
  end
end
