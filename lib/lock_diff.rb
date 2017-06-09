require "logger"
require "forwardable"

require "lock_diff/core_ext/memoize"
require "lock_diff/formatter/github_markdown"
require "lock_diff/gem"
require "lock_diff/github"
require "lock_diff/pull_request"
require "lock_diff/version"

module LockDiff
  class << self
    attr_accessor :client_class, :formatter, :strategy, :memoize_response, :logger

    def client
      client_class.client
    end

    def run(repository:, number:, post_comment: false)
      pr = PullRequest.new(repository: repository, number: number)
      lockfile_diff_infos = strategy.lock_file_diffs(pr)
      result = formatter.format(lockfile_diff_infos)

      if post_comment
        client.add_comment(repository, number, result)
      else
        $stdout.puts result
      end
    end
  end

  self.client_class = Github
  self.formatter = Formatter::GithubMarkdown
  self.strategy = Gem
  self.memoize_response = true
  self.logger = Logger.new(nil)
end
