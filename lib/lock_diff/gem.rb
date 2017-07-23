require "bundler"
require_relative "gem/lockfile_comparator"
require_relative "gem/package"
require_relative "gem/ruby_gem"
require_relative "gem/spec"

module LockDiff
  module Gem
    class << self
      def lockfile_name
        'Gemfile.lock'
      end

      def lockfile_comparator
        LockfileComparator
      end
    end
  end
end
