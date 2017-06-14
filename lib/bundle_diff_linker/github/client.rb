require 'octokit'

module BundleDiffLinker
  module Github
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

      def pull_request_content(repository, number, file_name)
        content = @client.pull_request_files(repository, number).
          find { |file| file.filename.include?(file_name) }
        if content
          Github::PullRequestContent.new(content)
        end
      end

      def releases(repository)
        @client.releases(repository)
      end

      def contents(repository)
        @client.contents(repository)
      end

      def tags(repository)
        @client.tags(repository)
      end

    end
  end
end
