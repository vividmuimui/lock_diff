require 'octokit'

module LockDiff
  module Github
    # wrapper of Octokit::Client

    class << self
      def client
        @client ||= Github::Client.new(Github::AccessToken.new)
      end
    end

    class Client
      def initialize(access_token)
        @client = Octokit::Client.new(access_token: access_token)
      end

      def file(repository, path:, ref:)
        content = @client.contents(repository, path: path, ref: ref)
        Base64.decode64(content.content)
      end

      def pull_request(repository, number)
        Github::PullRequest.new(@client.pull_request(repository, number))
      end

      def latest_pull_request(repository)
        @client.pull_requests(repository).
          map { |pull_request| Github::PullRequest.new(pull_request) }
      end

      def pull_request_content_path(repository, number, file_name)
        content = @client.pull_request_files(repository, number).
          find { |file| file.filename.include?(file_name) }
        content&.filename
      end

      def exist_releases?(repository)
        return false unless repository
        @client.releases(repository).empty?
      end

      def contents(repository, options = {})
        return [] unless repository
        @client.contents(repository, options).map do |content|
          Content.new(content)
        end
      end

      def tag_names(repository, options = {})
        return [] unless repository
        @client.tags(repository, options).map(&:name)
      end

      def add_comment(repository, number, comment)
        @client.add_comment(repository, number, comment)
      end

    end
  end
end
