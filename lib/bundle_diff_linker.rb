require "logger"
require "bundle_diff_linker/version"

require "bundle_diff_linker/formatter/github_markdown"
require "bundle_diff_linker/gem_info"
require "bundle_diff_linker/gem"
require "bundle_diff_linker/github"
require "bundle_diff_linker/pull_request"
require "bundle_diff_linker/ruby_gem"

module BundleDiffLinker
  class << self
    def logger
      @logger ||= begin
        $stdout.sync = true
        logger = Logger.new($stdout)
        logger.level = ENV["LOG_LEVEL"] ? ENV["LOG_LEVEL"].to_i : Logger::INFO
        logger
      end
    end

    def github_client
      @github_client ||= begin
        access_token = Github::AccessToken.new
        Github::Client.new(access_token)
      end
    end

    def client
      github_client
    end

    def cache_response?
      ENV.fetch('CACHE_RESPONSE', true)
    end

    def run(repository:, pull_request_number:, with_comment: false)
      # BundleDiffLinker.client = :github
      # BundleDiffLinker.strategy = :bundler or :gemfile

      pr = PullRequest.new(repository: repository, number: pull_request_number)
      # pr_gemfile_lock = Gem::PrGemfileLock.new(pr)
      pr_lockfile = Gem.pr_lockfile(pr)
      return unless pr_lockfile.updated?

      # gem_diffs = Gem::LockComparator.by(pr_lockfile).compare
      lockfile_diffs = Gem.diffs(pr_lockfile)
      formatter = Formatter::GithubMarkdown.new(lockfile_diffs)
      if with_comment
        github_client.add_comment(repository, pull_request_number, formatter.format)
      else
        puts formatter.format
      end
    end
  end
end
