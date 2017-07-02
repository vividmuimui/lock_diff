require_relative "gem/diff_info"
require_relative "gem/gem"
require_relative "gem/lockfile_comparator"
require_relative "gem/pr_lockfile"
require_relative "gem/ruby_gem"
require_relative "gem/spec"
require_relative "gem/version"

module LockDiff
  module Gem
    class << self
      class NotChangedLockfile < StandardError; end

      def lock_file_diffs(pull_request)
        pr_lockfile = PrLockfile.new(pull_request)
        raise NotChangedLockfile unless pr_lockfile.changed?
        LockfileComparator.compare_by(pr_lockfile)
      end

    end
  end
end
