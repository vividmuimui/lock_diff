require "logger"
require "forwardable"

require "lock_diff/diff_info"
require "lock_diff/formatter/github_markdown"
require "lock_diff/gem"
require "lock_diff/github"
require "lock_diff/pull_request"
require "lock_diff/version"

module LockDiff
  class << self
    attr_accessor :config

    def init!
      self.config = Config.new
    end

    def client
      config.client_class.client
    end

    def logger
      config.logger
    end

    def run(repository:, number:, post_comment: false)
      pr = PullRequest.new(repository: repository, number: number)
      lockfile_diff_infos = config.strategy.lock_file_diffs(pr)
      result = config.formatter.format(lockfile_diff_infos)

      if post_comment
        client.add_comment(repository, number, result)
      else
        $stdout.puts result
      end
    end

    def run_by_latest_tachikoma(repository:, post_comment: false)
      pr = Github.client.latest_pull_request(repository).
        find { |pull_request| pull_request.head_ref.include?("tachikoma") }
      if pr
        run(repository: repository, number: pr.number, post_comment: post_comment)
      else
        LockDiff.logger.warn("Not found pull request by tachikoma. (Hint: search pull request by whether branch name includes 'tachikoma'")
      end
    end

    class Config
      attr_accessor :client_class, :formatter, :strategy, :logger

      def initialize
        @client_class = Github
        @formatter = Formatter::GithubMarkdown
        @strategy = Gem
        @logger = Logger.new($stdout)
        @logger.level = :warn
      end
    end
  end
end

LockDiff.init!
