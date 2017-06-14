require "logger"

require "bundle_diff_linker/core_ext/memoize"
require "bundle_diff_linker/formatter/github_markdown"
require "bundle_diff_linker/gem"
require "bundle_diff_linker/github"
require "bundle_diff_linker/pull_request"
require "bundle_diff_linker/version"

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

    def client
      github_client
    end
    memoize :client

    def memoize_response?
      ENV.fetch('MEMOIZE_RESPONSE', 'true') == 'true'
    end

    def run(repository:, pull_request_number:, with_comment: false)
      pr = PullRequest.new(repository: repository, number: pull_request_number)
      pr_lockfile = Gem.pr_lockfile(pr)
      return unless pr_lockfile.updated?

      lockfile_diffs = Gem.diffs(pr_lockfile)
      formatter = Formatter::GithubMarkdown.new(lockfile_diffs)
      if with_comment
        github_client.add_comment(repository, pull_request_number, formatter.format)
      else
        puts formatter.format
      end
    end

    private

    def github_client
      Github::Client.new(Github::AccessToken.new)
    end

  end
end
