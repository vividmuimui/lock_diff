require "bundler"
require_relative "gem/lockfile_comparator"
require_relative "gem/package"
require_relative "gem/ruby_gem"
require_relative "gem/spec"

module LockDiff
  module Gem
    class << self
      class NotChangedLockfile < StandardError; end

      def lock_file_diffs(pull_request)
        pr_lockfile = Github::PrLockfile.new(pull_request, 'Gemfile.lock')
        raise NotChangedLockfile unless pr_lockfile.changed?
        LockfileComparator.compare_by(pr_lockfile)
      end

    end
  end
end
