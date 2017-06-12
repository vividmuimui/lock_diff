require "logger"
require "bundle_diff_linker/version"

require "bundle_diff_linker/formatter/github_markdown"
require "bundle_diff_linker/gem_diff"
require "bundle_diff_linker/gem_info"
require "bundle_diff_linker/gemfile/pr_gemfile_lock"
require "bundle_diff_linker/gemfile_lock_comparator"
require "bundle_diff_linker/github/access_token"
require "bundle_diff_linker/github/change_log_url_finder"
require "bundle_diff_linker/github/client"
require "bundle_diff_linker/github/github_url_detector"
require "bundle_diff_linker/github/pull_request"
require "bundle_diff_linker/github/pull_request_content"
require "bundle_diff_linker/github/repository_name_detector"
require "bundle_diff_linker/github/tag_finder"
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
      pr_gemfile_lock = Gemfile::PrGemfileLock.new(pr)
      return unless pr_gemfile_lock.updated?

      gem_diffs = GemfileLockComparator.by(pr_gemfile_lock).compare
      formatter = Formatter::GithubMarkdown.new(gem_diffs)
      if with_comment
        github_client.add_comment(repository, pull_request_number, formatter.format)
      else
        puts formatter.format
      end
    end
  end
end
