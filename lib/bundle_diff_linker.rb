require "logger"
require "bundle_diff_linker/version"
require "bundle_diff_linker/github/access_token"
require "bundle_diff_linker/github/client"
require "bundle_diff_linker/github/change_log_url_finder"
require "bundle_diff_linker/github/pull_request"
require "bundle_diff_linker/github/github_url_detector"
require "bundle_diff_linker/github/tag_finder"
require "bundle_diff_linker/github/repository_name_detector"
require "bundle_diff_linker/formatter/github_markdown"
require "bundle_diff_linker/gemfile_lock_comparator"
require "bundle_diff_linker/gem_diff"
require "bundle_diff_linker/gem_info"
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

    # def initialize(github_access_token:, repository:, pull_request_number:)
    # end
  end
end
