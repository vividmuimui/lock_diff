require "logger"
require "forwardable"

require "lock_diff/diff_info"
require "lock_diff/formatter/github_markdown"
require "lock_diff/gem"
require "lock_diff/github"
require "lock_diff/lockfile_comparator"
require "lock_diff/pull_request"
require "lock_diff/version"

module LockDiff
  class << self
    attr_accessor :config

    def init!
      self.config = Config.new
    end

    def logger
      config.logger
    end

    def run(repository:, number:, post_comment: false)
      pr = PullRequest.find_by(repository: repository, number: number)
      _run(pull_request: pr, post_comment: post_comment)
    end

    def run_by_latest_tachikoma(repository:, post_comment: false)
      pr = PullRequest.latest_by_tachikoma(repository)
      if pr
        LockDiff.logger.info { "Running on repository: #{pr.repository}, number: #{pr.number}"}
        _run(pull_request: pr, post_comment: post_comment)
      else
        LockDiff.logger.warn("Not found pull request by tachikoma. (Hint: search pull request by whether branch name includes 'tachikoma'")
      end
    end

    private

    def _run(pull_request:, post_comment: false)
      lockfile_diff_infos = LockfileComparator.compare_by(pull_request)
      result = config.formatter.format(lockfile_diff_infos)

      if post_comment
        pull_request.add_comment(result)
      else
        $stdout.puts result
      end
    end
  end

  class Config
    attr_accessor :pr_repository_service, :formatter, :strategy, :logger

    def initialize
      @pr_repository_service = Github
      @formatter = Formatter::GithubMarkdown
      @strategy = Gem
      @logger = Logger.new($stdout)
      @logger.level = :warn
    end
  end
end

LockDiff.init!
